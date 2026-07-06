/*
 * ir_opt.c — IR-level optimisation passes.
 *
 * Each pass walks the IR and mutates it in-place. Decoupled from the
 * compiler internals (no ccdefs.h) so ir_selftest can link standalone.
 */

#include "ccdefs.h"
#include "ir_opt.h"
#include "ir_analysis.h"

/* Defined in ir_lower.c (the CPU-lowering layer). Target predicate for the
   const-store fold — no ccdefs.h dependency, so the decoupling above holds.
   `width` = store size in bytes (byte folds everywhere; word is gated). */
extern int ir_cpu_const_store_ok(int width);

#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* Shadow entry: the most recent IR_ST_MEM at this address; the stored
   vreg is the value live there until invalidated.

   Inlined small array — most BBs have a handful of live entries at most.
   On overflow we just drop tracking (conservative; correctness preserved). */
typedef struct {
    MemKind kind;
    SYMBOL *sym;        /* IR_MEM_SYM only */
    int     base;       /* IR_MEM_VREG only — base vreg holding the pointer */
    int     offset;
    int     stored_vreg;
    int     width;
    /* Dead-store (3c): op index of the IR_ST_MEM that created this
       entry; -1 if it came from a IR_LD_MEM (never dead-eliminable).
       An exact overwrite of a >=0 entry marks that store dead. */
    int     store_origin_op;
} ShadowEntry;

#define MAX_SHADOW 16

static int addr_matches(const ShadowEntry *e, const MemOp *m)
{
    if (e->kind != m->kind) return 0;
    if (e->offset != m->offset) return 0;
    if (m->kind == IR_MEM_SYM)  return e->sym  == m->sym;
    if (m->kind == IR_MEM_VREG) return e->base == m->base;
    return 0;
}

static int trackable_kind(MemKind k)
{
    return k == IR_MEM_SYM || k == IR_MEM_VREG;
}

/* Drop an entry by swapping with the tail. */
static void drop(ShadowEntry *sh, int *n, int i)
{
    if (i < *n - 1) sh[i] = sh[*n - 1];
    (*n)--;
}

int ir_opt_st2ld(Func *f)
{
    if (!f) return 0;
    int changed = 0;
    ShadowEntry sh[MAX_SHADOW];

    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        int n = 0;
        if (bb->n_ops <= 0) continue;
        /* Dead-op bitset; marked ops are compacted out after the walk. */
        unsigned char *dead = calloc((size_t)bb->n_ops, 1);
        if (!dead) continue;

        for (int j = 0; j < bb->n_ops; j++) {
            Op *op = &bb->ops[j];

            /* Calls invalidate everything — callees can touch any memory. */
            if (op->kind == IR_CALL || op->kind == IR_HCALL) {
                n = 0;
                continue;
            }
            /* Asm passthrough: assume worst — invalidate all. */
            if (op->kind == IR_ASM) {
                n = 0;
                continue;
            }

            /* IR_LD_MEM: forward against the shadow, else track this
               load so a later same-address load can MOV from it (RLE,
               roadmap 3b). */
            if (op->kind == IR_LD_MEM && op->dst >= 0) {
                if (op->mem.volatile_) continue;
                if (!trackable_kind(op->mem.kind)) continue;
                /* A post-stepping load (`*p++`/`*p--`) bumps its base
                   pointer as a side effect. It must NOT be forwarded to a
                   plain MOV (that would silently drop the increment), and
                   after it any shadow entry keyed on the stepped base is
                   stale — a later `*p` reads the NEW address, not this
                   load's value. Drop those entries and don't track this
                   load (its [base] is about to mean something else). */
                if (op->mem.post_step != 0 && op->mem.kind == IR_MEM_VREG) {
                    for (int k = 0; k < n; ) {
                        if ((sh[k].kind == IR_MEM_VREG
                             && sh[k].base == op->mem.base)
                            || sh[k].stored_vreg == op->dst)
                            drop(sh, &n, k);
                        else
                            k++;
                    }
                    continue;
                }
                int dst_w = (op->dst < f->n_vregs)
                          ? f->vregs[op->dst].width : 0;
                int hit = -1;
                for (int k = 0; k < n; k++) {
                    if (!addr_matches(&sh[k], &op->mem)) continue;
                    if (sh[k].width != dst_w) continue;
                    hit = k;
                    break;
                }
                if (hit >= 0) {
                    /* Forward: rewrite as IR_MOV dst <- cached vreg.
                       Does NOT mark the origin store dead — only a
                       later overwriting ST_MEM does that. */
                    op->kind   = IR_MOV;
                    op->src[0] = sh[hit].stored_vreg;
                    op->src[1] = -1;
                    op->mem.kind      = IR_MEM_FRAME;
                    op->mem.sym       = NULL;
                    op->mem.base      = -1;
                    op->mem.offset    = 0;
                    op->mem.elem      = 0;
                    op->mem.volatile_ = 0;
                    op->mem.port      = NULL;
                    changed++;
                    continue;
                }
                /* No match — track as an RLE source (origin -1: never
                   dead-store eligible). */
                if (n < MAX_SHADOW) {
                    sh[n].kind             = op->mem.kind;
                    sh[n].sym              = op->mem.sym;
                    sh[n].base             = op->mem.base;
                    sh[n].offset           = op->mem.offset;
                    sh[n].stored_vreg      = op->dst;
                    sh[n].width            = dst_w;
                    sh[n].store_origin_op  = -1;
                    n++;
                }
                continue;
            }

            /* IR_ST_MEM: update shadow. */
            if (op->kind == IR_ST_MEM) {
                if (op->mem.volatile_ || !trackable_kind(op->mem.kind)
                    || op->src[0] < 0) {
                    /* Untrackable store — alias risk, drop everything. */
                    n = 0;
                    continue;
                }
                /* Drop non-matching entries — alias risk, no points-to
                   analysis. A matching entry gets the new stored vreg. */
                int matched = -1;
                for (int k = 0; k < n; ) {
                    if (addr_matches(&sh[k], &op->mem)) {
                        matched = k;
                        k++;
                    } else {
                        drop(sh, &n, k);
                    }
                }
                int width = (op->src[0] < f->n_vregs)
                          ? f->vregs[op->src[0]].width : 0;
                if (matched >= 0) {
                    /* Dead-store elim (3c): same-width overwrite of a
                       store-origin entry — memory was never read in
                       between (forwarded reads used the vreg), so the
                       old store is dead. */
                    if (sh[matched].store_origin_op >= 0
                        && sh[matched].width == width) {
                        dead[sh[matched].store_origin_op] = 1;
                        changed++;
                    }
                    sh[matched].stored_vreg     = op->src[0];
                    sh[matched].width           = width;
                    sh[matched].store_origin_op = j;
                } else if (n < MAX_SHADOW) {
                    sh[n].kind             = op->mem.kind;
                    sh[n].sym              = op->mem.sym;
                    sh[n].base             = op->mem.base;
                    sh[n].offset           = op->mem.offset;
                    sh[n].stored_vreg      = op->src[0];
                    sh[n].width            = width;
                    sh[n].store_origin_op  = j;
                    n++;
                }
                continue;
            }

            /* Any other op that writes a vreg: invalidate entries whose
               base or stored_vreg is overwritten. ir_op_defs covers
               multi-def ops (IR_POSTSTEP writes src[0] as well). */
            {
                int defs[4];
                int nd = ir_op_defs(op, defs,
                                    (int)(sizeof defs / sizeof defs[0]));
                for (int di = 0; di < nd && di < 4; di++) {
                    int d = defs[di];
                    if (d < 0) continue;
                    for (int k = 0; k < n; ) {
                        int kill = 0;
                        if (sh[k].kind == IR_MEM_VREG && sh[k].base == d)
                            kill = 1;
                        else if (sh[k].stored_vreg == d)
                            kill = 1;
                        if (kill) drop(sh, &n, k);
                        else k++;
                    }
                }
            }
        }

        /* Compact out dead ops. store_origin_op indexed the original
           array; not used past this point. */
        int new_n = 0;
        for (int j = 0; j < bb->n_ops; j++) {
            if (dead[j]) continue;
            if (new_n != j) bb->ops[new_n] = bb->ops[j];
            new_n++;
        }
        bb->n_ops = new_n;
        free(dead);
    }
    return changed;
}

/* ---- 3d: arithmetic CSE ------------------------------------------- */

typedef struct {
    OpKind  kind;
    int     src0;
    int     src1;       /* -1 if unary or imm-rhs */
    int64_t imm;        /* part of identity for imm-rhs ops */
    int     has_imm;    /* 1 if imm is meaningful */
    int     dst;        /* vreg holding the computed value */
    int     width;
} CSEntry;

#define MAX_CSE 32

static int cse_eligible(OpKind k)
{
    switch (k) {
    case IR_ADD: case IR_SUB: case IR_RSUB:
    case IR_AND: case IR_OR: case IR_XOR:
    case IR_SHL: case IR_SHR:
    case IR_NEG: case IR_NOT:
    case IR_CONV_ZX: case IR_CONV_SX:
    case IR_CONV_TRUNC: case IR_CONV_BYTE_TO_HIGH:
    case IR_ROTL: case IR_ROTR:
    case IR_CMP_EQ:  case IR_CMP_NE:
    case IR_CMP_LT:  case IR_CMP_LE:  case IR_CMP_GT:  case IR_CMP_GE:
    case IR_CMP_ULT: case IR_CMP_ULE: case IR_CMP_UGT: case IR_CMP_UGE:
        return 1;
    default:
        return 0;
    }
}

/* For binops + cmps + shifts, an immediate-rhs is encoded as
   src[1] == -1 with op->imm carrying the constant. CONV ops don't
   use imm, neither do NEG/NOT. ROTL/ROTR carry the bit count in imm.
   We always record the imm so identical-imm variants collide and
   different-imm variants don't. */
static int op_has_imm_identity(OpKind k)
{
    switch (k) {
    case IR_ADD: case IR_SUB: case IR_RSUB:
    case IR_AND: case IR_OR: case IR_XOR:
    case IR_SHL: case IR_SHR:
    case IR_ROTL: case IR_ROTR:
    case IR_CMP_EQ:  case IR_CMP_NE:
    case IR_CMP_LT:  case IR_CMP_LE:  case IR_CMP_GT:  case IR_CMP_GE:
    case IR_CMP_ULT: case IR_CMP_ULE: case IR_CMP_UGT: case IR_CMP_UGE:
        return 1;
    default:
        return 0;
    }
}

static int cse_drop(CSEntry *tbl, int *n, int i)
{
    if (i < *n - 1) tbl[i] = tbl[*n - 1];
    (*n)--;
    return i;
}

static void cse_invalidate_for_write(CSEntry *tbl, int *n, int v)
{
    if (v < 0) return;
    for (int k = 0; k < *n; ) {
        if (tbl[k].src0 == v || tbl[k].src1 == v || tbl[k].dst == v)
            cse_drop(tbl, n, k);
        else
            k++;
    }
}

/* ---- 3e: loop-invariant code motion ------------------------------ */

/* Forward reachability: can `from` reach `to` following succ edges?
   Used to validate a candidate back-edge: an edge B->S is only a real
   natural-loop back-edge if the header S reaches the latch B (closing
   the cycle S->...->B->S). Without this, a plain forward JOIN edge whose
   target happens to have a lower block id than its source (e.g. an
   if/else else-arm BB3 -> merge BB2, where the merge was numbered before
   the arm) is misread as a back-edge — LICM then "hoists" the arm's
   single-def LD_IMMs into a bogus pre-header on the OTHER arm, a
   miscompile (def no longer dominates its use). */
static int licm_reaches(Func *f, int from, int to)
{
    if (from == to) return 1;
    int *seen = calloc((size_t)f->n_bbs, sizeof(int));
    int *stack = calloc((size_t)f->n_bbs, sizeof(int));
    int found = 0;
    if (seen && stack) {
        int sp = 0;
        seen[from] = 1; stack[sp++] = from;
        while (sp > 0) {
            int cur = stack[--sp];
            BB *cbb = &f->bbs[cur];
            int ns = ir_bb_n_succ(cbb);
            for (int s = 0; s < ns; s++) {
                int sid = ir_bb_succ_at(cbb, s);
                if (sid < 0 || sid >= f->n_bbs) continue;
                if (sid == to) { found = 1; sp = 0; break; }
                if (!seen[sid]) { seen[sid] = 1; stack[sp++] = sid; }
            }
        }
    }
    free(seen); free(stack);
    return found;
}

/* Detect loops via dominator-confirmed back-edges. An edge B->S is a real
   natural-loop back-edge iff its target S dominates its source B; the loop
   body is then S (the header) plus every node that can reach the latch B
   without passing through S. Sets bb_in_loop[] and per-BB loop_header[]
   (-1 if not in any loop). For nested loops, keeps the OUTERMOST header
   (lowest id) — sufficient for hoisting all the way out.

   An earlier cut used "S.id <= B.id and S reaches B" with a contiguous
   id-range [S,B] body. That mis-modelled an `if` nested in a loop: the
   loop-exit block can be numbered BELOW the if-body, so the body isn't a
   contiguous range and the latch->...->if-body forward path produced a
   spurious inner back-edge whose "pre-header" was a dead block — LICM then
   hoisted invariants into unreachable code (a miscompile). Dominance is
   the correct back-edge test and handles non-contiguous bodies. */
