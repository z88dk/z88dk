/*
 * ir_alloc.c — register allocator.
 *
 * Per-vreg phys-reg assignment in f->vreg_to_phys:
 *   - IR_PR_HL   : vreg lives in HL across its (short, chained) live
 *                  range. Every def is followed immediately by a cache-
 *                  served use, so no frame slot is needed. The lowerer
 *                  consults this to skip store_hl after the producing
 *                  op.
 *   - IR_PR_DE   : lives in DE.
 *   - IR_PR_BC   : lives in BC.
 *   - IR_PR_DEHL : long vreg lives in the DE+HL pair. Same shape as
 *                  PR_HL but for width-4 values: produced once,
 *                  consumed once in the immediately following op. No frame
 *                  slot allocated; store_dehl_finalize calls
 *                  cache_dehl_no_spill unconditionally for these vregs.
 *   - IR_PR_SPILL: vreg has a frame slot; ir_assign_slots allocates it.
 *
 * Decoupled from compiler internals (no ccdefs.h) — ir_selftest links
 * this standalone alongside ir.c / ir_analysis.c / ir_lower.c.
 */

#include "ccdefs.h"     /* FASTCALL flag bit (sets DEFINE_H for ir.h) */
#include "ir_alloc.h"
#include "ir_analysis.h"

#include <stdlib.h>
#include <limits.h>
#include <string.h>

/* -1 = sp mode (no IX/IY frame pointer); else the frame register is live. */
extern int c_framepointer_is_ix;

/* Word DE-home tentative-pick undo: the picker evicts other PR_DE tenants to
   give the home exclusive DE, which is a net loss if the home's loop doesn't
   end up DE-clean (no resident region forms). Region formation can only be
   decided once slots are assigned (after ir_alloc), so the picker saves the
   pre-pick allocation here; the lowerer checks the region and, if none forms,
   restores this and re-slots — reverting the function to baseline. */
static int *word_home_prepick;

int *ir_alloc_take_word_home_prepick(void)
{
    int *p = word_home_prepick;
    word_home_prepick = NULL;
    return p;
}

/* Returns 1 if the spill of op->dst at bb->ops[op_idx] is dead — its
   value is never read from the frame, only consumed via the HL cache
   by the immediately-following op. Requires liveness computed. */
static int op_dst_spill_is_dead(const BB *bb, int op_idx)
{
    const Op *op = &bb->ops[op_idx];
    if (op->dst < 0) return 0;
    if (bb->live_out
        && ir_bitset_get((const BitSet *)bb->live_out, op->dst))
        return 0;
    int allow_cache_hit = 1;
    for (int k = op_idx + 1; k < bb->n_ops; k++) {
        int uses[16];
        int nu = ir_op_uses(&bb->ops[k], uses,
                            (int)(sizeof uses / sizeof uses[0]));
        for (int u = 0; u < nu; u++) {
            if (uses[u] != op->dst) continue;
            const Op *use = &bb->ops[k];
            int cache_served =
                allow_cache_hit &&
                k == op_idx + 1 &&
                ((use->src[0] == op->dst && use->src[1] != op->dst)
                 /* Computed pointer consumed as the next op's LD_MEM
                    base: gen_ld_mem loads the base FIRST and cache-
                    aware (hl_has), so the spill is dead. ST_MEM is
                    excluded — it loads the VALUE before the address,
                    clobbering HL. post_step needs the base's slot
                    (in-place `inc (hl)` step). */
                 || (use->kind == IR_LD_MEM
                     && use->mem.kind == IR_MEM_VREG
                     && use->mem.base == op->dst
                     && use->mem.post_step == 0
                     && use->src[0] != op->dst
                     && use->src[1] != op->dst));
            if (!cache_served) return 0;
            allow_cache_hit = 0;
        }
    }
    return 1;
}

/* Enumerate ALL of a BB's CFG successors into out[] (up to max), from its
   branch/switch OPS — not the fixed succ[2] pair, which a short-circuit
   &&/|| lowering (>2 branch ops in one BB) silently truncates. Returns the
   count. Used to build the predecessor adjacency for natural-loop nesting. */
static int alloc_bb_succ(const BB *bb, int *out, int max)
{
    int n = 0;
    for (int j = 0; j < bb->n_ops && n < max; j++) {
        const Op *o = &bb->ops[j];
        if (o->kind == IR_BR || o->kind == IR_BR_COND || o->kind == IR_BR_ZERO) {
            if (o->label >= 0) out[n++] = o->label;
        } else if (o->kind == IR_SWITCH && o->sw) {
            for (int c = 0; c < o->sw->n_cases && n < max; c++)
                if (o->sw->target_bb[c] >= 0) out[n++] = o->sw->target_bb[c];
            if (n < max && o->sw->default_bb >= 0) out[n++] = o->sw->default_bb;
        }
    }
    /* Fall-through successors carried only in succ[] (defensive). */
    for (int s = 0; s < 2 && n < max; s++)
        if (bb->succ[s] >= 0) {
            int dup = 0;
            for (int k = 0; k < n; k++) if (out[k] == bb->succ[s]) { dup = 1; break; }
            if (!dup) out[n++] = bb->succ[s];
        }
    return n;
}

/* ---- Register-residency orchestrator (Phase 0: PR_BC only) ---------------
   A proposer emits Candidates; an arbiter assigns physical registers. Phase 0
   converts the PR_BC picker to this shape byte-identically (single proposer,
   single register class); later phases add proposers + cross-class arbitration.
   See src/80cc/LOOP_ALLOC_PLAN.md. */
/* Register-class masks a candidate may be assigned to. Grows as pickers
   convert; the Phase-0 arbiters key off these + the flags below. */
enum {
    RC_BC     = 1u << 0,   /* the BC pair */
    RC_IDX2   = 1u << 1,   /* the spare index register f->idx2_reg (IX or IY) */
    RC_DE_ACC = 1u << 2,   /* the DE pair, as a loop reduction accumulator */
    RC_BYTE   = 1u << 3,   /* a byte home (C slotless, or E slot-backed) */
    RC_IDX3   = 1u << 4,   /* the second spare index register f->idx3_reg (IY, sp-mode) */
    RC_EXX    = 1u << 5,   /* a loop-invariant homed in the exx/alt bank f->exx_reg */
};
/* Per-candidate discriminators the arbiters need for byte-identical priority. */
enum {
    CF_IDX2_COUNTER   = 1u << 0,   /* idx2: a stepping counter (beats a param) */
    CF_IDX2_PARAM     = 1u << 1,   /* idx2: a read-only invariant param */
    CF_BYTE_SINGLE_BB = 1u << 2,   /* byte: confined to one BB → slotless PR_C ok */
    CF_SPECULATIVE    = 1u << 3,   /* IV-residency candidate (Phase 2) */
    CF_DE_GENERAL     = 1u << 4,   /* DE-home: a general (non-accumulate) home */
    CF_DE_PTR         = 1u << 5,   /* DE-home: a walking byte pointer (loop regalloc) */
};
/* Cost-model per-access weights (relative T-state savings of reg vs slot; the
   orchestrator's benefit = Σ depth-weighted access weights). A DEREF of a base
   in a register avoids a full pointer reload → worth most; a value read is a
   reg-copy vs a slot load; a write is a reg-stamp vs a slot store. Tuned so a
   hot deref base out-ranks a merely-frequent write-heavy IV. */
#define COST_DEREF_W  3
#define COST_READ_W   2
#define COST_WRITE_W  1
typedef struct {
    int      vreg;
    long     benefit;   /* higher = more valuable (Phase 0 = depth-weighted use_count) */
    int      lo, hi;    /* live interval [first_use, last_use] */
    unsigned allowed;   /* RC_* mask */
    unsigned flags;     /* CF_* */
} Cand;

/* Op-kinds whose width-2 lowering STAMPS a PR_BC dst into BC (end in
   spill_and_swap_unless_dead / commit_hl_word → `ld bc,hl`). A write-many int
   IV lives in BC only if EVERY def is such a kind (else a def elsewhere leaves
   BC stale). Phase 2 IV-residency proposer. */
static int bc_safe_producer(int k)
{
    switch (k) {
    case IR_LD_IMM: case IR_LD_SYM: case IR_LD_STR:
    case IR_LD_MEM: case IR_LEA: case IR_MOV:
    case IR_ADD: case IR_SUB: case IR_RSUB:
    case IR_AND: case IR_OR: case IR_XOR:
    case IR_SHL: case IR_SHR:
    case IR_INC: case IR_DEC:
    case IR_NEG: case IR_NOT:
    case IR_CONV_ZX: case IR_CONV_SX:
    case IR_CONV_BYTE_TO_HIGH:
        return 1;
    default:
        return 0;
    }
}

/* PR_BC proposer: the width-2 vregs eligible for a BC home (read-free PARAM,
   IVSR write-twice pointer, or write-once LOCAL with a BC-stamping producer).
   Fills out[] (caller sizes it f->n_vregs) and returns the count. This is the
   former collection-loop gate verbatim — the effective selector; the old
   separate cap-count loop (a looser gate used only for sizing) is dropped. */
static int pr_bc_propose(const Func *f,
                         const int *use_count, const int *write_count,
                         const int *def_kind, int has_prepushed_call,
                         const BitSet *entry_live,
                         const int *first_use, const int *last_use,
                         Cand *out)
{
    int n = 0;
    /* §3a″ (opt-in IR_BC_STEP_PARAM): allow a stepped-pointer PARAM in BC. A
       call would evict BC → emit_bc_reload restores it from the caller slot,
       which is STALE once the pointer stepped; so gate hard on a call-free
       function (no op can evict BC). Phase-1 `inc bc` keeps BC coherent on the
       step. Residual (non-call) eviction would still read stale, but the bench
       checksum self-checks; keep opt-in until proven. */
    int allow_step_param = getenv("IR_BC_STEP_PARAM") != NULL;
    int fn_has_call = 0;
    if (allow_step_param)
        for (int i = 0; i < f->n_bbs && !fn_has_call; i++)
            for (int j = 0; j < f->bbs[i].n_ops; j++) {
                OpKind k = f->bbs[i].ops[j].kind;
                if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) { fn_has_call = 1; break; }
            }
    for (int v = 0; v < f->n_vregs; v++) {
        const VReg *vr = &f->vregs[v];
        if (vr->width != 2) continue;
        if (vr->flags & IR_VREG_ADDR_TAKEN) continue;
        if (vr->flags & IR_VREG_VOLATILE) continue;
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
        if (use_count[v] < 2) continue;
        int is_param  = (vr->flags & IR_VREG_PARAM) != 0;
        int is_induct = (vr->flags & IR_VREG_INDUCTION) != 0;
        if (!is_param && has_prepushed_call) continue;
        if (!is_param && entry_live && ir_bitset_get(entry_live, v)) continue;
        if (is_param) {
            if (write_count[v] > 0) {
                /* Stepped pointer param (walking char ptr): single in-place
                   INC/DEC step, call-free function, gated. Otherwise a written
                   param is rejected (BC would go stale). */
                int step_ok = allow_step_param && !fn_has_call
                    && write_count[v] == 1
                    && (def_kind[v] == IR_INC || def_kind[v] == IR_DEC)
                    && (vr->kind == KIND_PTR || vr->kind == KIND_CPTR);
                if (!step_ok) continue;
            }
        } else if (is_induct) {
            if (write_count[v] != 2) continue;   /* init + step */
        } else {
            if (write_count[v] != 1) continue;
            int k = def_kind[v];
            int prod_ok = 0;
            switch (k) {
            case IR_LD_IMM: case IR_LD_SYM: case IR_LD_MEM:
            case IR_MOV:
            case IR_ADD: case IR_SUB: case IR_RSUB:
            case IR_AND: case IR_OR: case IR_XOR:
            case IR_SHL: case IR_SHR:
            case IR_INC: case IR_DEC:
            case IR_NEG: case IR_NOT:
            case IR_CONV_ZX: case IR_CONV_SX:
            case IR_CONV_BYTE_TO_HIGH:
                prod_ok = 1;
                break;
            default:
                break;
            }
            if (!prod_ok) continue;
        }
        out[n].vreg = v;
        out[n].benefit = use_count[v];
        out[n].lo = first_use[v];
        out[n].hi = last_use[v];
        out[n].allowed = RC_BC;
        out[n].flags = 0;
        n++;
    }
    return n;
}

/* z80/z80n/z180: a stepping counter homed in idx2 (IX/IY) is only cheap if its
   reads are index-half-friendly — its own step (`inc iy`) and, on z80/z80n only,
   branch-fused int compares (`ld a,iyl; sub …` — the (ix+d) fold reads the halves
   in place). Any OTHER read (address arithmetic `arr[i]`, general ALU `n - i`, a
   move to a gp pair) needs a `push iy; pop hl` every iteration, which usually
   costs more than the frame slot the idx2 home saved. Returns 1 if v has such a
   "hostile" use → the caller skips the idx2 counter home, letting v fall to BC/a
   slot.
   z180 has NO usable index halves (`sub iyl` traps the undocumented opcode), so
   there the compare exemption does NOT apply — a counter's exit test would itself
   push/pop, so any counter with a compare use is hostile (effectively disabling
   the idx2 counter home on z180, which is right). ez80/kc160/rabbit read index
   registers cheaply (lea / native ops), so they keep the counter — gate is
   z80/z80n/z180 only. */
static int idx2_counter_hostile_use(const Func *f, int v)
{
    int halves_ok = (c_cpu == CPU_Z80 || IS_Z80N());   /* NOT z180 */
    if (!(halves_ok || c_cpu == CPU_Z180)) return 0;
    int hostile = 0;
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            const Op *o = &f->bbs[i].ops[j];
            int u[16];
            int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
            int uses_v = 0;
            for (int k = 0; k < nu; k++) if (u[k] == v) { uses_v = 1; break; }
            if (!uses_v) continue;
            /* The counter's own self-step (inc/dec iy, or add iy,rr) — fine. */
            if (o->dst == v && (o->kind == IR_INC || o->kind == IR_DEC
                                || o->kind == IR_ADD || o->kind == IR_SUB))
                continue;
            /* Branch-fused int compare reads iyl/iyh in place — z80/z80n only
               (z180 traps the index-half opcodes, so its compare push/pops too). */
            if (halves_ok
                && (o->kind == IR_CMP_LT || o->kind == IR_CMP_LE
                 || o->kind == IR_CMP_GT || o->kind == IR_CMP_GE
                 || o->kind == IR_CMP_ULT || o->kind == IR_CMP_ULE
                 || o->kind == IR_CMP_UGT || o->kind == IR_CMP_UGE
                 || o->kind == IR_CMP_EQ || o->kind == IR_CMP_NE))
                continue;
            hostile++;   /* address/ALU/move (or any z180 non-step) use */
        }
    return hostile;
}

/* idx2 proposer: the two candidate classes for the spare index register
   (f->idx2_reg) — a hot stepping COUNTER (LD_IMM init + INC/DEC self-steps,
   never a deref/step base) and a hot read-only PARAM bound. Both need the
   call/asm/acc-free envelope (a call clobbers the spare index reg). Fills out[]
   (caller sizes it f->n_vregs) and returns the count. Byte-identical to the two
   former inline pickers; the counter-beats-param priority lives in the arbiter. */
static int idx2_propose(const Func *f, const int *use_count,
                        const int *write_count, const int *first_use,
                        const int *last_use, Cand *out)
{
    if (f->idx2_reg == IR_PR_NONE || f->uses_acc || f->is_interrupt) return 0;
    /* Envelope: a CALL/HCALL/ASM clobbers the spare index reg (the frame reg
       survives via its prologue push, the spare one does not). Same scan the
       former cnt_safe / idx2_safe used. */
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            OpKind k = f->bbs[i].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return 0;
        }
    /* Base map: LD_MEM/ST_MEM MEM_VREG base + POSTSTEP src[0] = a deref'd/
       stepped pointer, never an idx2 counter/bound. (Was cbase / is_base —
       identical.) */
    size_t nv = f->n_vregs > 0 ? (size_t)f->n_vregs : 0;
    int *is_base = calloc(nv, sizeof(int));
    int *cstep   = calloc(nv, sizeof(int));
    int *cinit   = calloc(nv, sizeof(int));
    int *cother  = calloc(nv, sizeof(int));
    int n = 0;
    if (is_base && cstep && cinit && cother) {
        for (int i = 0; i < f->n_bbs; i++)
            for (int j = 0; j < f->bbs[i].n_ops; j++) {
                const Op *o = &f->bbs[i].ops[j];
                if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                    && o->mem.kind == IR_MEM_VREG
                    && o->mem.base >= 0 && o->mem.base < f->n_vregs)
                    is_base[o->mem.base] = 1;
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs)
                    is_base[o->src[0]] = 1;
                /* Fused byte copy-loop pointers are stepped deref bases —
                   never an idx2 counter/invariant-param. */
                if (o->kind == IR_COPY_STEP_BRZ)
                    for (int q = 0; q < 2; q++)
                        if (o->src[q] >= 0 && o->src[q] < f->n_vregs)
                            is_base[o->src[q]] = 1;
                int d = o->dst;
                if (d < 0 || d >= f->n_vregs) continue;
                if ((o->kind == IR_INC || o->kind == IR_DEC) && o->src[0] == d)
                    cstep[d]++;
                else if (o->kind == IR_LD_IMM) cinit[d]++;
                else cother[d]++;
            }
        int counter_off = getenv("IR_NO_IDX2_COUNTER") != NULL;
        for (int v = 0; v < f->n_vregs; v++) {
            const VReg *vr = &f->vregs[v];
            if (vr->width != 2) continue;
            if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) continue;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            if (is_base[v]) continue;
            if (use_count[v] < 4) continue;
            unsigned fl = 0;
            /* Stepping counter: only-init(<=1) + steps write it. On z80/z80n/z180
               skip the idx2 home when the counter feeds address/ALU work that
               would push iy;pop hl every iteration (idx2_counter_hostile_use). */
            if (!counter_off && cstep[v] >= 1 && cother[v] == 0 && cinit[v] <= 1
                && idx2_counter_hostile_use(f, v) == 0)
                fl = CF_IDX2_COUNTER;
            /* Read-only invariant param. */
            else if ((vr->flags & IR_VREG_PARAM) && write_count[v] == 0)
                fl = CF_IDX2_PARAM;
            else continue;
            out[n].vreg = v;
            out[n].benefit = use_count[v];
            out[n].lo = first_use[v];
            out[n].hi = last_use[v];
            out[n].allowed = RC_IDX2;
            out[n].flags = fl;
            n++;
        }
    }
    free(is_base); free(cstep); free(cinit); free(cother);
    return n;
}

