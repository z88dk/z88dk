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
    /* For 3c (dead-store): when this entry was created by a IR_ST_MEM,
       store_origin_op is the op index of that store; -1 if the entry
       came from a IR_LD_MEM (RLE source — never dead-eliminable). When
       a later IR_ST_MEM exactly overwrites this entry and the entry has
       store_origin_op >= 0, the original store is dead and gets marked
       in the per-BB dead[] bitset. */
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
        /* Dead-op bitset, sized to the BB. Marked ops are compacted out
           at the end of the BB walk. Allocated per-BB so the size is
           always exact. */
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

            /* IR_LD_MEM: try to forward against the shadow. If no match,
               track THIS load — a subsequent IR_LD_MEM of the same
               address can MOV from this dst (redundant load elimination,
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
                    /* Forward: rewrite IR_LD_MEM dst <- [mem]
                                as     IR_MOV    dst <- sh[hit].stored_vreg.
                       The original ST_MEM's store_origin_op (if any) is
                       NOT marked dead here — the load above used the
                       cached vreg directly, not memory. Dead-store
                       elimination only fires when a later ST_MEM
                       overwrites; the read happening here is fine. */
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
                /* No prior match — track this load as a fresh source.
                   store_origin_op = -1 marks it as a load-source (not
                   eligible for dead-store elim if overwritten). */
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
                /* Drop any entry that doesn't address-match — alias risk
                   (we don't have points-to analysis). The matching entry,
                   if any, gets overwritten with the new stored vreg. */
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
                    /* Dead-store elimination (3c): if the existing entry
                       came from a IR_ST_MEM (store_origin_op >= 0) and the
                       new store also has matching width, the original
                       store's memory effect is dead — overwritten with no
                       intervening memory read (forwarded reads use the
                       vreg directly, not memory). Mark for compaction. */
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
               base or stored_vreg is overwritten. */
            if (op->dst >= 0) {
                for (int k = 0; k < n; ) {
                    int kill = 0;
                    if (sh[k].kind == IR_MEM_VREG && sh[k].base == op->dst)
                        kill = 1;
                    else if (sh[k].stored_vreg == op->dst)
                        kill = 1;
                    if (kill) drop(sh, &n, k);
                    else k++;
                }
            }
        }

        /* Compaction: walk the BB and skip dead ops. The shadow's
           `store_origin_op` indices reference positions in the *original*
           array; we've finished using them by this point. */
        int new_n = 0;
        for (int j = 0; j < bb->n_ops; j++) {
            if (dead[j]) continue;
            if (new_n != j) bb->ops[new_n] = bb->ops[j];
            new_n++;
        }
        bb->n_ops = new_n;
        free(dead);
        /* BB boundary: shadow resets implicitly via the loop. */
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
    case IR_ADD: case IR_SUB:
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
    case IR_ADD: case IR_SUB:
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

/* Walk succ[] to detect loops via back-edges. For each BB B, any
   successor S with S.id ≤ B.id is a back-edge into a loop header at S.
   The loop body is the contiguous range [S.id, B.id]. (Reducible CFG
   assumption — true for IR produced by our builder.) Sets bb_in_loop[]
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
    for (int b = 0; b < f->n_bbs; b++) {
        BB *bb = &f->bbs[b];
        for (int s = 0; s < 2; s++) {
            int sid = bb->succ[s];
            if (sid < 0 || sid > b) continue;
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
        for (int s = 0; s < 2; s++) {
            if (bb->succ[s] == header) {
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
    /* Shift last op (terminator) down by one and insert before it. */
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
            /* Copy to pre-header before its terminator. */
            BB *pbb = &f->bbs[ph];
            if (licm_insert_before_terminator(pbb, op) != 0) continue;
            dead[j] = 1;
            hoisted++;
        }

        /* Compact: drop dead ops. */
        int new_n = 0;
        for (int j = 0; j < bb->n_ops; j++) {
            if (dead[j]) continue;
            if (new_n != j) bb->ops[new_n] = bb->ops[j];
            new_n++;
        }
        bb->n_ops = new_n;
        free(dead);
    }

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

            /* If the op is CSE-eligible, try to match against the table. */
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
                    /* Rewrite to IR_MOV dst <- existing dst. The MOV's
                       width takes care of long vs int (the lowerer's
                       IR_MOV case branches on dst width). */
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
                } else if (n < MAX_CSE) {
                    tbl[n].kind    = op->kind;
                    tbl[n].src0    = op->src[0];
                    tbl[n].src1    = op->src[1];
                    tbl[n].imm     = op->imm;
                    tbl[n].has_imm = has_imm;
                    tbl[n].dst     = op->dst;
                    tbl[n].width   = dst_w;
                    n++;
                }
            }

            /* Invalidate entries based on what this op wrote. */
            if (op->dst >= 0)
                cse_invalidate_for_write(tbl, &n, op->dst);
            if (op->kind == IR_CALL && op->call
                && op->call->ret_vreg >= 0)
                cse_invalidate_for_write(tbl, &n, op->call->ret_vreg);
            if (op->kind == IR_HCALL && op->hcall
                && op->hcall->ret_vreg >= 0)
                cse_invalidate_for_write(tbl, &n, op->hcall->ret_vreg);
        }
        /* BB boundary: table resets via loop. */
    }
    return rewritten;
}