static void licm_find_loops(Func *f, int *in_loop, int *loop_header,
                            int *loop_end)
{
    for (int i = 0; i < f->n_bbs; i++) {
        in_loop[i]     = 0;
        loop_header[i] = -1;
        loop_end[i]    = -1;
    }
    /* Reachability from the entry (BB0). An UNREACHABLE BB never executes,
       so a `succ.id <= b.id` edge out of it is NOT a real back-edge — it
       can't form a loop. The switch builder leaves exactly such a BB: a
       dead post-SWITCH block that falls through to the first case label
       (whose id is lower), e.g. BB4 -> BB2. Without this guard that fake
       back-edge marks the case bodies as a loop and LICM hoists their
       (single-def) `LD_IMM`s into the switch block — a miscompile. */
    int *reachable = calloc((size_t)f->n_bbs, sizeof(int));
    if (reachable) {
        int *stack = calloc((size_t)f->n_bbs, sizeof(int));
        if (stack) {
            int sp = 0;
            reachable[0] = 1; stack[sp++] = 0;
            while (sp > 0) {
                int cur = stack[--sp];
                BB *cbb = &f->bbs[cur];
                int cns = ir_bb_n_succ(cbb);
                for (int s = 0; s < cns; s++) {
                    int sid = ir_bb_succ_at(cbb, s);
                    if (sid >= 0 && sid < f->n_bbs && !reachable[sid]) {
                        reachable[sid] = 1; stack[sp++] = sid;
                    }
                }
            }
            free(stack);
        } else {
            for (int i = 0; i < f->n_bbs; i++) reachable[i] = 1;
        }
    }
    int n = f->n_bbs;

    /* Iterative dominators over the reachable sub-CFG (entry = BB0).
       dom[b*n + d] != 0  iff  d dominates b. */
    char *dom = (reachable && n > 0) ? malloc((size_t)n * (size_t)n) : NULL;
    int  *tmp = calloc((size_t)(n > 0 ? n : 1), sizeof(int));
    if (dom && tmp) {
        for (int b = 0; b < n; b++) {
            if (!reachable[b]) { for (int d = 0; d < n; d++) dom[b*n+d] = 0; }
            else if (b == 0)   { for (int d = 0; d < n; d++) dom[d] = (d == 0); }
            else               { for (int d = 0; d < n; d++) dom[b*n+d] = (char)reachable[d]; }
        }
        int changed = 1;
        while (changed) {
            changed = 0;
            for (int b = 0; b < n; b++) {
                if (!reachable[b] || b == 0) continue;
                int have = 0;
                for (int p = 0; p < n; p++) {
                    if (!reachable[p]) continue;
                    BB *pb = &f->bbs[p];
                    int pns = ir_bb_n_succ(pb), is_pred = 0;
                    for (int ps = 0; ps < pns; ps++)
                        if (ir_bb_succ_at(pb, ps) == b) { is_pred = 1; break; }
                    if (!is_pred) continue;
                    if (!have) { for (int d = 0; d < n; d++) tmp[d] = dom[p*n+d]; have = 1; }
                    else       { for (int d = 0; d < n; d++) tmp[d] = tmp[d] && dom[p*n+d]; }
                }
                if (!have) for (int d = 0; d < n; d++) tmp[d] = 0;
                tmp[b] = 1;                          /* b dominates itself */
                for (int d = 0; d < n; d++)
                    if (dom[b*n+d] != (char)tmp[d]) { dom[b*n+d] = (char)tmp[d]; changed = 1; }
            }
        }
    }

    /* For each dominator-confirmed back-edge, mark the natural loop body. */
    int *inthis = calloc((size_t)(n > 0 ? n : 1), sizeof(int));
    int *wstack = calloc((size_t)(n > 0 ? n : 1), sizeof(int));
    for (int b = 0; dom && inthis && wstack && b < n; b++) {
        if (!reachable[b]) continue;
        BB *bb = &f->bbs[b];
        int ns = ir_bb_n_succ(bb);
        for (int s = 0; s < ns; s++) {
            int sid = ir_bb_succ_at(bb, s);
            if (sid < 0 || sid >= n || !reachable[sid]) continue;
            if (!dom[b*n + sid]) continue;          /* not a back-edge: sid !dom b */
            /* Natural loop: header sid + every node reaching latch b
               without passing through sid (backward DFS over preds). */
            for (int k = 0; k < n; k++) inthis[k] = 0;
            inthis[sid] = 1;
            int sp = 0;
            if (b != sid) { inthis[b] = 1; wstack[sp++] = b; }
            while (sp > 0) {
                int x = wstack[--sp];
                for (int p = 0; p < n; p++) {
                    if (!reachable[p] || inthis[p]) continue;
                    BB *pb = &f->bbs[p];
                    int pns = ir_bb_n_succ(pb);
                    for (int ps = 0; ps < pns; ps++)
                        if (ir_bb_succ_at(pb, ps) == x) {
                            inthis[p] = 1; wstack[sp++] = p; break;
                        }
                }
            }
            int lo = sid, hi = b;
            for (int k = 0; k < n; k++) {
                if (!inthis[k]) continue;
                in_loop[k] = 1;
                /* Outermost header wins (smallest id). */
                if (loop_header[k] < 0 || lo < loop_header[k]) {
                    loop_header[k] = lo;
                    loop_end[k]    = hi;
                }
            }
        }
    }
    free(inthis); free(wstack); free(tmp); free(dom);
    free(reachable);
}

/* Find the unique outside predecessor of `header`. Returns its BB id,
   or -1 if there isn't exactly one outside predecessor (header is
   unreachable, or has multiple entry edges — would need a synthesised
   pre-header). */
static int licm_pre_header(const Func *f, const int *in_loop, int header)
{
    int outside = -1;
    int count = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        if (in_loop[b] && b >= header) continue;
        const BB *bb = &f->bbs[b];
        int ns = ir_bb_n_succ(bb);
        for (int s = 0; s < ns; s++) {
            if (ir_bb_succ_at(bb, s) == header) {
                outside = b;
                count++;
                break;
            }
        }
    }
    return count == 1 ? outside : -1;
}

/* Eligible-for-LICM ops: produce a value that doesn't depend on memory
   state or any other vreg (or whose sources are all loop-invariant).
   For this first cut we only handle the unconditionally-invariant
   set: LD_IMM (constant), LD_SYM (sym address), LD_STR (literal queue
   address), LEA (local frame address). */
static int licm_eligible_kind(OpKind k)
{
    /* LD_IMM (a true constant) is trivially rematerialisable — a 3-byte
       immediate at each use. Hoisting it only makes the allocator spill it to
       a slot and reload per iteration (the greedy allocator can't hold it in a
       register across a body that clobbers HL/DE/BC), which is strictly worse.
       Leave literals at the use site. LD_SYM (&global) STAYS eligible: hoisting
       the invariant base is what lets IVSR strength-reduce `base + i` into a
       register pointer walk (`inc bc`), a real win we must not forgo. */
    return k == IR_LD_SYM || k == IR_LD_STR || k == IR_LEA;
}

/* Insert `src_op` into `dst_bb` just BEFORE its last op (the
   terminator), keeping the terminator at the end. Grows the ops
   array if needed. Returns 0 on success. */
static int licm_insert_before_terminator(BB *dst_bb, const Op *src_op)
{
    if (dst_bb->n_ops >= dst_bb->cap_ops) {
        int cap = dst_bb->cap_ops ? dst_bb->cap_ops * 2 : 8;
        Op *new_ops = realloc(dst_bb->ops, (size_t)cap * sizeof(Op));
        if (!new_ops) return -1;
        memset(&new_ops[dst_bb->cap_ops], 0,
               (size_t)(cap - dst_bb->cap_ops) * sizeof(Op));
        dst_bb->ops = new_ops;
        dst_bb->cap_ops = cap;
    }
    int n = dst_bb->n_ops;
    if (n == 0) {
        dst_bb->ops[0] = *src_op;
        dst_bb->n_ops = 1;
        return 0;
    }
    dst_bb->ops[n] = dst_bb->ops[n - 1];
    dst_bb->ops[n - 1] = *src_op;
    dst_bb->n_ops = n + 1;
    return 0;
}

/* Free a BB's op payloads + owned arrays (mirror of ir_func_free's per-BB
   cleanup). Used when pruning a dead block. live_in/out are not yet built
   at prune time (this runs before ir_analysis), so nothing to free there. */
static void prune_free_bb(BB *bb)
{
    for (int j = 0; j < bb->n_ops; j++) {
        Op *o = &bb->ops[j];
        if (o->call)  { free(o->call->args);  free(o->call); }
        if (o->hcall) { free(o->hcall->args); free(o->hcall); }
        if (o->sw)    { free(o->sw->values); free(o->sw->target_bb); free(o->sw); }
        if (o->mem.port) free(o->mem.port);
    }
    free(bb->ops);
    free(bb->pred);
}

int ir_opt_prune_unreachable(Func *f)
{
    if (!f || f->n_bbs <= 0) return 0;
    if (getenv("IR_NO_PRUNE")) return 0;
    int n = f->n_bbs;
    int *reach = calloc((size_t)n, sizeof(int));
    int *stack = calloc((size_t)n, sizeof(int));
    int *remap = malloc((size_t)n * sizeof(int));
    if (!reach || !stack || !remap) {
        free(reach); free(stack); free(remap);
        return 0;
    }
    /* DFS reachability from the entry. Enumerate successors from the BB's
       branch OPS, not succ[] — a short-circuit && / || lowering leaves >2
       branch ops (BR_COND + BR_ZERO + BR) in one BB, and the fixed succ[2]
       pair silently drops the 3rd target. Missing it here would prune a live
       block and leave a dangling `jp`. IR_SWITCH targets come from its
       SwitchInfo. */
    int sp = 0;
    reach[0] = 1; stack[sp++] = 0;
    while (sp > 0) {
        BB *bb = &f->bbs[stack[--sp]];
        #define PRUNE_VISIT(sid) do {                                      \
            int _s = (sid);                                                \
            if (_s >= 0 && _s < n && !reach[_s]) {                         \
                reach[_s] = 1; stack[sp++] = _s;                           \
            }                                                              \
        } while (0)
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if (o->kind == IR_BR || o->kind == IR_BR_COND
                || o->kind == IR_BR_ZERO) {
                PRUNE_VISIT(o->label);
            } else if (o->kind == IR_SWITCH && o->sw) {
                for (int c = 0; c < o->sw->n_cases; c++)
                    PRUNE_VISIT(o->sw->target_bb[c]);
                PRUNE_VISIT(o->sw->default_bb);
            }
        }
        /* succ[] too, in case a BB carries a fall-through successor with no
           explicit terminator op (defensive — normal BBs end in a branch). */
        PRUNE_VISIT(bb->succ[0]);
        PRUNE_VISIT(bb->succ[1]);
        #undef PRUNE_VISIT
    }
    int next = 0;
    for (int i = 0; i < n; i++) remap[i] = reach[i] ? next++ : -1;
    int removed = n - next;
    if (removed == 0) {
        free(reach); free(stack); free(remap);
        return 0;
    }
    /* Compact survivors down (new id <= old id, so a forward copy in
       increasing order never clobbers a not-yet-moved survivor); free the
       dead blocks in place. */
    for (int i = 0; i < n; i++) {
        if (reach[i]) {
            if (remap[i] != i) f->bbs[remap[i]] = f->bbs[i];
        } else {
            prune_free_bb(&f->bbs[i]);
        }
    }
    f->n_bbs = next;
    /* Renumber ids to the compacted index and remap every stored BB-id
       reference. A survivor's successors are themselves reachable (BFS
       invariant), so remap[...] is always a valid new id here. */
    for (int i = 0; i < next; i++) {
        BB *bb = &f->bbs[i];
        bb->id = i;
        for (int s = 0; s < 2; s++)
            if (bb->succ[s] >= 0 && bb->succ[s] < n)
                bb->succ[s] = remap[bb->succ[s]];
        for (int j = 0; j < bb->n_ops; j++) {
            Op *o = &bb->ops[j];
            if (o->kind == IR_BR || o->kind == IR_BR_COND
                || o->kind == IR_BR_ZERO) {
                if (o->label >= 0 && o->label < n) o->label = remap[o->label];
            } else if (o->kind == IR_SWITCH && o->sw) {
                for (int c = 0; c < o->sw->n_cases; c++)
                    if (o->sw->target_bb[c] >= 0 && o->sw->target_bb[c] < n)
                        o->sw->target_bb[c] = remap[o->sw->target_bb[c]];
                if (o->sw->default_bb >= 0 && o->sw->default_bb < n)
                    o->sw->default_bb = remap[o->sw->default_bb];
            }
        }
    }
    free(reach); free(stack); free(remap);
    return removed;
}

int ir_opt_licm(Func *f)
{
    if (!f || f->n_bbs <= 0) return 0;

    int *in_loop      = calloc((size_t)f->n_bbs, sizeof(int));
    int *loop_header  = calloc((size_t)f->n_bbs, sizeof(int));
    int *loop_end     = calloc((size_t)f->n_bbs, sizeof(int));
    if (!in_loop || !loop_header || !loop_end) {
        free(in_loop); free(loop_header); free(loop_end);
        return 0;
    }
    licm_find_loops(f, in_loop, loop_header, loop_end);

    /* For each loop header, look up (or remember) its pre-header. -1
       means "no natural pre-header — skip this loop". */
    int *pre_header = calloc((size_t)f->n_bbs, sizeof(int));
    if (!pre_header) {
        free(in_loop); free(loop_header); free(loop_end);
        return 0;
    }
    for (int b = 0; b < f->n_bbs; b++) pre_header[b] = -1;
    for (int b = 0; b < f->n_bbs; b++) {
        if (loop_header[b] < 0) continue;
        int h = loop_header[b];
        if (pre_header[h] != -1) continue;  /* already computed */
        pre_header[h] = licm_pre_header(f, in_loop, h);
    }

    int hoisted = 0;

    /* Per-vreg def counts: hoisting is only sound for single-def
       dsts. A multi-def vreg (e.g. `r = K` in each arm of a switch
       whose forward-goto BRs look like back-edges in id order) gets
       every arm's def stacked into the pre-header, leaving the last
       writer's value. Single-def pure ops are safe: nothing else
       writes the dst, so executing the def earlier/unconditionally
       preserves every use. */
    int *def_count = calloc((size_t)f->n_vregs, sizeof(int));
    if (!def_count) {
        free(in_loop); free(loop_header); free(loop_end);
        free(pre_header);
        return 0;
    }
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            int defs[16];
            int nd = ir_op_defs(&bb->ops[j], defs,
                                (int)(sizeof defs / sizeof defs[0]));
            for (int k = 0; k < nd && k < 16; k++)
                if (defs[k] >= 0 && defs[k] < f->n_vregs)
                    def_count[defs[k]]++;
        }
    }

    /* Walk loop BBs and hoist eligible ops. Mark hoisted ops dead,
       compact each BB at the end. We do the walk in BB-id order so a
       hoisted op landing in the pre-header is visible (in terms of
       def order) to any later use we encounter. */
    for (int b = 0; b < f->n_bbs; b++) {
        if (!in_loop[b]) continue;
        int h = loop_header[b];
        if (h < 0) continue;
        int ph = pre_header[h];
        if (ph < 0 || ph == b) continue;       /* no pre-header */
        if (in_loop[ph]) continue;             /* sanity check */

        BB *bb = &f->bbs[b];
        if (bb->n_ops <= 0) continue;
        unsigned char *dead = calloc((size_t)bb->n_ops, 1);
        if (!dead) continue;

        for (int j = 0; j < bb->n_ops; j++) {
            Op *op = &bb->ops[j];
            if (!licm_eligible_kind(op->kind)) continue;
            if (op->mem.volatile_) continue;
            if (op->dst < 0 || op->dst >= f->n_vregs
                || def_count[op->dst] != 1) continue;
            BB *pbb = &f->bbs[ph];
            if (licm_insert_before_terminator(pbb, op) != 0) continue;
            dead[j] = 1;
            hoisted++;
        }

        int new_n = 0;
        for (int j = 0; j < bb->n_ops; j++) {
            if (dead[j]) continue;
            if (new_n != j) bb->ops[new_n] = bb->ops[j];
            new_n++;
        }
        bb->n_ops = new_n;
        free(dead);
    }

    free(def_count);
    free(in_loop);
    free(loop_header);
    free(loop_end);
    free(pre_header);
    return hoisted;
}

