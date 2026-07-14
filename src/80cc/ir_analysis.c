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

#include <stdio.h>
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
    case IR_DEREF_CMP_BR:   /* compare-and-branch: reads two ptrs, defines nothing */
    case IR_SWITCH:
    case IR_RET:
    case IR_OUT:
    case IR_CRITICAL_ENTER:
    case IR_CRITICAL_LEAVE:
    case IR_ASM:
    case IR_PHI:
    case IR_PUSH_DEHL_LONG:
    case IR_PUSH_ARG:
    case IR_PUSH_STRUCT:
        /* No vreg def. */
        return 0;
    case IR_CALL:
        if (op->call && op->call->ret_vreg >= 0)
            n = add_unique(out, n, max, op->call->ret_vreg);
        return n;
    case IR_HCALL:
    case IR_ACC_BINOP:
    case IR_ACC_UNOP:
    case IR_ACC_CMP:
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
    case IR_LD_MEM:
        n = add_unique(out, n, max, op->dst);
        /* A post-step load (`*p++`) also REDEFINES the base pointer
           (base += step). The fuse pass dropped the separate INC that
           used to be base's def, so list it here or liveness/slot
           allocation would miss the redefinition (and could free or
           reuse base's slot while it is still the live, bumped pointer). */
        if (op->mem.post_step != 0 && op->mem.kind == IR_MEM_VREG
            && op->mem.base >= 0)
            n = add_unique(out, n, max, op->mem.base);
        return n;
    case IR_ST_MEM:
        /* A post-step store (`*p++ = v`, fused by ir_match stpp) REDEFINES
           the base pointer (base += step) — same as the post-step load
           above; the fused-away POSTSTEP's def now lives here. */
        if (op->mem.post_step != 0 && op->mem.kind == IR_MEM_VREG
            && op->mem.base >= 0)
            n = add_unique(out, n, max, op->mem.base);
        return n;
    case IR_COPY_STEP_BRZ:
        /* Steps (defines) BOTH pointers: src[0]=source, src[1]=dest. */
        n = add_unique(out, n, max, op->src[0]);
        n = add_unique(out, n, max, op->src[1]);
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
    case IR_COPY_STEP_BRZ:
        n = add_unique(out, n, max, op->src[0]);   /* source ptr */
        n = add_unique(out, n, max, op->src[1]);   /* dest ptr */
        return n;
    case IR_DEREF_CMP_BR:
        n = add_unique(out, n, max, op->src[0]);   /* ptr a (uses only) */
        n = add_unique(out, n, max, op->src[1]);   /* ptr b */
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
    case IR_ACC_BINOP:
    case IR_ACC_UNOP:
    case IR_ACC_CMP:
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
    case IR_PUSH_STRUCT:
        /* Reads src[0] (the value to push / the struct's address). */
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

/* ----- Structural verifier -------------------------------------------- */

static int ir_bb_id_valid(const Func *f, int id)
{
    for (int i = 0; i < f->n_bbs; i++)
        if (f->bbs[i].id == id) return 1;
    return 0;
}

/* Width-keyed arithmetic / shift / unary ops: a KC_FLOAT or KC_LONGLONG result
   is a mis-sort — those need a fused IR_ACC_* / helper (dadd, l_i64_*). This is
   the OP_NEG-width-8 / test_double bug family. (Float negate/abs are NOT here:
   they're done as bitwise sign-bit tricks — see ir_op_bitwise.) */
static int ir_op_arith_no_float_ll(OpKind k)
{
    switch (k) {
    case IR_ADD: case IR_SUB: case IR_RSUB:
    case IR_SHL: case IR_SHR:
    case IR_NEG: case IR_NOT: case IR_INC: case IR_DEC:
    case IR_ROTL: case IR_ROTR:
    case IR_SHL_INTO_CARRY: case IR_SHR_INTO_CARRY:
        return 1;
    default:
        return 0;
    }
}

/* Bitwise ops are legitimately applied to FLOAT bits (negate via `^ sign`,
   abs via `& ~sign`), so a float result is fine. A long long result, though,
   must go through l_i64_and/or/xor via IR_ACC_*. */
static int ir_op_bitwise(OpKind k)
{
    return k == IR_AND || k == IR_OR || k == IR_XOR;
}