/* idx2 arbiter: single occupant. A stepping counter beats a param (it's
   stepped every iteration); within a class, highest benefit wins, first on a
   tie (vreg order). Byte-identical to the former counter-then-param sequence. */
static void arbitrate_idx2(Func *f, const Cand *cand, int n)
{
    int best_counter = -1, best_param = -1;
    for (int i = 0; i < n; i++) {
        if (!(cand[i].allowed & RC_IDX2)) continue;
        if (cand[i].flags & CF_IDX2_COUNTER) {
            if (best_counter < 0 || cand[i].benefit > cand[best_counter].benefit)
                best_counter = i;
        } else if (cand[i].flags & CF_IDX2_PARAM) {
            if (best_param < 0 || cand[i].benefit > cand[best_param].benefit)
                best_param = i;
        }
    }
    int pick = best_counter >= 0 ? best_counter : best_param;
    if (pick >= 0) f->vreg_to_phys[cand[pick].vreg] = f->idx2_reg;
}

/* Word DE-home accumulator proposer: a hot loop-carried width-2 REDUCTION
   accumulator (`v = v OP w`, w a vreg, inside a loop) with a def that dominates
   its reads. Gated NO-calls (DE survives by construction) and DE's low half not
   already a byte E/D home. Fills out[] (sized f->n_vregs), returns the count.
   Byte-identical to the former inline picker; the OWNS-DE side effects live in
   the arbiter. */
static int word_acc_propose(const Func *f, const int *use_count,
                            const int *write_count, const int *bb_in_loop,
                            const int *first_use, const int *last_use,
                            Cand *out)
{
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            OpKind k = f->bbs[i].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return 0;
        }
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vreg_to_phys[v] == IR_PR_E || f->vreg_to_phys[v] == IR_PR_D)
            return 0;   /* DE low half already a byte E/D home */
    size_t nv = f->n_vregs > 0 ? (size_t)f->n_vregs : 0;
    int *wd_def  = calloc(nv, sizeof(int));
    int *wd_read = calloc(nv, sizeof(int));
    int *wd_base = calloc(nv, sizeof(int));
    int *wd_acc  = calloc(nv, sizeof(int));
    int n = 0;
    if (wd_def && wd_read && wd_base && wd_acc) {
        for (int v = 0; v < f->n_vregs; v++) { wd_def[v] = INT_MAX; wd_read[v] = INT_MAX; }
        int g = 0;
        for (int i = 0; i < f->n_bbs; i++) {
            const BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++, g++) {
                const Op *o = &bb->ops[j];
                int u[16];
                int nu = ir_op_uses(o, u, (int)(sizeof u/sizeof u[0]));
                for (int k = 0; k < nu; k++)
                    if (u[k] >= 0 && u[k] < f->n_vregs && g < wd_read[u[k]])
                        wd_read[u[k]] = g;
                if (o->dst >= 0 && o->dst < f->n_vregs && g < wd_def[o->dst])
                    wd_def[o->dst] = g;
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs && g < wd_def[o->src[0]])
                    wd_def[o->src[0]] = g;
                if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                    && o->mem.kind == IR_MEM_VREG
                    && o->mem.base >= 0 && o->mem.base < f->n_vregs)
                    wd_base[o->mem.base] = 1;
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs)
                    wd_base[o->src[0]] = 1;
                /* Fused byte copy-loop pointers are deref bases (exclude from
                   idx/word homes; they want a BC/DE gp pointer, not push/pop). */
                if (o->kind == IR_COPY_STEP_BRZ)
                    for (int q = 0; q < 2; q++)
                        if (o->src[q] >= 0 && o->src[q] < f->n_vregs)
                            wd_base[o->src[q]] = 1;
                switch (o->kind) {
                case IR_ADD: case IR_SUB: case IR_RSUB:
                case IR_AND: case IR_OR:  case IR_XOR:
                    if (o->dst >= 0 && o->dst < f->n_vregs
                        && o->src[1] >= 0 && bb_in_loop[i]
                        && (o->src[0] == o->dst || o->src[1] == o->dst))
                        wd_acc[o->dst] = 1;
                    break;
                default: break;
                }
            }
        }
        for (int v = 0; v < f->n_vregs; v++) {
            const VReg *vr = &f->vregs[v];
            if (vr->width != 2) continue;
            if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                             | IR_VREG_PARAM)) continue;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            if (wd_base[v]) continue;
            if (!wd_acc[v]) continue;
            if (use_count[v] < 4) continue;
            if (write_count[v] < 2) continue;
            if (wd_def[v] >= f->bbs[0].n_ops) continue;   /* def in entry bb0 */
            if (wd_def[v] >= wd_read[v]) continue;        /* def-first */
            out[n].vreg = v;
            out[n].benefit = use_count[v];
            out[n].lo = first_use[v];
            out[n].hi = last_use[v];
            out[n].allowed = RC_DE_ACC;
            out[n].flags = 0;
            n++;
        }
    }
    free(wd_def); free(wd_read); free(wd_base); free(wd_acc);
    return n;
}

/* DE-home GENERAL proposer (default-on; IR_NO_DE_HOME opts out): a hot loop-
   carried width-2 vreg that is NOT a reduction accumulator — searchbench's `hi`
   (init in bb0, updated `hi = mid - 1` in-loop). It rides DE across the loop; the
   (ix+d) compare/ALU folds keep the region DE-clean and the indexed deref recomputes
   from BC. Distinct from word_acc_propose (which requires `v = v OP w`). Same
   domination + hotness gates; additionally the vreg must be DEFINED inside a loop
   (loop-carried) and not be a memory base. Tagged CF_DE_GENERAL so the arbiter sets
   f->de_home_general. The pick is speculative (the lowerer reverts to the baseline
   allocation if no DE-clean region forms), so a false candidate never regresses.
   Fills out[] (sized f->n_vregs), returns the count. */
static int de_home_general_propose(const Func *f, const int *use_count,
                                   const int *write_count, const int *bb_in_loop,
                                   const int *first_use, const int *last_use,
                                   Cand *out)
{
    if (getenv("IR_NO_DE_HOME")) return 0;
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            OpKind k = f->bbs[i].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return 0;
        }
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vreg_to_phys[v] == IR_PR_E || f->vreg_to_phys[v] == IR_PR_D)
            return 0;   /* DE low half already a byte E/D home */
    size_t nv = f->n_vregs > 0 ? (size_t)f->n_vregs : 0;
    int *wd_def  = calloc(nv, sizeof(int));
    int *wd_read = calloc(nv, sizeof(int));
    int *wd_base = calloc(nv, sizeof(int));
    int *wd_acc  = calloc(nv, sizeof(int));   /* exclude reduction accumulators */
    int *wd_ldef = calloc(nv, sizeof(int));   /* defined inside a loop bb */
    int n = 0;
    if (wd_def && wd_read && wd_base && wd_acc && wd_ldef) {
        for (int v = 0; v < f->n_vregs; v++) { wd_def[v] = INT_MAX; wd_read[v] = INT_MAX; }
        int g = 0;
        for (int i = 0; i < f->n_bbs; i++) {
            const BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++, g++) {
                const Op *o = &bb->ops[j];
                int u[16];
                int nu = ir_op_uses(o, u, (int)(sizeof u/sizeof u[0]));
                for (int k = 0; k < nu; k++)
                    if (u[k] >= 0 && u[k] < f->n_vregs && g < wd_read[u[k]])
                        wd_read[u[k]] = g;
                if (o->dst >= 0 && o->dst < f->n_vregs) {
                    if (g < wd_def[o->dst]) wd_def[o->dst] = g;
                    if (bb_in_loop[i]) wd_ldef[o->dst] = 1;
                }
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs && g < wd_def[o->src[0]])
                    wd_def[o->src[0]] = g;
                if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                    && o->mem.kind == IR_MEM_VREG
                    && o->mem.base >= 0 && o->mem.base < f->n_vregs) {
                    wd_base[o->mem.base] = 1;
                    /* A post-step mem op (`*p++` load or the fused `*p++ = v`
                       store) steps its base in-place — mark it loop-defined so
                       the walking pointer qualifies as loop-carried even though
                       the base is not a plain dst. */
                    if (o->mem.post_step != 0 && bb_in_loop[i])
                        wd_ldef[o->mem.base] = 1;
                }
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs) {
                    wd_base[o->src[0]] = 1;
                    /* POSTSTEP steps (defines) its src[0] pointer in-place,
                       not just its dst — mark it loop-defined so a `*d++` walking
                       pointer (strcpy dest) qualifies as loop-carried. */
                    if (bb_in_loop[i]) wd_ldef[o->src[0]] = 1;
                }
                /* Fused byte copy-loop: both pointers (src[0]=source,
                   src[1]=dest) are stepped deref bases — home both (BC + DE). */
                if (o->kind == IR_COPY_STEP_BRZ) {
                    for (int q = 0; q < 2; q++) {
                        int p = o->src[q];
                        if (p >= 0 && p < f->n_vregs) {
                            wd_base[p] = 1;
                            if (bb_in_loop[i]) wd_ldef[p] = 1;
                            if (g < wd_def[p]) wd_def[p] = g;
                        }
                    }
                }
                switch (o->kind) {
                case IR_ADD: case IR_SUB: case IR_RSUB:
                case IR_AND: case IR_OR:  case IR_XOR:
                    if (o->dst >= 0 && o->dst < f->n_vregs
                        && o->src[1] >= 0 && bb_in_loop[i]
                        && (o->src[0] == o->dst || o->src[1] == o->dst))
                        wd_acc[o->dst] = 1;
                    break;
                default: break;
                }
            }
        }
        for (int v = 0; v < f->n_vregs; v++) {
            const VReg *vr = &f->vregs[v];
            if (vr->width != 2) continue;
            if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                             | IR_VREG_PARAM)) continue;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            if (wd_base[v]) continue;                     /* not a deref base */
            if (wd_acc[v]) continue;                      /* accumulators → word_acc */
            if (!wd_ldef[v]) continue;                    /* must be loop-carried */
            if (use_count[v] < 4) continue;
            if (write_count[v] < 2) continue;
            if (wd_def[v] >= f->bbs[0].n_ops) continue;   /* init def in entry bb0 */
            if (wd_def[v] >= wd_read[v]) continue;        /* def-first */
            out[n].vreg = v;
            out[n].benefit = use_count[v];
            out[n].lo = first_use[v];
            out[n].hi = last_use[v];
            out[n].allowed = RC_DE_ACC;
            out[n].flags = CF_DE_GENERAL;
            n++;
        }
        /* Loop regalloc Phase A (default-on; IR_NO_LOOP_RA opts out): a walking
           BYTE pointer to home in DE across its loop — a deref base that is
           stepped in the loop (the strcmp/strcpy/memcpy second pointer). Unlike
           the word-acc filter this REQUIRES a deref base, ALLOWS a param (loaded
           once at region entry from the caller slot, spilled back at exit), and
           needs only one step. op_de_clean (de_home_is_ptr) proves the region
           DE-clean; a non-clean loop reverts to slot (speculative pick). */
        if (!getenv("IR_NO_LOOP_RA")) {
            for (int v = 0; v < f->n_vregs; v++) {
                const VReg *vr = &f->vregs[v];
                if (vr->width != 2) continue;
                if (!(vr->kind == KIND_PTR || vr->kind == KIND_CPTR)) continue;
                if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) continue;
                /* PARAM only (first cut): the caller slot is a coherent entry
                   source for the region rehome. A local-init pointer (p = s)
                   writes DE directly and leaves its own slot unwritten, so the
                   rehome would read garbage — and such locals are already served
                   by the induction BC picker. */
                if (!(vr->flags & IR_VREG_PARAM)) continue;
                if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                if (!wd_base[v]) continue;        /* MUST be a deref base */
                if (!wd_ldef[v]) continue;        /* stepped inside the loop */
                /* A stepped loop pointer benefits even with a single use: the
                   `*d++` store idiom (strcpy) reads d once (POSTSTEP), but that
                   one op expands to a load+inc+store slot round-trip when
                   spilled. wd_ldef already proves it is stepped in the loop —
                   write_count doesn't count post_step base redefs, so don't
                   gate on it. */
                if (use_count[v] < 1) continue;
                out[n].vreg = v;
                out[n].benefit = use_count[v];
                out[n].lo = first_use[v];
                out[n].hi = last_use[v];
                out[n].allowed = RC_DE_ACC;
                out[n].flags = CF_DE_GENERAL | CF_DE_PTR;
                n++;
            }
        }
    }
    free(wd_def); free(wd_read); free(wd_base); free(wd_acc); free(wd_ldef);
    return n;
}

/* idx3 proposer (opt-in c_idx3_residency / f->idx3_reg != NONE): a hot
   loop-carried width-2 word to home in the SECOND spare index register (IY in
   sp-mode). Unlike the DE-home this needs NO region proof — an index register
   is a dedicated home never used as codegen scratch, so the value rides it for
   the whole function (call-gated via idx3_reg being NONE when calls could
   clobber it — same envelope as idx2). Eligibility mirrors de_home_general
   (loop-carried, not a deref base / accumulator / addr-taken / volatile /
   param). Read/written via index halves (z80/z80n gate in ir_idx3_reg).
   Fills out[], returns count. */
static int idx3_propose(const Func *f, const int *use_count,
                        const int *write_count, const int *bb_in_loop,
                        const int *first_use, const int *last_use, Cand *out)
{
    if (f->idx3_reg == IR_PR_NONE || f->is_interrupt || f->is_naked) return 0;
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            OpKind k = f->bbs[i].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return 0;
        }
    size_t nv = f->n_vregs > 0 ? (size_t)f->n_vregs : 0;
    int *wd_def  = calloc(nv, sizeof(int));
    int *wd_read = calloc(nv, sizeof(int));
    int *wd_base = calloc(nv, sizeof(int));
    int *wd_acc  = calloc(nv, sizeof(int));
    int *wd_ldef = calloc(nv, sizeof(int));
    int *wd_addr = calloc(nv, sizeof(int));   /* transitively feeds a deref address */
    int n = 0;
    if (wd_def && wd_read && wd_base && wd_acc && wd_ldef && wd_addr) {
        for (int v = 0; v < f->n_vregs; v++) { wd_def[v] = INT_MAX; wd_read[v] = INT_MAX; }
        int g = 0;
        for (int i = 0; i < f->n_bbs; i++) {
            const BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++, g++) {
                const Op *o = &bb->ops[j];
                int u[16];
                int nu = ir_op_uses(o, u, (int)(sizeof u/sizeof u[0]));
                for (int k = 0; k < nu; k++)
                    if (u[k] >= 0 && u[k] < f->n_vregs && g < wd_read[u[k]])
                        wd_read[u[k]] = g;
                if (o->dst >= 0 && o->dst < f->n_vregs) {
                    if (g < wd_def[o->dst]) wd_def[o->dst] = g;
                    if (bb_in_loop[i]) wd_ldef[o->dst] = 1;
                }
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs && g < wd_def[o->src[0]])
                    wd_def[o->src[0]] = g;
                if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                    && o->mem.kind == IR_MEM_VREG
                    && o->mem.base >= 0 && o->mem.base < f->n_vregs)
                    wd_base[o->mem.base] = 1;
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs)
                    wd_base[o->src[0]] = 1;
                /* Fused byte copy-loop pointers are deref bases (exclude from
                   idx/word homes; they want a BC/DE gp pointer, not push/pop). */
                if (o->kind == IR_COPY_STEP_BRZ)
                    for (int q = 0; q < 2; q++)
                        if (o->src[q] >= 0 && o->src[q] < f->n_vregs)
                            wd_base[o->src[q]] = 1;
                switch (o->kind) {
                case IR_ADD: case IR_SUB: case IR_RSUB:
                case IR_AND: case IR_OR:  case IR_XOR:
                    if (o->dst >= 0 && o->dst < f->n_vregs
                        && o->src[1] >= 0 && bb_in_loop[i]
                        && (o->src[0] == o->dst || o->src[1] == o->dst))
                        wd_acc[o->dst] = 1;
                    break;
                default: break;
                }
            }
        }
        /* Hostility = v is an ARRAY INDEX (materialised every iteration by
           `arr[v]`). Precisely: v (or v<<k) is a DIRECT operand of an ADD/SUB
           whose dst is a deref base. Two levels only — NOT a transitive closure
           through plain ALU: searchbench `mid = lo + hi` makes MID the index
           (mid<<1 + base), so mid is hostile but lo/hi (mere ALU inputs to mid)
           must stay eligible. wd_addr[v]=1 iff v is such an index.
           Step 1: into_base[x] — x is directly added to a deref base. */
        int *into_base = wd_addr;   /* reuse the buffer for the intermediate set */
        for (int i = 0; i < f->n_bbs; i++)
            for (int j = 0; j < f->bbs[i].n_ops; j++) {
                const Op *o = &f->bbs[i].ops[j];
                if (o->kind != IR_ADD && o->kind != IR_SUB) continue;
                if (o->dst < 0 || o->dst >= f->n_vregs || !wd_base[o->dst]) continue;
                for (int s = 0; s < 2; s++)
                    if (o->src[s] >= 0 && o->src[s] < f->n_vregs)
                        into_base[o->src[s]] = 1;
            }
        /* Step 2: v is hostile if it is into_base, or feeds a SHL/SHR (index
           scaling) whose result is into_base. Compute the scaled contribution
           into a set disjoint from into_base, then union. */
        int *scaled = calloc(nv, sizeof(int));
        if (scaled) {
            for (int i = 0; i < f->n_bbs; i++)
                for (int j = 0; j < f->bbs[i].n_ops; j++) {
                    const Op *o = &f->bbs[i].ops[j];
                    if (o->kind != IR_SHL && o->kind != IR_SHR) continue;
                    if (o->dst < 0 || o->dst >= f->n_vregs || !into_base[o->dst]) continue;
                    if (o->src[0] >= 0 && o->src[0] < f->n_vregs)
                        scaled[o->src[0]] = 1;
                }
            for (int v = 0; v < f->n_vregs; v++) if (scaled[v]) wd_addr[v] = 1;
            free(scaled);
        }
        for (int v = 0; v < f->n_vregs; v++) {
            const VReg *vr = &f->vregs[v];
            if (vr->width != 2) continue;
            if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                             | IR_VREG_PARAM)) continue;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            if (wd_base[v]) continue;                     /* not a deref base */
            if (wd_acc[v]) continue;                      /* accumulators → word_acc */
            if (!wd_ldef[v]) continue;                    /* must be loop-carried */
            if (use_count[v] < 4) continue;
            if (write_count[v] < 2) continue;
            if (wd_def[v] >= f->bbs[0].n_ops) continue;   /* init def in entry bb0 */
            if (wd_def[v] >= wd_read[v]) continue;        /* def-first */
            /* Hostile: v feeds a deref address (array index `arr[v]`) — an index
               home materialises it (`push iy; pop hl; add hl,..`) every iteration,
               whereas a gp reg (BC) indexes cheaply. wd_addr is the transitive
               closure (covers i → i<<k → base+idx, e.g. queen's board[i]); a
               plain ALU source whose result is NOT an address (searchbench
               mid=lo+hi) is fine. */
            if (wd_addr[v]) continue;
            out[n].vreg = v;
            out[n].benefit = use_count[v];
            out[n].lo = first_use[v];
            out[n].hi = last_use[v];
            out[n].allowed = RC_IDX3;
            out[n].flags = 0;
            n++;
        }
    }
    free(wd_def); free(wd_read); free(wd_base); free(wd_acc); free(wd_ldef);
    free(wd_addr);
    return n;
}

