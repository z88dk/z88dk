/*
 * ir_analysis.c — analyses over the IR.
 *
 * Liveness via standard iterative dataflow:
 *
 *   USE[b]      = vregs read before written in BB b
 *   DEF[b]      = vregs written in BB b
 *   live_in[b]  = USE[b] ∪ (live_out[b] − DEF[b])
 *   live_out[b] = ∪ over successors s of live_in[s]
 *
 * Iterate to fixed point (a worklist would be marginally faster — not
 * worth the bookkeeping at our BB counts).
 *
 * No dependency on the rest of the compiler; ir_selftest can link this
 * standalone.
 */

#include "ir_analysis.h"

#include <stdlib.h>
#include <string.h>

/* ----- BitSet --------------------------------------------------------- */

struct BitSet {
    int  n;          /* vreg count */
    uint8_t bits[];  /* (n + 7) / 8 bytes */
};

BitSet *ir_bitset_new(int n)
{
    int nbytes = (n + 7) / 8;
    BitSet *bs = calloc(1, sizeof(BitSet) + nbytes);
    if (!bs) return NULL;
    bs->n = n;
    return bs;
}

void ir_bitset_free(BitSet *bs)
{
    free(bs);
}

int ir_bitset_get(const BitSet *bs, int v)
{
    if (!bs || v < 0 || v >= bs->n) return 0;
    return (bs->bits[v >> 3] >> (v & 7)) & 1;
}

void ir_bitset_set(BitSet *bs, int v)
{
    if (!bs || v < 0 || v >= bs->n) return;
    bs->bits[v >> 3] |= (uint8_t)(1u << (v & 7));
}

void ir_bitset_clear(BitSet *bs, int v)
{
    if (!bs || v < 0 || v >= bs->n) return;
    bs->bits[v >> 3] &= (uint8_t)~(1u << (v & 7));
}

void ir_bitset_for_each(const BitSet *bs,
                        int (*cb)(int vreg, void *ud), void *ud)
{
    if (!bs) return;
    int nbytes = (bs->n + 7) / 8;
    for (int byte = 0; byte < nbytes; byte++) {
        uint8_t b = bs->bits[byte];
        while (b) {
            int bit = __builtin_ctz(b);
            int v = byte * 8 + bit;
            if (v < bs->n && cb(v, ud) != 0) return;
            b &= (uint8_t)(b - 1);
        }
    }
}

/* ----- Bit-set arithmetic (internal, vec-of-bytes) -------------------- */

static int bitset_copy_changed(BitSet *dst, const BitSet *src)
{
    int changed = 0;
    int nbytes = (dst->n + 7) / 8;
    for (int i = 0; i < nbytes; i++) {
        if (dst->bits[i] != src->bits[i]) {
            dst->bits[i] = src->bits[i];
            changed = 1;
        }
    }
    return changed;
}

static int bitset_or_changed(BitSet *dst, const BitSet *src)
{
    int changed = 0;
    int nbytes = (dst->n + 7) / 8;
    for (int i = 0; i < nbytes; i++) {
        uint8_t before = dst->bits[i];
        uint8_t after  = before | src->bits[i];
        if (after != before) {
            dst->bits[i] = after;
            changed = 1;
        }
    }
    return changed;
}

static void bitset_minus(BitSet *dst, const BitSet *a, const BitSet *b)
{
    int nbytes = (dst->n + 7) / 8;
    for (int i = 0; i < nbytes; i++) {
        dst->bits[i] = (uint8_t)(a->bits[i] & ~b->bits[i]);
    }
}

static void bitset_clear_all(BitSet *bs)
{
    int nbytes = (bs->n + 7) / 8;
    memset(bs->bits, 0, nbytes);
}

/* ----- Op def/use ----------------------------------------------------- */

static int add_unique(int *out, int n, int max, int v)
{
    if (v < 0) return n;
    for (int i = 0; i < n; i++) if (out[i] == v) return n;
    if (n < max) out[n] = v;
    return n + 1;
}