int ir_verify_func(const Func *f, const char *stage)
{
    int n = 0;
    if (!f) return 0;
    if (!stage) stage = "?";

#define VERR(...) do { \
        fprintf(stderr, "ir_verify[%s]: ", stage); \
        fprintf(stderr, __VA_ARGS__); \
        fputc('\n', stderr); \
        n++; \
    } while (0)

    int nv = f->n_vregs;

    if (f->n_bbs < 1) VERR("function has no basic blocks");

    /* VReg sanity. NB: PR_SPILL with slot == -1 is NOT an error — a
       register-only or dead vreg (e.g. a compare result cached in HL,
       never spilled) legitimately has no slot. The -1 'no slot' sentinel
       only miscompiles if a slot LOAD reaches it (`ld hl,-1; add hl,sp`),
       which is a use-site condition the lowerer must guard, not a static
       vreg-property invariant. */
    for (int v = 0; f->vregs && v < nv; v++) {
        int w = (int)f->vregs[v].width;
        Kind k = f->vregs[v].kind;
        if (w <= 0)
            VERR("vreg %d: non-positive width %d", v, w);
        int ksw = kind_scalar_width(k);
        if (ksw && w != ksw)
            VERR("vreg %d: kind %d implies width %d but width is %d", v, (int)k, ksw, w);
        else if ((k == KIND_DOUBLE || k == KIND_FLOAT)
                 && !(w == 2 || w == 4 || w == 5 || w == 6 || w == 8))
            VERR("vreg %d: float/double kind %d implausible width %d", v, (int)k, w);
    }

    /* Per-BB / per-op structure. */
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];

        for (int s = 0; s < 2; s++)
            if (bb->succ[s] != -1 && !ir_bb_id_valid(f, bb->succ[s]))
                VERR("bb %d: succ[%d]=%d is not a valid BB id",
                     bb->id, s, bb->succ[s]);
        for (int p = 0; bb->pred && p < bb->n_pred; p++)
            if (!ir_bb_id_valid(f, bb->pred[p]))
                VERR("bb %d: pred[%d]=%d is not a valid BB id",
                     bb->id, p, bb->pred[p]);

        for (int k = 0; k < bb->n_ops; k++) {
            const Op *op = &bb->ops[k];

            if (op->dst != -1 && (op->dst < 0 || op->dst >= nv))
                VERR("bb %d op %d (kind %d): dst vreg %d out of range [0,%d)",
                     bb->id, k, (int)op->kind, op->dst, nv);
            for (int s = 0; s < 2; s++)
                if (op->src[s] != -1 && (op->src[s] < 0 || op->src[s] >= nv))
                    VERR("bb %d op %d (kind %d): src[%d] vreg %d out of range [0,%d)",
                         bb->id, k, (int)op->kind, s, op->src[s], nv);

            /* Mis-sort tripwire: a helper-dispatched (float / long long) result
               must never reach a width-keyed generic op — it belongs in a fused
               IR_ACC_*. Bitwise ops may carry a float (sign-bit tricks). */
            if (op->dst >= 0 && op->dst < nv) {
                KindClass kc = kind_class(f->vregs[op->dst].kind);
                if (ir_op_arith_no_float_ll(op->kind)
                    && (kc == KC_FLOAT || kc == KC_LONGLONG))
                    VERR("bb %d op %d (kind %d): generic arith with %s result "
                         "(kind %d) — should be a fused IR_ACC_* / helper",
                         bb->id, k, (int)op->kind,
                         kc == KC_FLOAT ? "float" : "long long",
                         (int)f->vregs[op->dst].kind);
                else if (ir_op_bitwise(op->kind) && kc == KC_LONGLONG)
                    VERR("bb %d op %d (kind %d): generic bitwise with long long "
                         "result (kind %d) — should be l_i64_* via IR_ACC_*",
                         bb->id, k, (int)op->kind, (int)f->vregs[op->dst].kind);
            }

            switch (op->kind) {
            case IR_BR: case IR_BR_COND: case IR_BR_ZERO:
                if (!ir_bb_id_valid(f, op->label))
                    VERR("bb %d op %d: branch target %d is not a valid BB id",
                         bb->id, k, op->label);
                break;
            case IR_SWITCH:
                if (!op->sw) {
                    VERR("bb %d op %d: IR_SWITCH has NULL SwitchInfo", bb->id, k);
                    break;
                }
                if (!ir_bb_id_valid(f, op->sw->default_bb))
                    VERR("bb %d op %d: switch default target %d invalid",
                         bb->id, k, op->sw->default_bb);
                for (int c = 0; op->sw->target_bb && c < op->sw->n_cases; c++)
                    if (!ir_bb_id_valid(f, op->sw->target_bb[c]))
                        VERR("bb %d op %d: switch case %d target %d invalid",
                             bb->id, k, c, op->sw->target_bb[c]);
                break;
            case IR_CALL:
                if (!op->call)
                    VERR("bb %d op %d: IR_CALL has NULL CallInfo", bb->id, k);
                break;
            case IR_HCALL:
                if (!op->hcall)
                    VERR("bb %d op %d: IR_HCALL has NULL HelperInfo", bb->id, k);
                break;
            case IR_ASM:
                if (!op->asm_text)
                    VERR("bb %d op %d: IR_ASM has NULL asm_text", bb->id, k);
                break;
            default:
                break;
            }
        }
    }

#undef VERR
    return n;
}