/* ---- LD_SYM + ADD/SUB imm fold ------------------------------------

   Pattern (per BB, adjacent ops):
     IR_LD_SYM  v_a <- sym+K1         (single use across function)
     IR_ADD     v_b <- v_a (imm=K2)   (literal RHS, src[1]==-1)
   →
     IR_LD_SYM  v_b <- sym+(K1+K2)
   (original LD_SYM marked dead and compacted out)

   SUB analogous: new offset = K1 - K2.

   Eliminates the `ld hl,_sym; ld de,K; add hl,de` (5 inst) sequence
   that the lowerer emits for member access shapes like `g.counter`,
   `mdContext->buf[N]`, etc. The merged LD_SYM lowers to a single
   `ld hl,_sym+K` instruction.

   Single-use gate: the LD_SYM's dst must have exactly one use across
   the whole function (the immediately-following ADD/SUB). Multi-use
   shapes can still benefit from a future extension that keeps the
   original LD_SYM alive alongside the rewritten consumer.
*/
int ir_opt_sym_offset_fold(Func *f)
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
        if (bb->n_ops < 2) continue;
        unsigned char *dead = calloc((size_t)bb->n_ops, 1);
        if (!dead) continue;

        for (int j = 0; j + 1 < bb->n_ops; j++) {
            Op *ld = &bb->ops[j];
            Op *ar = &bb->ops[j + 1];
            if (ld->kind != IR_LD_SYM) continue;
            if (ld->mem.kind != IR_MEM_SYM) continue;
            if (ld->mem.sym == NULL) continue;
            if (ld->dst < 0 || ld->dst >= f->n_vregs) continue;
            if (use_count[ld->dst] != 1) continue;

            if (ar->kind != IR_ADD && ar->kind != IR_SUB) continue;
            if (ar->src[0] != ld->dst) continue;
            if (ar->src[1] != -1) continue;

            int64_t add_off = (ar->kind == IR_ADD) ? ar->imm : -ar->imm;
            int64_t new_off = (int64_t)ld->mem.offset + add_off;
            if (new_off < INT32_MIN || new_off > INT32_MAX) continue;

            int b_dst = ar->dst;
            SYMBOL *sym = ld->mem.sym;

            memset(ar, 0, sizeof(*ar));
            ar->kind         = IR_LD_SYM;
            ar->dst          = b_dst;
            ar->src[0]       = -1;
            ar->src[1]       = -1;
            ar->mem.kind     = IR_MEM_SYM;
            ar->mem.sym      = sym;
            ar->mem.base     = -1;
            ar->mem.offset   = (int)new_off;

            dead[j] = 1;
            changed++;
            j++;   /* skip the rewritten op; chain-folds handled by rerun */
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
    free(use_count);
    return changed;
}