/* exx co-design proposer (opt-in c_exx_residency / f->exx_reg != NONE): a hot
   loop-INVARIANT word (read in the loop, NEVER written in the loop — e.g. the
   compare RHS `key`) homed in the exx/alt bank. Read-only means it persists
   across `exx` with no write-back; the compare bridges through A. The POINT is
   to displace the invariant OUT of the spare index register (idx2/IX) so that
   register frees up for a WRITABLE loop var — so this only fires when there are
   >= 2 idx3-eligible writable loop words competing for the two index registers
   (IX+IY). Gated no-calls (a call clobbers the alt bank) and no-FA (float uses
   the alt regs). Fills out[], returns count. */
static int exx_propose(const Func *f, const int *use_count,
                       const int *write_count, const int *bb_in_loop,
                       const int *first_use, const int *last_use, Cand *out)
{
    if (f->exx_reg == IR_PR_NONE || f->is_interrupt || f->is_naked) return 0;
    if (f->uses_acc) return 0;                     /* float/FA owns the alt bank */
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            OpKind k = f->bbs[i].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return 0;
        }
    size_t nv = f->n_vregs > 0 ? (size_t)f->n_vregs : 0;
    int *wd_ldef  = calloc(nv, sizeof(int));   /* defined inside a loop bb */
    int *wd_lread = calloc(nv, sizeof(int));   /* read inside a loop bb */
    int *wd_base  = calloc(nv, sizeof(int));
    int *wd_acc   = calloc(nv, sizeof(int));
    int n = 0;
    if (wd_ldef && wd_lread && wd_base && wd_acc) {
        for (int i = 0; i < f->n_bbs; i++) {
            const BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++) {
                const Op *o = &bb->ops[j];
                int u[16];
                int nu = ir_op_uses(o, u, (int)(sizeof u/sizeof u[0]));
                for (int k = 0; k < nu; k++)
                    if (u[k] >= 0 && u[k] < f->n_vregs && bb_in_loop[i])
                        wd_lread[u[k]] = 1;
                if (o->dst >= 0 && o->dst < f->n_vregs && bb_in_loop[i])
                    wd_ldef[o->dst] = 1;
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs && bb_in_loop[i])
                    wd_ldef[o->src[0]] = 1;
                if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                    && o->mem.kind == IR_MEM_VREG
                    && o->mem.base >= 0 && o->mem.base < f->n_vregs)
                    wd_base[o->mem.base] = 1;
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs)
                    wd_base[o->src[0]] = 1;
                /* Fused byte copy-loop pointers are deref bases (exclude from
                   idx/word homes; they want a BC/DE gp pointer, not push/pop). */
                if (o->kind == IR_COPY_STEP_BRZ)
                    for (int q = 0; q < 2; q++)
                        if (o->src[q] >= 0 && o->src[q] < f->n_vregs)
                            wd_base[o->src[q]] = 1;
                switch (o->kind) {
                case IR_ADD: case IR_SUB: case IR_RSUB:
                case IR_AND: case IR_OR:  case IR_XOR:
                    if (o->dst >= 0 && o->dst < f->n_vregs && o->src[1] >= 0
                        && bb_in_loop[i]
                        && (o->src[0] == o->dst || o->src[1] == o->dst))
                        wd_acc[o->dst] = 1;
                    break;
                default: break;
                }
            }
        }
        /* Count idx3-eligible writable loop words (loop-defined, not base/acc). */
        int writables = 0;
        for (int v = 0; v < f->n_vregs; v++) {
            const VReg *vr = &f->vregs[v];
            if (vr->width != 2) continue;
            if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM))
                continue;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            if (wd_base[v] || wd_acc[v] || !wd_ldef[v]) continue;
            if (use_count[v] < 4 || write_count[v] < 2) continue;
            writables++;
        }
        if (writables >= 2) {
            /* Propose loop-invariant words: read in-loop, never written in-loop,
               not a deref base. Params (e.g. `key`) qualify. */
            for (int v = 0; v < f->n_vregs; v++) {
                const VReg *vr = &f->vregs[v];
                if (vr->width != 2) continue;
                if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) continue;
                if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                if (!wd_lread[v] || wd_ldef[v]) continue;   /* read in loop, never written */
                if (wd_base[v]) continue;                    /* deref base wants a gp reg */
                if (use_count[v] < 4) continue;
                /* The alt-bank home only pays off through the A-bridge COMPARE
                   (`exx; sub half; exx`). An invariant used in address arithmetic
                   / general ALU (`base + v`) gains nothing and would need an
                   expensive materialize — home it in a gp reg instead. Require
                   EVERY use to be an ordered/equality compare operand. */
                {
                    int all_cmp = 1;
                    for (int bi = 0; bi < f->n_bbs && all_cmp; bi++)
                        for (int bj = 0; bj < f->bbs[bi].n_ops; bj++) {
                            const Op *o = &f->bbs[bi].ops[bj];
                            int u[16];
                            int nu = ir_op_uses(o, u, (int)(sizeof u/sizeof u[0]));
                            int uses_v = 0;
                            for (int k = 0; k < nu; k++) if (u[k] == v) { uses_v = 1; break; }
                            if (!uses_v) continue;
                            switch (o->kind) {
                            case IR_CMP_LT: case IR_CMP_LE: case IR_CMP_GT:
                            case IR_CMP_GE: case IR_CMP_ULT: case IR_CMP_ULE:
                            case IR_CMP_UGT: case IR_CMP_UGE: case IR_CMP_EQ:
                            case IR_CMP_NE: break;
                            default: all_cmp = 0; break;
                            }
                            if (!all_cmp) break;
                        }
                    if (!all_cmp) continue;
                }
                out[n].vreg = v;
                out[n].benefit = use_count[v];
                out[n].lo = first_use[v];
                out[n].hi = last_use[v];
                out[n].allowed = RC_EXX;
                out[n].flags = 0;
                n++;
            }
        }
    }
    free(wd_ldef); free(wd_lread); free(wd_base); free(wd_acc);
    return n;
}

/* Word DE-home arbiter: single occupant, highest benefit (first on tie). The
   winner OWNS DE — every other PR_DE tenant is demoted to SPILL (its def can't
   clobber the home; it reloads through HL at the accumulate). Saves the pre-pick
   allocation so the lowerer can revert if no resident region forms. */
static void arbitrate_word_acc(Func *f, const Cand *cand, int n)
{
    int wbest = -1;
    for (int i = 0; i < n; i++) {
        if (!(cand[i].allowed & RC_DE_ACC)) continue;
        if (wbest < 0 || cand[i].benefit > cand[wbest].benefit) wbest = i;
    }
    if (wbest < 0) return;
    int v = cand[wbest].vreg;
    free(word_home_prepick);
    word_home_prepick = malloc((size_t)f->n_vregs * sizeof(int));
    if (word_home_prepick)
        memcpy(word_home_prepick, f->vreg_to_phys,
               (size_t)f->n_vregs * sizeof(int));
    for (int j = 0; j < f->n_vregs; j++)
        if (j != v && f->vreg_to_phys[j] == IR_PR_DE)
            f->vreg_to_phys[j] = IR_PR_SPILL;
    f->vreg_to_phys[v] = IR_PR_DE;
    f->word_home_vreg = v;
}

/* Byte-home proposer: a hot loop-carried width-1 accumulator/counter whose def
   dominates its reads (first def in bb0, before first read). Gated NO-calls
   (BC/DE preserved). Each candidate is tagged CF_BYTE_SINGLE_BB iff confined to
   one BB (slotless PR_C is only sound then — cross-BB byte reads are BB-local).
   Fills out[] (sized f->n_vregs), returns the count. Byte-identical to the
   former inline picker; the C-vs-E choice lives in the arbiter. */
static int byte_home_propose(const Func *f, const int *use_count,
                             const int *write_count, const int *first_use,
                             const int *last_use, Cand *out)
{
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            OpKind k = f->bbs[i].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return 0;
        }
    size_t nvr = f->n_vregs > 0 ? (size_t)f->n_vregs : 0;
    int *first_def  = calloc(nvr, sizeof(int));
    int *first_read = calloc(nvr, sizeof(int));
    int *only_bb    = calloc(nvr, sizeof(int));
    int n = 0;
    if (first_def && first_read && only_bb) {
        for (int v = 0; v < f->n_vregs; v++) {
            first_def[v] = INT_MAX; first_read[v] = INT_MAX; only_bb[v] = -2;
        }
        int g = 0;
        for (int i = 0; i < f->n_bbs; i++) {
            const BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++, g++) {
                const Op *o = &bb->ops[j];
                int u[16];
                int nu = ir_op_uses(o, u, (int)(sizeof u/sizeof u[0]));
                for (int k = 0; k < nu; k++)
                    if (u[k] >= 0 && u[k] < f->n_vregs) {
                        if (g < first_read[u[k]]) first_read[u[k]] = g;
                        if (only_bb[u[k]] == -2) only_bb[u[k]] = i;
                        else if (only_bb[u[k]] != i) only_bb[u[k]] = -1;
                    }
                if (o->dst >= 0 && o->dst < f->n_vregs) {
                    if (g < first_def[o->dst]) first_def[o->dst] = g;
                    if (only_bb[o->dst] == -2) only_bb[o->dst] = i;
                    else if (only_bb[o->dst] != i) only_bb[o->dst] = -1;
                }
                if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                    && o->src[0] < f->n_vregs) {
                    if (g < first_def[o->src[0]]) first_def[o->src[0]] = g;
                    if (only_bb[o->src[0]] == -2) only_bb[o->src[0]] = i;
                    else if (only_bb[o->src[0]] != i) only_bb[o->src[0]] = -1;
                }
            }
        }
        for (int v = 0; v < f->n_vregs; v++) {
            const VReg *vr = &f->vregs[v];
            if (vr->width != 1) continue;
            if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) continue;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            if (use_count[v] < 8) continue;
            if (write_count[v] < 1) continue;
            if (first_def[v] >= f->bbs[0].n_ops) continue;   /* def in entry bb0 */
            if (first_def[v] >= first_read[v]) continue;     /* def-first */
            out[n].vreg = v;
            out[n].benefit = use_count[v];
            out[n].lo = first_use[v];
            out[n].hi = last_use[v];
            out[n].allowed = RC_BYTE;
            out[n].flags = (only_bb[v] >= 0) ? CF_BYTE_SINGLE_BB : 0;
            n++;
        }
    }
    free(first_def); free(first_read); free(only_bb);
    return n;
}

/* Byte-home arbiter: single occupant, highest benefit (first on tie). Slotless
   PR_C only when BC is free AND the byte is single-BB confined (cross-BB byte
   reads are BB-local, and PR_C has no slot fallback); otherwise slot-backed
   PR_E. Byte-identical to the former inline choice. */
static void arbitrate_byte_home(Func *f, const Cand *cand, int n)
{
    int bc_taken = 0;
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vreg_to_phys[v] == IR_PR_BC) { bc_taken = 1; break; }
    int best = -1;
    for (int i = 0; i < n; i++) {
        if (!(cand[i].allowed & RC_BYTE)) continue;
        if (best < 0 || cand[i].benefit > cand[best].benefit) best = i;
    }
    if (best < 0) return;
    int single_bb = (cand[best].flags & CF_BYTE_SINGLE_BB) != 0;
    f->vreg_to_phys[cand[best].vreg] =
        (bc_taken || !single_bb) ? IR_PR_E : IR_PR_C;
}

/* IV-residency proposer (Phase 2): a hot loop-carried WRITE-MANY int IV whose
   EVERY def is a BC-stamping producer (all_defs_ok) — BC always holds the
   current value, copy-from-BC reads are sound cross-BB. Emits RC_BC candidates;
   the arbiter ranks by the COST-MODEL benefit (so a deref base out-scores this
   even if this has more raw uses) and a loser falls back to a slot. Only
   collected under IR_ORCHESTRATOR. */
static int iv_propose(const Func *f, const int *use_count,
                      const int *write_count, const int *all_defs_ok,
                      int has_prepushed_call, const BitSet *entry_live,
                      const int *first_use, const int *last_use, Cand *out)
{
    int n = 0;
    for (int v = 0; v < f->n_vregs; v++) {
        const VReg *vr = &f->vregs[v];
        if (vr->width != 2) continue;
        if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                         | IR_VREG_PARAM | IR_VREG_INDUCTION)) continue;
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
        if (has_prepushed_call) continue;
        if (entry_live && ir_bitset_get(entry_live, v)) continue;  /* read-before-def */
        if (write_count[v] < 2) continue;   /* write-many */
        if (!all_defs_ok[v]) continue;      /* every def stamps BC */
        if (use_count[v] < 8) continue;     /* hot → in a loop */
        out[n].vreg = v;
        out[n].benefit = use_count[v];      /* remapped to cost in the orch branch */
        out[n].lo = first_use[v];
        out[n].hi = last_use[v];
        out[n].allowed = RC_BC;
        out[n].flags = CF_SPECULATIVE;
        n++;
    }
    return n;
}

/* ---- Phase 1: single cross-class arbiter (gated IR_ORCHESTRATOR) ----------
   One benefit-ranked pass over the combined candidate pool of ALL proposers.
   The classes mostly own independent registers (BC / idx2 / DE / a byte); the
   only cross-class contention is ALIASING — a byte in C shares BC's low byte,
   a byte in E shares DE's low byte. The arbiter resolves those by BENEFIT
   instead of the fixed picker order, and any candidate that can't get a
   register falls back to its slot (never displaces). Sound-by-construction:
   a vreg is assigned only once (skip if already placed), and C/E vs BC/DE
   mutual exclusion is enforced whole-function (conservative).

   Behavioural deltas vs the sequential pickers (all benefit-resolved now):
   BC-vs-byteC, DE-acc-vs-byteE, and idx2-vs-BC for a shared read-only param
   (the param keeps its BC preference via stable tie-break: BC candidates are
   collected first, so on an equal-benefit tie they win over idx2). */
static int cand_more_important(const Cand *a, const Cand *b)
{
    if (a->benefit != b->benefit) return a->benefit > b->benefit;
    /* most-constrained-first: fewer allowed classes wins the tie */
    unsigned pa = a->allowed, pb = b->allowed;
    int na = 0, nb = 0;
    while (pa) { na += pa & 1; pa >>= 1; }
    while (pb) { nb += pb & 1; pb >>= 1; }
    return na < nb;
}