/* Visit a pointer to every vreg-id field in `op` (dst, both srcs, an
   IR_MEM_VREG base, an IR_MEM_PORT port vreg, and the CALL/HCALL ret / fnptr /
   arg ids). The SINGLE source of truth for "where the vreg ids live in an op":
   both the dead-vreg scan and the compaction rewrite drive off it, so a missed
   field can't make them disagree. -1 fields are visited too (callback skips). */
static void ir_op_for_each_vreg_slot(Op *op, void (*fn)(int *, void *), void *ud)
{
    fn(&op->dst, ud);
    fn(&op->src[0], ud);
    fn(&op->src[1], ud);
    if (op->mem.kind == IR_MEM_VREG)
        fn(&op->mem.base, ud);
    if (op->mem.kind == IR_MEM_PORT && op->mem.port)
        fn(&op->mem.port->port_vreg, ud);
    if (op->call) {
        fn(&op->call->ret_vreg, ud);
        fn(&op->call->fnptr_vreg, ud);
        for (int i = 0; i < op->call->n_args; i++)
            fn(&op->call->args[i], ud);
    }
    if (op->hcall) {
        fn(&op->hcall->ret_vreg, ud);
        for (int i = 0; i < op->hcall->n_args; i++)
            fn(&op->hcall->args[i], ud);
    }
}

static void slot_mark(int *slot, void *ud)
{
    char *ref = ud;
    if (*slot >= 0) ref[*slot] = 1;
}

/* Mark every vreg that appears in any op slot; ABI roots (PARAM/RETURN) and
   address-taken / volatile vregs are always kept. Caller owns `ref` sized
   f->n_vregs. */
static void mark_referenced_vregs(const Func *f, char *ref)
{
    for (int b = 0; b < f->n_bbs; b++)
        for (int o = 0; o < f->bbs[b].n_ops; o++)
            ir_op_for_each_vreg_slot(&f->bbs[b].ops[o], slot_mark, ref);
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vregs[v].flags & (IR_VREG_PARAM | IR_VREG_RETURN
                                 | IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
            ref[v] = 1;
}

/* Report vregs that appear in NO op slot and are not roots — pure allocation
   cruft (ir_build minted a temp and abandoned it, e.g. the return-value temp
   of a discarded/void-context call). Harmless to codegen (never emitted).
   Read-only; returns the count, printing each when `verbose`. */
int ir_report_dead_vregs(const Func *f, const char *stage, int verbose)
{
    if (!f || f->n_vregs <= 0) return 0;
    if (!stage) stage = "?";

    char *ref = calloc((size_t)f->n_vregs, 1);
    if (!ref) return 0;
    mark_referenced_vregs(f, ref);

    int dead = 0;
    for (int v = 0; v < f->n_vregs; v++) {
        if (ref[v]) continue;
        if (verbose)
            fprintf(stderr,
                    "ir_dead[%s]: vreg %d unreferenced (kind %d width %d flags %#x)\n",
                    stage, v, (int)f->vregs[v].kind,
                    (int)f->vregs[v].width, f->vregs[v].flags);
        dead++;
    }
    free(ref);
    return dead;
}

struct remap_ud { const int *remap; };
static void slot_remap(int *slot, void *ud)
{
    const int *remap = ((struct remap_ud *)ud)->remap;
    if (*slot >= 0) *slot = remap[*slot];
}

/* Remove orphan vregs (in no op slot, not a root) and renumber the survivors,
   preserving their relative order. Rewrites every op slot through the remap so
   no reference dangles. Returns the count removed. Run BEFORE liveness/alloc,
   so the id-indexed allocation tables (vreg_to_phys / vreg_spill_slot) and
   word_home_vreg don't yet exist to update. Order-preserving so a linear-scan
   allocator keyed on live-range start (not raw id) is unaffected. */
int ir_compact_vregs(Func *f)
{
    if (!f || f->n_vregs <= 0) return 0;

    char *ref = calloc((size_t)f->n_vregs, 1);
    int  *remap = malloc((size_t)f->n_vregs * sizeof(int));
    if (!ref || !remap) { free(ref); free(remap); return 0; }
    mark_referenced_vregs(f, ref);

    int nn = 0;
    for (int v = 0; v < f->n_vregs; v++) {
        if (ref[v]) {
            remap[v] = nn;
            if (nn != v) f->vregs[nn] = f->vregs[v];
            f->vregs[nn].id = nn;
            nn++;
        } else {
            remap[v] = -1;   /* orphan — must never appear in a slot */
        }
    }
    int removed = f->n_vregs - nn;
    f->n_vregs = nn;

    if (removed) {
        struct remap_ud ud = { remap };
        for (int b = 0; b < f->n_bbs; b++)
            for (int o = 0; o < f->bbs[b].n_ops; o++)
                ir_op_for_each_vreg_slot(&f->bbs[b].ops[o], slot_remap, &ud);
    }
    free(ref);
    free(remap);
    return removed;
}