/* ---- 3f: induction-variable strength reduction (IVSR) ------------ */

/* The canonical indexed-array walk `for(i;i<n;i++) sum += a[i]` builds,
   per iteration, a fresh address `a + i*scale` (an `SHL i,s` + `ADD
   base,i`). IVSR replaces that recompute with a stepped pointer `p`:
   `p = base + K*scale` once in the pre-header, `p += step*scale` in the
   latch, and every use of the derived address reads `p` directly. The
   basic IV `i` is left alone (it still drives the exit test — LFTR, a
   later pass, is what would kill it). Conservative: bails on anything it
   can't prove safe (see the guards below). IR_NO_IVSR opts out. */

/* Rewrite a use of `old` in `op` to `newv`: covers the src operands and
   an IR_MEM_VREG base (LD_MEM/ST_MEM). Returns the number of fields
   changed — callers compare it against the use count to detect a use
   shape they can't redirect (and then bail). */
static int ivsr_rewrite_use(Op *op, int old, int newv)
{
    int n = 0;
    if (op->src[0] == old) { op->src[0] = newv; n++; }
    if (op->src[1] == old) { op->src[1] = newv; n++; }
    if ((op->kind == IR_LD_MEM || op->kind == IR_ST_MEM)
        && op->mem.kind == IR_MEM_VREG && op->mem.base == old) {
        op->mem.base = newv; n++;
    }
    return n;
}

/* Count defs of vreg v inside vs. outside the loop body [lo,hi]. When a
   side's count is exactly 1, its bb/idx out-params point at that def. */
static void ivsr_def_sites(Func *f, int v, int lo, int hi,
                           int *n_in, int *in_bb, int *in_idx,
                           int *n_out, int *out_bb, int *out_idx)
{
    *n_in = *n_out = 0;
    *in_bb = *in_idx = *out_bb = *out_idx = -1;
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        int inside = (b >= lo && b <= hi);
        for (int j = 0; j < bb->n_ops; j++) {
            int defs[8];
            int nd = ir_op_defs(&bb->ops[j], defs, 8);
            for (int k = 0; k < nd; k++) {
                if (defs[k] != v) continue;
                if (inside) { (*n_in)++;  *in_bb  = b; *in_idx  = j; }
                else        { (*n_out)++; *out_bb = b; *out_idx = j; }
            }
        }
    }
}

/* True if v is used in any BB outside the loop body [lo,hi]. */
static int ivsr_used_outside(Func *f, int v, int lo, int hi)
{
    for (int b = 0; b < f->n_bbs; b++) {
        if (b >= lo && b <= hi) continue;
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            int uses[8];
            int nu = ir_op_uses(&bb->ops[j], uses, 8);
            for (int k = 0; k < nu; k++)
                if (uses[k] == v) return 1;
        }
    }
    return 0;
}

/* Number of in-loop uses of v. */
static int ivsr_uses_in_loop(Func *f, int v, int lo, int hi)
{
    int c = 0;
    for (int b = lo; b <= hi; b++) {
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            int uses[8];
            int nu = ir_op_uses(&bb->ops[j], uses, 8);
            for (int k = 0; k < nu; k++)
                if (uses[k] == v) c++;
        }
    }
    return c;
}

/* Count uses of `v` in a single op. */
static int ivsr_uses_in_op(const Op *o, int v)
{
    int uses[8];
    int nu = ir_op_uses(o, uses, 8);
    int c = 0;
    for (int k = 0; k < nu; k++) if (uses[k] == v) c++;
    return c;
}

/* True if `base`'s reaching def is an IR_LD_SYM (a compile-time-constant
   address, e.g. a static array). Such a base makes recomputing the indexed
   address `base + iv*scale` cheap (ld hl,SYM; add hl,de) — no persistent
   pointer register needed. Scans out-of-loop defs (base is loop-invariant). */
static int ivsr_base_is_const_sym(Func *f, int base, int lo, int hi)
{
    if (base < 0 || base >= f->n_vregs) return 0;
    for (int b = 0; b < f->n_bbs; b++) {
        if (b >= lo && b <= hi) continue;
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            int defs[8];
            int nd = ir_op_defs(o, defs, 8);
            for (int k = 0; k < nd; k++)
                if (defs[k] == base)
                    return o->kind == IR_LD_SYM;   /* only LD_SYM counts */
        }
    }
    return 0;
}

/* Recognise a basic IV `v`: exactly one in-loop self-step def
   (v = v ± c via INC/DEC/ADD-imm/SUB-imm) and exactly one out-of-loop
   def that is an LD_IMM init in the pre-header `ph`. Returns 1 and fills
   *K (init) / *D (signed step). Address-taken / volatile vregs bail. */
static int ivsr_basic_iv(Func *f, int v, int lo, int hi, int ph,
                         int64_t *K, int64_t *D)
{
    if (v < 0 || v >= f->n_vregs) return 0;
    if (f->vregs[v].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
        return 0;
    int n_in, in_bb, in_idx, n_out, out_bb, out_idx;
    ivsr_def_sites(f, v, lo, hi, &n_in, &in_bb, &in_idx,
                   &n_out, &out_bb, &out_idx);
    if (n_in != 1 || n_out != 1) return 0;
    if (out_bb != ph) return 0;
    Op *initop = &f->bbs[out_bb].ops[out_idx];
    if (initop->kind != IR_LD_IMM) return 0;
    Op *step = &f->bbs[in_bb].ops[in_idx];
    if (step->dst != v || step->src[0] != v) return 0;
    int64_t d;
    switch (step->kind) {
    case IR_INC: d =  1; break;
    case IR_DEC: d = -1; break;
    case IR_ADD: if (step->src[1] != -1) return 0; d =  step->imm; break;
    case IR_SUB: if (step->src[1] != -1) return 0; d = -step->imm; break;
    default: return 0;
    }
    *K = initop->imm;
    *D = d;
    return 1;
}

/* Is `x` a derived-IV scaling term off a basic IV in loop [lo,hi]?
   Either x is itself a basic IV (scale 1, *shl_bb = -1) or x is a
   single-use `SHL x <- iv, s` whose iv is a basic IV (scale 2^s, *shl_bb
   points at the SHL). Fills *iv / *scale / *K / *D. */
static int ivsr_iv_term(Func *f, int x, int lo, int hi, int ph,
                        int *iv_out, int64_t *scale, int64_t *K, int64_t *D,
                        int *shl_bb, int *shl_idx)
{
    int64_t k, d;
    if (ivsr_basic_iv(f, x, lo, hi, ph, &k, &d)) {
        *iv_out = x; *scale = 1; *K = k; *D = d;
        *shl_bb = -1; *shl_idx = -1;
        return 1;
    }
    int n_in, in_bb, in_idx, n_out, out_bb, out_idx;
    ivsr_def_sites(f, x, lo, hi, &n_in, &in_bb, &in_idx,
                   &n_out, &out_bb, &out_idx);
    if (n_in != 1 || n_out != 0) return 0;
    Op *sh = &f->bbs[in_bb].ops[in_idx];
    if (sh->kind != IR_SHL || sh->src[1] != -1) return 0;
    if (sh->imm < 0 || sh->imm >= 16) return 0;
    if (!ivsr_basic_iv(f, sh->src[0], lo, hi, ph, &k, &d)) return 0;
    /* The SHL must feed only this loop (its sole consumer is the ADD we
       are about to fold away), else NOPing it drops a live value. */
    if (ivsr_uses_in_loop(f, x, lo, hi) != 1) return 0;
    if (ivsr_used_outside(f, x, lo, hi)) return 0;
    *iv_out = sh->src[0]; *scale = (int64_t)1 << sh->imm;
    *K = k; *D = d;
    *shl_bb = in_bb; *shl_idx = in_idx;
    return 1;
}

/* Every in-loop use of `d` must be redirectable by ivsr_rewrite_use
   (src operand or IR_MEM_VREG base) — a call-arg / port use we can't
   rewrite would dangle after the def is NOPed. */
static int ivsr_d_rewritable(Func *f, int d, int lo, int hi,
                             int add_bb, int add_idx)
{
    for (int b = lo; b <= hi; b++) {
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            if (b == add_bb && j == add_idx) continue; /* the defining ADD */
            Op *op = &bb->ops[j];
            int uses[8];
            int nu = ir_op_uses(op, uses, 8);
            int nd = 0;
            for (int k = 0; k < nu; k++) if (uses[k] == d) nd++;
            if (!nd) continue;
            int ok = (op->src[0] == d) + (op->src[1] == d)
                   + (((op->kind == IR_LD_MEM || op->kind == IR_ST_MEM)
                       && op->mem.kind == IR_MEM_VREG
                       && op->mem.base == d) ? 1 : 0);
            if (ok != nd) return 0;   /* a use we can't redirect */
        }
    }
    return 1;
}

typedef struct {
    int     d;          /* derived-IV vreg (the recomputed address) */
    int     iv;         /* the basic IV it derives from */
    int     base;       /* loop-invariant base */
    int64_t scale;      /* element scale (1 / 2^s) */
    int64_t K, D;       /* basic-IV init / step */
    int     add_bb, add_idx;   /* the `ADD d <- base, term` to NOP */
    int     shl_bb, shl_idx;   /* the scale `SHL` to NOP (-1 if scale 1) */
    int     p;          /* synthesised stepped pointer */
} IvsrCand;

#define IVSR_MAX_CAND 32

/* Set on a fresh stack Op so synthesised ADD/MOV are well-formed. */
static void ivsr_init_op(Op *o, OpKind kind)
{
    memset(o, 0, sizeof(*o));
    o->kind = kind;
    o->dst = -1;
    o->src[0] = -1; o->src[1] = -1;
    o->label = -1;
    o->mem.base = -1;
}

/* True if the exit-test bound is a provably non-negative compile-time
   constant — an immediate on the compare, or an invariant LD_IMM>=0
   vreg. The signed→unsigned pointer-compare LFTR is only safe then (a
   negative bound makes `i<n` a 0-trip loop that `p<p_end` would run as a
   huge wrapped loop). ir_opt can't see KIND signedness, so a constant is
   the safe signal we can check here. */
static int ivsr_const_bound(Func *f, const Op *cmp, int lo, int hi,
                            int64_t *N)
{
    if (cmp->src[1] == -1) {                 /* immediate bound */
        if (cmp->imm < 0) return 0;
        *N = cmp->imm; return 1;
    }
    int v = cmp->src[1];
    if (v < 0) return 0;
    int ni, ib, ii, no, ob, oi;
    ivsr_def_sites(f, v, lo, hi, &ni, &ib, &ii, &no, &ob, &oi);
    if (ni != 0 || no != 1) return 0;        /* invariant, single def */
    Op *d = &f->bbs[ob].ops[oi];
    if (d->kind != IR_LD_IMM || d->imm < 0) return 0;
    *N = d->imm; return 1;
}

/* Linear-function test replacement. After strength reduction, if the
   loop's header exit test is `iv < N` (signed or unsigned) with iv a
   reduced basic IV stepping up, N a non-negative constant, and iv now
   used only by its own step and this test, swap the test for the pointer
   compare `p < p_end` (unsigned; p_end = base + N*scale built in the
   pre-header) and NOP iv's step + init. The basic IV is then dead — its
   slot, its per-iteration step (the costly stack-TOS `i++` dance) and the
   signed compare all vanish. Returns 1 if applied. */