static void unified_arbitrate(Func *f, Cand *pool, int n)
{
    /* Stable insertion sort by importance (equal keys keep pool order — which
       is proposer order: BC, idx2, word-acc, byte). */
    for (int i = 1; i < n; i++) {
        Cand c = pool[i];
        int j = i;
        while (j > 0 && cand_more_important(&c, &pool[j - 1])) {
            pool[j] = pool[j - 1];
            j--;
        }
        pool[j] = c;
    }
    int idx2_taken = 0, byte_reg = 0;    /* 0 / 'C' / 'E' */
    int idx3_taken = 0;                  /* the second index (IY) home */
    int exx_taken = 0;                   /* alt-bank invariant claimed → IX freed */
    int de_acc_vreg = -1;                /* DE-acc winner, APPLIED after the loop */
    int de_acc_general = 0;              /* winner is a general (non-acc) home */
    /* exx co-design PRE-PASS: the invariant→alt decision must precede the index
       assignments so exx_taken is set when idx3 fills IX+IY. The benefit-first
       sort would otherwise process the higher-benefit writables first (with
       exx_taken still 0). exx_propose only emits candidates when >=2 writable
       loop words compete for the index regs, so claiming the best invariant for
       the alt bank here is always the co-design win. */
    if (f->exx_reg != IR_PR_NONE) {
        int eb = -1;
        for (int i = 0; i < n; i++) {
            if (!(pool[i].allowed & RC_EXX)) continue;
            if (f->vreg_to_phys[pool[i].vreg] != IR_PR_SPILL) continue;
            if (eb < 0 || pool[i].benefit > pool[eb].benefit) eb = i;
        }
        if (eb >= 0) {
            f->vreg_to_phys[pool[eb].vreg] = f->exx_reg;
            exx_taken = 1;
        }
    }
    /* Whole-function occupancy predicates, recomputed cheaply from
       vreg_to_phys as assignments land. */
    for (int i = 0; i < n; i++) {
        const Cand *c = &pool[i];
        int v = c->vreg;
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;   /* already placed */
        /* Reserved for the (deferred) DE-acc — don't let another candidate for
           the SAME vreg (e.g. its IV/BC candidate) grab a register first. A
           reduction accumulator that also looks like an IV must stay DE-bound. */
        if (v == de_acc_vreg) continue;

        if (c->allowed & RC_EXX) {
            /* Loop-invariant → alt bank (single occupant). Displaces the idx2
               invariant from IX; sets exx_taken so idx3 may use IX for a second
               writable loop var. */
            if (exx_taken || f->exx_reg == IR_PR_NONE) continue;
            f->vreg_to_phys[v] = f->exx_reg;
            exx_taken = 1;
            continue;
        }

        if (c->allowed & RC_IDX2) {
            /* idx2 sub-priority: a stepping counter beats a param. Only take
               idx2 for a param if no counter candidate is still assignable. */
            if (idx2_taken || f->idx2_reg == IR_PR_NONE) continue;
            if (c->flags & CF_IDX2_PARAM) {
                int counter_waiting = 0;
                for (int k = 0; k < n; k++)
                    if ((pool[k].allowed & RC_IDX2)
                        && (pool[k].flags & CF_IDX2_COUNTER)
                        && f->vreg_to_phys[pool[k].vreg] == IR_PR_SPILL) {
                        counter_waiting = 1; break;
                    }
                if (counter_waiting) continue;
            }
            f->vreg_to_phys[v] = f->idx2_reg;
            idx2_taken = 1;
            continue;
        }

        if (c->allowed & RC_IDX3) {
            /* Writable loop var in an index register. First → IY (idx3_reg).
               A SECOND writable → IX (idx2_reg) ONLY when the exx co-design
               moved the invariant to the alt bank (exx_taken) and idx2 didn't
               claim IX — that's the search layout (lo→IX, hi→IY, key→alt). The
               lowering recognises IR_PR_IX as an index home via vreg_idx_home. */
            if (f->idx3_reg == IR_PR_NONE) continue;
            if (!idx3_taken) {
                f->vreg_to_phys[v] = f->idx3_reg;
                idx3_taken = 1;
            } else if (exx_taken && !idx2_taken && f->idx2_reg != IR_PR_NONE) {
                f->vreg_to_phys[v] = f->idx2_reg;   /* IX freed by exx */
                idx2_taken = 1;
            }
            continue;
        }

        if (c->allowed & RC_DE_ACC) {
            /* GENERAL DE-home candidates are handled in a SEPARATE phase after
               this loop (see below): they are speculative (revert if no region
               forms), so they must be overlaid on the finished BC/idx2/byte
               baseline — reserving DE here would let an inferior vreg grab the
               BC the home vacated, and a revert would restore THAT perturbed
               state, not the true baseline. The reduction word-acc (non-general)
               keeps the in-loop reservation (present in every build). */
            if (c->flags & CF_DE_GENERAL) continue;
            /* RESERVE DE (E aliases it, so a later byte can't take E); the
               eviction + prepick snapshot + assign happen AFTER the loop, so
               the prepick captures the full BC/idx2/byte baseline the lowerer
               reverts to — matching the sequential picker (word-acc runs last). */
            if (de_acc_vreg < 0 && byte_reg != 'E') {
                de_acc_vreg = v;
                de_acc_general = 0;
            }
            continue;
        }

        if (c->allowed & RC_BYTE) {
            if (byte_reg) continue;                 /* one byte home per fn */
            int single_bb = (c->flags & CF_BYTE_SINGLE_BB) != 0;
            int bc_used = 0;
            for (int j = 0; j < f->n_vregs; j++)
                if (f->vreg_to_phys[j] == IR_PR_BC) { bc_used = 1; break; }
            if (single_bb && !bc_used) { f->vreg_to_phys[v] = IR_PR_C; byte_reg = 'C'; }
            else if (de_acc_vreg < 0)  { f->vreg_to_phys[v] = IR_PR_E; byte_reg = 'E'; }
            /* else: no byte register free (DE reserved) → slot fallback */
            continue;
        }

        if (c->allowed & RC_BC) {
            if (byte_reg == 'C') continue;          /* C owned by a byte */
            /* Interval overlap against already-assigned BC vregs, using the
               [lo,hi] each carries in the pool (BC is multi-occupant). */
            int ok = 1;
            for (int j = 0; j < n && ok; j++) {
                if (pool[j].vreg == v) continue;
                if (f->vreg_to_phys[pool[j].vreg] != IR_PR_BC) continue;
                int s = c->lo > pool[j].lo ? c->lo : pool[j].lo;
                int e = c->hi < pool[j].hi ? c->hi : pool[j].hi;
                if (s <= e) ok = 0;
            }
            if (ok) f->vreg_to_phys[v] = IR_PR_BC;
            continue;
        }
    }
    /* Apply the reserved DE-acc now that BC/idx2/byte are all placed, so the
       prepick snapshot is the full baseline (matches the sequential picker). */
    if (de_acc_vreg >= 0 && f->vreg_to_phys[de_acc_vreg] == IR_PR_SPILL) {
        free(word_home_prepick);
        word_home_prepick = malloc((size_t)f->n_vregs * sizeof(int));
        if (word_home_prepick)
            memcpy(word_home_prepick, f->vreg_to_phys,
                   (size_t)f->n_vregs * sizeof(int));
        for (int j = 0; j < f->n_vregs; j++)
            if (j != de_acc_vreg && f->vreg_to_phys[j] == IR_PR_DE)
                f->vreg_to_phys[j] = IR_PR_SPILL;
        f->vreg_to_phys[de_acc_vreg] = IR_PR_DE;
        f->word_home_vreg = de_acc_vreg;
        f->de_home_general = de_acc_general;
    }

    /* GENERAL DE-home phase (opt-in, speculative). Only if no reduction word-acc
       claimed DE and no byte E/D-home took DE's low half. The pick is OVERLAID on
       the finished BC/idx2/byte/word-acc baseline: snapshot that baseline as the
       revert target FIRST, then promote the winner to DE (from BC or spill),
       evicting any other DE tenant. Because the snapshot is the true baseline,
       a revert (no region forms) restores codegen exactly — no BC perturbation. */
    if (f->word_home_vreg < 0) {
        int gbest = -1;
        for (int i = 0; i < n; i++) {
            const Cand *c = &pool[i];
            if (!(c->allowed & RC_DE_ACC) || !(c->flags & CF_DE_GENERAL)) continue;
            int v = c->vreg;
            int ph = f->vreg_to_phys[v];
            if (ph != IR_PR_SPILL && ph != IR_PR_BC) continue;  /* promotable only */
            if (gbest < 0) { gbest = i; continue; }
            /* Loop-regalloc (CF_DE_PTR): with two walking-pointer candidates —
               one already in BC, one spilled — prefer promoting the SPILLED one
               to DE. That keeps the BC tenant resident too, so BOTH pointers ride
               registers (a→BC, b→DE). Promoting the BC one instead would merely
               move it and leave the second pointer in a slot. Off-gate no
               candidate carries CF_DE_PTR, so this reduces to the benefit sort. */
            int best_ph = f->vreg_to_phys[pool[gbest].vreg];
            int cur_ptr_spill  = (c->flags & CF_DE_PTR) && ph == IR_PR_SPILL;
            int best_ptr_spill = (pool[gbest].flags & CF_DE_PTR)
                                 && best_ph == IR_PR_SPILL;
            if (cur_ptr_spill != best_ptr_spill) {
                if (cur_ptr_spill) gbest = i;
                continue;
            }
            if (c->benefit > pool[gbest].benefit) gbest = i;
        }
        /* A byte home in E/D forbids a word DE-home (shared low half). */
        int e_taken = 0;
        for (int j = 0; j < f->n_vregs; j++)
            if (f->vreg_to_phys[j] == IR_PR_E || f->vreg_to_phys[j] == IR_PR_D) {
                e_taken = 1; break;
            }
        if (gbest >= 0 && !e_taken) {
            int v = pool[gbest].vreg;
            free(word_home_prepick);
            word_home_prepick = malloc((size_t)f->n_vregs * sizeof(int));
            if (word_home_prepick)
                memcpy(word_home_prepick, f->vreg_to_phys,
                       (size_t)f->n_vregs * sizeof(int));
            for (int j = 0; j < f->n_vregs; j++)
                if (j != v && f->vreg_to_phys[j] == IR_PR_DE)
                    f->vreg_to_phys[j] = IR_PR_SPILL;
            f->vreg_to_phys[v] = IR_PR_DE;   /* promote (from BC or spill) to DE */
            f->word_home_vreg = v;
            f->de_home_general = 1;
            f->de_home_is_ptr = (pool[gbest].flags & CF_DE_PTR) != 0;
        }
    }
}

/* Arbiter (Phase 0): sort candidates by benefit desc (stable on ties — insertion
   sort, preserving vreg order), then greedily assign PR_BC to each whose live
   interval doesn't overlap an already-assigned PR_BC vreg. Byte-identical to the
   former inline sort+greedy. */
static void arbitrate_to_bc(Func *f, Cand *cand, int n,
                            const int *first_use, const int *last_use)
{
    for (int i = 1; i < n; i++) {
        Cand c = cand[i];
        int j = i;
        while (j > 0 && cand[j - 1].benefit < c.benefit) {
            cand[j] = cand[j - 1];
            j--;
        }
        cand[j] = c;
    }
    for (int i = 0; i < n; i++) {
        int v = cand[i].vreg;
        int ok = 1;
        for (int j = 0; j < f->n_vregs && ok; j++) {
            if (f->vreg_to_phys[j] != IR_PR_BC) continue;
            int s = first_use[v] > first_use[j] ? first_use[v] : first_use[j];
            int e = last_use[v]  < last_use[j]  ? last_use[v]  : last_use[j];
            if (s <= e) ok = 0;
        }
        if (ok) f->vreg_to_phys[v] = IR_PR_BC;
    }
}

/* Op-kinds allowed to appear in a BC-pack candidate's span AFTER its def
   (ir_bc_pack, default on). These all PRESERVE a live BC cache in the
   lowerer (their `bc_live = (L.rs.bc >= 0)` guards stage through HL/DE when a
   PR_BC tenant is resident). Deliberately EXCLUDES the ops that use BC as an
   unconditional scratch — IR_MUL (multiply staging), IR_SHL/SHR/ROT* (B shift
   counter), the wide/DEHL machinery (IR_ACC_*, PUSH/POP_DEHL_LONG), far
   accesses, IR_COPY_STEP_BRZ/IR_POSTSTEP (BC step counters), IR_SWITCH,
   IR_IN/OUT, IR_STRCPY/STRCHR — and calls/asm (already excluded by the
   call-free gate). A width-4 operand anywhere in the span is rejected
   separately (the DEHL path clobbers BC). Over-rejection only loses a pack;
   a residual miss is fail-safe (a post-clobber read misses the BC cache and
   emit_bc_reload → require_slot aborts loudly — no silent miscompile). */
static int bc_pack_span_kind_ok(OpKind k)
{
    switch (k) {
    case IR_MOV: case IR_LD_IMM: case IR_LD_SYM: case IR_LD_STR: case IR_LEA:
    case IR_ADD: case IR_SUB: case IR_RSUB:
    case IR_AND: case IR_OR: case IR_XOR:
    case IR_INC: case IR_DEC: case IR_NEG: case IR_NOT:
    case IR_CONV_ZX: case IR_CONV_SX: case IR_CONV_TRUNC:
    case IR_CONV_BYTE_TO_HIGH:
    case IR_CMP_EQ: case IR_CMP_NE: case IR_CMP_LT: case IR_CMP_LE:
    case IR_CMP_GT: case IR_CMP_GE: case IR_CMP_ULT: case IR_CMP_ULE:
    case IR_CMP_UGT: case IR_CMP_UGE:
    case IR_BR: case IR_BR_COND: case IR_BR_ZERO:
    case IR_LD_MEM: case IR_ST_MEM: case IR_EXTRACT_BYTE:
    case IR_RET: case IR_NOP:
        return 1;
    default:
        return 0;
    }
}

/* True if op o references (dst or any use) a width-4 (DEHL) vreg — that
   lowering clobbers BC unconditionally, so it must not sit in a pack span. */
static int bc_pack_op_touches_w4(const Func *f, const Op *o)
{
    if (o->dst >= 0 && o->dst < f->n_vregs && f->vregs[o->dst].width == 4)
        return 1;
    int u[16];
    int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
    for (int k = 0; k < nu; k++)
        if (u[k] >= 0 && u[k] < f->n_vregs && f->vregs[u[k]].width == 4)
            return 1;
    return 0;
}

/* Live-range packing into BC for call-free-interval word temps (default on,
   IR_NO_BC_PACK opts out). unified_arbitrate uses whole-function / loop-extended intervals,
   so several non-overlapping call-free temps in one loop body all look like
   they span the whole loop and only ONE lands in BC. This second pass gives the
   losers a home using their TRUE (tight, per-op) live range.

   A candidate is admitted only if it is proven ITERATION-LOCAL and BC-clean, so
   BC never has to be reloaded from a (nonexistent) slot and the value is never
   live across a call:
     - width-2, currently SPILL, not param/addr-taken/volatile;
     - write-once with a BC-stamping producer (bc_safe_producer) — reuses the
       exact def-side machinery the existing write-once LOCAL PR_BC path proves;
     - all refs in ONE bb, the FIRST ref is the def (def-before-use), and the
       value is NOT live-in and NOT live-out of that bb → born-and-killed within
       each execution, never carried across the back-edge (this is what the
       loop-extension in unified_arbitrate guards against — md5 #349 — and what
       makes tight intervals safe here);
     - call-free span, and every op strictly after the def is BC-preserving
       (bc_pack_span_kind_ok) with no width-4 operand.
   The admitted candidates share the single BC register by greedy interval
   scheduling on their flat op ranges, skipping any overlap with an existing
   (loop-home) PR_BC tenant's extended interval. Winners are tagged
   IR_VREG_BC_PACK so gen_call's whole-function BC-save ignores them.

   Default ON; IR_NO_BC_PACK opts out (restores the pre-pack codegen exactly). */

/* LRA Phase-4: is op j one whose src[1]→BC staging the emitter (steps 3-4)
   actually implements? Only width-2 ADD/SUB have the `add hl,bc` / `sbc hl,bc`
   form wired in gen_add/gen_sub. Any other op that (per op_clobbers) may touch
   DE — CMP, byte ops, MUL, etc. — must BLOCK the DE placement rather than be
   marked, so the loud-abort backstop in load_binop_operands can never fire. */
static int lra_bc_emittable(const Func *f, const Op *o)
{
    if (o->kind != IR_ADD && o->kind != IR_SUB) return 0;
    return o->dst >= 0 && o->dst < f->n_vregs && f->vregs[o->dst].width == 2;
}

/* LRA Phase 2c: is IY available as a reduction-chain home in this function?
   Needs a CPU with IY + `add iy,de` (excludes gbz80/808x), sp-mode (IY free;
   -frameiy uses it as the frame ptr — widen to -frameix later), IY not already
   claimed by idx2/idx3/exx, and not an interrupt/naked function. */
static int lra_iy_available(const Func *f)
{
    if (f->is_interrupt || f->is_naked) return 0;
    /* CPU must have IY + `add iy,de` (excludes gbz80/8080/8085). z180/ez80/rabbit
       support the full-word add iy,rr (only the index-HALF ops trap on z180). */
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180
          || IS_EZ80() || IS_RABBIT())) return 0;
    /* IY is free in sp-mode (-1) and -frameix (1, IX is the frame); NOT under
       -frameiy (0, IY is the frame). The fp epilogue frame fix + IY-occupancy
       arbitration (below) + the FULL-live-range IY-clean check (rejects an
       accumulator live across an IY-clobbering call — the remat.c fp miscompile,
       now fixed) make fp sound. */
    if (c_framepointer_is_ix == 0) return 0;
    return 1;   /* IY occupancy handled (with benefit arbitration) in the pass */
}

/* A vreg that can be a reduction-chain member homed in IY: a plain width-2
   spill temp (no address-taken/volatile/param). */
static int lra_iy_chain_ok(const Func *f, int v)
{
    if (v < 0 || v >= f->n_vregs) return 0;
    if (f->vregs[v].width != 2) return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;      /* free / not already placed */
    if (f->vregs[v].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM))
        return 0;
    return 1;
}

/* LRA Phase 2c (IR_LRA-gated): home a DE-dirty straight-line reduction chain in
   IY. A chain is a run of width-2 ADDs c0=x+y, c1=c0+z, c2=c1+w… where each
   partial feeds the NEXT add as an operand and is otherwise dead (single use),
   all spilling in one loop-body BB. The addends' address computation owns HL+DE
   (and BC holds the loop ptr/IV), so the partials can't home in BC/DE and spill
   to slots. IY is immune to that clobbering, so the whole chain time-shares ONE
   IY register: c0 inits it (`push hl; pop iy` via commit_hl_result), c1.. via
   `add iy,de` (Phase 2b emitter). Sets f->idx3_reg=IY so vreg_idx_home sees the
   members and the prologue saves IY (frame_has_saved_iy). Runs AFTER ir_bc_pack
   (takes the SPILL losers) and before ir_stack_spill. Gated; byte-identical off. */