int ir_op_defs(const Op *op, int *out, int max)
{
    if (!op) return 0;
    int n = 0;
    switch (op->kind) {
    case IR_NOP:
    case IR_BR:
    case IR_BR_COND:
    case IR_BR_ZERO:
    case IR_SWITCH:
    case IR_RET:
    case IR_ST_MEM:
    case IR_OUT:
    case IR_CRITICAL_ENTER:
    case IR_CRITICAL_LEAVE:
    case IR_ASM:
    case IR_PHI:
    case IR_PUSH_DEHL_LONG:
    case IR_PUSH_ARG:
        /* No vreg def. */
        return 0;
    case IR_CALL:
        if (op->call && op->call->ret_vreg >= 0)
            n = add_unique(out, n, max, op->call->ret_vreg);
        return n;
    case IR_HCALL:
        if (op->hcall && op->hcall->ret_vreg >= 0)
            n = add_unique(out, n, max, op->hcall->ret_vreg);
        return n;
    case IR_POSTSTEP:
        /* Defines dst (the old value) AND src[0] (the stepped var). */
        n = add_unique(out, n, max, op->dst);
        n = add_unique(out, n, max, op->src[0]);
        return n;
    case IR_POP_DEHL_LONG:
        /* Defines src[0] — the vreg is reborn after the pop.
           (Using src[0] as the dst slot keeps the IR shape simple:
           same vreg id in and out, just reaches a fresh def point.) */
        n = add_unique(out, n, max, op->src[0]);
        return n;
    default:
        /* All other ops define op->dst. */
        n = add_unique(out, n, max, op->dst);
        return n;
    }
}

int ir_op_uses(const Op *op, int *out, int max)
{
    if (!op) return 0;
    int n = 0;
    switch (op->kind) {
    case IR_NOP:
    case IR_BR:
    case IR_LD_IMM:
    case IR_LD_SYM:
    case IR_CRITICAL_ENTER:
    case IR_CRITICAL_LEAVE:
    case IR_ASM:
        return 0;
    case IR_LD_MEM:
        if (op->mem.kind == IR_MEM_VREG)
            n = add_unique(out, n, max, op->mem.base);
        if (op->mem.kind == IR_MEM_PORT && op->mem.port
            && op->mem.port->port_vreg >= 0)
            n = add_unique(out, n, max, op->mem.port->port_vreg);
        return n;
    case IR_ST_MEM:
        n = add_unique(out, n, max, op->src[0]);
        if (op->mem.kind == IR_MEM_VREG)
            n = add_unique(out, n, max, op->mem.base);
        if (op->mem.kind == IR_MEM_PORT && op->mem.port
            && op->mem.port->port_vreg >= 0)
            n = add_unique(out, n, max, op->mem.port->port_vreg);
        return n;
    case IR_OUT:
        n = add_unique(out, n, max, op->src[0]);
        if (op->mem.port && op->mem.port->port_vreg >= 0)
            n = add_unique(out, n, max, op->mem.port->port_vreg);
        return n;
    case IR_IN:
        if (op->mem.port && op->mem.port->port_vreg >= 0)
            n = add_unique(out, n, max, op->mem.port->port_vreg);
        return n;
    case IR_BR_COND:
    case IR_BR_ZERO:
    case IR_SWITCH:
    case IR_POSTSTEP:
        n = add_unique(out, n, max, op->src[0]);
        return n;
    case IR_RET:
        if (op->src[0] >= 0)
            n = add_unique(out, n, max, op->src[0]);
        return n;
    case IR_CALL:
        if (op->call) {
            if (op->call->fnptr_vreg >= 0)
                n = add_unique(out, n, max, op->call->fnptr_vreg);
            /* Pre-pushed args were consumed by their IR_PUSH_ARG ops;
               gen_call never reads them. Only the non-pushed tail
               (fastcall's HL arg) is a use here. */
            for (int i = op->call->pre_pushed; i < op->call->n_args; i++)
                n = add_unique(out, n, max, op->call->args[i]);
        }
        return n;
    case IR_HCALL:
        if (op->hcall) {
            for (int i = 0; i < op->hcall->n_args; i++)
                n = add_unique(out, n, max, op->hcall->args[i]);
        }
        return n;
    case IR_PHI:
        for (int i = 0; i < 2; i++)
            if (op->src[i] >= 0)
                n = add_unique(out, n, max, op->src[i]);
        return n;
    case IR_PUSH_DEHL_LONG:
    case IR_PUSH_ARG:
        /* Reads src[0] (the value to push). */
        n = add_unique(out, n, max, op->src[0]);
        return n;
    case IR_POP_DEHL_LONG:
        /* No reads — the pop produces a fresh def in src[0]. */
        return 0;
    default:
        /* Standard binop / unop / conv: src[0] and possibly src[1]. */
        if (op->src[0] >= 0) n = add_unique(out, n, max, op->src[0]);
        if (op->src[1] >= 0) n = add_unique(out, n, max, op->src[1]);
        return n;
    }
}