static int ivsr_try_lftr(Func *f, int lo, int hi, int ph,
                         IvsrCand *cand, int n_cand)
{
    if (getenv("IR_NO_LFTR")) return 0;
    BB *hb = &f->bbs[lo];
    int cond = -1;
    for (int j = 0; j < hb->n_ops; j++) {
        OpKind k = hb->ops[j].kind;
        if (k == IR_BR_ZERO || k == IR_BR_COND) cond = hb->ops[j].src[0];
    }
    if (cond < 0) return 0;
    int ni, ib, ii, no, ob, oi;
    ivsr_def_sites(f, cond, lo, hi, &ni, &ib, &ii, &no, &ob, &oi);
    if (ni != 1 || no != 0) return 0;
    int cmp_bb = ib, cmp_idx = ii;
    Op *cmp = &f->bbs[cmp_bb].ops[cmp_idx];
    if (cmp->kind != IR_CMP_LT && cmp->kind != IR_CMP_ULT) return 0;
    int iv = cmp->src[0];
    int c = -1;
    for (int t = 0; t < n_cand; t++)
        if (cand[t].iv == iv && cand[t].D > 0 && cand[t].K >= 0) { c = t; break; }
    if (c < 0) return 0;
    /* The exit bound. Two cases:
       - a proven-nonnegative COMPILE-TIME CONSTANT: p_end = base + N*scale, a
         single pre-header ADD (the original, cheapest path);
       - a loop-invariant VARIABLE bound `n` (e.g. a signed int param, the
         index_walk shape): the unsigned pointer compare `p < p_end` would turn
         a 0-trip signed loop (`n <= 0`) into a huge wrapped one if p_end fell
         below base. Guard it by clamping the bound to max(0,n) when building
         p_end — branchless, no CFG surgery: p_end = base + max(0,n)*scale >=
         base always (0-trip when n<=0, no wrap). IR_NO_LFTR_SIGNED opts out. */
    int64_t N = 0;
    int bound_v = -1;
    if (!ivsr_const_bound(f, cmp, lo, hi, &N)) {
        if (getenv("IR_NO_LFTR_SIGNED")) return 0;
        int bv = cmp->src[1];
        if (bv < 0 || bv >= f->n_vregs) return 0;   /* immediate handled above */
        if (f->vregs[bv].width != 2) return 0;       /* int bound only */
        if (f->vregs[bv].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
        int bni, bib, bii, bno, bob, boi;
        ivsr_def_sites(f, bv, lo, hi, &bni, &bib, &bii, &bno, &bob, &boi);
        if (bni != 0) return 0;                       /* must be loop-invariant */
        bound_v = bv;
    }
    /* iv used only by its step + this test, not live-out. */
    if (ivsr_uses_in_loop(f, iv, lo, hi) != 2) return 0;
    if (ivsr_used_outside(f, iv, lo, hi)) return 0;
    int s_ni, s_ib, s_ii, s_no, s_ob, s_oi;
    ivsr_def_sites(f, iv, lo, hi, &s_ni, &s_ib, &s_ii, &s_no, &s_ob, &s_oi);
    if (s_ni != 1 || s_no != 1 || s_ob != ph) return 0;

    int64_t scale = cand[c].scale;
    int base = cand[c].base, p = cand[c].p;
    /* log2(scale) — scale is 1 or a power of two (from ivsr_iv_term). */
    int sh = 0; { int64_t sc = scale; while (sc > 1) { sc >>= 1; sh++; } }

    /* Create all vregs up front (ir_vreg_new may realloc f->vregs / f->bbs
       op arrays — re-fetch the compare op by index afterwards). */
    int pend = ir_vreg_new(f, f->vregs[p].kind, NULL, 0);
    f->vregs[pend].width = f->vregs[p].width;
    int v_b = -1, v_m = -1, v_neff = -1, v_scaled = -1;
    if (bound_v >= 0) {
        v_b = ir_vreg_new(f, KIND_INT, NULL, 0); f->vregs[v_b].width = 2;
        v_m = ir_vreg_new(f, KIND_INT, NULL, 0); f->vregs[v_m].width = 2;
        v_neff = ir_vreg_new(f, KIND_INT, NULL, 0); f->vregs[v_neff].width = 2;
        if (sh > 0) {
            v_scaled = ir_vreg_new(f, KIND_INT, NULL, 0);
            f->vregs[v_scaled].width = 2;
        } else {
            v_scaled = v_neff;
        }
    }

    /* Rewrite the test to the unsigned pointer compare. */
    Op *c2 = &f->bbs[cmp_bb].ops[cmp_idx];
    c2->kind = IR_CMP_ULT;
    c2->src[0] = p; c2->src[1] = pend; c2->imm = 0;
    /* Kill the now-dead basic IV (step + init). */
    f->bbs[s_ib].ops[s_ii].kind = IR_NOP;
    f->bbs[s_ob].ops[s_oi].kind = IR_NOP;

    Op o;
    if (bound_v < 0) {
        /* p_end = base + N*scale (constant). */
        int64_t end_off = N * scale;
        if (end_off == 0) { ivsr_init_op(&o, IR_MOV); o.dst = pend; o.src[0] = base; }
        else { ivsr_init_op(&o, IR_ADD); o.dst = pend; o.src[0] = base; o.imm = end_off; }
        licm_insert_before_terminator(&f->bbs[ph], &o);
    } else {
        /* neff = max(0, n), branchlessly and with only reliable ops (80cc has
           no arithmetic >> — IR_SHR is logical, #289 — and a standalone
           compare-to-value mis-lowers here):
             sb   = (unsigned)n >> 15   (0 if n>=0, 1 if n<0)   [logical shift]
             mask = sb - 1              (0xFFFF if n>=0, 0 if n<0)
             neff = n & mask            (n if n>=0, 0 if n<0) */
        ivsr_init_op(&o, IR_SHR); o.dst = v_b; o.src[0] = bound_v; o.imm = 15;
        licm_insert_before_terminator(&f->bbs[ph], &o);
        ivsr_init_op(&o, IR_SUB); o.dst = v_m; o.src[0] = v_b; o.imm = 1;
        licm_insert_before_terminator(&f->bbs[ph], &o);
        ivsr_init_op(&o, IR_AND); o.dst = v_neff; o.src[0] = bound_v; o.src[1] = v_m;
        licm_insert_before_terminator(&f->bbs[ph], &o);
        if (sh > 0) {
            ivsr_init_op(&o, IR_SHL); o.dst = v_scaled; o.src[0] = v_neff; o.imm = sh;
            licm_insert_before_terminator(&f->bbs[ph], &o);
        }
        /* p_end = base + neff*scale. */
        ivsr_init_op(&o, IR_ADD); o.dst = pend; o.src[0] = base; o.src[1] = v_scaled;
        licm_insert_before_terminator(&f->bbs[ph], &o);
    }
    return 1;
}

/* Strength-reduce one natural loop (header h, single latch, pre-header
   ph; body = contiguous range [h, latch]). Returns derived IVs reduced. */
static int ivsr_process_loop(Func *f, int h, int latch, int ph)
{
    int lo = h, hi = latch;
    IvsrCand cand[IVSR_MAX_CAND];
    int n_cand = 0;

    for (int b = lo; b <= hi && n_cand < IVSR_MAX_CAND; b++) {
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops && n_cand < IVSR_MAX_CAND; j++) {
            Op *op = &bb->ops[j];
            if (op->kind != IR_ADD) continue;
            if (op->src[0] < 0 || op->src[1] < 0) continue; /* need 2 vregs */
            int d = op->dst;
            if (d < 0) continue;

            /* Try each operand as the IV term, the other as the base. */
            for (int swap = 0; swap < 2; swap++) {
                int term = swap ? op->src[1] : op->src[0];
                int base = swap ? op->src[0] : op->src[1];
                int iv; int64_t scale, K, D; int sb, si;
                if (!ivsr_iv_term(f, term, lo, hi, ph,
                                  &iv, &scale, &K, &D, &sb, &si))
                    continue;
                if (base == d || base == iv || base < 0) continue;
                /* base loop-invariant: no def inside the loop. */
                int ni, ib, ii, no, ob, oi;
                ivsr_def_sites(f, base, lo, hi, &ni, &ib, &ii,
                               &no, &ob, &oi);
                if (ni != 0) continue;
                /* d: single in-loop def (this ADD), not live-out, and
                   every other in-loop use is redirectable. */
                ivsr_def_sites(f, d, lo, hi, &ni, &ib, &ii, &no, &ob, &oi);
                if (ni != 1 || ib != b || ii != j) continue;
                if (ivsr_used_outside(f, d, lo, hi)) continue;
                if (!ivsr_d_rewritable(f, d, lo, hi, b, j)) continue;

                /* Redundant-pointer gate: when the base is a constant address
                   (LD_SYM) AND the index `iv` is independently live — it has
                   in-loop uses beyond this derived address, so it survives LFTR
                   and must stay resident anyway — a stepped pointer is a SECOND
                   loop-carried value competing for the one BC home. It loses,
                   spills to a slot, and the per-iteration slot RMW costs more
                   than recomputing `base + iv*scale` from the resident index
                   (sdcc's strategy; queenbench's `safe`). Suppress here.
                   Detect "survives LFTR": after this reduction removes iv's use
                   in the address derivation (the SHL, or the ADD when scale==1),
                   iv still has >2 in-loop uses (LFTR needs exactly 2 = step +
                   exit test). A pure array-walk (ptrbench) has exactly 2 left →
                   not suppressed, IVSR still fires. IR_NO_IVSR_SUPPRESS opts out.
                   Gated to z80/z80n/z180 — the CPUs where a slot-homed pointer's
                   `ld hl,(ix+d)` is 2 ops, so maintaining a spilled pointer costs
                   more than recomputing. ez80/kc160/rabbit have a 1-op word slot
                   load (+ native indexing), so the walking pointer stays cheaper
                   there (measured: ez80 +8% if suppressed) — leave IVSR on. */
                if (!getenv("IR_NO_IVSR_SUPPRESS")
                    && (c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180)
                    && ivsr_base_is_const_sym(f, base, lo, hi)) {
                    int addr_uses = ivsr_uses_in_op(&f->bbs[b].ops[j], iv);
                    if (sb >= 0)
                        addr_uses += ivsr_uses_in_op(&f->bbs[sb].ops[si], iv);
                    int remaining = ivsr_uses_in_loop(f, iv, lo, hi) - addr_uses;
                    if (remaining > 2) continue;   /* iv survives → pointer redundant */
                }

                cand[n_cand].d = d;     cand[n_cand].base = base;
                cand[n_cand].iv = iv;
                cand[n_cand].scale = scale;
                cand[n_cand].K = K;     cand[n_cand].D = D;
                cand[n_cand].add_bb = b; cand[n_cand].add_idx = j;
                cand[n_cand].shl_bb = sb; cand[n_cand].shl_idx = si;
                cand[n_cand].p = -1;
                n_cand++;
                break;  /* one reduction per ADD */
            }
        }
    }

    if (n_cand == 0) return 0;

    /* Create the stepped pointers (may realloc f->vregs — index after). */
    for (int c = 0; c < n_cand; c++) {
        int d = cand[c].d;
        /* INDUCTION marks the stepped pointer for the allocator's PR_BC
           pool — the one twice-written (init + step) vreg it admits, so
           the pointer lives in BC across the back-edge. */
        int pv = ir_vreg_new(f, f->vregs[d].kind, NULL, IR_VREG_INDUCTION);
        f->vregs[pv].width = f->vregs[d].width;  /* exact pointer width */
        cand[c].p = pv;
    }

    /* Phase A — in-place rewrites + NOPs (no insertions yet, so op
       indices stay stable for the still-pending candidates). */
    for (int c = 0; c < n_cand; c++) {
        int d = cand[c].d, p = cand[c].p;
        for (int b = lo; b <= hi; b++) {
            BB *bb = &f->bbs[b];
            for (int j = 0; j < bb->n_ops; j++) {
                if (b == cand[c].add_bb && j == cand[c].add_idx) continue;
                ivsr_rewrite_use(&bb->ops[j], d, p);
            }
        }
        f->bbs[cand[c].add_bb].ops[cand[c].add_idx].kind = IR_NOP;
        if (cand[c].shl_bb >= 0)
            f->bbs[cand[c].shl_bb].ops[cand[c].shl_idx].kind = IR_NOP;
    }

    /* Phase B — synthesise pre-header init and latch step. */
    for (int c = 0; c < n_cand; c++) {
        int64_t init_off = cand[c].K * cand[c].scale;
        int64_t step_off = cand[c].D * cand[c].scale;
        Op o;
        if (init_off == 0) {
            ivsr_init_op(&o, IR_MOV);
            o.dst = cand[c].p; o.src[0] = cand[c].base;
        } else {
            ivsr_init_op(&o, IR_ADD);
            o.dst = cand[c].p; o.src[0] = cand[c].base; o.imm = init_off;
        }
        licm_insert_before_terminator(&f->bbs[ph], &o);

        ivsr_init_op(&o, IR_ADD);
        o.dst = cand[c].p; o.src[0] = cand[c].p; o.imm = step_off;
        licm_insert_before_terminator(&f->bbs[latch], &o);
    }

    /* LFTR — eliminate the basic IV when the exit test allows it. */
    ivsr_try_lftr(f, lo, hi, ph, cand, n_cand);
    return n_cand;
}

int ir_opt_ivsr(Func *f)
{
    if (!f || f->n_bbs <= 0) return 0;
    if (getenv("IR_NO_IVSR")) return 0;

    /* The stepped pointer only pays off if it can live in BC across the
       back-edge (else it is a second spilled loop-carried var and the
       per-iteration slot RMW costs more than the SHL;ADD removed). The
       allocator's PR_BC envelope is function-wide and barred by any
       width-4 vreg (long ops stage through BC) or BC-clobbering op
       (IR_ST_MEM vreg+offset, non-char IR_SWITCH, IR_ASM). Mirror that
       gate here so IVSR fires only where BC residency is reachable — md5
       (full of UINT4) would otherwise regress 13%. */
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vregs[v].width == 4) return 0;
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if (o->kind == IR_ST_MEM && o->mem.kind == IR_MEM_VREG
                && o->mem.offset != 0) return 0;
            if (o->kind == IR_SWITCH && !(o->sw && o->sw->is_char)) return 0;
            if (o->kind == IR_ASM) return 0;
        }
    }

    /* Reachable-from-entry set: an unreachable BB's `succ.id <= self`
       edge is not a real back-edge (mirrors licm_find_loops). */
    int *reach = calloc((size_t)f->n_bbs, sizeof(int));
    if (!reach) return 0;
    {
        int *stack = calloc((size_t)f->n_bbs, sizeof(int));
        if (!stack) { free(reach); return 0; }
        int sp = 0; reach[0] = 1; stack[sp++] = 0;
        while (sp > 0) {
            BB *cbb = &f->bbs[stack[--sp]];
            int ns = ir_bb_n_succ(cbb);
            for (int s = 0; s < ns; s++) {
                int sid = ir_bb_succ_at(cbb, s);
                if (sid >= 0 && sid < f->n_bbs && !reach[sid]) {
                    reach[sid] = 1; stack[sp++] = sid;
                }
            }
        }
        free(stack);
    }

    int reduced = 0;
    /* A header `h` heads a single-latch natural loop when it has exactly
       one entry predecessor (id < h → pre-header) and exactly one
       back-edge predecessor (id >= h, and h reaches it). Found by
       scanning succ edges (pred[] isn't populated this early). */
    for (int h = 0; h < f->n_bbs; h++) {
        if (!reach[h]) continue;
        int ph = -1, latch = -1, n_entry = 0, n_back = 0;
        for (int b = 0; b < f->n_bbs; b++) {
            BB *bb = &f->bbs[b];
            int ns = ir_bb_n_succ(bb);
            int targets_h = 0;
            for (int s = 0; s < ns; s++)
                if (ir_bb_succ_at(bb, s) == h) { targets_h = 1; break; }
            if (!targets_h) continue;
            if (b < h)              { ph = b; n_entry++; }
            else if (b >= h && reach[b] && licm_reaches(f, h, b))
                                    { latch = b; n_back++; }
        }
        if (n_entry != 1 || n_back != 1) continue;
        if (ph < 0 || latch < 0 || ph == h) continue;
        reduced += ivsr_process_loop(f, h, latch, ph);
    }

    free(reach);
    return reduced;
}