static void ir_iy_reduction_pack(Func *f, const int *bb_in_loop,
                                 const int *use_count)
{
    if (!getenv("IR_LRA")) return;
    if (!lra_iy_available(f)) return;

    /* RAW use counts (the passed use_count is depth-weighted — no good for a
       single-use test). raw_uses[v] = number of ops that read v. Also mark
       deref bases: a value used as a MEM_VREG base (or POSTSTEP subject) is a
       POINTER — it must stay addressable (`ld a,(hl)` etc.), NOT get homed in IY
       via add-iy-de (its deref would need (iy+d) / a separate path). The
       accumulator detector otherwise matches a walking pointer `p = p + stride`
       (same `s = s OP x` shape); excluding bases prevents that (test_remat_counter). */
    int *raw_uses = calloc((size_t)f->n_vregs, sizeof(int));
    int *is_base  = calloc((size_t)f->n_vregs, sizeof(int));
    if (!raw_uses || !is_base) { free(raw_uses); free(is_base); return; }
    for (int b = 0; b < f->n_bbs; b++)
        for (int j = 0; j < f->bbs[b].n_ops; j++) {
            const Op *o = &f->bbs[b].ops[j];
            int u[16], nu = ir_op_uses(o, u, 16);
            for (int k = 0; k < nu; k++)
                if (u[k] >= 0 && u[k] < f->n_vregs) raw_uses[u[k]]++;
            if (o->mem.kind == IR_MEM_VREG && o->mem.base >= 0
                && o->mem.base < f->n_vregs) is_base[o->mem.base] = 1;
            if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                && o->src[0] < f->n_vregs) is_base[o->src[0]] = 1;
        }

    /* Loop-carried accumulator (checked FIRST — it is live the whole loop, so
       homing it saves per-iteration slot traffic word_acc/DE-home couldn't). A
       width-2 spill s self-updated `s = s OP x` (ADD/SUB) in a loop, live across
       the back-edge (live-in AND live-out of the update's BB). word_acc left it
       spilling because DE is dirtied by the addend's address calc or a call; IY
       survives both (op_clobbers respects the helper table — l_mult etc. preserve
       IY), so s rides IY the whole loop: init `ld iy,K`/push;pop, updates
       `add iy,de` (Phase 2b aliased path), read at exit. Requires the ENTIRE loop
       region IY-clean. Scored by depth-weighted use_count (hotness) and compared
       against the best chain below — one IY user per function, take the hotter.
       (matrixbench has a COLD outer checksum accumulator AND the HOT inner
       stencil chain; the score picks the chain.) */
    int acc = -1, acc_bb = -1; long acc_score = 0;
    for (int v = 0; v < f->n_vregs; v++) {
        if (!lra_iy_chain_ok(f, v) || is_base[v]) continue;   /* not a deref-base pointer */
        int ub = -1;
        for (int b = 0; b < f->n_bbs && ub < 0; b++) {
            if (!bb_in_loop[b]) continue;
            for (int j = 0; j < f->bbs[b].n_ops; j++) {
                const Op *o = &f->bbs[b].ops[j];
                if ((o->kind == IR_ADD || o->kind == IR_SUB)
                    && o->dst == v && (o->src[0] == v || o->src[1] == v)) { ub = b; break; }
            }
        }
        if (ub < 0) continue;
        const BB *ubb = &f->bbs[ub];
        if (!ubb->live_in || !ubb->live_out) continue;
        if (!ir_bitset_get((const BitSet *)ubb->live_in, v)
            || !ir_bitset_get((const BitSet *)ubb->live_out, v)) continue;   /* loop-carried */
        /* IY-clean over the accumulator's FULL span — anywhere it is LIVE, not
           just the loop. An IY-clobbering op is a problem iff it isn't v's own
           write (an `add iy,de` / `ld iy` legitimately sets IY=v) AND v is
           live-OUT of it (needed afterwards). This catches a call BEFORE the loop
           that v is carried across (`chk=0; o=encode_pairs(); for(...)chk+=...` —
           the remat.c:48 fp miscompile) while allowing the last-use op (RET /
           the exit compare reads v then IY is free) and v's own updates. */
        int clean = 1;
        for (int b = 0; b < f->n_bbs && clean; b++) {
            const BB *cb = &f->bbs[b];
            if (!cb->live_in_per_op) continue;
            for (int k = 0; k < cb->n_ops; k++) {
                const Op *o = &cb->ops[k];
                if (o->dst == v) continue;                    /* v's own write */
                if (!(op_clobbers(f, o) & IR_R_IY)) continue;
                const BitSet *lo = (k + 1 < cb->n_ops)
                    ? (const BitSet *)cb->live_in_per_op[k + 1]
                    : (const BitSet *)cb->live_out;
                if (lo && ir_bitset_get(lo, v)) { clean = 0; break; }  /* v survives an IY clobber */
            }
        }
        if (!clean) continue;
        if ((long)use_count[v] > acc_score) { acc = v; acc_bb = ub; acc_score = use_count[v]; }
    }

    /* Find the single BEST (longest = most spill traffic saved) reduction chain
       in the function. ONE chain per function: the members of one chain have
       disjoint consecutive ranges and safely time-share IY, but two chains in
       different BBs can be simultaneously live (matrixbench: a row-offset chain
       lives across the neighbour-sum chain) and would collide in the one IY
       register. Proper inter-chain interference needs live ranges (not built
       here) — that's Phase 2d. */
    int best[32], best_nm = 0, best_bb = -1; long best_score = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        if (!bb_in_loop[b]) continue;
        BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            if (bb->ops[j].kind != IR_ADD) continue;
            int d0 = bb->ops[j].dst;
            if (!lra_iy_chain_ok(f, d0) || is_base[d0]) continue;  /* fresh spill, not a ptr */
            /* Grow the chain within this BB: follow the single-use partial into
               the next ADD that consumes it. Each partial (incl. the head) must
               be consumed ONLY by that add (raw single use) so the members'
               ranges are disjoint and can share one IY register. */
            int members[32]; int nm = 0; members[nm++] = d0;
            int cur = d0, ci = j;
            while (nm < 32 && raw_uses[cur] == 1) {
                int nb = -1, nd = -1;
                for (int k = ci + 1; k < bb->n_ops; k++) {
                    const Op *p = &bb->ops[k];
                    if (p->kind == IR_ADD && (p->src[0] == cur || p->src[1] == cur)) {
                        nb = k; nd = p->dst; break;
                    }
                }
                if (nb < 0 || !lra_iy_chain_ok(f, nd) || is_base[nd]) break;
                members[nm++] = nd; cur = nd; ci = nb;
            }
            if (nm < 2) continue;                          /* need >=1 accumulate add */
            /* IY must stay clean across the whole chain span [j..ci] (no CALL/
               ASM / non-preserving HCALL — op_clobbers respects the helper table). */
            int clean = 1;
            for (int k = j; k <= ci && clean; k++)
                if (op_clobbers(f, &bb->ops[k]) & IR_R_IY) clean = 0;
            if (!clean) continue;
            /* Score by depth-weighted hotness (sum of members' weighted uses) so
               a hot inner-loop chain outranks a cold one. */
            long score = 0;
            for (int m = 0; m < nm; m++) score += use_count[members[m]];
            if (score > best_score) {
                best_score = score; best_nm = nm; best_bb = b;
                for (int m = 0; m < nm; m++) best[m] = members[m];
            }
        }
    }
    /* One IY user per function: the higher-scoring of {accumulator, chain}. */
    int win_acc = (acc >= 0 && acc_score >= best_score);
    long win_score = win_acc ? acc_score : best_score;
    if (!win_acc && best_nm < 2) { free(raw_uses); free(is_base); return; }   /* no candidate */

    /* IY-occupancy ARBITRATION (2d). If idx2/idxhalf already homed value(s) in
       IY, our candidate must OUTSCORE them (depth-weighted uses) to claim it.
       fp-mode: idx2's index-home is ~a wash there (`push iy;pop hl` costs the
       same as an `(ix+d)` slot read), while our `add iy,de` accumulate is a real
       win — and idx2 in fp doesn't even save the caller's IY, whereas taking IY
       for the reduction does (frame_has_saved_iy) — so eviction is a strict
       improvement when we outscore it. sp-mode: idx2's IY-home is genuinely
       cheaper than a slot, so DON'T evict (keep the current free-IY-only rule);
       occ_score is set to LONG_MAX to force a bail. */
    long occ_score = 0; int occ_n = 0;
    for (int v = 0; v < f->n_vregs; v++) {
        PhysReg p = f->vreg_to_phys[v];
        if (p == IR_PR_IY || p == IR_PR_IYL || p == IR_PR_IYH) {
            occ_score += use_count[v]; occ_n++;
        }
    }
    if (occ_n > 0) {
        /* fp-mode: idx2's index-home is a WASH (`push iy;pop hl` == `(ix+d)`
           slot read), so ANY real reduction candidate (its `add iy,de` saves the
           accumulator RMW) is a net win over it — evict unconditionally. A
           use_count comparison would wrongly keep idx2 (it counts the base ptr's
           many reads but not that each costs the same in a slot). sp-mode: idx2's
           IY-home genuinely beats an expensive sp slot, so never evict — bail and
           leave IY to idx2 (matches the pre-arbitration free-IY-only rule). */
        if (c_framepointer_is_ix != 1) { free(raw_uses); free(is_base); return; }
        for (int v = 0; v < f->n_vregs; v++) {
            PhysReg p = f->vreg_to_phys[v];
            if (p == IR_PR_IY || p == IR_PR_IYL || p == IR_PR_IYH)
                f->vreg_to_phys[v] = IR_PR_SPILL;   /* revert-to-slot */
        }
        if (getenv("IR_ALLOC_PROBE"))
            fprintf(stderr, "IY_EVICT %d idx2 occupant(s) (fp wash) for candidate score=%ld\n",
                    occ_n, win_score);
    }
    (void)occ_score;

    if (win_acc) {
        f->vreg_to_phys[acc] = IR_PR_IY;
        f->idx3_reg = IR_PR_IY;
        if (getenv("IR_ALLOC_PROBE"))
            fprintf(stderr, "IY_ACC v%d bb%d score=%ld (loop-carried accumulator)\n",
                    acc, acc_bb, acc_score);
    } else {
        for (int m = 0; m < best_nm; m++) f->vreg_to_phys[best[m]] = IR_PR_IY;
        f->idx3_reg = IR_PR_IY;
        if (getenv("IR_ALLOC_PROBE")) {
            fprintf(stderr, "IY_REDUCE bb%d members=%d score=%ld:", best_bb, best_nm, best_score);
            for (int m = 0; m < best_nm; m++) fprintf(stderr, " v%d", best[m]);
            fprintf(stderr, "\n");
        }
    }
    free(raw_uses); free(is_base);
}

/* Single-BB tight-interval SHAPE of a spill temp — the analysis both ir_bc_pack
   and ir_stack_spill need. A width-2 vreg is `local` iff all its refs are in one
   BB, the first ref is its def, and it is neither live-in nor live-out of that BB
   (born-and-killed each execution). [lo,hi] is its tight op interval (local op
   indices in bb_of); `uses` is its raw use count. Placement policy (BC-clean
   span / call-free / single-use / stack hazards) stays in each pass — this is
   just the shared shape, computed once. */
typedef struct { int local, bb_of, lo, hi, uses; } SpillShape;

static SpillShape *compute_spill_shapes(const Func *f)
{
    SpillShape *sh = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1), sizeof *sh);
    if (!sh) return NULL;
    for (int v = 0; v < f->n_vregs; v++) {
        if (f->vregs[v].width != 2) continue;
        int bb_of = -1, lo = INT_MAX, hi = -1, first_is_def = 0, multi = 0, uses = 0;
        for (int i = 0; i < f->n_bbs && !multi; i++) {
            const BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++) {
                const Op *o = &bb->ops[j];
                int is_def = (o->dst == v);
                int u[16]; int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
                int is_use = 0;
                for (int k = 0; k < nu; k++) if (u[k] == v) { is_use = 1; uses++; }
                if (!is_def && !is_use) continue;
                if (bb_of == -1) { bb_of = i; first_is_def = is_def; }
                else if (bb_of != i) { multi = 1; break; }
                if (j < lo) lo = j;
                if (j > hi) hi = j;
            }
        }
        if (multi || bb_of < 0 || hi < 0 || !first_is_def) continue;
        const BB *bb = &f->bbs[bb_of];
        if (bb->live_out && ir_bitset_get((const BitSet *)bb->live_out, v)) continue;
        if (bb->live_in  && ir_bitset_get((const BitSet *)bb->live_in,  v)) continue;
        sh[v].local = 1; sh[v].bb_of = bb_of; sh[v].lo = lo; sh[v].hi = hi;
        sh[v].uses = uses;
    }
    return sh;
}

