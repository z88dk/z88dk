/*
 * ir_opt.c — IR-level optimisation passes.
 *
 * Each pass walks the IR and mutates it in-place. Decoupled from the
 * compiler internals (no ccdefs.h) so ir_selftest can link standalone.
 */

#include "ir_opt.h"
#include "ir_analysis.h"

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

/* Walk succ[] to detect loops via back-edges. For each BB B, any
   successor S with S.id ≤ B.id is a candidate back-edge into a loop
   header at S — confirmed only when S actually reaches B (licm_reaches),
   so a forward join edge to a lower-numbered block isn't mistaken for a
   loop. The loop body is the contiguous range [S.id, B.id]. (Reducible
   CFG assumption — true for IR produced by our builder.) Sets bb_in_loop[]
   and per-BB loop_header[] (-1 if not in any loop). For nested loops,
   keeps the OUTERMOST header (lowest id) — sufficient for hoisting all
   the way out. */
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
    for (int b = 0; b < f->n_bbs; b++) {
        if (reachable && !reachable[b]) continue;   /* dead BB: no real edges */
        BB *bb = &f->bbs[b];
        int ns = ir_bb_n_succ(bb);
        for (int s = 0; s < ns; s++) {
            int sid = ir_bb_succ_at(bb, s);
            if (sid < 0 || sid > b) continue;
            /* sid <= b is necessary but not sufficient: confirm the
               header reaches the latch (real cycle), else this is a
               forward join edge with a low-numbered target, not a loop. */
            if (!licm_reaches(f, sid, b)) continue;
            int lo = sid, hi = b;
            for (int k = lo; k <= hi; k++) {
                in_loop[k] = 1;
                /* Outermost header wins (smallest id). */
                if (loop_header[k] < 0 || lo < loop_header[k]) {
                    loop_header[k] = lo;
                    loop_end[k]    = hi;
                }
            }
        }
    }
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
    return k == IR_LD_IMM || k == IR_LD_SYM
        || k == IR_LD_STR || k == IR_LEA;
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
            int is_copy = (op->kind == IR_MOV
                           || op->kind == IR_CONV_SX
                           || op->kind == IR_CONV_ZX);
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