int ir_opt_cse(Func *f)
{
    if (!f) return 0;
    int rewritten = 0;
    CSEntry tbl[MAX_CSE];

    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        int n = 0;

        for (int j = 0; j < bb->n_ops; j++) {
            Op *op = &bb->ops[j];

            /* IR_ASM: unknown clobbers, wipe everything. */
            if (op->kind == IR_ASM) { n = 0; continue; }

            if (cse_eligible(op->kind) && op->dst >= 0) {
                int has_imm = op_has_imm_identity(op->kind);
                int dst_w = (op->dst < f->n_vregs)
                          ? f->vregs[op->dst].width : 0;
                int hit = -1;
                for (int k = 0; k < n; k++) {
                    if (tbl[k].kind     != op->kind)   continue;
                    if (tbl[k].src0     != op->src[0]) continue;
                    if (tbl[k].src1     != op->src[1]) continue;
                    if (tbl[k].width    != dst_w)      continue;
                    if (tbl[k].has_imm  != has_imm)    continue;
                    if (has_imm && tbl[k].imm != op->imm) continue;
                    hit = k;
                    break;
                }
                if (hit >= 0) {
                    /* Rewrite to IR_MOV dst <- existing dst; the lowerer
                       branches on dst width for long vs int. */
                    int src_dst = tbl[hit].dst;
                    op->kind   = IR_MOV;
                    op->src[0] = src_dst;
                    op->src[1] = -1;
                    op->imm    = 0;
                    op->mem.kind      = IR_MEM_FRAME;
                    op->mem.sym       = NULL;
                    op->mem.base      = -1;
                    op->mem.offset    = 0;
                    op->mem.elem      = 0;
                    op->mem.volatile_ = 0;
                    op->mem.port      = NULL;
                    rewritten++;
                    /* Fall through to invalidation — the MOV writes
                       op->dst, which may match other entries. */
                } else {
                    /* Invalidate for the write BEFORE recording the
                       new entry — recording first dropped the fresh
                       entry on its own dst and CSE never fired. Skip
                       recording self-referencing ops (dst == a src):
                       their inputs name the pre-write value. */
                    cse_invalidate_for_write(tbl, &n, op->dst);
                    if (n < MAX_CSE
                        && op->src[0] != op->dst
                        && op->src[1] != op->dst) {
                        tbl[n].kind    = op->kind;
                        tbl[n].src0    = op->src[0];
                        tbl[n].src1    = op->src[1];
                        tbl[n].imm     = op->imm;
                        tbl[n].has_imm = has_imm;
                        tbl[n].dst     = op->dst;
                        tbl[n].width   = dst_w;
                        n++;
                    }
                    goto cse_invalidated;
                }
            }

            /* Invalidate entries based on what this op wrote.
               ir_op_defs covers multi-def ops (IR_POSTSTEP). */
            {
                int defs[4];
                int nd = ir_op_defs(op, defs,
                                    (int)(sizeof defs / sizeof defs[0]));
                for (int di = 0; di < nd && di < 4; di++)
                    if (defs[di] >= 0)
                        cse_invalidate_for_write(tbl, &n, defs[di]);
            }
            cse_invalidated:
            if (op->kind == IR_CALL && op->call
                && op->call->ret_vreg >= 0)
                cse_invalidate_for_write(tbl, &n, op->call->ret_vreg);
            if (op->kind == IR_HCALL && op->hcall
                && op->hcall->ret_vreg >= 0)
                cse_invalidate_for_write(tbl, &n, op->hcall->ret_vreg);
        }
    }
    return rewritten;
}

/* sym_offset_fold and vreg_offset_fold migrated to the ir_match
   table as symoff / vregoff_sym / vregoff_imm / vregoff_idx — see
   ir_match.c. */

/* Long (*p)++ fuse (long_inc_mhl) migrated to the ir_match table
   as the `incmhl` pattern — see ir_match.c. */

/* Post-step fusion (fuse_poststep) migrated to the ir_match early
   phase as the `poststep` pattern — see ir_match.c. */

/* Byte-extract idiom (extract_byte) migrated to the ir_match late
   phase as the xbyte / xbyte_b0 / xbyte_shr patterns — see
   ir_match.c. */

/* ---- Dead pure-op elimination -------------------------------------
   Remove side-effect-free ops whose dst has zero function-wide uses.
   Iterates to a fixed point so copy/address chains orphaned by other
   passes (pack_bytes kills loads -> their MOV'd bases die -> the ADDs
   feeding those die) unravel completely. Liveness isn't computed yet
   at opt time, but a function-wide use count of zero means no op
   anywhere reads the vreg — cross-BB liveness can't resurrect it. */
static int dce_pure_kind(const Op *op)
{
    switch (op->kind) {
    case IR_MOV: case IR_LD_IMM: case IR_LD_SYM: case IR_LD_STR:
    case IR_LEA:
    case IR_ADD: case IR_SUB: case IR_RSUB:
    case IR_AND: case IR_OR: case IR_XOR:
    case IR_SHL: case IR_SHR:
    case IR_INC: case IR_DEC:
    case IR_NEG: case IR_NOT:
    case IR_CONV_ZX: case IR_CONV_SX:
    case IR_CONV_TRUNC: case IR_CONV_BYTE_TO_HIGH:
    case IR_CMP_EQ:  case IR_CMP_NE:
    case IR_CMP_LT:  case IR_CMP_LE:  case IR_CMP_GT:  case IR_CMP_GE:
    case IR_CMP_ULT: case IR_CMP_ULE: case IR_CMP_UGT: case IR_CMP_UGE:
        return 1;
    case IR_LD_MEM:
        return !op->mem.volatile_ && op->mem.post_step == 0;
    default:
        return 0;
    }
}

int ir_opt_dce(Func *f)
{
    if (!f) return 0;
    if (getenv("IR_NO_DCE")) return 0;
    int removed = 0;
    int pass_changed;
    do {
        pass_changed = 0;
        int *use_count = calloc((size_t)f->n_vregs, sizeof(int));
        if (!use_count) break;
        for (int b = 0; b < f->n_bbs; b++) {
            BB *bb = &f->bbs[b];
            for (int j = 0; j < bb->n_ops; j++) {
                int uses[16];
                int nu = ir_op_uses(&bb->ops[j], uses,
                                    (int)(sizeof uses / sizeof uses[0]));
                for (int u = 0; u < nu && u < 16; u++) {
                    int v = uses[u];
                    if (v >= 0 && v < f->n_vregs) use_count[v]++;
                }
            }
        }
        for (int b = 0; b < f->n_bbs; b++) {
            BB *bb = &f->bbs[b];
            int new_n = 0;
            for (int j = 0; j < bb->n_ops; j++) {
                Op *op = &bb->ops[j];
                int is_dead = (op->dst >= 0 && op->dst < f->n_vregs
                               && use_count[op->dst] == 0
                               && dce_pure_kind(op));
                if (is_dead) { pass_changed++; continue; }
                if (new_n != j) bb->ops[new_n] = bb->ops[j];
                new_n++;
            }
            bb->n_ops = new_n;
        }
        free(use_count);
        removed += pass_changed;
    } while (pass_changed);
    return removed;
}

/* ---- Induction-variable range narrowing (ir_opt_narrow_iv) ----------
   A loop counter whose value range provably fits [0,256) is retyped to a
   byte (width 1, KIND_CHAR): the step becomes a byte inc/dec and its slot is
   one byte, while every int use auto-widens (load_to_hl zero-extends a
   width-1 vreg). Sound because zero-extending a value proven in [0,256)
   reproduces its exact int value. Two shapes, both off a single-latch
   natural loop whose header holds the guard:
     up:   c=c0 (0..255); header CMP_LT/ULT c,B (B<=255) or LE/ULE (B<=254);
           exactly one INC c, no DEC.               range [c0, max] <= 255
     down: c=c0 (0..255); header CMP_GT/GE/NE c,0(/1); exactly one DEC c, no
           INC (dec runs after the guard, so c stays >= 0). range [0, c0]
   IR_NO_IV_NARROW opts out. Retype only (no op insertion): the lowerer's
   width-1 paths do the rest. */

/* Classify every vreg's defs in one function-wide scan (mirrors the idx2
   counter scan in ir_alloc.c). */
typedef struct {
    int n_ldimm, n_inc, n_dec, n_other, is_base;
    int64_t initval;
} IvClass;

static int niv_classify(Func *f, IvClass *cl)
{
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                && o->mem.kind == IR_MEM_VREG && o->mem.base >= 0
                && o->mem.base < f->n_vregs)
                cl[o->mem.base].is_base = 1;
            if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                && o->src[0] < f->n_vregs)
                cl[o->src[0]].is_base = 1;
            int d = o->dst;
            if (d < 0 || d >= f->n_vregs) continue;
            if (o->kind == IR_LD_IMM)              { cl[d].n_ldimm++; cl[d].initval = o->imm; }
            else if (o->kind == IR_INC && o->src[0] == d) cl[d].n_inc++;
            else if (o->kind == IR_DEC && o->src[0] == d) cl[d].n_dec++;
            else                                    cl[d].n_other++;
        }
    }
    return 1;
}

/* Is `v` a clean counter (single const init in [0,255], only ±1 self-steps
   in one direction, no other def, no aliasing) narrowable to a byte? */
static int niv_counter_ok(Func *f, const IvClass *cl, int v, int *is_down)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2 || !kind_is_integer((int)vr->kind)) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    const IvClass *c = &cl[v];
    if (c->is_base || c->n_other != 0 || c->n_ldimm != 1) return 0;
    if (c->initval < 0 || c->initval > 255) return 0;
    if (c->n_inc == 1 && c->n_dec == 0) { *is_down = 0; return 1; }
    if (c->n_dec == 1 && c->n_inc == 0) { *is_down = 1; return 1; }
    return 0;
}

/* Header-guard bound: find a CMP in header `h` that tests counter `c`
   against a constant and bounds it. Returns 1 and sets *maxval (the largest
   value c can hold) for the up-counter; for a down-counter it only checks
   the exit test stops at >= 0 (range [0,c0], caller uses initval). */
static int niv_up_bound_ok(Func *f, int h, int c, int64_t *maxval)
{
    BB *hb = &f->bbs[h];
    for (int j = 0; j < hb->n_ops; j++) {
        const Op *o = &hb->ops[j];
        if (o->src[0] != c || o->src[1] != -1) continue;
        /* c < B: max value c reaches is B; c <= B: max is B+1. */
        if (o->kind == IR_CMP_LT || o->kind == IR_CMP_ULT) {
            if (o->imm >= 0 && o->imm <= 255) { *maxval = o->imm; return 1; }
        } else if (o->kind == IR_CMP_LE || o->kind == IR_CMP_ULE) {
            if (o->imm >= 0 && o->imm <= 254) { *maxval = o->imm + 1; return 1; }
        }
    }
    return 0;
}

static int niv_down_exit_ok(Func *f, int h, int c)
{
    BB *hb = &f->bbs[h];
    for (int j = 0; j < hb->n_ops; j++) {
        const Op *o = &hb->ops[j];
        /* while (c) / while (c != 0) / while (c > 0): stops at 0, never neg. */
        if (o->kind == IR_BR_ZERO && o->src[0] == c) return 1;
        if (o->src[0] != c || o->src[1] != -1) continue;
        if ((o->kind == IR_CMP_NE || o->kind == IR_CMP_GT
             || o->kind == IR_CMP_UGT) && o->imm == 0) return 1;
        if ((o->kind == IR_CMP_GE || o->kind == IR_CMP_UGE) && o->imm == 1) return 1;
    }
    return 0;
}

int ir_opt_narrow_iv(Func *f)
{
    if (!f || f->n_bbs <= 0 || getenv("IR_NO_IV_NARROW")) return 0;

    IvClass *cl = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1), sizeof(IvClass));
    if (!cl) return 0;
    niv_classify(f, cl);

    /* Reachability (unreachable back-edges aren't real loops). */
    int *reach = calloc((size_t)f->n_bbs, sizeof(int));
    int *stack = calloc((size_t)f->n_bbs, sizeof(int));
    if (!reach || !stack) { free(cl); free(reach); free(stack); return 0; }
    int sp = 0; reach[0] = 1; stack[sp++] = 0;
    while (sp > 0) {
        BB *cbb = &f->bbs[stack[--sp]];
        int ns = ir_bb_n_succ(cbb);
        for (int s = 0; s < ns; s++) {
            int sid = ir_bb_succ_at(cbb, s);
            if (sid >= 0 && sid < f->n_bbs && !reach[sid]) { reach[sid] = 1; stack[sp++] = sid; }
        }
    }
    free(stack);

    int narrowed = 0;
    for (int h = 0; h < f->n_bbs; h++) {
        if (!reach[h]) continue;
        /* Single-latch natural loop (mirror ir_opt_ivsr's scan). */
        int n_entry = 0, n_back = 0;
        for (int b = 0; b < f->n_bbs; b++) {
            BB *bb = &f->bbs[b];
            int ns = ir_bb_n_succ(bb), targets_h = 0;
            for (int s = 0; s < ns; s++)
                if (ir_bb_succ_at(bb, s) == h) { targets_h = 1; break; }
            if (!targets_h) continue;
            if (b < h) n_entry++;
            else if (b >= h && reach[b] && licm_reaches(f, h, b)) n_back++;
        }
        if (n_entry != 1 || n_back != 1) continue;

        /* Look in the header for a counter-vs-constant guard. */
        BB *hb = &f->bbs[h];
        for (int j = 0; j < hb->n_ops; j++) {
            const Op *o = &hb->ops[j];
            int c = -1;
            if ((o->kind >= IR_CMP_EQ && o->kind <= IR_CMP_UGE)
                && o->src[0] >= 0 && o->src[1] == -1) c = o->src[0];
            else if (o->kind == IR_BR_ZERO && o->src[0] >= 0) c = o->src[0];
            if (c < 0 || c >= f->n_vregs) continue;
            int is_down = 0;
            if (!niv_counter_ok(f, cl, c, &is_down)) continue;
            int ok = 0;
            if (!is_down) {
                int64_t maxv = 0;
                ok = niv_up_bound_ok(f, h, c, &maxv) && maxv <= 255;
            } else {
                ok = niv_down_exit_ok(f, h, c) && cl[c].initval <= 255;
            }
            if (!ok) continue;
            f->vregs[c].width = 1;
            f->vregs[c].kind  = KIND_CHAR;
            narrowed++;
        }
    }
    free(reach);
    free(cl);
    return narrowed;
}

/* ---- Byte-width narrowing (ir_opt_narrow_byte) ----------------------
   C promotes char operands to int, so `crc ^ d[i]`, `x & 0x0f`, `c << 1`
   etc. become width-2 IR ops whose result is immediately truncated back
   to a byte (CONV_TRUNC → width-1). The high byte of such an op is dead.
   This pass narrows the producing op to width 1 so ir_lower emits the
   8-bit-in-A form (no `ld h,0`, no 16-bit ALU on the always-dead high
   byte). The lowerer's byte paths read only the low byte of each operand,
   which is exactly what truncation demands — so narrowing the result is
   sufficient; operand widths are left alone. */

static int narrow_kind(const Op *op)
{
    switch (op->kind) {
    case IR_ADD: case IR_SUB:
    case IR_AND: case IR_OR: case IR_XOR:
    /* Zero/sign-extend feeding only byte uses degrades to a byte copy:
       the low byte of zext(src)/sext(src) == low byte of src for any
       source width, so the extension's high-byte work is dead. (Signed
       char arithmetic `(char)(acc op b)` promotes both operands via
       CONV_SX — narrowing those kills the per-operand sign-extend.) */
    case IR_CONV_ZX: case IR_CONV_SX:
        return 1;
    /* A plain copy is narrowable too: low byte of dst == low byte of src.
       The char ternary defines its result temp by XOR in one arm and by a
       bare MOV in the other; narrowing demands EVERY def be narrowable, so
       the MOV arm must qualify or the temp stays width-2 (and the `^7` arm
       keeps the dead `ld h,0` widen). Pairs with ir_opt_coalesce_copies,
       which folds the narrowed temp into the byte home. */
    case IR_MOV:
        return 1;
    case IR_SHL:
        return op->src[1] == -1;   /* imm count only (byte path) */
    default:
        return 0;
    }
}