/* ---- Long (*p)++ fuse → l_long_inc_mhl ----------------------------

   Pattern (per BB, three adjacent ops):
     IR_LD_MEM  v_old <- [v_p, off]          (width 4, MEM_VREG)
     IR_ADD     v_new <- v_old (imm=1)       (width 4)
     IR_ST_MEM            [v_p, off], v_new  (width 4)

   When both v_old and v_new have NO uses outside this triple (the
   classic discarded-result statement `(*p)++;` or `c->i[k]++;`),
   rewrites to a single
     IR_HCALL  l_long_inc_mhl(v_p, off)

   The helper increments the long at *HL in place. IX-clean (uses
   only F + HL). Replaces ~30 inst of inline LD_MEM-long + ADD-imm-1
   long + ST_MEM-long with ~5 inst (one slot load to HL + call).

   POST/PRE shapes where the value IS used (`x = (*p)++`, `x = ++(*p)`)
   fall through to the inline path — a future extension could pair
   `l_long_load_mhl` with `l_long_inc_mhl` to cover those, but it
   requires IR_HCALL lowerer changes (long-result via DEHL) that
   aren't in place yet.
*/
int ir_opt_long_inc_mhl(Func *f)
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
        unsigned char *dead = calloc((size_t)bb->n_ops, 1);
        if (!dead) continue;

        for (int j = 0; j + 2 < bb->n_ops; j++) {
            Op *ld = &bb->ops[j];
            Op *ad = &bb->ops[j + 1];
            Op *st = &bb->ops[j + 2];

            if (ld->kind != IR_LD_MEM) continue;
            if (ld->mem.kind != IR_MEM_VREG) continue;
            if (ld->mem.volatile_) continue;
            if (ld->dst < 0 || ld->dst >= f->n_vregs) continue;
            if (f->vregs[ld->dst].width != 4) continue;

            if (ad->kind != IR_ADD) continue;
            if (ad->src[0] != ld->dst) continue;
            if (ad->src[1] != -1) continue;
            if (ad->imm != 1) continue;
            if (ad->dst < 0 || ad->dst >= f->n_vregs) continue;
            if (f->vregs[ad->dst].width != 4) continue;

            if (st->kind != IR_ST_MEM) continue;
            if (st->mem.kind != IR_MEM_VREG) continue;
            if (st->mem.volatile_) continue;
            if (st->mem.base != ld->mem.base) continue;
            if (st->mem.offset != ld->mem.offset) continue;
            if (st->src[0] != ad->dst) continue;

            /* v_old (ld->dst) used only as ad's src[0]?
               v_new (ad->dst) used only as st's src[0]? */
            if (use_count[ld->dst] != 1) continue;
            if (use_count[ad->dst] != 1) continue;

            int ptr_v  = ld->mem.base;
            int offset = ld->mem.offset;

            /* Rewrite ld → IR_HCALL inc_mhl(ptr_v + offset).
               The helper expects HL = pointer, so when offset != 0
               we still need to add it. For now restrict to offset==0
               — covers `mdContext->i[1]++` where the address ADD has
               folded into the base vreg already. Non-zero-offset
               shapes fall through to inline. */
            if (offset != 0) continue;

            memset(ld, 0, sizeof(*ld));
            ld->kind   = IR_HCALL;
            ld->dst    = -1;
            ld->src[0] = -1;
            ld->src[1] = -1;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            if (!hi) { free(dead); free(use_count); return changed; }
            hi->name     = "l_long_inc_mhl";
            hi->args     = calloc(1, sizeof(int));
            if (!hi->args) {
                free(hi); free(dead); free(use_count); return changed;
            }
            hi->args[0]  = ptr_v;
            hi->n_args   = 1;
            hi->ret_vreg = -1;
            ld->hcall = hi;

            dead[j + 1] = 1;
            dead[j + 2] = 1;
            changed++;
            j += 2;
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
    free(use_count);
    return changed;
}

/* ---- IR_MOV elimination via producer fusion ---------------------

   Pattern (per BB, two adjacent ops):
     op j:    <producer> v_t <- ...
     op j+1:  IR_MOV v_dst <- v_t

   Conditions for fusion:
     - v_t has exactly one function-wide use (the MOV).
     - v_t and v_dst have the same width.
     - Producer's kind is one whose dst is a plain write target (no
       aliased-with-src constraint we can't satisfy by simply
       changing the dst vreg id).
     - v_dst is not also defined by the producer (no self-MOV).

   Rewrite:
     op j:    <producer> v_dst <- ...
     op j+1:  deleted

   Eliminates a slot store + slot reload + slot store pair: typically
   ~14 bytes per fusion. MD5 Transform's `UINT4 a = buf[0], b=buf[1],
   c=buf[2], d=buf[3]` prologue is the canonical hit (4 LD_MEM/MOV
   pairs each saving the MOV's store).

   Only fires for producers that write into the vreg as a final
   "result" (LD_MEM, LD_IMM, LD_SYM, LD_STR, LEA, arithmetic, conv).
   IR_CALL and IR_HCALL excluded since changing ret_vreg requires
   touching CallInfo/HelperInfo (separate work). */