static void ir_bc_pack(Func *f, const int *first_use, const int *last_use,
                       const int *bb_first_op, const int *def_kind,
                       const int *write_count, const int *use_count)
{
    if (getenv("IR_NO_BC_PACK")) return;
    if (f->n_vregs <= 0) return;

    /* Per-vreg iteration-local SHAPE, computed for EVERY vreg (not just SPILL
       candidates). A vreg is `itloc` iff all refs are in one bb, the first ref
       is its def, it is neither live-in nor live-out of that bb (born-and-killed
       each execution), and every op after the def up to its last use is
       call-free + BC-preserving + width-4-free. `itlo`/`ithi` are its TIGHT flat
       op interval. Existing PR_BC tenants that are itloc release BC outside
       their tight span, so a packed temp may reuse BC there — using the tight
       interval (not the loop-EXTENDED first_use/last_use) in the clash test is
       exactly the refinement unified_arbitrate's loop-extension is too coarse
       for (a genuinely loop-carried tenant is live-in or live-out → not itloc →
       keeps its extended interval and still blocks). */
    int *itloc = calloc((size_t)f->n_vregs, sizeof(int));
    int *itlo  = calloc((size_t)f->n_vregs, sizeof(int));
    int *ithi  = calloc((size_t)f->n_vregs, sizeof(int));
    int *itbb  = calloc((size_t)f->n_vregs, sizeof(int));
    int *itdop = calloc((size_t)f->n_vregs, sizeof(int));   /* def op idx in itbb */
    SpillShape *sh = compute_spill_shapes(f);
    if (!itloc || !itlo || !ithi || !itbb || !itdop || !sh) {
        free(itloc); free(itlo); free(ithi); free(itbb); free(itdop); free(sh); return;
    }

    /* itloc = single-BB-local (shared shape) AND the BC-specific span admission:
       every op after the def must be call-free + BC-preserving + width-4-free. */
    for (int v = 0; v < f->n_vregs; v++) {
        if (!sh[v].local) continue;
        const BB *bb = &f->bbs[sh[v].bb_of];
        int span_ok = 1;
        for (int j = sh[v].lo + 1; j <= sh[v].hi && span_ok; j++) {
            const Op *o = &bb->ops[j];
            if (o->kind == IR_CALL || o->kind == IR_HCALL || o->kind == IR_ASM
                || !bc_pack_span_kind_ok(o->kind)
                || bc_pack_op_touches_w4(f, o))
                span_ok = 0;
        }
        if (!span_ok) continue;
        itloc[v] = 1;
        itlo[v]  = bb_first_op[sh[v].bb_of] + sh[v].lo;
        ithi[v]  = bb_first_op[sh[v].bb_of] + sh[v].hi;
        itbb[v]  = sh[v].bb_of;
        itdop[v] = sh[v].lo;           /* first_is_def ⇒ def is at op index lo */
    }
    free(sh);

    /* Candidate flat interval [flo,fhi], sorted by flo for greedy scheduling. */
    typedef struct { int vreg, flo, fhi; } PackCand;
    PackCand *cand = calloc((size_t)f->n_vregs, sizeof(PackCand));
    if (!cand) { free(itloc); free(itlo); free(ithi); return; }
    int nc = 0;

    for (int v = 0; v < f->n_vregs; v++) {
        const VReg *vr = &f->vregs[v];
        if (!itloc[v]) continue;
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;   /* already placed */
        if (vr->flags & (IR_VREG_PARAM | IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
            continue;
        if (write_count[v] != 1) continue;
        if (use_count[v] < 1) continue;
        if (!bc_safe_producer(def_kind[v])) continue;
        /* Only pack when the SPILL alternative actually costs frame traffic: if
           the def's spill store is dead (value HL-carried to a single adjacent
           use), a BC home saves nothing and the `ld bc,hl` stamp is pure
           overhead. Requiring a live spill captures exactly the store/reload
           the home eliminates. */
        if (op_dst_spill_is_dead(&f->bbs[itbb[v]], itdop[v])) continue;
        /* A value used as a MEM_VREG deref base wants to be in HL (`ld a,(hl)` /
           `ld (hl),a`), not BC: a BC home forces `ld bc,hl` at the def and the
           deref still uses HL, so the stamp is wasted — UNLESS slots are
           expensive (sp mode on a CPU without cheap sp-relative addressing),
           where the BC home saves the pointer's slot reload and pays off
           (hashbench/strbench sp). So reject a deref-base candidate only when
           slots are cheap: fp mode, or kc160/rabbit (native ld rr,(sp+d)). The
           loop-home walking-pointer `ld a,(bc)` case is a separate proposer. */
        int cheap_slot = (c_framepointer_is_ix != -1) || IS_KC160() || IS_RABBIT();
        if (cheap_slot) {
            int is_membase = 0;
            for (int i = 0; i < f->n_bbs && !is_membase; i++)
                for (int j = 0; j < f->bbs[i].n_ops; j++) {
                    const Op *o = &f->bbs[i].ops[j];
                    if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                        && o->mem.kind == IR_MEM_VREG && o->mem.base == v) {
                        is_membase = 1; break;
                    }
                }
            if (is_membase) continue;
        }
        cand[nc].vreg = v;
        cand[nc].flo  = itlo[v];
        cand[nc].fhi  = ithi[v];
        nc++;
    }

    /* Sort candidates by flo ascending (insertion sort — nc is small). */
    for (int i = 1; i < nc; i++) {
        PackCand c = cand[i];
        int j = i;
        while (j > 0 && cand[j - 1].flo > c.flo) { cand[j] = cand[j - 1]; j--; }
        cand[j] = c;
    }

    /* Greedy: assign BC to a candidate whose flat interval starts after the last
       assigned one ends AND doesn't overlap an existing PR_BC tenant. A genuine
       loop-home tenant (not itloc) blocks over its EXTENDED interval; an itloc
       tenant only over its TIGHT span (it releases BC when dead). */
    int packed = 0, last_fhi = -1;
    for (int i = 0; i < nc; i++) {
        int v = cand[i].vreg;
        if (cand[i].flo <= last_fhi) continue;   /* overlaps a packed sibling */
        int clash = 0;
        for (int j = 0; j < f->n_vregs && !clash; j++) {
            if (f->vreg_to_phys[j] != IR_PR_BC) continue;
            if (f->vregs[j].flags & IR_VREG_BC_PACK) continue;   /* our own */
            int jlo = itloc[j] ? itlo[j] : first_use[j];
            int jhi = itloc[j] ? ithi[j] : last_use[j];
            int s = cand[i].flo > jlo ? cand[i].flo : jlo;
            int e = cand[i].fhi < jhi ? cand[i].fhi : jhi;
            if (s <= e) clash = 1;
        }
        if (clash) continue;
        f->vreg_to_phys[v] = IR_PR_BC;
        f->vregs[v].flags |= IR_VREG_BC_PACK;
        last_fhi = cand[i].fhi;
        packed++;
    }
    /* ---- DE as a SECOND local home (IR_LRA) -------------------------------
       For the itloc candidates BC couldn't take (BC held by a loop home →
       clash), try DE: place a candidate in DE when its span is DE-CLEAN under
       the RELAXED model (op_clobbers_relaxed — ADD/SUB/CMP stage src[1] into BC
       not DE) AND DE is otherwise idle over the span (no PR_DE/E/D tenant). On
       commit, MARK each relaxed op (`lra_stage_src1_bc`) so the loader +
       `hl,bc` emitter route its src[1] through BC, keeping the DE resident live.
       Relaxing an op needs BC free across it (staging clobbers BC), so a span
       crossing a live BC tenant stays DE-dirty (rejected `bc_busy`).

       DORMANT in practice: this is the "persistent DE second home" the operand
       loader structurally blocks — freeing DE needs BC-staging, but BC is
       exactly what's contended in the loops that would benefit, so placements
       come out empty. Kept as the mechanism + measurement; IY is the workaround
       that actually pays (ir_iy_reduction_pack). See ADR 0003. */
    int de_packed = 0, de_rej_dirty = 0, de_rej_clash = 0, de_avail = 0;
    int de_rej_bc_busy = 0, de_marks = 0, de_rej_noop = 0;
    if (getenv("IR_LRA")) {
        int de_last = -1;
        for (int i = 0; i < nc; i++) {
            int v = cand[i].vreg;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;   /* BC already took it */
            de_avail++;
            BB *bb = &f->bbs[itbb[v]];
            int base = bb_first_op[itbb[v]];
            int llo = itdop[v];                                /* def op (local) */
            int lhi = ithi[v] - base;                          /* last ref (local) */
            int relax_ok = 1, relax_bc_blocked = 0;
            for (int j = llo + 1; j <= lhi && relax_ok; j++) {
                RegMask cs = op_clobbers(f, &bb->ops[j]);
                if (op_clobbers_relaxed(f, &bb->ops[j]) & IR_R_DE) {
                    relax_ok = 0;                              /* non-relaxable DE clobber */
                    continue;
                }
                /* This op was relaxed (strict-DE, relaxed-clean) → its BC-staging
                   needs BC free at this flat index. An op whose src[1] IS the
                   packed value reads it straight from DE (`add hl,de`) — no
                   staging, no BC needed, so it never blocks. */
                if ((cs & IR_R_DE) && bb->ops[j].src[1] != v) {
                    /* The emitter only BC-stages width-2 ADD/SUB; a DE-staging
                       op it can't rewrite (CMP / byte / etc.) blocks placement. */
                    if (!lra_bc_emittable(f, &bb->ops[j])) { relax_ok = 0; continue; }
                    int fidx = base + j, bc_busy = 0;
                    for (int k = 0; k < f->n_vregs && !bc_busy; k++) {
                        PhysReg pk = f->vreg_to_phys[k];
                        if (pk != IR_PR_BC && pk != IR_PR_C && pk != IR_PR_B) continue;
                        /* Check the tenant's live interval (tight for an itloc
                           BC_PACK tenant, extended for a loop-home) against this
                           op — a BC_PACK value live ACROSS the marked op (its
                           tight span covers fidx) genuinely holds BC and blocks
                           the BC-staging; only skip it where fidx is outside. */
                        int klo = itloc[k] ? itlo[k] : first_use[k];
                        int khi = itloc[k] ? ithi[k] : last_use[k];
                        if (fidx >= klo && fidx <= khi) bc_busy = 1;
                    }
                    if (bc_busy) { relax_ok = 0; relax_bc_blocked = 1; }
                }
            }
            if (!relax_ok) {
                if (relax_bc_blocked) de_rej_bc_busy++; else de_rej_dirty++;
                continue;
            }
            if (cand[i].flo <= de_last) continue;              /* overlaps a DE sibling */
            /* DE-tenant overlap (a value already resident in DE across the span). */
            int clash = 0;
            for (int j = 0; j < f->n_vregs && !clash; j++) {
                PhysReg pj = f->vreg_to_phys[j];
                if (pj != IR_PR_DE && pj != IR_PR_E && pj != IR_PR_D) continue;
                if (f->vregs[j].flags & IR_VREG_DE_PACK) continue;   /* our own */
                int jlo = itloc[j] ? itlo[j] : first_use[j];
                int jhi = itloc[j] ? ithi[j] : last_use[j];
                int s = cand[i].flo > jlo ? cand[i].flo : jlo;
                int e = cand[i].fhi < jhi ? cand[i].fhi : jhi;
                if (s <= e) clash = 1;
            }
            if (clash) { de_rej_clash++; continue; }
            /* --- Identify the ops to mark. Evaluate with v still SPILL so
               op_clobbers isolates the STAGING-DE bit (once v is PR_DE an op
               using v carries DE as an operand home and the `!relaxed-DE` test
               would wrongly fail). Skip src[1]==v (v is consumed from DE,
               nothing staged). A mark = a DE-clobbering staging op the peephole
               cannot carry the resident across → the traffic the home saves. */
            int nm = 0;
            for (int j = llo + 1; j <= lhi; j++) {
                if (bb->ops[j].src[1] == v || !lra_bc_emittable(f, &bb->ops[j])) continue;
                if ((op_clobbers(f, &bb->ops[j]) & IR_R_DE)
                    && !(op_clobbers_relaxed(f, &bb->ops[j]) & IR_R_DE))
                    nm++;
            }
            /* marks==0 ⇒ every use is adjacent / src[1]-consumed, so the
               existing peephole DE-cache already carries v across its whole
               span (the `ex de,hl` operand-swap keeps it there). A PR_DE home
               would be byte-identical — a no-op placement. Only place (and pay
               the BC-staging of steps 3-4) when it rescues real slot traffic. */
            if (nm == 0) { de_rej_noop++; continue; }
            for (int j = llo + 1; j <= lhi; j++) {
                if (bb->ops[j].src[1] == v || !lra_bc_emittable(f, &bb->ops[j])) continue;
                if ((op_clobbers(f, &bb->ops[j]) & IR_R_DE)
                    && !(op_clobbers_relaxed(f, &bb->ops[j]) & IR_R_DE))
                    bb->ops[j].lra_stage_src1_bc = 1;
            }
            de_marks += nm;
            /* --- COMMIT: place v in DE. */
            f->vreg_to_phys[v] = IR_PR_DE;
            f->vregs[v].flags |= IR_VREG_DE_PACK;
            de_last = cand[i].fhi;
            de_packed++;
        }
    }
    if (getenv("IR_ALLOC_PROBE"))
        fprintf(stderr, "BC_PACK packed=%d of candidates=%d  DE_PACK placed=%d "
                "(avail=%d dirty=%d bc_busy=%d clash=%d noop=%d marks=%d)\n",
                packed, nc, de_packed, de_avail, de_rej_dirty, de_rej_bc_busy,
                de_rej_clash, de_rej_noop, de_marks);
    free(cand); free(itloc); free(itlo); free(ithi); free(itbb); free(itdop);
}

/* Ops that manipulate the stack or transfer control — forbidden between a
   stack-transient's def and its use (they'd break the push/pop TOS discipline
   or the LIFO balance). ALU/compare/load/store/conv are all fine: the value
   rides the stack across them untouched. */
static int stack_spill_span_hazard(OpKind k)
{
    switch (k) {
    case IR_CALL: case IR_HCALL: case IR_ASM:
    case IR_LD_FAR: case IR_ST_FAR: case IR_LD_FARSYM:
    case IR_PUSH_ARG: case IR_PUSH_STRUCT:
    case IR_PUSH_DEHL_LONG: case IR_POP_DEHL_LONG:
    case IR_SWITCH:
    case IR_BR: case IR_BR_COND: case IR_BR_ZERO: case IR_RET:
        return 1;
    default:
        return 0;
    }
}

/* Stack-transient spill (default on, IR_NO_STACK_SPILL opts out). A leftover spilled width-2
   temp (after all register allocation incl. ir_bc_pack) with a SINGLE def and
   SINGLE use in one straight-line span goes on the STACK — `push hl` at the
   def, `pop` at the use — instead of a frame slot. push/pop (1 byte each) beat
   the slot store+reload, and the frame slot is freed. This is the register-
   pressure fallback below ir_bc_pack: it takes the transients no register could.

   Admitted only when it is provably safe as a 1-deep stack park:
     - width-2, still SPILL, not param/addr-taken/volatile;
     - write-once with a bc_safe_producer def (leaves HL=value, routes through
       commit_hl_word so the def-store becomes `push hl`);
     - exactly ONE static use; all refs in ONE bb; FIRST ref is the def; not
       live-in and not live-out → born, parked, consumed, dead — each execution;
     - the def's spill is genuinely live (op_dst_spill_is_dead false), else the
       value would just ride HL and the push/pop is pure overhead;
     - NO stack/control hazard between def and use (stack_spill_span_hazard);
     - DISJOINT from every other stack-transient (greedy) — at most one parked
       at a time, so a single TOS slot and LIFO are trivially safe. */
static void ir_stack_spill(Func *f, const int *bb_first_op, const int *def_kind,
                           const int *write_count)
{
    if (getenv("IR_NO_STACK_SPILL")) return;   /* default ON; opts out */
    if (f->n_vregs <= 0) return;
    /* Gate: z80/z80n/z180/8080/8085/gbz80, sp AND fp — every CPU with expensive
       word slot access (fp: 2× ld (ix+d) ~38T; sp: ld hl,N;add hl,sp;…) vs
       push/pop 21T, so parking pays. Correctness rests on: copt strips pointless
       adjacent parks (push %1/pop %1); the commutative-addend reject (above) stops
       parking values that ride HL into a reduction (the sp structbench +29%
       cause); and NO slot-store path emits the -1 sentinel for a PR_STACK vreg —
       spill_and_swap/store_hl/store_a_byte/spill_de_unless_dead all park, and the
       load_to_* pop is checked before any cache hit (else a stale cache_hl/de
       skips the balancing pop → sp-1 write / stack leak; 8085's LD_IMM `ld de,K`
       fastpath via spill_de_unless_dead was the crash). EXCLUDED: ez80/kc160/
       rabbit (cheap native sp-relative slots — parking doesn't pay). */
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180
          || IS_8080() || IS_8085() || IS_GBZ80())) return;

    typedef struct { int vreg, flo, fhi; } SCand;
    SCand *cand = calloc((size_t)f->n_vregs, sizeof(SCand));
    SpillShape *sh = compute_spill_shapes(f);
    if (!cand || !sh) { free(cand); free(sh); return; }
    int nc = 0;

    for (int v = 0; v < f->n_vregs; v++) {
        const VReg *vr = &f->vregs[v];
        if (vr->width != 2) continue;
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
        if (vr->flags & (IR_VREG_PARAM | IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
            continue;
        if (write_count[v] != 1) continue;
        if (!bc_safe_producer(def_kind[v])) continue;

        /* Shared shape: single-BB, first-ref-is-def, not live across the BB, tight
           [lo,hi]; plus stack_spill's own "exactly one use". */
        if (!sh[v].local || sh[v].uses != 1) continue;
        int bb_of = sh[v].bb_of, lo = sh[v].lo, hi = sh[v].hi;

        const BB *bb = &f->bbs[bb_of];
        if (op_dst_spill_is_dead(bb, lo)) continue;   /* value rides HL — no win */
        /* A value consumed by an IMMEDIATELY-following COMMUTATIVE binop rides a
           register straight into it (the lowering swaps it into the HL operand
           position), so it never needs a slot — parking is pure overhead.
           op_dst_spill_is_dead only catches the src[0] case; a commutative op's
           src[1] (the classic reduction addend `acc += *p`) slips through and was
           being parked (structbench sp addends → +29% clock). Reject it. */
        if (hi == lo + 1) {
            OpKind uk = bb->ops[hi].kind;
            if (uk == IR_ADD || uk == IR_AND || uk == IR_OR || uk == IR_XOR)
                continue;
        }

        int span_ok = 1;
        for (int j = lo + 1; j <= hi && span_ok; j++)
            if (stack_spill_span_hazard(bb->ops[j].kind)) span_ok = 0;
        if (!span_ok) continue;

        cand[nc].vreg = v;
        cand[nc].flo  = bb_first_op[bb_of] + lo;
        cand[nc].fhi  = bb_first_op[bb_of] + hi;
        nc++;
    }

    /* Sort by flo; greedy DISJOINT (one parked at a time → single TOS slot). */
    for (int i = 1; i < nc; i++) {
        SCand c = cand[i];
        int j = i;
        while (j > 0 && cand[j - 1].flo > c.flo) { cand[j] = cand[j - 1]; j--; }
        cand[j] = c;
    }
    int placed = 0, last_fhi = -1;
    for (int i = 0; i < nc; i++) {
        if (cand[i].flo <= last_fhi) continue;   /* overlaps a parked sibling */
        f->vreg_to_phys[cand[i].vreg] = IR_PR_STACK;
        last_fhi = cand[i].fhi;
        placed++;
    }
    if (getenv("IR_ALLOC_PROBE"))
        fprintf(stderr, "STACK_SPILL placed=%d of candidates=%d\n", placed, nc);
    free(cand); free(sh);
}

/* Diagnostic probe (IR_ALLOC_PROBE): count spilled width-2 temps whose whole
   live range sits in ONE bb with no call between first def and last use — the
   reachable subset for call-free-interval word residency (option A). This is an
   UPPER BOUND: it ignores whether the codegen clobbers a register inside the
   span (layer 2), so real A wins are a subset of this. */
static void alloc_probe(const Func *f)
{
    if (!getenv("IR_ALLOC_PROBE")) return;
    int eligible = 0, passable = 0, bc_clean = 0, spilled_words = 0, total_uses = 0;
    /* DE reachability (runs AFTER ir_bc_pack, so PR_BC winners are already
       excluded from `eligible` — these are the LEFTOVER spilled word temps).
       de_clean = DE-clean span; de_reach = de_clean AND the function's DE pair
       is free (no PR_DE/PR_E/PR_D tenant, no word-home) → the reachable set a
       DE-pack pass could still take. bc_taken tells us whether a loop-home is
       what pushed these off BC. */
    int de_clean = 0, de_reach = 0;
    int de_free = (f->word_home_vreg < 0);
    int bc_taken = 0;
    for (int v = 0; v < f->n_vregs && de_free; v++)
        if (f->vreg_to_phys[v] == IR_PR_DE || f->vreg_to_phys[v] == IR_PR_E
            || f->vreg_to_phys[v] == IR_PR_D) de_free = 0;
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vreg_to_phys[v] == IR_PR_BC) { bc_taken = 1; break; }
    for (int v = 0; v < f->n_vregs; v++) {
        if (f->vregs[v].width != 2) continue;
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
        if (f->vregs[v].flags & (IR_VREG_PARAM | IR_VREG_ADDR_TAKEN)) continue;
        spilled_words++;
        int bb_of = -1, lo = INT_MAX, hi = -1, multi = 0, uses = 0;
        for (int i = 0; i < f->n_bbs && !multi; i++) {
            const BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++) {
                const Op *o = &bb->ops[j];
                int refs = (o->dst == v);
                int u[16]; int nu = ir_op_uses(o, u, 16);
                for (int k = 0; k < nu; k++) if (u[k] == v) { refs = 1; uses++; }
                if (!refs) continue;
                if (bb_of == -1) bb_of = i;
                else if (bb_of != i) { multi = 1; break; }
                if (j < lo) lo = j;
                if (j > hi) hi = j;
            }
        }
        if (multi || bb_of < 0) continue;
        int callfree = 1;
        const BB *bb = &f->bbs[bb_of];
        for (int j = lo; j <= hi; j++) {
            OpKind k = bb->ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) { callfree = 0; break; }
        }
        if (!callfree) continue;
        eligible++;
        total_uses += uses;
        /* Layer-2 estimate: is a register clobber-free across the span?
           In a call-free span the operand loaders stage through HL/DE, never
           BC, so BC is clobbered only by IR_MUL and width-4 (DEHL) ops. DE is
           clobbered by word binops/compares/conv, offset/indirect mem, and
           width-4 ops. A temp is layer-2-passable if BC or DE stays clean. */
        int bc_dirty = 0, de_dirty = 0;
        for (int j = lo; j <= hi; j++) {
            const Op *o = &bb->ops[j];
            int w4 = (o->dst >= 0 && o->dst < f->n_vregs
                      && f->vregs[o->dst].width == 4);
            if (o->kind == IR_MUL || w4) bc_dirty = 1;
            switch (o->kind) {
            case IR_ADD: case IR_SUB: case IR_RSUB:
            case IR_AND: case IR_OR: case IR_XOR: case IR_MUL:
            case IR_CMP_EQ: case IR_CMP_NE: case IR_CMP_LT: case IR_CMP_LE:
            case IR_CMP_GT: case IR_CMP_GE: case IR_CMP_ULT: case IR_CMP_ULE:
            case IR_CMP_UGT: case IR_CMP_UGE:
            case IR_CONV_SX: case IR_CONV_ZX: case IR_CONV_TRUNC:
            case IR_CONV_BYTE_TO_HIGH:
                de_dirty = 1; break;
            case IR_LD_MEM: case IR_ST_MEM:
                if (o->mem.kind == IR_MEM_VREG || o->mem.offset != 0) de_dirty = 1;
                break;
            default: break;
            }
            if (w4) de_dirty = 1;
        }
        if (!bc_dirty) bc_clean++;
        if (!de_dirty) { de_clean++; if (de_free) de_reach++; }
        if (!bc_dirty || !de_dirty) passable++;
    }
    if (spilled_words)
        fprintf(stderr, "ALLOC_PROBE eligible=%d passable=%d bc_clean=%d "
                "de_clean=%d de_reach=%d de_free=%d bc_taken=%d "
                "spilled_words=%d uses=%d\n",
                eligible, passable, bc_clean, de_clean, de_reach, de_free,
                bc_taken, spilled_words, total_uses);
}