/* True if EVERY def of v is an AND with an immediate mask whose high byte
   is clear — so v's value provably fits in 8 bits and a zero/cond test on
   its low byte is a test of the whole value. */
static int v_fits_byte(const Func *f, int v)
{
    int seen = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *op = &bb->ops[j];
            if (op->dst != v) continue;
            seen = 1;
            if (op->kind != IR_AND || op->src[1] != -1
                || (op->imm & ~0xFFLL) != 0)
                return 0;
        }
    }
    return seen;
}

/* True if EVERY def of v is a sign-extend of a byte source — so v's value
   provably fits a signed byte [-128,127] and its sign bit is bit 7 (not
   bit 15). A signed `v < 0` / `v >= 0` on the narrowed byte then tests the
   correct bit. (CONV_ZX would NOT qualify: an unsigned byte 0x80 is +128,
   yet bit 7 is set — narrowing would flip the sign test.) */
static int v_is_sx_of_byte(const Func *f, int v)
{
    int seen = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *op = &bb->ops[j];
            if (op->dst != v) continue;
            seen = 1;
            if (op->kind != IR_CONV_SX
                || op->src[0] < 0 || op->src[0] >= f->n_vregs
                || f->vregs[op->src[0]].width != 1)
                return 0;
        }
    }
    return seen;
}

/* Every use of vreg v demands only its low 8 bits? True when each using
   op is either a CONV_TRUNC to a byte, or a narrowable op already at
   width 1 with v in a value (not shift-count) position. A BR_ZERO/BR_COND
   truth-test counts too WHEN v provably fits a byte (a byte-mask AND, e.g.
   `crc & 0x80`): then testing the low byte is testing the whole value, so
   the producer can stay 8-bit (no `ld h,0` widen for the branch). */
static int demands_low_byte_only(const Func *f, int v)
{
    int byte_val = v_fits_byte(f, v);
    int seen = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *u = &bb->ops[j];
            int uses[16];
            int nu = ir_op_uses(u, uses, (int)(sizeof uses / sizeof uses[0]));
            int here = 0;
            for (int k = 0; k < nu; k++) if (uses[k] == v) here = 1;
            if (!here) continue;
            seen = 1;
            if (u->kind == IR_CONV_TRUNC && u->dst >= 0
                && f->vregs[u->dst].width == 1)
                continue;
            if (narrow_kind(u) && u->dst >= 0
                && f->vregs[u->dst].width == 1) {
                /* SHL count position needs full value, not just byte. */
                if (u->kind == IR_SHL && u->src[1] == v) return 0;
                continue;
            }
            if (byte_val && (u->kind == IR_BR_ZERO || u->kind == IR_BR_COND))
                continue;
            /* Signed `v REL 0` reads only v's sign bit; when v provably fits a
               signed byte (all defs sign-extend a byte) that bit is bit 7 of
               the low byte, so the compare survives narrowing. Lets the whole
               CONV_SX collapse to a byte copy (then copy-prop + DCE). */
            if ((u->kind == IR_CMP_LT || u->kind == IR_CMP_GE)
                && u->src[1] == -1 && u->imm == 0
                && v_is_sx_of_byte(f, v))
                continue;
            return 0;
        }
    }
    return seen;   /* a dead vreg (no uses) stays width-2 */
}

int ir_opt_narrow_byte(Func *f)
{
    if (!f) return 0;
    if (getenv("IR_NO_NARROW_BYTE")) return 0;
    /* A vreg is a candidate iff it has ≥1 def and EVERY def is a
       narrowable op (so each def has an 8-bit lowering). Multi-def is
       allowed — the diamond `if(c&m) c=(c<<1)^p; else c<<=1;` defines
       the same temp in both arms; narrowing the vreg narrows both. */
    char *bad = calloc((size_t)f->n_vregs, 1);   /* def disqualifies */
    char *hasdef = calloc((size_t)f->n_vregs, 1);
    if (!bad || !hasdef) { free(bad); free(hasdef); return 0; }
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *op = &bb->ops[j];
            int d = op->dst;
            if (d < 0 || d >= f->n_vregs) continue;
            hasdef[d] = 1;
            if (!narrow_kind(op)) bad[d] = 1;
        }
    }
    int changed = 0, pass_changed;
    do {
        pass_changed = 0;
        for (int d = 0; d < f->n_vregs; d++) {
            if (!hasdef[d] || bad[d]) continue;
            if (f->vregs[d].width != 2) continue;
            if (demands_low_byte_only(f, d)) {
                f->vregs[d].width = 1;
                f->vregs[d].kind  = KIND_CHAR;   /* keep kind/width consistent */
                pass_changed++;
            }
        }
        changed += pass_changed;
    } while (pass_changed);
    free(bad);
    free(hasdef);
    return changed;
}

/* ---- Local copy propagation (ir_opt_copy_prop) ---------------------
   Per-BB: an identity copy `vd <- vs` (IR_MOV, or IR_CONV_SX/CONV_ZX
   with width(vd)==width(vs) — a byte-identity copy) lets later reads of
   vd read vs directly. Narrowing signed-char arithmetic turns the
   promoting CONV_SX operands into such byte copies; without this the
   copy spills to a slot (a store + reload) where the original
   sign-extend kept the value flowing through registers — a net loss.
   Propagating the copy away and DCE-ing it recovers that.

   Surgical + safe: rewrites only src[0]/src[1] (every arithmetic /
   compare / conv / mov / branch consumer carries its inputs there; uses
   in mem.base / call args are left alone, keeping the copy live and
   correct — just unpropagated). Invalidation is by redefinition
   (ir_op_defs), so multiply-defined vregs are handled. Per-BB only — the
   copy map resets at each BB boundary. DCE then removes copies whose dst
   became unused. */
int ir_opt_copy_prop(Func *f)
{
    if (!f) return 0;
    int *copy_of = malloc((size_t)f->n_vregs * sizeof(int));
    if (!copy_of) return 0;
    int changed = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        for (int i = 0; i < f->n_vregs; i++) copy_of[i] = -1;
        for (int j = 0; j < bb->n_ops; j++) {
            Op *op = &bb->ops[j];
            /* Rewrite value operands to the copy root. */
            for (int s = 0; s < 2; s++) {
                int v = op->src[s];
                if (v >= 0 && v < f->n_vregs && copy_of[v] >= 0) {
                    op->src[s] = copy_of[v];
                    changed++;
                }
            }
            /* Invalidate any copy whose source (or dst) this op redefines. */
            int defs[8];
            int nd = ir_op_defs(op, defs, 8);
            for (int d = 0; d < nd; d++) {
                int D = defs[d];
                if (D < 0 || D >= f->n_vregs) continue;
                copy_of[D] = -1;
                for (int x = 0; x < f->n_vregs; x++)
                    if (copy_of[x] == D) copy_of[x] = -1;
            }
            /* Record this op if it's a byte-identity copy. Scoped to
               width-1: that is exactly what narrow_byte produces (the
               signed-char CONV_SX/ZX operands), and a byte vreg has no
               wide/pointer/bank lowering semantics — so propagating it
               can't expose a positional assumption (e.g. far-pointer ADD
               lowered in-place expecting dst==src0). */
            int vd = op->dst, vs = op->src[0];
            if (vd < 0 || vd >= f->n_vregs || vs < 0 || vs >= f->n_vregs
                || vs == vd)
                continue;
            if (f->vregs[vd].width != 1 || f->vregs[vs].width != 1)
                continue;
            /* width1<-width1 CONV_TRUNC is a byte-identity copy too — it
               only arises once narrow_byte shrinks the source (e.g. the
               `(unsigned char)(c<<1)` step in a char ternary). Propagating
               it away keeps the SHL→XOR chain immediate so the intermediate
               rides A (cache_a) instead of spilling. */
            int is_copy = (op->kind == IR_MOV
                           || op->kind == IR_CONV_SX
                           || op->kind == IR_CONV_ZX
                           || op->kind == IR_CONV_TRUNC);
            if (!is_copy) continue;
            if ((f->vregs[vd].flags & IR_VREG_VOLATILE)
                || (f->vregs[vs].flags & IR_VREG_VOLATILE))
                continue;
            copy_of[vd] = (copy_of[vs] >= 0) ? copy_of[vs] : vs;
        }
    }
    free(copy_of);
    return changed;
}

/* ---- Byte-copy coalescing into the home accumulator (ir_opt_coalesce_copies)
   The char ternary `c = (c&m) ? (uchar)(c<<1)^p : (uchar)(c<<1)` lowers to a
   diamond that defines a RESULT TEMP in each arm and copies it to the
   accumulator at the merge:
       BB5: SHL t1<-c,1 ; XOR v<-t1,p      BB7: (copy) c <- v
       BB6: SHL t2<-c,1 ; MOV v<-t2
   The copy keeps `v` on its own register (HL), so `c`'s byte home (E) only
   gets written at the merge — and the wide `v` carries a dead `ld h,0` widen.
   Coalescing `v` INTO `c` (rename every def of v to c, drop the now-identity
   merge copy) makes both arms write the home directly:
       BB5: SHL t1<-c,1 ; XOR c<-t1,p      BB7: (gone)
       BB6: SHL t2<-c,1 ; MOV c<-t2
   so the E-home's cross-BB carry keeps `c` resident across the diamond and
   the per-arm copy + widen vanish.

   Scoped to width-1 copies — that bounds the transform to byte values (the
   residency target) and avoids exposing the positional / pointer / long
   lowering assumptions a wider copy might carry. The source `t` need NOT be
   single-use: in the real ternary the result temp is read twice in the merge
   block — once by the copy to the accumulator and once by the next bit's
   `crc & 0x80` test — and coalescing routes BOTH onto the home, which is
   exactly the win. Correctness rests entirely on a real interference check
   (the standard Chaitin test: t and d interfere if a def of one is live-out
   alongside the other, the connecting copy excepted, since it makes them
   equal). Single-use alone would be neither sufficient nor necessary. */

/* live-out set of ops[j] in B: live-in of the next op, or the BB's live_out
   for the last op (mirrors ir_op_live_out without allocating). Requires
   ir_compute_op_liveness to have run. */
static const BitSet *op_live_out_set(const BB *B, int j)
{
    if (j + 1 < B->n_ops) return ir_op_live_in(B, j + 1);
    return (const BitSet *)B->live_out;
}

/* Chaitin interference between t and d, ignoring the connecting copy
   (copy_bb,copy_idx). True if any def of one is live-out alongside the other. */
static int coalesce_interfere(const Func *f, int t, int d,
                              const BB *copy_bb, int copy_idx)
{
    int defs[8];
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *B = &f->bbs[b];
        for (int j = 0; j < B->n_ops; j++) {
            const Op *op = &B->ops[j];
            if (B == copy_bb && j == copy_idx) continue;   /* the copy: d==t */
            int nd = ir_op_defs(op, defs, 8);
            int defs_t = 0, defs_d = 0;
            for (int k = 0; k < nd; k++) {
                if (defs[k] == t) defs_t = 1;
                if (defs[k] == d) defs_d = 1;
            }
            if (!defs_t && !defs_d) continue;
            const BitSet *lo = op_live_out_set(B, j);
            if (!lo) return 1;   /* no liveness here — be conservative */
            if (defs_t && ir_bitset_get(lo, d)) return 1;
            if (defs_d && ir_bitset_get(lo, t)) return 1;
        }
    }
    return 0;
}

/* Replace every occurrence of vreg `from` with `to` in one op. */
static void op_rename_vreg(Op *op, int from, int to)
{
    if (op->dst == from)    op->dst = to;
    if (op->src[0] == from) op->src[0] = to;
    if (op->src[1] == from) op->src[1] = to;
    if (op->mem.kind == IR_MEM_VREG && op->mem.base == from) op->mem.base = to;
    if (op->mem.port && op->mem.port->port_vreg == from)
        op->mem.port->port_vreg = to;
    if (op->call) {
        if (op->call->fnptr_vreg == from) op->call->fnptr_vreg = to;
        if (op->call->ret_vreg == from)   op->call->ret_vreg = to;
        for (int i = 0; i < op->call->n_args; i++)
            if (op->call->args[i] == from) op->call->args[i] = to;
    }
    if (op->hcall) {
        if (op->hcall->ret_vreg == from) op->hcall->ret_vreg = to;
        for (int i = 0; i < op->hcall->n_args; i++)
            if (op->hcall->args[i] == from) op->hcall->args[i] = to;
    }
}

int ir_opt_coalesce_copies(Func *f)
{
    if (!f) return 0;
    if (getenv("IR_NO_COALESCE_COPIES")) return 0;

    int total = 0, round_changed;
    do {
        round_changed = 0;
        ir_compute_liveness(f);
        ir_compute_op_liveness(f);

        for (int b = 0; b < f->n_bbs && !round_changed; b++) {
            BB *bb = &f->bbs[b];
            for (int j = 0; j < bb->n_ops && !round_changed; j++) {
                Op *op = &bb->ops[j];
                int is_copy = (op->kind == IR_MOV
                               || op->kind == IR_CONV_TRUNC
                               || op->kind == IR_CONV_ZX
                               || op->kind == IR_CONV_SX);
                if (!is_copy) continue;
                int d = op->dst, t = op->src[0];
                if (d < 0 || d >= f->n_vregs || t < 0 || t >= f->n_vregs
                    || d == t)
                    continue;
                if (f->vregs[d].width != 1 || f->vregs[t].width != 1) continue;
                /* t must be a plain temp (renaming its defs to d must not
                   alias memory or a param's entry-live range); d must not be
                   pinned to memory. */
                if (f->vregs[t].flags
                    & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM))
                    continue;
                if (f->vregs[d].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
                    continue;
                if (coalesce_interfere(f, t, d, bb, j)) continue;

                /* Safe: fold t into d everywhere, then NOP the (now d<-d) copy. */
                for (int b2 = 0; b2 < f->n_bbs; b2++) {
                    BB *B = &f->bbs[b2];
                    for (int k = 0; k < B->n_ops; k++)
                        op_rename_vreg(&B->ops[k], t, d);
                }
                op->kind = IR_NOP;
                op->dst = op->src[0] = op->src[1] = -1;
                round_changed = 1;
                total++;
            }
        }
    } while (round_changed);

    ir_free_liveness(f);   /* main pipeline recomputes before ir_alloc */
    return total;
}