static int fuse_mov_producer_ok(OpKind k)
{
    switch (k) {
    case IR_LD_MEM: case IR_LD_IMM: case IR_LD_SYM: case IR_LD_STR:
    case IR_LEA:
    case IR_ADD: case IR_SUB:
    case IR_AND: case IR_OR:  case IR_XOR:
    case IR_NEG: case IR_NOT:
    case IR_INC: case IR_DEC:
    case IR_SHL: case IR_SHR:
    case IR_CONV_ZX: case IR_CONV_SX:
    case IR_CONV_TRUNC: case IR_CONV_BYTE_TO_HIGH:
    case IR_CMP_EQ: case IR_CMP_NE:
    case IR_CMP_LT: case IR_CMP_LE: case IR_CMP_GT: case IR_CMP_GE:
    case IR_CMP_ULT: case IR_CMP_ULE: case IR_CMP_UGT: case IR_CMP_UGE:
    /* MOV-MOV chain: st2ld converts forwardable LD_MEMs into MOVs,
       leaving `MOV b <- a; MOV c <- b` shapes — copy-propagate b
       out by redirecting the first MOV's dst to c. */
    case IR_MOV:
        return 1;
    default:
        return 0;
    }
}

int ir_opt_fuse_mov(Func *f)
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
        if (bb->n_ops < 2) continue;
        unsigned char *dead = calloc((size_t)bb->n_ops, 1);
        if (!dead) continue;

        for (int j = 1; j < bb->n_ops; j++) {
            if (dead[j]) continue;
            Op *mov = &bb->ops[j];
            if (mov->kind != IR_MOV) continue;
            int src = mov->src[0];
            int dst = mov->dst;
            if (src < 0 || dst < 0) continue;
            if (src == dst) continue;
            if (src >= f->n_vregs || dst >= f->n_vregs) continue;
            if (use_count[src] != 1) continue;
            if (f->vregs[src].width != f->vregs[dst].width) continue;

            /* Walk back to the producer of src — must be the previous
               non-dead op. (Phase D and other passes may have inserted
               dead markers; honour them.) */
            int pj = j - 1;
            while (pj >= 0 && dead[pj]) pj--;
            if (pj < 0) continue;
            Op *prev = &bb->ops[pj];
            if (prev->dst != src) continue;
            if (!fuse_mov_producer_ok(prev->kind)) continue;

            /* Redirect producer's dst to the MOV's dst; drop the MOV. */
            prev->dst = dst;
            dead[j] = 1;
            /* use_count of src is now logically 0 (the MOV is gone);
               keep the table consistent in case a later iter checks it. */
            use_count[src] = 0;
            changed++;
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
    free(use_count);
    return changed;
}

/* ---- Phase D — insert IR_PUSH/POP_DEHL_LONG for long vregs that
   live across DEHL-clobbering ops ---------------------------------

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
        || k == IR_SHL || k == IR_SHR
        || k == IR_NEG || k == IR_NOT
        || k == IR_MOV
        || k == IR_CONV_ZX || k == IR_CONV_SX;
}

static int long_consumer_kind_d(OpKind k)
{
    return k == IR_ADD || k == IR_SUB
        || k == IR_AND || k == IR_OR || k == IR_XOR
        || k == IR_SHL || k == IR_SHR
        || k == IR_NEG || k == IR_NOT
        || k == IR_ST_MEM
        || k == IR_PUSH_DEHL_LONG;
}

static int op_is_branch_or_call_d(OpKind k)
{
    return k == IR_BR || k == IR_BR_COND || k == IR_BR_ZERO
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
                       and need the POP to materialize DEHL. */
                    if (use_op->kind == IR_ADD || use_op->kind == IR_SUB
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