/* ----- BB USE / DEF --------------------------------------------------- */

/* Compute the BB's USE (vregs read before being written in this BB)
   and DEF (vregs ever written). Fills the two bit sets, both must be
   pre-zeroed. */
static void bb_use_def(const BB *bb, BitSet *use, BitSet *def)
{
    int buf[16];
    for (int i = 0; i < bb->n_ops; i++) {
        const Op *op = &bb->ops[i];
        /* USE: any read whose vreg isn't already in DEF. */
        int n = ir_op_uses(op, buf, (int)(sizeof buf / sizeof buf[0]));
        if (n > (int)(sizeof buf / sizeof buf[0])) {
            /* Rare (long arg list on IR_CALL) — allocate. */
            int *big = malloc(n * sizeof(int));
            ir_op_uses(op, big, n);
            for (int j = 0; j < n; j++) {
                if (!ir_bitset_get(def, big[j]))
                    ir_bitset_set(use, big[j]);
            }
            free(big);
        } else {
            for (int j = 0; j < n; j++) {
                if (!ir_bitset_get(def, buf[j]))
                    ir_bitset_set(use, buf[j]);
            }
        }
        /* DEF: every write. */
        n = ir_op_defs(op, buf, (int)(sizeof buf / sizeof buf[0]));
        for (int j = 0; j < n; j++) ir_bitset_set(def, buf[j]);
    }
}

/* ----- Liveness fixed point ------------------------------------------- */

void ir_compute_liveness(Func *f)
{
    if (!f || f->n_bbs == 0) return;

    ir_free_liveness(f);

    int n_vregs = f->n_vregs;

    /* Per-BB USE / DEF (transient). */
    BitSet **use = calloc(f->n_bbs, sizeof(BitSet *));
    BitSet **def = calloc(f->n_bbs, sizeof(BitSet *));

    for (int i = 0; i < f->n_bbs; i++) {
        use[i] = ir_bitset_new(n_vregs);
        def[i] = ir_bitset_new(n_vregs);
        bb_use_def(&f->bbs[i], use[i], def[i]);

        f->bbs[i].live_in  = ir_bitset_new(n_vregs);
        f->bbs[i].live_out = ir_bitset_new(n_vregs);
    }

    /* Backward dataflow, iterate to fixed point. */
    BitSet *tmp = ir_bitset_new(n_vregs);
    int changed;
    do {
        changed = 0;
        for (int i = f->n_bbs - 1; i >= 0; i--) {
            BB *bb = &f->bbs[i];
            /* live_out = ∪ live_in of successors */
            BitSet *lo = (BitSet *)bb->live_out;
            bitset_clear_all(tmp);
            int ns = ir_bb_n_succ(bb);
            for (int s = 0; s < ns; s++) {
                int suc = ir_bb_succ_at(bb, s);
                if (suc < 0 || suc >= f->n_bbs) continue;
                bitset_or_changed(tmp, (BitSet *)f->bbs[suc].live_in);
            }
            if (bitset_copy_changed(lo, tmp)) changed = 1;

            /* live_in = USE ∪ (live_out − DEF) */
            BitSet *li = (BitSet *)bb->live_in;
            bitset_clear_all(tmp);
            bitset_minus(tmp, lo, def[i]);
            bitset_or_changed(tmp, use[i]);
            if (bitset_copy_changed(li, tmp)) changed = 1;
        }
    } while (changed);

    for (int i = 0; i < f->n_bbs; i++) {
        ir_bitset_free(use[i]);
        ir_bitset_free(def[i]);
    }
    free(use);
    free(def);
    ir_bitset_free(tmp);
}