/* ---- Local constant folding + algebraic identity (ir_opt_const_fold) ----
   Per-BB. Tracks each vreg's known constant (from LD_IMM, propagated through
   const-valued MOV) and simplifies arithmetic/logic ops with an identity
   constant operand into a MOV or LD_IMM — never materialising the constant
   or creating an imm-form op, so the result is always trivially lowerable.

   Motivating case (`main`): `int res = 0; res += f();` lowers to
   `LD_IMM res,0` then `ADD res<-res, t`. res is known 0 → the ADD becomes
   `MOV res<-t`, the LD_IMM goes dead (DCE), and downstream copy-prop can
   carry it. Folds handled (mask = width's all-ones):
     ADD/SUB/OR/XOR  with a 0 operand        → MOV (the other operand)
     SHL/SHR         with a 0 shift count    → MOV (the value)
     AND             with a 0 operand        → LD_IMM 0
     AND             with an all-ones operand→ MOV (the other operand)
     OR              with an all-ones operand→ LD_IMM mask
   Per-BB (constants reset at each BB head — no cross-block dataflow), which
   is enough for the straight-line `x = K; … x op y` idiom. */
static int cf_width_mask(int w, int64_t *mask)
{
    switch (w) {
    case 1: *mask = 0xFF; return 1;
    case 2: *mask = 0xFFFF; return 1;
    case 4: *mask = 0xFFFFFFFFLL; return 1;
    default: return 0;   /* width 8 / unknown: don't fold */
    }
}

int ir_opt_const_fold(Func *f)
{
    if (!f) return 0;
    if (getenv("IR_NO_CONST_FOLD")) return 0;
    int nv = f->n_vregs;
    if (nv <= 0) return 0;
    int8_t  *known = calloc((size_t)nv, 1);
    int64_t *val   = calloc((size_t)nv, sizeof(int64_t));
    if (!known || !val) { free(known); free(val); return 0; }
    int changed = 0;

    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        memset(known, 0, (size_t)nv);
        for (int j = 0; j < bb->n_ops; j++) {
            Op *op = &bb->ops[j];
            int d = op->dst;
            int s0 = op->src[0], s1 = op->src[1];
            int w = (d >= 0 && d < nv) ? f->vregs[d].width : 2;
            int64_t mask;
            int have_mask = cf_width_mask(w, &mask);
            /* Is operand `s` (a vreg or, for imm-form, the imm) the constant
               C masked to width? `*c` returns its masked value. */
            #define KCONST(s, cout) \
                ((s) >= 0 && (s) < nv && known[(s)] \
                 ? (*(cout) = val[(s)] & (have_mask ? mask : -1LL), 1) : 0)

            int folded = 0;
            if (have_mask) switch (op->kind) {
            case IR_ADD: case IR_OR: case IR_XOR: {
                int64_t c;
                if (s1 == -1) {                 /* imm form */
                    if ((op->imm & mask) == 0) { op->kind = IR_MOV; folded = 1; }
                    else if (op->kind == IR_OR && (op->imm & mask) == mask) {
                        op->kind = IR_LD_IMM; op->imm = mask; op->src[0] = -1; folded = 1;
                    }
                } else if (KCONST(s0, &c) && c == 0) {   /* 0 op x → x */
                    op->kind = IR_MOV; op->src[0] = s1; op->src[1] = -1; folded = 1;
                } else if (KCONST(s1, &c) && c == 0) {   /* x op 0 → x */
                    op->kind = IR_MOV; op->src[1] = -1; folded = 1;
                } else if (op->kind == IR_OR && (KCONST(s0, &c) && c == mask)) {
                    op->kind = IR_LD_IMM; op->imm = mask; op->src[0] = -1; op->src[1] = -1; folded = 1;
                } else if (op->kind == IR_OR && (KCONST(s1, &c) && c == mask)) {
                    op->kind = IR_LD_IMM; op->imm = mask; op->src[0] = -1; op->src[1] = -1; folded = 1;
                }
                break;
            }
            case IR_SUB:                        /* x - 0 → x (s1 only) */
                if (s1 == -1) { if ((op->imm & mask) == 0) { op->kind = IR_MOV; folded = 1; } }
                else { int64_t c; if (KCONST(s1, &c) && c == 0) { op->kind = IR_MOV; op->src[1] = -1; folded = 1; } }
                break;
            case IR_SHL: case IR_SHR:           /* x << 0 / x >> 0 → x */
                if (s1 == -1) { if ((op->imm & mask) == 0) { op->kind = IR_MOV; folded = 1; } }
                else { int64_t c; if (KCONST(s1, &c) && c == 0) { op->kind = IR_MOV; op->src[1] = -1; folded = 1; } }
                break;
            case IR_AND: {
                int64_t c;
                if (s1 == -1) {
                    if ((op->imm & mask) == 0) { op->kind = IR_LD_IMM; op->imm = 0; op->src[0] = -1; folded = 1; }
                    else if ((op->imm & mask) == mask) { op->kind = IR_MOV; folded = 1; }
                } else if ((KCONST(s0, &c) && c == 0) || (KCONST(s1, &c) && c == 0)) {
                    op->kind = IR_LD_IMM; op->imm = 0; op->src[0] = -1; op->src[1] = -1; folded = 1;
                } else if (KCONST(s0, &c) && c == mask) {
                    op->kind = IR_MOV; op->src[0] = s1; op->src[1] = -1; folded = 1;
                } else if (KCONST(s1, &c) && c == mask) {
                    op->kind = IR_MOV; op->src[1] = -1; folded = 1;
                }
                break;
            }
            case IR_CMP_EQ: case IR_CMP_NE: {
                /* Fold a constant RHS vreg into the immediate form so the
                   lowerer takes its const-RHS path. Otherwise the RHS is a
                   slotless constant vreg and the long-compare lowering reads
                   it from a slot it was never given — the `-1` no-slot
                   sentinel below the frame (`0L || 0L` read garbage and
                   compared unequal). Mask to the OPERAND width, not the
                   bool-result dst width. Done outside the `folded` path
                   because line below would zero op->imm for a non-LD_IMM. */
                if (s1 >= 0 && s1 < nv && known[s1]
                    && !(s0 >= 0 && s0 < nv && known[s0])) {
                    int sw = (s0 >= 0 && s0 < nv) ? f->vregs[s0].width : 2;
                    int64_t smask;
                    if (cf_width_mask(sw, &smask)) {
                        op->imm = val[s1] & smask;
                        op->src[1] = -1;
                        changed++;
                    }
                }
                break;
            }
            default: break;
            }
            if (folded) { op->imm = (op->kind == IR_LD_IMM) ? op->imm : 0; changed++; }

            /* Constant value into an indirect store: fold it into op->imm
               (src[0]=-1) so the lowerer stores the immediate directly — no
               value register, no A/E clobber, no DE-cache invalidation (word
               leaves PR_DE free). Byte and word; require the element-width hint
               to agree (the lowerer recovers the store width from mem.elem once
               src[0] is gone — incl. after a &sym+const base folds this into a
               MEM_SYM store). Byte folds everywhere, word is CPU-gated. Skip
               volatile / __addressmod (special lowering). */
            if (op->kind == IR_ST_MEM && op->mem.kind == IR_MEM_VREG
                && s0 >= 0 && s0 < nv && known[s0]
                && !op->mem.volatile_ && !op->mem.bank_fn) {
                int sw = f->vregs[s0].width;
                /* byte/word: any integer elem of that width (known[] tracks only
                   integer LD_IMM, so a float const never reaches here). width 4:
                   KIND_LONG ONLY — NOT KIND_CPTR (3 bytes in memory), nor
                   KIND_DOUBLE (4-byte float in math32/mbf32, format-dependent
                   bits, not an integer constant). */
                int ok = (sw == 1 || sw == 2) ? (kind_scalar_width(op->mem.elem) == sw)
                       : (sw == 4)            ? (op->mem.elem == KIND_LONG)
                       : 0;
                if (ok && ir_cpu_const_store_ok(sw)) {
                    op->imm = val[s0] & (sw == 1 ? 0xffULL
                                       : sw == 2 ? 0xffffULL : 0xffffffffULL);
                    op->src[0] = -1;
                    changed++;
                }
            }

            /* Update constant tracking for the (possibly rewritten) op. */
            if (op->kind == IR_POSTSTEP && s0 >= 0 && s0 < nv)
                known[s0] = 0;          /* steps src[0] in place */
            if (d >= 0 && d < nv) {
                if (op->kind == IR_LD_IMM) {
                    known[d] = 1;
                    val[d] = have_mask ? (op->imm & mask) : op->imm;
                } else if (op->kind == IR_MOV && op->src[0] >= 0
                           && op->src[0] < nv && known[op->src[0]]) {
                    known[d] = 1; val[d] = val[op->src[0]];
                } else if (op->kind == IR_CONV_TRUNC && op->src[0] >= 0
                           && op->src[0] < nv && known[op->src[0]]) {
                    /* Narrowing a known constant stays constant (masked to the
                       dst width) — lets a `(unsigned char)K` store fold to an
                       immediate (sieve's flags[k]=1). */
                    known[d] = 1;
                    val[d] = have_mask ? (val[op->src[0]] & mask) : val[op->src[0]];
                } else {
                    known[d] = 0;
                }
            }
            #undef KCONST
        }
    }
    free(known); free(val);
    return changed;
}

/* ---- Reassociate a reduction's add-tree into the accumulator -------------
   `acc += x0 + x1 + … + xk` is built left-leaning: (((x0+x1)+x2)+…+xk)
   feeding one `acc = acc + tree` accumulate. The tree materialises k-1
   single-use intermediates and — fatally for the word DE-home — computes the
   sub-sums through DE/HL, so the accumulator can't stay resident in DE while
   the tree uses it as scratch. Rewrite the chain IN PLACE into k+1 direct
   accumulates `acc += xi`, each an is_word_accumulate (`add hl,de; ex de,hl`)
   the DE-home recognises. The k tree-adds plus the final accumulate are the
   exact k+1 ADD slots needed, so the rewrite reuses them 1:1 — no insertion;
   the intermediate vregs simply go dead.

   Soundness: integer add is associative/commutative (2's-complement wrap), so
   reordering the addends is value-preserving. LD_MEMs are left untouched in
   program order (aliasing/volatile safe), and each reused add slot is checked
   to still see its assigned leaf already defined. Gated on c_word_resident so
   flag-off is inert (byte-identical); the win only materialises if the home
   is then picked and a resident region forms. */
extern int c_word_resident;

#define RR_MAX_CHAIN 16
int ir_opt_reassoc_reduction(Func *f)
{
    if (!f) return 0;
    if (!c_word_resident || getenv("IR_NO_WORD_RESIDENT")) return 0;
    if (getenv("IR_NO_REASSOC")) return 0;
    int nv = f->n_vregs;
    if (nv <= 0) return 0;

    /* Function-wide: total src-uses, and the single def site of each vreg. */
    int *use_cnt  = calloc((size_t)nv, sizeof(int));
    int *def_bb   = calloc((size_t)nv, sizeof(int));
    int *def_idx  = calloc((size_t)nv, sizeof(int));
    int *def_cnt  = calloc((size_t)nv, sizeof(int));
    if (!use_cnt || !def_bb || !def_idx || !def_cnt) {
        free(use_cnt); free(def_bb); free(def_idx); free(def_cnt); return 0;
    }
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            Op *o = &bb->ops[j];
            int u[16];
            int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
            for (int k = 0; k < nu; k++)
                if (u[k] >= 0 && u[k] < nv) use_cnt[u[k]]++;
            if (o->dst >= 0 && o->dst < nv) {
                if (def_cnt[o->dst]++ == 0) { def_bb[o->dst] = b; def_idx[o->dst] = j; }
            }
        }
    }

    int changed = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        for (int h = 0; h < bb->n_ops; h++) {
            Op *acc_op = &bb->ops[h];
            if (acc_op->kind != IR_ADD) continue;
            int acc = acc_op->dst;
            /* Left-leaning reduction: `acc = acc + t`, acc width-2. */
            if (acc < 0 || acc >= nv || f->vregs[acc].width != 2) continue;
            if (acc_op->src[0] != acc || acc_op->src[1] < 0) continue;
            /* acc must appear nowhere else in THIS bb (no partial-sum reader
               between the rewritten slots). It is read+written only at h. */
            int acc_refs = 0;
            for (int j = 0; j < bb->n_ops; j++) {
                Op *o = &bb->ops[j];
                if (o->dst == acc) acc_refs++;
                int u[16];
                int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
                for (int k = 0; k < nu; k++) if (u[k] == acc) acc_refs++;
            }
            if (acc_refs != 2) continue;   /* exactly: dst@h + src0@h */

            /* Walk the spine down src[0] of each intermediate, collecting the
               per-level leaf (src[1]) and finally the innermost-left leaf. */
            int chain_op[RR_MAX_CHAIN];   /* op indices, chain_op[0]=h */
            int leaf[RR_MAX_CHAIN];
            int chain_n = 0, leaf_n = 0, ok = 1;
            chain_op[chain_n++] = h;
            int cur = acc_op->src[1];
            while (1) {
                if (cur < 0 || cur >= nv) { ok = 0; break; }
                if (use_cnt[cur] != 1) break;          /* shared ⇒ a leaf, stop */
                if (def_cnt[cur] != 1 || def_bb[cur] != b) break;  /* not a local single def */
                int di = def_idx[cur];
                Op *da = &bb->ops[di];
                if (da->kind != IR_ADD) break;          /* leaf (e.g. LD_MEM), stop */
                if (f->vregs[cur].width != 2) { ok = 0; break; }
                if (da->src[0] < 0 || da->src[1] < 0) { ok = 0; break; }
                if (chain_n >= RR_MAX_CHAIN || leaf_n >= RR_MAX_CHAIN) { ok = 0; break; }
                chain_op[chain_n++] = di;
                leaf[leaf_n++] = da->src[1];
                cur = da->src[0];
            }
            if (!ok) continue;
            if (leaf_n >= RR_MAX_CHAIN) continue;
            leaf[leaf_n++] = cur;                        /* innermost-left leaf */
            if (chain_n < 2 || chain_n != leaf_n) continue;   /* need a real tree */

            /* Each leaf must be a width-2 LD_MEM defined once in THIS bb — so
               we own a load op to pair with each accumulate. (Live-in leaves
               have no local load to interleave; bail rather than spill.) */
            int bad = 0, ld_idx[RR_MAX_CHAIN];
            for (int i = 0; i < leaf_n; i++) {
                int lv = leaf[i];
                if (lv < 0 || lv >= nv || f->vregs[lv].width != 2) { bad = 1; break; }
                if (def_cnt[lv] != 1 || def_bb[lv] != b) { bad = 1; break; }
                ld_idx[i] = def_idx[lv];
                if (bb->ops[ld_idx[i]].kind != IR_LD_MEM) { bad = 1; break; }
            }
            if (bad) continue;

            /* Reorder the chain's span into interleaved load/accumulate pairs
               (`LD li; acc += li`), so each leaf is consumed the instant it is
               loaded and never spills. The span [lo..h] holds the k+1 loads +
               k+1 chain adds; any OTHER op in it must be a dead pure temp
               (its dst unused — e.g. the address-calc adds DCE will remove),
               which we overwrite with a NOP. A live/impure foreign op ⇒ bail. */
            int span_lo = h, span_hi = h;
            for (int i = 0; i < chain_n; i++) {
                if (chain_op[i] < span_lo) span_lo = chain_op[i];
                if (chain_op[i] > span_hi) span_hi = chain_op[i];
                if (ld_idx[i] < span_lo) span_lo = ld_idx[i];
                if (ld_idx[i] > span_hi) span_hi = ld_idx[i];
            }
            /* Mark the chain ops; classify the rest. */
            for (int q = span_lo; q <= span_hi && !bad; q++) {
                int is_chain = (q == h);
                for (int i = 0; i < chain_n && !is_chain; i++)
                    if (q == chain_op[i] || q == ld_idx[i]) is_chain = 1;
                if (is_chain) continue;
                const Op *o = &bb->ops[q];
                /* Foreign op: a NOP (e.g. an address-add the matcher folded
                   into a load) is free to overwrite; any other op must be a
                   dead, pure value temp (dst unused) we can drop. */
                if (o->kind == IR_NOP) continue;
                switch (o->kind) {
                case IR_MOV: case IR_LD_IMM: case IR_LD_SYM: case IR_LD_STR:
                case IR_ADD: case IR_SUB: case IR_RSUB: case IR_AND:
                case IR_OR:  case IR_XOR: case IR_SHL: case IR_SHR:
                case IR_NOT: case IR_NEG: case IR_LEA:
                    if (o->dst < 0 || o->dst >= nv || use_cnt[o->dst] != 0) bad = 1;
                    break;
                default: bad = 1; break;   /* load/store/call/branch — don't move */
                }
            }
            if (bad) continue;

            /* Order leaves by load position (program order ⇒ memory reads stay
               ordered). Insertion sort the parallel (leaf, load-index) arrays. */
            int ord_leaf[RR_MAX_CHAIN], ord_ld[RR_MAX_CHAIN];
            for (int i = 0; i < leaf_n; i++) { ord_leaf[i] = leaf[i]; ord_ld[i] = ld_idx[i]; }
            for (int i = 0; i < leaf_n - 1; i++)
                for (int j = i + 1; j < leaf_n; j++)
                    if (ord_ld[j] < ord_ld[i]) {
                        int t = ord_ld[i]; ord_ld[i] = ord_ld[j]; ord_ld[j] = t;
                        t = ord_leaf[i]; ord_leaf[i] = ord_leaf[j]; ord_leaf[j] = t;
                    }
            /* Snapshot the load ops before overwriting the span. */
            Op saved_ld[RR_MAX_CHAIN];
            for (int i = 0; i < leaf_n; i++) saved_ld[i] = bb->ops[ord_ld[i]];
            const char *afile = bb->ops[h].file; int aline = bb->ops[h].line;
            /* Write the interleaved pairs into the front of the span; NOP-fill
               the trailing slots vacated by the dropped dead temps. */
            int w = span_lo;
            for (int i = 0; i < chain_n; i++) {
                bb->ops[w++] = saved_ld[i];               /* LD leaf i */
                Op *ad = &bb->ops[w++];
                memset(ad, 0, sizeof *ad);
                ad->kind = IR_ADD;
                ad->dst = acc; ad->src[0] = acc; ad->src[1] = ord_leaf[i];
                ad->mem.base = -1;
                ad->file = afile; ad->line = aline;
            }
            for (; w <= span_hi; w++) {
                Op *nop = &bb->ops[w];
                memset(nop, 0, sizeof *nop);
                nop->kind = IR_NOP; nop->dst = -1; nop->src[0] = -1; nop->src[1] = -1;
                nop->mem.base = -1;
            }
            changed++;
        }
    }
    free(use_cnt); free(def_bb); free(def_idx); free(def_cnt);
    return changed;
}
#undef RR_MAX_CHAIN