void ir_alloc(Func *f)
{
    if (!f) return;
    free(f->vreg_to_phys);
    f->vreg_to_phys = NULL;
    if (f->n_vregs <= 0) return;
    f->vreg_to_phys = calloc((size_t)f->n_vregs, sizeof(*f->vreg_to_phys));
    if (!f->vreg_to_phys) return;

    /* Default: every vreg gets a slot, then narrow to the register
       pools below. */
    for (int v = 0; v < f->n_vregs; v++)
        f->vreg_to_phys[v] = IR_PR_SPILL;

    /* Param-in-place: read AND write the caller's pushed-arg slot
       directly — the caller pops those slots after return and never
       observes callee writes, so no prologue copy-in or local slot
       is needed.

       ADDR_TAKEN params are safe too: `&param` only has to stay valid
       for the function's lifetime (escaping it is UB), which is
       exactly the window the pushed-arg slot covers. */
    /* The __z88dk_fastcall arg (the last param) arrives in HL, NOT on the
       caller stack — it can't be read in place. emit_prologue stores it to
       a real local slot (or its allocated register), so leave it off the
       in-place list. It's the highest-indexed PARAM vreg (params precede
       temps in creation order). */
    int fc_param = -1;
    if (f->flags & FASTCALL)
        for (int v = 0; v < f->n_vregs; v++)
            if (f->vregs[v].flags & IR_VREG_PARAM) fc_param = v;
    for (int v = 0; v < f->n_vregs; v++) {
        VReg *vr = &f->vregs[v];
        if (!(vr->flags & IR_VREG_PARAM)) continue;
        if (v == fc_param) continue;
        /* __sdcccall(1) params (flagged VOLATILE by ir_build) are NOT on the
           caller stack — register args arrive in A/HL/DE, and even the
           stacked remainder is placed into local slots by emit_prologue.
           Reading them "in place" would alias the return address / a
           still-pending stacked slot, so give them real local slots. */
        if ((f->flags & SDCCCALL1) && (vr->flags & IR_VREG_VOLATILE)) continue;
        vr->flags |= IR_VREG_PARAM_IN_PLACE;
    }

    /* `cacheable[v]` is 1 iff every def of v is in an op whose lowerer
       path runs through spill_and_swap_unless_dead
       (i.e., the cache-aware emit paths) AND the dst is dead-after at
       every def AND v's width is 2 (HL cache only). Other ops always
       store to the slot, so the slot is needed. */
    int *cacheable = calloc((size_t)f->n_vregs, sizeof(int));
    if (!cacheable) return;
    for (int v = 0; v < f->n_vregs; v++) cacheable[v] = 1;

    /* Params and addr-taken always need a slot. */
    for (int v = 0; v < f->n_vregs; v++) {
        const VReg *vr = &f->vregs[v];
        if ((vr->flags & IR_VREG_PARAM)
            || (vr->flags & IR_VREG_ADDR_TAKEN))
            cacheable[v] = 0;
    }
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *op = &bb->ops[j];
            if (op->kind == IR_CALL && op->call && op->call->ret_vreg >= 0)
                cacheable[op->call->ret_vreg] = 0;
            if (op->kind == IR_HCALL && op->hcall
                && op->hcall->ret_vreg >= 0)
                cacheable[op->hcall->ret_vreg] = 0;
            /* IR_POSTSTEP also DEFINES src[0] (the stepped var) and
               writes its slot unconditionally — never slot-less. */
            if (op->kind == IR_POSTSTEP && op->src[0] >= 0)
                cacheable[op->src[0]] = 0;
            if (op->dst < 0) continue;
            int eligible_kind;
            switch (op->kind) {
            case IR_LD_IMM: case IR_LD_SYM: case IR_LD_MEM:
            case IR_LD_STR: case IR_LEA:
            case IR_MOV: case IR_POSTSTEP:
            case IR_ADD: case IR_SUB: case IR_RSUB:
            case IR_AND: case IR_OR: case IR_XOR:
            case IR_SHL: case IR_SHR:
            case IR_INC: case IR_DEC:
            case IR_NEG: case IR_NOT:
            case IR_CMP_EQ:  case IR_CMP_NE:
            case IR_CMP_LT:  case IR_CMP_LE:
            case IR_CMP_GT:  case IR_CMP_GE:
            case IR_CMP_ULT: case IR_CMP_ULE:
            case IR_CMP_UGT: case IR_CMP_UGE:
            case IR_CONV_ZX: case IR_CONV_SX:
            case IR_CONV_BYTE_TO_HIGH:
                /* Byte→int conversion producers: their width=2 emits
                   are spill-skip-aware (spill_and_swap_unless_dead +
                   cache_hl), so a dead-after-next-op result can stay
                   in HL like any other binop dst. */
                eligible_kind = 1;
                break;
            default:
                eligible_kind = 0;
                break;
            }
            int dst_w = f->vregs[op->dst].width;
            if (dst_w != 2 || !eligible_kind || !op_dst_spill_is_dead(bb, j))
                cacheable[op->dst] = 0;
        }
    }

    for (int v = 0; v < f->n_vregs; v++) {
        if (cacheable[v]) f->vreg_to_phys[v] = IR_PR_HL;
    }
    free(cacheable);

    /* PR_DE pool: width-2 vregs whose only use is as src[1] of
       the immediately-following binop, defined by an op whose lowerer
       can route the value directly into DE (saving the HL→slot→DE
       round trip). Producer set:
         - IR_LD_IMM (emits `ld de,K`)
         - IR_LD_MEM with IR_MEM_SYM (emits `ld de,(sym)`)

       The PR_HL set above never overlaps (PR_HL requires src[0]==v in
       the next op; PR_DE requires src[1]==v), so vregs are always in
       at most one pool.

       Criterion is intentionally narrow: exactly-one def in the
       eligible-producer set, exactly-one use at op_idx+1 as src[1],
       not src[0], not live-out, not param / addr-taken (those rules
       came from the HL pool pre-filter). Anything else falls back to
       PR_SPILL with the dynamic DE cache (rs.de) handling
       opportunistic hits at emit time. */
    int *de_defs = calloc((size_t)f->n_vregs, sizeof(int));
    int *de_uses = calloc((size_t)f->n_vregs, sizeof(int));
    if (!de_defs || !de_uses) { free(de_defs); free(de_uses); return; }
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            int buf[16];
            int n = ir_op_defs(&bb->ops[j], buf,
                               (int)(sizeof buf / sizeof buf[0]));
            for (int k = 0; k < n && k < 16; k++)
                if (buf[k] >= 0 && buf[k] < f->n_vregs) de_defs[buf[k]]++;
            n = ir_op_uses(&bb->ops[j], buf,
                           (int)(sizeof buf / sizeof buf[0]));
            for (int k = 0; k < n && k < 16; k++)
                if (buf[k] >= 0 && buf[k] < f->n_vregs) de_uses[buf[k]]++;
        }
    }
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j + 1 < bb->n_ops; j++) {
            const Op *op  = &bb->ops[j];
            const Op *nxt = &bb->ops[j + 1];
            int producer_ok = 0;
            switch (op->kind) {
            case IR_LD_IMM:
            case IR_MOV:
                /* IR_MOV: load src directly into DE via load_to_de. */
                producer_ok = 1;
                break;
            case IR_LD_MEM:
                producer_ok = (op->mem.kind == IR_MEM_SYM
                               || op->mem.kind == IR_MEM_VREG);
                break;
            case IR_ADD: case IR_SUB: case IR_RSUB:
            case IR_AND: case IR_OR: case IR_XOR:
                /* The int (width-2) binop lowerers route the final
                   byte writes into D/E (for AND/OR/XOR) or wrap the
                   `add hl,de` / `sbc hl,de` result with `ex de,hl`
                   (for ADD/SUB) when dst is PR_DE. */
                producer_ok = 1;
                break;
            case IR_SHL: case IR_SHR:
                /* Int shifts: emit into HL as usual (the bit shifts
                   need add hl,hl / srl h / rr l etc.), then wrap with
                   ex de,hl on PR_DE dst. The count >= 16 zero-result
                   path emits `ld de,0` directly. */
                producer_ok = 1;
                break;
            case IR_CONV_ZX:
            case IR_CONV_SX:
            case IR_CONV_BYTE_TO_HIGH:
                /* Width-extending conversions to int: byte→int (ZX/SX)
                   and byte→int<<8 (BYTE_TO_HIGH). The lowerer routes
                   the result bytes into E/D for PR_DE dst. Common in
                   `crc ^= ((unsigned int)*data) << 8` shapes — the
                   CONV producer feeds the XOR as src[1]. */
                producer_ok = 1;
                break;
            default:
                break;
            }
            if (!producer_ok) continue;
            if (op->dst < 0) continue;
            int v = op->dst;
            if (f->vregs[v].width != 2) continue;
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            const VReg *vr = &f->vregs[v];
            if ((vr->flags & IR_VREG_PARAM)
                || (vr->flags & IR_VREG_ADDR_TAKEN))
                continue;
            /* Not live past this op (would need slot for cross-BB read). */
            if (bb->live_out
                && ir_bitset_get((const BitSet *)bb->live_out, v))
                continue;
            if (nxt->src[1] != v || nxt->src[0] == v) continue;
            int nxt_eligible;
            switch (nxt->kind) {
            case IR_ADD: case IR_SUB: case IR_RSUB:
            case IR_AND: case IR_OR: case IR_XOR:
            case IR_CMP_EQ:  case IR_CMP_NE:
            case IR_CMP_LT:  case IR_CMP_LE:
            case IR_CMP_GT:  case IR_CMP_GE:
            case IR_CMP_ULT: case IR_CMP_ULE:
            case IR_CMP_UGT: case IR_CMP_UGE:
                nxt_eligible = 1;
                break;
            default:
                nxt_eligible = 0;
                break;
            }
            if (!nxt_eligible) continue;
            /* Exactly one def and one use function-wide. Multi-def
               vregs (sym-mapped locals) must keep their slot — only
               THIS def would write DE; the other defs/uses go through
               the slot paths, which a PR_DE vreg doesn't have. */
            if (de_defs[v] != 1 || de_uses[v] != 1) continue;
            f->vreg_to_phys[v] = IR_PR_DE;
        }
    }
    free(de_defs);
    free(de_uses);

    /* PR_BC pool (narrow no-call case).

       Function-wide envelope: BC is preserved across every body emit
       path ONLY when the function has no IR_CALL / IR_HCALL (callee
       conventions vary on BC) and no width-4 vregs (long ops use BC as
       the low-half spill register). In that envelope, BC stays put
       between the prologue load and the function exit.

       Candidate: one width-2 PARAM with at least 2 use sites in the
       function. PARAMs are loaded once in the prologue immediately
       after PARAM_IN_PLACE copy-in is skipped, then every use site
       reads from BC via `ld l,c; ld h,b` (2 inst) instead of the full
       6-inst slot reload. Break-even is at 2 uses (6 inst init + 2 *
       use_count) vs the unchanged 6 * use_count slot reads.

       First-cut limit: ONE vreg per function. Picking the best
       candidate by use count is the natural next step but adds
       complexity (sort + interference checks); a single-occupant pool
       is fine for the first measurement. */
    int has_long = 0;
    int has_bc_clobber = 0;
    for (int v = 0; v < f->n_vregs && !has_long; v++)
        if (f->vregs[v].width == 4) has_long = 1;
    /* Calls used to exclude PR_BC entirely. Task #319 added save/restore
       around IR_CALL / IR_HCALL in the lowerer, so calls no longer
       disqualify — they just add a push bc/pop bc pair around each
       call site when PR_BC is active. has_long and has_bc_clobber
       still exclude (long ops use BC for low-half staging, and
       IR_ST_MEM IR_MEM_VREG with offset clobbers BC for the
       `ld bc,N; add hl,bc` offset add). */
    for (int i = 0; i < f->n_bbs && !has_bc_clobber; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            /* (Offset stores used to clobber BC via `ld bc,N; add hl,bc` for
               the offset add and disqualified the whole function from BC
               residency. gen_st_mem now emits that add BC-clean, avoid_bc=1
               — inc/dec chain or an A-through add — so an offset store keeps a
               BC-homed base/value alive and is no longer a clobber.) */
            /* A WIDE (double / long long, width>4) LD_MEM/ST_MEM lowers to a
               dload/dstore helper CALL that clobbers BC with no save/restore
               point (unlike IR_CALL/IR_HCALL), so a BC-resident base can't
               survive it. (width==4 long is already covered by has_long.) */
            if (o->kind == IR_LD_MEM || o->kind == IR_ST_MEM) {
                int vw = 0;
                if (o->dst >= 0 && o->dst < f->n_vregs)
                    vw = f->vregs[o->dst].width;
                if (o->src[0] >= 0 && o->src[0] < f->n_vregs
                    && f->vregs[o->src[0]].width > vw)
                    vw = f->vregs[o->src[0]].width;
                if (vw > 4) has_bc_clobber = 1;
            }
            /* l_case / l_long_case walk the table through BC, so a
               PR_BC value can't survive a table-dispatch IR_SWITCH
               (and the helper jumps away — no save/restore point).
               The char route is an inline cp chain: BC-clean. */
            if (o->kind == IR_SWITCH && !(o->sw && o->sw->is_char))
                has_bc_clobber = 1;
            /* Inline asm is opaque — it may clobber BC, and unlike a call
               the lowerer has no save/restore point around it. A PR_BC
               LOCAL has no backing slot, so it couldn't be reloaded after
               the asm anyway (emit_bc_reload would read a bogus offset).
               Disqualify PR_BC for the whole function. */
            if (o->kind == IR_ASM)
                has_bc_clobber = 1;
            /* Wide-accumulator float/long-long ops (IR_ACC_*) call helpers
               (dadd/dmul/l_int2long_s_float/…) that clobber BC, and — unlike
               IR_CALL/IR_HCALL — gen_acc_* emit NO push bc/pop bc around them.
               A PR_BC LOCAL has no backing slot, so emit_bc_reload after the
               clobber would read a bogus below-frame offset. Disqualify. */
            if (o->kind == IR_ACC_BINOP || o->kind == IR_ACC_UNOP
                || o->kind == IR_ACC_CMP)
                has_bc_clobber = 1;
            /* Pre-pushed call args (IR_PUSH_ARG): gen_call can't wrap such
               calls in push/pop bc (the save would land above the arg block),
               so it restores the PR_BC tenant by reloading its backing slot
               via emit_bc_reload. That works for a PARAM (caller slot) but
               NOT a slotless write-once LOCAL — handled by the per-candidate
               `is_param || !has_prepushed_call` guard below, not here. */
        }
    }
    /* A pre-pushed-arg call restores the PR_BC tenant via emit_bc_reload
       (slot read), which a slotless LOCAL candidate can't satisfy. */
    int has_prepushed_call = 0;
    for (int i = 0; i < f->n_bbs && !has_prepushed_call; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++)
            if (f->bbs[i].ops[j].kind == IR_CALL && f->bbs[i].ops[j].call
                && f->bbs[i].ops[j].call->pre_pushed > 0) {
                has_prepushed_call = 1;
                break;
            }
    if (!has_long && !has_bc_clobber) {
        /* Per-vreg write count: any op with dst == v writes the vreg.
           Lowerer's PR_BC short-circuit only handles reads (load_to_hl
           / load_to_de copy from BC); it doesn't update BC on writes.
           So a candidate must be write-free in the function body. PARAM
           vregs that survive without modification (the common "use param
           multiple times" case) qualify; one that gets `data++` style
           updates (post-inc / compound-assign) doesn't. */
        int *write_count = calloc((size_t)f->n_vregs, sizeof(int));
        int *use_count   = calloc((size_t)f->n_vregs, sizeof(int));
        /* cost_benefit[v]: the ORCHESTRATOR's residency benefit (T-state model),
           distinct from the flat use_count the Phase-0 pickers keep. Each access
           is classified: a DEREF (v is a mem base — `ld a,(bc)` in a reg vs a
           full pointer reload from a slot) is worth much more than a plain
           value read (reg copy vs slot load), and a write earns the store→stamp
           saving. So a hot deref base out-scores a merely-frequent write-heavy
           IV — the discriminator the flat count missed. Depth-weighted. */
        long *cost_benefit = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                                    sizeof(long));
        /* all_defs_ok[v]: every def is a BC-stamping producer + not POSTSTEP-
           stepped — precondition for the write-many IV proposer. */
        int *all_defs_ok = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                                  sizeof(int));
        /* Use intervals [first_use, last_use] in linear op order —
           when the value actually has to sit in BC. Needed because
           PARAMs are live-from-entry, making ir_live_ranges_overlap
           too conservative for multi-tenant allocation. Write-once
           locals (#318) anchor first_use at the def. */
        int *first_use   = calloc((size_t)f->n_vregs, sizeof(int));
        int *last_use    = calloc((size_t)f->n_vregs, sizeof(int));
        /* def_kind[v] = the OpKind of v's first writing op, or -1 if
           never written. Used by the LOCAL PR_BC eligibility check to
           ensure the producer goes through spill_and_swap_unless_dead
           (only those lowerings know to also write BC for PR_BC dst). */
        int *def_kind    = calloc((size_t)f->n_vregs, sizeof(int));
        /* Loop detection (#317): BB B is "in a loop" if a back-edge
           p→h exists with h.id ≤ B.id ≤ p.id — reliable because the
           builder produces reducible CFGs. One cheap pass. */
        int *bb_in_loop  = calloc((size_t)f->n_bbs, sizeof(int));
        /* bb_loop_lo/hi[b]: [header, tail] bb-id span of the loop
           containing b (b itself if outside any loop). In-loop uses
           extend the PR_BC interval to the whole loop body — else a
           single-static-use vreg in a loop looks like a one-op
           interval and a second tenant later in the same loop would
           pass non-overlap yet clobber BC every iteration (md5
           MDPrint, #349). */
        int *bb_loop_lo  = calloc((size_t)f->n_bbs, sizeof(int));
        int *bb_loop_hi  = calloc((size_t)f->n_bbs, sizeof(int));
        int *bb_first_op = calloc((size_t)f->n_bbs, sizeof(int));
        int *bb_last_op  = calloc((size_t)f->n_bbs, sizeof(int));
        /* Loop-nesting depth per BB: how many back-edge loop bodies contain
           it. Weights hot-use counting so a use in a deeper loop (which runs
           per-inner × per-outer iterations) outranks one in an outer loop —
           picks the innermost accumulator/counter for the scarce register
           pairs. */
        int *bb_loop_depth = calloc((size_t)f->n_bbs, sizeof(int));
        if (!write_count || !use_count || !first_use || !last_use
            || !bb_in_loop || !def_kind || !bb_loop_lo || !bb_loop_hi
            || !bb_first_op || !bb_last_op || !bb_loop_depth
            || !cost_benefit || !all_defs_ok) {
            free(write_count); free(use_count);
            free(first_use); free(last_use);
            free(bb_in_loop); free(def_kind);
            free(bb_loop_lo); free(bb_loop_hi);
            free(bb_first_op); free(bb_last_op);
            free(bb_loop_depth); free(cost_benefit); free(all_defs_ok);
            return;
        }
        for (int v = 0; v < f->n_vregs; v++) {
            first_use[v] = -1;
            last_use[v]  = -1;
            def_kind[v]  = -1;
            all_defs_ok[v] = 1;   /* cleared by any non-stamping def */
        }
        for (int i = 0; i < f->n_bbs; i++) {
            bb_loop_lo[i] = i;
            bb_loop_hi[i] = i;
        }
        /* Loop membership + nesting depth via NATURAL LOOPS, not id-ranges.
           For each back-edge p->h (a successor h with id <= source p), the
           loop body is h plus every BB that reaches p without passing through
           h. The old [h..p] id-range method mis-handled a nested inner loop
           whose BBs are numbered AFTER the outer latch (it looked like a
           sibling, so its body got the wrong depth) — exactly what the
           unreachable-BB prune's renumbering exposes. A backward walk over the
           full op-level predecessor adjacency gets nesting right regardless of
           block numbering. bb_loop_lo/hi keep the [min,max] id span of the
           body (a conservative over-approx of the op-index interval used to
           extend in-loop PR_BC lifetimes — safe if a gap BB creeps in). */
        {
            /* Predecessor adjacency (CSR) from complete op-level successors. */
            int *pred_cnt = calloc((size_t)f->n_bbs + 1, sizeof(int));
            int  scratch[64];
            for (int i = 0; pred_cnt && i < f->n_bbs; i++) {
                int ns = alloc_bb_succ(&f->bbs[i], scratch,
                                       (int)(sizeof scratch / sizeof scratch[0]));
                for (int s = 0; s < ns; s++)
                    if (scratch[s] >= 0 && scratch[s] < f->n_bbs)
                        pred_cnt[scratch[s]]++;
            }
            int *pred_off = calloc((size_t)f->n_bbs + 1, sizeof(int));
            if (pred_cnt && pred_off) {
                for (int i = 0; i < f->n_bbs; i++)
                    pred_off[i + 1] = pred_off[i] + pred_cnt[i];
                int total = pred_off[f->n_bbs];
                int *pred_list = calloc((size_t)(total > 0 ? total : 1), sizeof(int));
                int *fill = calloc((size_t)f->n_bbs, sizeof(int));
                int *inloop = calloc((size_t)f->n_bbs, sizeof(int));
                int *wl = calloc((size_t)f->n_bbs, sizeof(int));
                if (pred_list && fill && inloop && wl) {
                    for (int i = 0; i < f->n_bbs; i++) {
                        int ns = alloc_bb_succ(&f->bbs[i], scratch,
                                    (int)(sizeof scratch / sizeof scratch[0]));
                        for (int s = 0; s < ns; s++) {
                            int t = scratch[s];
                            if (t >= 0 && t < f->n_bbs)
                                pred_list[pred_off[t] + fill[t]++] = i;
                        }
                    }
                    /* One natural loop per back-edge p->h. */
                    for (int p = 0; p < f->n_bbs; p++) {
                        int ns = alloc_bb_succ(&f->bbs[p], scratch,
                                    (int)(sizeof scratch / sizeof scratch[0]));
                        for (int s = 0; s < ns; s++) {
                            int h = scratch[s];
                            if (h < 0 || h >= f->n_bbs || h > p) continue; /* back-edge */
                            memset(inloop, 0, (size_t)f->n_bbs * sizeof(int));
                            int wn = 0;
                            inloop[h] = 1;
                            if (!inloop[p]) { inloop[p] = 1; wl[wn++] = p; }
                            while (wn > 0) {
                                int x = wl[--wn];
                                for (int k = pred_off[x]; k < pred_off[x + 1]; k++) {
                                    int y = pred_list[k];
                                    if (!inloop[y]) { inloop[y] = 1; wl[wn++] = y; }
                                }
                            }
                            for (int b = 0; b < f->n_bbs; b++) {
                                if (!inloop[b]) continue;
                                bb_in_loop[b] = 1;
                                bb_loop_depth[b]++;
                                if (h < bb_loop_lo[b]) bb_loop_lo[b] = h;
                                if (p > bb_loop_hi[b]) bb_loop_hi[b] = p;
                            }
                        }
                    }
                }
                free(pred_list); free(fill); free(inloop); free(wl);
            }
            free(pred_cnt); free(pred_off);
        }
        /* Per-BB global op-index range (bb_last_op inclusive). Empty
           BBs get first == last + 1 — never matches, harmless. */
        {
            int g = 0;
            for (int i = 0; i < f->n_bbs; i++) {
                bb_first_op[i] = g;
                g += f->bbs[i].n_ops;
                bb_last_op[i]  = g - 1;
            }
        }
        /* Weight hot uses by loop-nesting depth (~4× per level): a use in a
           doubly-nested inner loop runs inner×outer iterations, so it must
           outrank an outer-loop use for the scarce DE/BC/idx2 homes — else the
           allocator can leave the hot inner accumulator spilled while a colder
           outer value sits in a register (sieve: count spilled, i_sq in DE).
           depth 0 → 1, depth 1 → 4 (identical to the old flat in-loop×4, so
           functions with no nesting deeper than one loop stay byte-identical);
           depth n → 4^n, capped. IR_NO_DEPTH_WEIGHT restores the flat weight. */
        int depth_flat = getenv("IR_NO_DEPTH_WEIGHT") != NULL;
        int global = 0;
        for (int i = 0; i < f->n_bbs; i++) {
            BB *bb = &f->bbs[i];
            int depth = bb_loop_depth[i];
            if (depth_flat && depth > 1) depth = 1;
            int weight = 1;
            for (int dw = 0; dw < depth && dw < 8; dw++) weight *= 4;
            /* In-loop uses/defs must hold BC across every iteration,
               so their interval is the whole loop body; straight-line
               ops use the per-op `global` index. */
            int loop_first = bb_in_loop[i]
                           ? bb_first_op[bb_loop_lo[i]] : -1;
            int loop_last  = bb_in_loop[i]
                           ? bb_last_op[bb_loop_hi[i]]  : -1;
            for (int j = 0; j < bb->n_ops; j++, global++) {
                int eff_first = bb_in_loop[i] ? loop_first : global;
                int eff_last  = bb_in_loop[i] ? loop_last  : global;
                const Op *op = &bb->ops[j];
                int d = op->dst;
                if (d >= 0 && d < f->n_vregs) {
                    write_count[d]++;
                    /* Anchor the interval at the def (BC ownership
                       starts there) and record the producer kind for
                       the PR_BC LOCAL eligibility check. */
                    if (def_kind[d] < 0) def_kind[d] = (int)op->kind;
                    if (!bc_safe_producer((int)op->kind)) all_defs_ok[d] = 0;
                    /* Cost model: a write earns the store→stamp saving. */
                    cost_benefit[d] += (long)weight * COST_WRITE_W;
                    if (first_use[d] < 0 || eff_first < first_use[d])
                        first_use[d] = eff_first;
                    if (eff_last > last_use[d]) last_use[d] = eff_last;
                }
                /* IR_POSTSTEP writes its stepped var via src[0], not dst
                   (dst holds the old value). Count that write — else a
                   post-inc/dec'd param/local looks write-free and lands
                   in PR_BC, where the in-place slot step doesn't update
                   BC and later reads see the stale register (while(k--)
                   read 4 every iteration). */
                if (op->kind == IR_POSTSTEP) {
                    int sv = op->src[0];
                    if (sv >= 0 && sv < f->n_vregs) {
                        write_count[sv]++;
                        all_defs_ok[sv] = 0;   /* in-place step: BC not stamped */
                    }
                }
                int mem_base = ((op->kind == IR_LD_MEM || op->kind == IR_ST_MEM)
                                && op->mem.kind == IR_MEM_VREG)
                             ? op->mem.base : -1;
                int u[16];
                int nu = ir_op_uses(op, u, (int)(sizeof u / sizeof u[0]));
                for (int k = 0; k < nu; k++) {
                    int v = u[k];
                    if (v < 0 || v >= f->n_vregs) continue;
                    use_count[v] += weight;
                    /* Cost model: a DEREF (v is this op's mem base) is worth far
                       more than a plain value read — a base in BC deref's for
                       free (`ld a,(bc)`) whereas from a slot it needs a full
                       pointer reload first. */
                    cost_benefit[v] += (long)weight *
                        (v == mem_base ? COST_DEREF_W : COST_READ_W);
                    if (first_use[v] < 0 || eff_first < first_use[v])
                        first_use[v] = eff_first;
                    if (eff_last > last_use[v]) last_use[v] = eff_last;
                }
            }
        }
        /* Eligibility pass: collect candidates into an array, sort by
           use count descending (heuristic — most-used first), then
           greedy-allocate to BC checking non-overlap against already-
           allocated PR_BC vregs.

           Two candidate classes:
             - PARAM_IN_PLACE vregs that are never written (`write_count==0`):
               prologue load (for the earliest first_use) or demand
               reload from caller's slot.
             - Write-once LOCALs (#318): `write_count==1`, and the
               single producer op's kind goes through
               spill_and_swap_unless_dead (the producer pattern that
               can be hooked to also write BC). Catches the common
               "compute X once, read X many times" shape in loop
               headers (e.g. crc16_ccitt's `end = data + len`). */
        /* A non-param vreg live at function entry is read before any def
           (uninitialised — UB in the source). It has no reaching def to load
           into a register, so promoting it to a slotless register home makes
           the lowerer read a nonexistent source and abort. Keep it spilled.
           (The word DE-home pick already guards this via wd_def>=wd_read.) */
        const BitSet *entry_live =
            (f->n_bbs > 0 && f->bbs[0].n_ops > 0)
            ? ir_op_live_in(&f->bbs[0], 0) : NULL;
        /* Register-residency ORCHESTRATOR (default ON as of Phase 2; validated
           no-regression across the CPU matrix — sieve -16.5%fp/-4.9%sp/-7.5%r2ka,
           else neutral). Collects ALL proposers into one pool and assigns via the
           single cost-model-ranked cross-class arbiter. IR_NO_ORCHESTRATOR falls
           back to the per-class proposer/arbiter pairs run in sequence. */
        int orch = getenv("IR_NO_ORCHESTRATOR") == NULL;
        if (orch) {
            Cand *pool = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1) * 6,
                                sizeof(Cand));
            if (pool) {
                int np = 0;
                np += pr_bc_propose(f, use_count, write_count, def_kind,
                                    has_prepushed_call, entry_live,
                                    first_use, last_use, pool + np);
                /* exx co-design FIRST: an invariant claimed for the alt bank
                   displaces idx2 from IX, freeing it for a writable loop var.
                   Must precede idx2_propose so the arbiter (stable on ties)
                   grabs the invariant for the alt bank before idx2 takes IX. */
                np += exx_propose(f, use_count, write_count, bb_in_loop,
                                  first_use, last_use, pool + np);
                np += idx2_propose(f, use_count, write_count,
                                   first_use, last_use, pool + np);
                if (c_byte_resident && !getenv("IR_NO_BYTE_RESIDENT"))
                    np += byte_home_propose(f, use_count, write_count,
                                            first_use, last_use, pool + np);
                if (c_word_resident && !getenv("IR_NO_WORD_RESIDENT"))
                    np += word_acc_propose(f, use_count, write_count, bb_in_loop,
                                           first_use, last_use, pool + np);
                /* DE-home co-design: a general loop-carried width-2 vreg (opt-in
                   IR_DE_HOME). Same RC_DE_ACC class → the arbiter's DE reservation
                   + prepick revert apply; tagged CF_DE_GENERAL so the lowerer uses
                   the general home-def path, not try_word_accumulate. */
                np += de_home_general_propose(f, use_count, write_count, bb_in_loop,
                                              first_use, last_use, pool + np);
                /* idx3: a second loop-carried word homed in IY (sp-mode, opt-in).
                   Dedicated index register → no region proof, assigned directly. */
                np += idx3_propose(f, use_count, write_count, bb_in_loop,
                                   first_use, last_use, pool + np);
                /* Phase 2: hot loop-carried int IVs. IR_NO_IV_RESIDENT opts out. */
                if (!getenv("IR_NO_IV_RESIDENT"))
                    np += iv_propose(f, use_count, write_count, all_defs_ok,
                                     has_prepushed_call, entry_live,
                                     first_use, last_use, pool + np);
                /* Phase 2-cost: rank by the T-state cost model, not flat
                   use_count (the Phase-0 pickers, else-branch, keep use_count so
                   the default build stays byte-identical). */
                for (int i = 0; i < np; i++)
                    pool[i].benefit = cost_benefit[pool[i].vreg];
                unified_arbitrate(f, pool, np);
                free(pool);
            }
        } else {
            /* PR_BC allocation via the Phase-0 proposer/arbiter. */
            Cand *cand = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                                sizeof(Cand));
            if (cand) {
                int n = pr_bc_propose(f, use_count, write_count, def_kind,
                                      has_prepushed_call, entry_live,
                                      first_use, last_use, cand);
                arbitrate_to_bc(f, cand, n, first_use, last_use);
                free(cand);
            }
        }
        /* idx2 spare-index-register allocation via the Phase-0 proposer/
           arbiter (skipped when the Phase-1 unified arbiter ran above). */
        if (!orch) {
            Cand *icand = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                                 sizeof(Cand));
            if (icand) {
                int in = idx2_propose(f, use_count, write_count,
                                      first_use, last_use, icand);
                arbitrate_idx2(f, icand, in);
                free(icand);
            }
        }
        /* Byte-register residency (Plan B, Phase 1 — C-home only).
           Keep a hot loop-carried width-1 accumulator in C instead of a
           frame slot. C is the low half of BC; in this block's envelope
           (!has_long && !has_bc_clobber) BC is preserved-by-construction,
           so a byte in C is rock-solid for the whole function — TRUE
           residency: the value rides C for the whole function with NO slot
           store (the lowerer's store_a_byte emits `ld c,a` and returns;
           every byte read funnels through load_byte_to_a, home-aware).
           Three gates make this audit-free + correct: NO calls (sidesteps
           the PR_BC call save/restore, keyed on a word PR_BC tenant); BC
           FREE (no word vreg took IR_PR_BC); and DEF-BEFORE-USE — the
           value's first def must strictly precede its first read (else a
           read would consult an unestablished home). Unlike PR_BC this
           admits a WRITE-MANY vreg (the accumulator is the point). One
           occupant. */
        if (!orch && c_byte_resident && !getenv("IR_NO_BYTE_RESIDENT")) {
            /* Byte-home (C/E) residency via the Phase-0 proposer/arbiter
               (skipped when the Phase-1 unified arbiter ran above). */
            Cand *bcand = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                                 sizeof(Cand));
            if (bcand) {
                int bn = byte_home_propose(f, use_count, write_count,
                                           first_use, last_use, bcand);
                arbitrate_byte_home(f, bcand, bn);
                free(bcand);
            }
        }
        /* Word (int) accumulator residency (DE-home) — word analog of the
           byte E-home above, INDEPENDENT of c_byte_resident. Keep a hot
           loop-carried width-2 accumulator in the DE pair across its loop
           instead of a frame slot; the lowerer accumulates via `add hl,de;
           ex de,hl` (addend through HL) so DE stays live with no per-iter
           slot store. Same gates as the byte E-home: NO calls (DE survives
           by construction), def-DOMINATES-use (home established first), hot +
           write-many (a real loop accumulator). The home OWNS DE: any other
           PR_DE tenant (e.g. a single-use addend the transient pass parked in
           DE) is demoted to SPILL so its def can't clobber the home — it
           reloads through HL at the accumulate. Skipped when a byte E/D-home
           already claimed DE's low half. One occupant. */
        if (!orch && c_word_resident && !getenv("IR_NO_WORD_RESIDENT")) {
            /* Word DE-home accumulator via the Phase-0 proposer/arbiter
               (skipped when the Phase-1 unified arbiter ran above). */
            Cand *wcand = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                                 sizeof(Cand));
            if (wcand) {
                int wn = word_acc_propose(f, use_count, write_count, bb_in_loop,
                                          first_use, last_use, wcand);
                arbitrate_word_acc(f, wcand, wn);
                free(wcand);
            }
        }
        /* Live-range packing of call-free word temps into BC (default on,
           IR_NO_BC_PACK opts out) — a second pass over the SPILL losers using
           tight per-op intervals. Runs after every register class is placed so
           it only claims BC where no loop home owns it. */
        ir_bc_pack(f, first_use, last_use, bb_first_op, def_kind,
                   write_count, use_count);
        /* LRA Phase 2c (IR_LRA): home a DE-dirty reduction chain in IY (add iy,de),
           taking the spill losers BC couldn't. Byte-identical off. */
        ir_iy_reduction_pack(f, bb_in_loop, use_count);
        /* Stack-transient spill (default on, IR_NO_STACK_SPILL opts out): the register-pressure
           fallback below BC-pack — a single-def/single-use word transient with
           no register free goes on the stack (push/pop) instead of a slot. */
        ir_stack_spill(f, bb_first_op, def_kind, write_count);
        free(write_count);
        free(use_count);
        free(first_use);
        free(last_use);
        free(bb_in_loop);
        free(def_kind);
        free(bb_loop_lo);
        free(bb_loop_hi);
        free(bb_first_op);
        free(bb_last_op);
        free(bb_loop_depth);
        free(cost_benefit);
        free(all_defs_ok);
    }

    /* PR_DEHL pool: long (width=4) vregs whose slot write is dead —
       same eligibility shape as PR_HL but for the DEHL register pair.
       Eliminates the 4-byte frame slot entirely (PR_HL only skips the
       write; PR_DEHL prevents allocation). The lowerer's
       commutative-swap pass normalises ADD's src[0]↔src[1] at lowering
       time so the PR_DEHL vreg always lands in the first-loaded source
       position for whichever consumer op it feeds. */
    {
        int *dehl_ok = calloc((size_t)f->n_vregs, sizeof(int));
        if (!dehl_ok) return;
        for (int v = 0; v < f->n_vregs; v++) dehl_ok[v] = 1;

        for (int v = 0; v < f->n_vregs; v++) {
            const VReg *vr = &f->vregs[v];
            if ((vr->flags & IR_VREG_PARAM)
                || (vr->flags & IR_VREG_ADDR_TAKEN))
                dehl_ok[v] = 0;
        }
        for (int i = 0; i < f->n_bbs; i++) {
            BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++) {
                const Op *op = &bb->ops[j];
                if (op->kind == IR_CALL && op->call
                    && op->call->ret_vreg >= 0)
                    dehl_ok[op->call->ret_vreg] = 0;
                if (op->kind == IR_HCALL && op->hcall
                    && op->hcall->ret_vreg >= 0)
                    dehl_ok[op->hcall->ret_vreg] = 0;
                if (op->dst < 0) continue;
                int eligible;
                switch (op->kind) {
                case IR_LD_IMM: case IR_LD_SYM: case IR_LD_MEM:
                case IR_MOV:
                case IR_ADD: case IR_SUB: case IR_RSUB:
                case IR_AND: case IR_OR: case IR_XOR:
                case IR_SHL: case IR_SHR:
                case IR_NEG: case IR_NOT:
                case IR_CONV_ZX: case IR_CONV_SX:
                    eligible = 1; break;
                default:
                    eligible = 0; break;
                }
                if (f->vregs[op->dst].width != 4 || !eligible
                    || !op_dst_spill_is_dead(bb, j))
                    dehl_ok[op->dst] = 0;
            }
        }
        for (int v = 0; v < f->n_vregs; v++) {
            if (dehl_ok[v] && f->vreg_to_phys[v] == IR_PR_SPILL)
                f->vreg_to_phys[v] = IR_PR_DEHL;
        }
        free(dehl_ok);
    }

    alloc_probe(f);
}