void ir_compute_op_liveness(Func *f)
{
    if (!f || f->n_bbs == 0) return;

    int n_vregs = f->n_vregs;

    /* Free any previous per-op allocations before reallocating. */
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        if (bb->live_in_per_op) {
            for (int j = 0; j < bb->n_ops; j++)
                ir_bitset_free((BitSet *)bb->live_in_per_op[j]);
            free(bb->live_in_per_op);
            bb->live_in_per_op = NULL;
        }
    }

    /* Scratch buffer carries live_out through the backward walk. We
       seed it from bb->live_out at the bottom and update for each op
       as we walk upward: live_in[k] = USE[k] ∪ (live_out[k] − DEF[k]),
       and live_out[k-1] = live_in[k]. */
    BitSet *cur = ir_bitset_new(n_vregs);
    int defs[16], uses[16];

    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        if (bb->n_ops <= 0) continue;
        bb->live_in_per_op = calloc((size_t)bb->n_ops,
                                    sizeof(*bb->live_in_per_op));
        if (!bb->live_in_per_op) continue;
        /* cur starts as bb->live_out (the live_out of the last op). */
        bitset_clear_all(cur);
        if (bb->live_out)
            bitset_or_changed(cur, (BitSet *)bb->live_out);

        for (int j = bb->n_ops - 1; j >= 0; j--) {
            const Op *op = &bb->ops[j];
            /* live_in[j] = USE[j] ∪ (live-after − DEF[j]). Same heap
               fallback as bb_use_def for wide IR_CALL arg lists. */
            int n = ir_op_defs(op, defs, (int)(sizeof defs / sizeof defs[0]));
            if (n > (int)(sizeof defs / sizeof defs[0])) {
                int *big = malloc(n * sizeof(int));
                ir_op_defs(op, big, n);
                for (int k = 0; k < n; k++)
                    if (big[k] >= 0) ir_bitset_clear(cur, big[k]);
                free(big);
            } else {
                for (int k = 0; k < n; k++)
                    if (defs[k] >= 0) ir_bitset_clear(cur, defs[k]);
            }
            n = ir_op_uses(op, uses, (int)(sizeof uses / sizeof uses[0]));
            if (n > (int)(sizeof uses / sizeof uses[0])) {
                int *big = malloc(n * sizeof(int));
                ir_op_uses(op, big, n);
                for (int k = 0; k < n; k++)
                    if (big[k] >= 0) ir_bitset_set(cur, big[k]);
                free(big);
            } else {
                for (int k = 0; k < n; k++)
                    if (uses[k] >= 0) ir_bitset_set(cur, uses[k]);
            }
            BitSet *snap = ir_bitset_new(n_vregs);
            bitset_copy_changed(snap, cur);
            bb->live_in_per_op[j] = snap;
        }
    }

    ir_bitset_free(cur);
}

const BitSet *ir_op_live_in(const BB *bb, int op_idx)
{
    if (!bb || !bb->live_in_per_op) return NULL;
    if (op_idx < 0 || op_idx >= bb->n_ops) return NULL;
    return (const BitSet *)bb->live_in_per_op[op_idx];
}

void ir_op_live_out(const BB *bb, int op_idx, BitSet *out)
{
    if (!bb || !out) return;
    bitset_clear_all(out);
    if (op_idx < 0 || op_idx >= bb->n_ops) return;
    if (op_idx == bb->n_ops - 1) {
        if (bb->live_out)
            bitset_or_changed(out, (BitSet *)bb->live_out);
    } else {
        if (bb->live_in_per_op && bb->live_in_per_op[op_idx + 1])
            bitset_or_changed(out,
                              (BitSet *)bb->live_in_per_op[op_idx + 1]);
    }
}

void ir_free_liveness(Func *f)
{
    if (!f) return;
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        ir_bitset_free((BitSet *)bb->live_in);
        ir_bitset_free((BitSet *)bb->live_out);
        bb->live_in  = NULL;
        bb->live_out = NULL;
        if (bb->live_in_per_op) {
            for (int j = 0; j < bb->n_ops; j++)
                ir_bitset_free((BitSet *)bb->live_in_per_op[j]);
            free(bb->live_in_per_op);
            bb->live_in_per_op = NULL;
        }
    }
    ir_free_live_ranges(f);
}