/* `*p++` deref + post-step fusion migrated to the ir_match early phase
   as the `derefpp` pattern — see ir_match.c. */

/* Byte-pack to wide load (pack_bytes) migrated to the ir_match
   packbytes phase as `packbytes` - see ir_match.c. */

/* IR_MOV elimination via producer fusion (fuse_mov) migrated to
   the ir_match early phase as the `movfuse` pattern — see
   ir_match.c. */

/* ---- Dead call-result elimination ---------------------------------
   `printf(...);` style statements allocate a ret vreg that is never
   read; gen_call then stores HL (or DEHL) to its slot after every
   call. Clear ret_vreg when it has zero function-wide uses — the
   store disappears and, since the vreg no longer appears in any op,
   so does its frame slot. */
int ir_opt_drop_dead_ret(Func *f)
{
    if (!f) return 0;
    int changed = 0;

    int *use_count = calloc((size_t)f->n_vregs, sizeof(int));
    if (!use_count) return 0;
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            int uses[16];
            int nu = ir_op_uses(&bb->ops[j], uses,
                                (int)(sizeof uses / sizeof uses[0]));
            for (int u = 0; u < nu && u < 16; u++) {
                int v = uses[u];
                if (v >= 0 && v < f->n_vregs) use_count[v]++;
            }
        }
    }

    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            Op *op = &bb->ops[j];
            if (op->kind == IR_CALL && op->call
                && op->call->ret_vreg >= 0
                && op->call->ret_vreg < f->n_vregs
                && use_count[op->call->ret_vreg] == 0) {
                if (op->dst == op->call->ret_vreg) op->dst = -1;
                op->call->ret_vreg = -1;
                changed++;
            }
            if (op->kind == IR_HCALL && op->hcall
                && op->hcall->ret_vreg >= 0
                && op->hcall->ret_vreg < f->n_vregs
                && use_count[op->hcall->ret_vreg] == 0) {
                if (op->dst == op->hcall->ret_vreg) op->dst = -1;
                op->hcall->ret_vreg = -1;
                changed++;
            }
        }
    }
    free(use_count);
    return changed;
}

/* ---- Insert IR_PUSH/POP_DEHL_LONG for long vregs that live across
   DEHL-clobbering ops ---------------------------------------------

   For each BB, find long-typed vregs whose def is followed by
   intermediate ops that clobber DEHL before the consumer reads
   the value. Replace the implicit slot-spill (~100T) with a stack
   save (`push de; push hl` ~22T) by inserting:
     IR_PUSH_DEHL_LONG src=v_a   right after the producer
     IR_POP_DEHL_LONG  src=v_a   right before the consumer

   The lowerer (see cur_sp_adjust + nxt_first_dehl_src) recognises
   IR_PUSH_DEHL_LONG as a DEHL-consuming op so the producer's
   store_dehl_finalize skips its slot write — net: spill replaced
   by push.

   Eligibility (MVP — conservative):
     - dst width 4 (long).
     - function-wide use_count exactly 1.
     - the single use is in the same BB as the def.
     - use is at op[k_use], k_use > j_def + 1 (the immediately-
       adjacent case is already handled by cur_dehl_dst_dead_safe).
     - no branches/calls in [j_def+1, k_use-1].
     - producer op kind ends with store_dehl_finalize.
     - consumer op consumes the vreg via load_to_dehl as its first
       DEHL load.
     - non-overlapping with any previously-selected candidate in
       this BB (LIFO discipline; only single-level pushes for MVP). */

static int long_producer_kind_d(OpKind k)
{
    return k == IR_LD_MEM || k == IR_ADD || k == IR_SUB
        || k == IR_AND || k == IR_OR || k == IR_XOR
        || k == IR_SHL || k == IR_SHR || k == IR_ROTL
        || k == IR_NEG || k == IR_NOT
        || k == IR_MOV
        || k == IR_CONV_ZX || k == IR_CONV_SX;
}

static int long_consumer_kind_d(OpKind k)
{
    return k == IR_ADD || k == IR_SUB
        || k == IR_AND || k == IR_OR || k == IR_XOR
        || k == IR_SHL || k == IR_SHR || k == IR_ROTL
        || k == IR_NEG || k == IR_NOT
        || k == IR_ST_MEM
        || k == IR_PUSH_DEHL_LONG;
}

static int op_is_branch_or_call_d(OpKind k)
{
    return k == IR_BR || k == IR_BR_COND || k == IR_BR_ZERO
        || k == IR_SWITCH || k == IR_PUSH_ARG
        || k == IR_RET || k == IR_CALL || k == IR_HCALL;
}

int ir_opt_insert_long_pushes(Func *f)
{
    if (!f) return 0;
    int changed = 0;

    int *use_count = calloc((size_t)f->n_vregs, sizeof(int));
    if (!use_count) return 0;
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            int uses[16];
            int nu = ir_op_uses(&bb->ops[j], uses,
                                (int)(sizeof uses / sizeof uses[0]));
            for (int u = 0; u < nu; u++) {
                int v = uses[u];
                if (v >= 0 && v < f->n_vregs) use_count[v]++;
            }
        }
    }

    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        if (bb->n_ops < 3) continue;

        /* `absorbs` means the consumer is a long-binop (OR/AND/XOR/
           ADD/SUB) whose src[0] is the pushed vreg — its ir_lower
           fastpath consumes the stack value directly via byte-wise
           (hl), so we emit PUSH but NO POP. For all other consumers
           (ST_MEM, NOT/NEG, SHL/SHR, nested PUSH) we emit both. */
        typedef struct { int def_idx, use_idx, vreg, absorbs; } Cand;
        Cand cands[64];
        int n_cands = 0;

        int *bb_use_idx = calloc((size_t)f->n_vregs, sizeof(int));
        if (!bb_use_idx) continue;
        for (int i = 0; i < f->n_vregs; i++) bb_use_idx[i] = -1;
        for (int j = 0; j < bb->n_ops; j++) {
            int uses[16];
            int nu = ir_op_uses(&bb->ops[j], uses,
                                (int)(sizeof uses / sizeof uses[0]));
            for (int u = 0; u < nu; u++) {
                int v = uses[u];
                if (v >= 0 && v < f->n_vregs && bb_use_idx[v] < 0)
                    bb_use_idx[v] = j;
            }
        }

        for (int j = 0; j < bb->n_ops && n_cands < 64; j++) {
            const Op *def_op = &bb->ops[j];
            int dst = def_op->dst;
            if (dst < 0 || dst >= f->n_vregs) continue;
            if (f->vregs[dst].width != 4) continue;
            if (f->vregs[dst].flags & IR_VREG_ADDR_TAKEN) continue;
            if (use_count[dst] != 1) continue;
            int k = bb_use_idx[dst];
            if (k < 0 || k <= j + 1) continue;
            if (!long_producer_kind_d(def_op->kind)) continue;

            const Op *use_op = &bb->ops[k];
            if (!long_consumer_kind_d(use_op->kind)) continue;

            int safe = 1;
            for (int x = j + 1; x < k && safe; x++) {
                if (op_is_branch_or_call_d(bb->ops[x].kind)) safe = 0;
                if (bb->ops[x].kind == IR_PUSH_DEHL_LONG
                 || bb->ops[x].kind == IR_POP_DEHL_LONG) safe = 0;
            }
            if (!safe) continue;

            int matches = 0;
            int absorbs = 0;
            if (use_op->kind == IR_ST_MEM) {
                if (use_op->src[0] == dst) matches = 1;
            } else if (use_op->kind == IR_PUSH_DEHL_LONG) {
                if (use_op->src[0] == dst) matches = 1;
            } else {
                if (use_op->src[0] == dst) {
                    matches = 1;
                    /* Long-binop consumers with the stacked vreg as
                       src[0] absorb it directly via the option-B
                       fastpath. SHL/SHR/NOT/NEG/MOV are single-source
                       and need the POP to materialize DEHL. SUB has
                       NO option-B block in the lowerer (only ADD and
                       the AND/OR/XOR family do) — marking it absorbing
                       left the value orphaned on the stack and the
                       consumer reading the stale slot. */
                    if (use_op->kind == IR_ADD
                     || use_op->kind == IR_AND || use_op->kind == IR_OR
                     || use_op->kind == IR_XOR)
                        absorbs = 1;
                }
                else if ((use_op->kind == IR_ADD || use_op->kind == IR_AND
                       || use_op->kind == IR_OR  || use_op->kind == IR_XOR)
                       && use_op->src[1] == dst)
                    matches = 1;   /* no absorb — option B's fastpath
                                      only handles src[0]==dst today */
            }
            if (!matches) continue;

            cands[n_cands].def_idx = j;
            cands[n_cands].use_idx = k;
            cands[n_cands].vreg    = dst;
            cands[n_cands].absorbs = absorbs;
            n_cands++;
        }
        free(bb_use_idx);

        if (n_cands == 0) continue;

        char selected[64] = {0};
        int last_use = -1;
        for (int i = 0; i < n_cands; i++) {
            if (cands[i].def_idx + 1 > last_use) {
                selected[i] = 1;
                last_use = cands[i].use_idx;
            }
        }

        int n_selected = 0;
        for (int i = 0; i < n_cands; i++) if (selected[i]) n_selected++;
        if (n_selected == 0) continue;

        int new_cap = bb->n_ops + 2 * n_selected + 8;
        Op *new_ops = calloc((size_t)new_cap, sizeof(Op));
        if (!new_ops) continue;
        int new_n = 0;

        int next_cand = 0;
        for (int j = 0; j < bb->n_ops; j++) {
            /* POP before this op if any selected cand has use_idx == j
               AND the consumer is NOT an absorbing binop — those
               consume the stacked value via option B's fastpath. */
            for (int ci2 = 0; ci2 < n_cands; ci2++) {
                if (!selected[ci2]) continue;
                if (cands[ci2].use_idx != j) continue;
                if (cands[ci2].absorbs) break;
                Op *pop = &new_ops[new_n++];
                pop->kind = IR_POP_DEHL_LONG;
                pop->dst = -1;
                pop->src[0] = cands[ci2].vreg;
                pop->src[1] = -1;
                pop->label = -1;
                break;
            }

            new_ops[new_n++] = bb->ops[j];

            /* PUSH after this op if it's a selected def. */
            while (next_cand < n_cands && !selected[next_cand]) next_cand++;
            if (next_cand < n_cands && cands[next_cand].def_idx == j) {
                Op *push = &new_ops[new_n++];
                push->kind = IR_PUSH_DEHL_LONG;
                push->dst = -1;
                push->src[0] = cands[next_cand].vreg;
                push->src[1] = -1;
                push->label = -1;
                next_cand++;
                changed++;
            }
        }

        free(bb->ops);
        bb->ops = new_ops;
        bb->n_ops = new_n;
        bb->cap_ops = new_cap;
    }

    free(use_count);
    return changed;
}

/* Immediate-conversion folding (fold_imm_conv) migrated to the
   ir_match table as the `immconv` pattern — see ir_match.c. */

/* ROTATE_LEFT triple fusion (fuse_rotl) migrated to the ir_match
   table as the `rotl` pattern — see ir_match.c. */