int ir_func_total_ops(const Func *f)
{
    if (!f) return 0;
    int n = 0;
    for (int i = 0; i < f->n_bbs; i++) n += f->bbs[i].n_ops;
    return n;
}

void ir_free_live_ranges(Func *f)
{
    if (!f) return;
    free(f->live_ranges);
    f->live_ranges = NULL;
}

void ir_compute_live_ranges(Func *f)
{
    if (!f) return;
    ir_free_live_ranges(f);
    if (f->n_vregs <= 0) return;
    LiveRange *lr = calloc((size_t)f->n_vregs, sizeof(LiveRange));
    if (!lr) return;
    for (int v = 0; v < f->n_vregs; v++) {
        lr[v].start = -1;
        lr[v].end   = -1;
    }

    /* Walk all ops in BB id order, assigning each a global index. For
       each op we widen the range of every vreg the op touches: dst (def
       site), srcs (use sites), and any vreg in this op's live-in (live
       through). The live-in widening is what makes the range conservative
       across BBs — a vreg live at entry of BB k has its range extended to
       cover op k even if not directly used by op k. */
    int global = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++, global++) {
            const Op *op = &bb->ops[j];
            if (op->dst >= 0 && op->dst < f->n_vregs) {
                LiveRange *r = &lr[op->dst];
                if (r->start < 0 || global < r->start) r->start = global;
                if (global > r->end) r->end = global;
            }
            int uses[16];
            int nu = ir_op_uses(op, uses, (int)(sizeof uses / sizeof uses[0]));
            for (int u = 0; u < nu && u < (int)(sizeof uses / sizeof uses[0]); u++) {
                int v = uses[u];
                if (v < 0 || v >= f->n_vregs) continue;
                LiveRange *r = &lr[v];
                if (r->start < 0 || global < r->start) r->start = global;
                if (global > r->end) r->end = global;
            }
            /* Live-in widening: every vreg live at entry of this op is
               part of the live range here, even if not directly used. */
            const BitSet *lin = bb->live_in_per_op
                ? (const BitSet *)bb->live_in_per_op[j]
                : NULL;
            if (lin) {
                for (int v = 0; v < f->n_vregs; v++) {
                    if (!ir_bitset_get(lin, v)) continue;
                    LiveRange *r = &lr[v];
                    if (r->start < 0 || global < r->start) r->start = global;
                    if (global > r->end) r->end = global;
                }
            }
        }
    }

    /* PARAM vregs are live from entry (caller pushed them before the
       first op runs). If a param has any use, its start was already set
       above; force it to 0. If a param is wholly unused, leave it as
       -1 so callers can spot dead params. */
    for (int v = 0; v < f->n_vregs; v++) {
        if (!(f->vregs[v].flags & IR_VREG_PARAM)) continue;
        if (lr[v].end < 0) continue;
        lr[v].start = 0;
    }

    /* live_out of the last BB extends ranges to the very last op
       (return-value vreg, in particular). */
    int last_op = global - 1;
    if (last_op >= 0 && f->n_bbs > 0) {
        const BB *last = &f->bbs[f->n_bbs - 1];
        if (last->live_out) {
            for (int v = 0; v < f->n_vregs; v++) {
                if (!ir_bitset_get((const BitSet *)last->live_out, v)) continue;
                LiveRange *r = &lr[v];
                if (r->start < 0) r->start = last_op;
                if (last_op > r->end) r->end = last_op;
            }
        }
    }

    f->live_ranges = lr;
}

const LiveRange *ir_live_range(const Func *f, int v)
{
    if (!f || !f->live_ranges) return NULL;
    if (v < 0 || v >= f->n_vregs) return NULL;
    return &((const LiveRange *)f->live_ranges)[v];
}

int ir_live_ranges_overlap(const Func *f, int a, int b)
{
    const LiveRange *ra = ir_live_range(f, a);
    const LiveRange *rb = ir_live_range(f, b);
    if (!ra || !rb) return 0;
    if (ra->start < 0 || rb->start < 0) return 0;
    /* Inclusive intervals: overlap iff max(starts) <= min(ends). */
    int s = ra->start > rb->start ? ra->start : rb->start;
    int e = ra->end   < rb->end   ? ra->end   : rb->end;
    return s <= e;
}
