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
/* When set the platform reserves IY — no IY residency (LRA-IY, idx2/idx3). */
extern int c_reserve_iy;

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
    CF_DE_OPERAND     = 1u << 6,   /* DE-fold hint: reused deref/binop (DENSITY §4) */
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

/* Append a proposal to the arbiter pool. The single point where a candidate enters
   the pool (every proposer used the same 6-field fill). benefit is a placeholder —
   unified_arbitrate overwrites it with cost_benefit[v] before ranking. */
static inline void add_cand(Cand *out, int *n, int v, long benefit,
                            int lo, int hi, unsigned allowed, unsigned flags)
{
    out[*n].vreg = v;
    out[*n].benefit = benefit;
    out[*n].lo = lo;
    out[*n].hi = hi;
    out[*n].allowed = allowed;
    out[*n].flags = flags;
    (*n)++;
}

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

/* True iff the function contains no call/helper-call/inline-asm op. Several
   residency proposers require this: a whole-function register home across a
   call would need caller-save/restore they don't emit, so they bail when it
   returns false. (Shared gate — was open-coded in each proposer.) */
static int func_is_call_free(const Func *f)
{
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            OpKind k = f->bbs[i].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return 0;
        }
    return 1;
}

static int func_idx2_self_use(const Func *f)
{
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            const Op *o = &f->bbs[i].ops[j];
            if (o->kind == IR_LD_FAR || o->kind == IR_ST_FAR
                || o->kind == IR_LD_FARSYM) return 1;
            if (o->kind == IR_CALL && o->call
                && (o->call->fnptr_vreg >= 0 || o->call->far_fnptr)) return 1;
        }
    return 0;
}

/* 5b HOOK — which callee-saved registers do THIS function's calls clobber?
   IX/IY are callee-saved: every 80cc-compiled function preserves them, so a value
   kept in IX/IY survives a call with no spill/reload (unlike BC/DE, caller-clobbered).
   The allocator asks per home: an IY word-home is safe across calls iff IY isn't in
   this set; likewise IX for the fp frame pointer. Returns the UNION of callee-saved
   registers clobbered by any callee f reaches.
   Returns the empty set: the maintainer's ABI decision is that the callable library
   is IX/IY-safe. Audit behind it: far mem and str routines now save both; qsort/bsearch
   use IX not IY; ADT-callback routines (adt_Heap*, adt_ListSearch) clobber IY but are
   niche/accepted; setjmp/longjmp RESTORE IY (context switch, not a clobber). The one
   broad IY-clobberer is the FLOAT library — handled OUT of band at link/config level
   (the IY word-home optimisation is switched off when a float library is linked; a
   link-time fact is more reliable than per-function float detection). This function is
   the extension point if a per-callee clobber signal is ever wanted (OR in CLOB_IX/
   CLOB_IY for a blacklisted callee, name visible at the IR_CALL). This is what 5b gates
   IY word-homes on instead of the blunt `func_is_call_free`. */
enum { CLOB_IX = 1u << 0, CLOB_IY = 1u << 1 };
static unsigned func_call_clobbers(const Func *f)
{
    (void)f;
    return 0;
}

/* B4 — BC-home realizability (extracted from pr_bc_propose's per-vreg gate).
   TRUE iff value v can be correctly kept in the BC pair over its whole live
   range with coherent slot backing: width-2, not addr-taken/volatile, not
   already homed, read >=2×, and — per role — a read-free PARAM (or a gated
   stepped-pointer param), an IVSR write-twice induction pointer, or a
   write-once LOCAL with a BC-stamping producer. This is the single per-value
   predicate `home_realizable(...,RC_BC,...)` dispatches to; pr_bc_propose is
   now just the loop that calls it and emits a candidate. Extracting it (rather
   than leaving the gate inline) lets increment 3's colouring GENERATE the BC
   candidate directly and retire the proposer wrapper. */
static int bc_home_realizable(const Func *f, int v,
                              const int *use_count, const int *write_count,
                              const int *def_kind, int has_prepushed_call,
                              const BitSet *entry_live)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (vr->flags & IR_VREG_ADDR_TAKEN) return 0;
    if (vr->flags & IR_VREG_VOLATILE) return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (use_count[v] < 2) return 0;
    /* §3a″ (opt-in IR_BC_STEP_PARAM): a stepped-pointer PARAM may ride BC only
       in a call-free function (a call evicts BC → emit_bc_reload restores from
       the STALE caller slot once the pointer stepped). Phase-1 `inc bc` keeps
       BC coherent on the step. Kept opt-in until proven (checksum self-checks). */
    int allow_step_param = getenv("IR_BC_STEP_PARAM") != NULL;
    int fn_has_call = allow_step_param && !func_is_call_free(f);
    int is_param  = (vr->flags & IR_VREG_PARAM) != 0;
    int is_induct = (vr->flags & IR_VREG_INDUCTION) != 0;
    if (!is_param && has_prepushed_call) return 0;
    if (!is_param && entry_live && ir_bitset_get(entry_live, v)) return 0;
    if (is_param) {
        if (write_count[v] > 0) {
            /* Stepped pointer param (walking char ptr): single in-place
               INC/DEC step, call-free, gated. Any other written param is
               rejected (BC would go stale). */
            int step_ok = allow_step_param && !fn_has_call
                && write_count[v] == 1
                && (def_kind[v] == IR_INC || def_kind[v] == IR_DEC)
                && (vr->kind == KIND_PTR || vr->kind == KIND_CPTR);
            if (!step_ok) return 0;
        }
    } else if (is_induct) {
        if (write_count[v] != 2) return 0;   /* init + step */
    } else {
        if (write_count[v] != 1) return 0;
        switch (def_kind[v]) {
        case IR_LD_IMM: case IR_LD_SYM: case IR_LD_MEM:
        case IR_MOV:
        case IR_ADD: case IR_SUB: case IR_RSUB:
        case IR_AND: case IR_OR: case IR_XOR:
        case IR_SHL: case IR_SHR:
        case IR_INC: case IR_DEC:
        case IR_NEG: case IR_NOT:
        case IR_CONV_ZX: case IR_CONV_SX:
        case IR_CONV_BYTE_TO_HIGH:
            break;
        default:
            return 0;
        }
    }
    return 1;
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

/* idx2 map builder (factored from idx2_propose so home_realizable can rebuild
   it independently). is_base = LD_MEM/ST_MEM MEM_VREG base + POSTSTEP src[0] +
   COPY_STEP_BRZ pointers (a deref'd/stepped pointer, never an idx2 counter/
   bound); cstep/cinit/cother = per-vreg def-shape counts. Buffers sized
   f->n_vregs, caller-zeroed. */
static void build_idx2_maps(const Func *f, int *is_base, int *cstep,
                            int *cinit, int *cother)
{
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
}

/* B4 — idx2-home realizability (extracted from idx2_propose's per-vreg gate).
   Returns the candidate FLAG (CF_IDX2_COUNTER / CF_IDX2_PARAM), or 0 if v
   cannot ride the spare index register. Unlike the width-classes this is a
   per-vreg gate over PRECOMPUTED function maps (is_base = deref/step-base map;
   cstep/cinit/cother = per-vreg def-shape counts) — the caller (proposer now,
   colouring in increment 3) supplies them along with the func-level envelope
   (idx2_reg present, acc-free, call-free), which stays in the proposer since
   it also guards building the maps. home_realizable(...,RC_IDX2,...) := this
   != 0. */
static unsigned idx2_home_realizable(const Func *f, int v,
                                     const int *use_count, const int *write_count,
                                     const int *is_base, const int *cstep,
                                     const int *cinit, const int *cother)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (is_base[v]) return 0;
    if (use_count[v] < 4) return 0;
    /* Stepping counter: only-init(<=1) + steps write it. On z80/z80n/z180 skip
       the idx2 home when the counter feeds address/ALU work that would push iy;
       pop hl every iteration (idx2_counter_hostile_use). */
    if (!opt_disabled("idx2-counter") && cstep[v] >= 1 && cother[v] == 0
        && cinit[v] <= 1 && idx2_counter_hostile_use(f, v) == 0)
        return CF_IDX2_COUNTER;
    /* Read-only invariant param. */
    if ((vr->flags & IR_VREG_PARAM) && write_count[v] == 0)
        return CF_IDX2_PARAM;
    return 0;
}


/* First def and first read of vreg v in GLOBAL op-index (BB-id order), INT_MAX
   if none. Def = v is an op's dst, or IR_POSTSTEP's src[0] (the in-place stepped
   var). Read = v appears in ir_op_uses. The shared re-expression of the
   wd_def/wd_read and first_def/first_read scans the residency proposers used to
   roll individually (RESIDENCY_STEP1A_AUDIT.md, step 1b/1c). Callers derive
   "def-first" = (first_def < first_read) and "def-in-entry-BB" via bb0.n_ops.
   NB deliberately mirrors those scans (raw dst + POSTSTEP src[0]) rather than
   ir_op_defs, whose LD_MEM/ST_MEM-post-step and COPY_STEP_BRZ def semantics the
   predicate scans intentionally ignore — those vregs are deref bases, excluded by
   the wd_base gate before the def-first check runs, so the difference is
   unobservable and this stays byte-identical. */
typedef struct { int first_def, first_read; } DefUseIdx;

static DefUseIdx vreg_def_first(const Func *f, int v)
{
    DefUseIdx r = { INT_MAX, INT_MAX };
    int g = 0;
    for (int i = 0; i < f->n_bbs; i++) {
        const BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++, g++) {
            const Op *o = &bb->ops[j];
            if ((o->dst == v || (o->kind == IR_POSTSTEP && o->src[0] == v))
                && g < r.first_def)
                r.first_def = g;
            int u[16];
            int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
            for (int k = 0; k < nu; k++)
                if (u[k] == v && g < r.first_read) { r.first_read = g; break; }
        }
    }
    return r;
}

/* The single BB id every ref of v lives in (ref = dst, IR_POSTSTEP src[0], or a
   member of ir_op_uses — the same union vreg_def_first walks), or -1 if v spans
   more than one BB (or is unreferenced). The shared re-expression of byte_home's
   only_bb scan (and the single-BB half of compute_spill_shapes.local, step 1d).
   Callers test "single-BB confined" = (vreg_single_bb(f,v) >= 0). */
static int vreg_single_bb(const Func *f, int v)
{
    int bb = -1, seen = 0;
    for (int i = 0; i < f->n_bbs; i++) {
        const BB *b = &f->bbs[i];
        for (int j = 0; j < b->n_ops; j++) {
            const Op *o = &b->ops[j];
            int ref = (o->dst == v)
                   || (o->kind == IR_POSTSTEP && o->src[0] == v);
            if (!ref) {
                int u[16];
                int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
                for (int k = 0; k < nu; k++) if (u[k] == v) { ref = 1; break; }
            }
            if (!ref) continue;
            if (!seen) { bb = i; seen = 1; }
            else if (bb != i) return -1;   /* spans >1 BB */
        }
    }
    return seen ? bb : -1;
}

/* Word DE-home accumulator proposer: a hot loop-carried width-2 REDUCTION
   accumulator (`v = v OP w`, w a vreg, inside a loop) with a def that dominates
   its reads. Gated NO-calls (DE survives by construction) and DE's low half not
   already a byte E/D home. Fills out[] (sized f->n_vregs), returns the count.
   Byte-identical to the former inline picker; the OWNS-DE side effects live in
   the arbiter. */
/* Shared per-vreg property scan for the loop-word proposers (de_propose /
   idx3_propose / exx_propose), which all recomputed it. Fills each NON-NULL set:
   - wd_base  : v is a deref base (MEM_VREG base, POSTSTEP/COPY_STEP-BRZ pointer).
   - wd_acc   : v is a reduction accumulator (`v = v OP w`, ADD/SUB/…, in a loop).
   - wd_ldef  : v is loop-defined — any in-loop dst, plus in-place-stepped pointers
                (post_step mem base, POSTSTEP src, COPY_STEP pointers). The stepped-
                pointer marks all land on wd_base vregs, which every consumer rejects
                before testing wd_ldef, so this richest wd_ldef is byte-identical to
                each former (narrower) local version.
   - wd_lread : v is read inside a loop (exx invariant test). */
static void scan_wd_props(const Func *f, const int *bb_in_loop,
                          int *wd_base, int *wd_acc, int *wd_ldef, int *wd_lread)
{
    for (int i = 0; i < f->n_bbs; i++) {
        const BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if (wd_lread && bb_in_loop[i]) {
                int u[16]; int nu = ir_op_uses(o, u, (int)(sizeof u/sizeof u[0]));
                for (int k = 0; k < nu; k++)
                    if (u[k] >= 0 && u[k] < f->n_vregs) wd_lread[u[k]] = 1;
            }
            if (wd_ldef && o->dst >= 0 && o->dst < f->n_vregs && bb_in_loop[i])
                wd_ldef[o->dst] = 1;
            if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                && o->mem.kind == IR_MEM_VREG
                && o->mem.base >= 0 && o->mem.base < f->n_vregs) {
                if (wd_base) wd_base[o->mem.base] = 1;
                if (wd_ldef && o->mem.post_step != 0 && bb_in_loop[i])
                    wd_ldef[o->mem.base] = 1;
            }
            if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                && o->src[0] < f->n_vregs) {
                if (wd_base) wd_base[o->src[0]] = 1;
                if (wd_ldef && bb_in_loop[i]) wd_ldef[o->src[0]] = 1;
            }
            if (o->kind == IR_COPY_STEP_BRZ)
                for (int q = 0; q < 2; q++) {
                    int p = o->src[q];
                    if (p >= 0 && p < f->n_vregs) {
                        if (wd_base) wd_base[p] = 1;
                        if (wd_ldef && bb_in_loop[i]) wd_ldef[p] = 1;
                    }
                }
            switch (o->kind) {
            case IR_ADD: case IR_SUB: case IR_RSUB:
            case IR_AND: case IR_OR:  case IR_XOR:
                if (wd_acc && o->dst >= 0 && o->dst < f->n_vregs
                    && o->src[1] >= 0 && bb_in_loop[i]
                    && (o->src[0] == o->dst || o->src[1] == o->dst))
                    wd_acc[o->dst] = 1;
                break;
            default: break;
            }
        }
    }
}
/* B4 — DE-home realizability, one predicate per sub-shape (extracted from
   de_propose's three per-vreg gates). All three are SPECULATIVE: the lowerer
   proves the DE-clean region with compute_home_region / op_de_clean and reverts
   to a slot if none forms — so these gates are plain per-vreg predicates over
   the shared wd_* maps; the region proof lives at lowering, not here. The
   func-level enable (call-free, DE low half not a byte E/D home, and the
   per-shape opt flags word-resident/de-home/loop-ra) stays in the proposer.
   home_realizable(...,RC_DE_ACC,...) := any of the three (with its opt-gate). */
static int de_acc_realizable(const Func *f, int v,
                             const int *use_count, const int *write_count,
                             const int *wd_base, const int *wd_acc)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM))
        return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (wd_base[v]) return 0;
    if (!wd_acc[v]) return 0;                        /* IS a reduction accumulator */
    if (use_count[v] < 4) return 0;
    if (write_count[v] < 2) return 0;
    DefUseIdx du = vreg_def_first(f, v);
    if (du.first_def >= f->bbs[0].n_ops) return 0;   /* def in entry bb0 */
    if (du.first_def >= du.first_read) return 0;     /* def-first */
    return 1;
}
static int de_general_realizable(const Func *f, int v,
                                 const int *use_count, const int *write_count,
                                 const int *wd_base, const int *wd_acc,
                                 const int *wd_ldef)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM))
        return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (wd_base[v]) return 0;                         /* not a deref base */
    if (wd_acc[v]) return 0;                          /* accumulators → (1) */
    if (!wd_ldef[v]) return 0;                        /* must be loop-carried */
    if (use_count[v] < 4) return 0;
    if (write_count[v] < 2) return 0;
    DefUseIdx du = vreg_def_first(f, v);
    if (du.first_def >= f->bbs[0].n_ops) return 0;    /* init def in entry bb0 */
    if (du.first_def >= du.first_read) return 0;      /* def-first */
    return 1;
}
/* Walking BYTE pointer stepped in a loop (strcmp/strcpy/memcpy 2nd pointer):
   REQUIRES a deref base, ALLOWS a param (rehomed from the caller slot at region
   entry, spilled at exit), needs only one step (wd_ldef proves it stepped —
   write_count misses post_step base redefs, so don't gate on it). Local-init
   pointers are excluded (own slot unwritten → rehome reads garbage; served by
   the induction BC picker). */
static int de_ptr_realizable(const Func *f, int v, const int *use_count,
                             const int *wd_base, const int *wd_ldef)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (!(vr->kind == KIND_PTR || vr->kind == KIND_CPTR)) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (!(vr->flags & IR_VREG_PARAM)) return 0;       /* PARAM only (first cut) */
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (!wd_base[v]) return 0;                        /* MUST be a deref base */
    if (!wd_ldef[v]) return 0;                        /* stepped inside the loop */
    if (use_count[v] < 1) return 0;
    return 1;
}
/* OPRES operand-residency (opt-in IR_OPRES) — a reused deref/binop RESULT value.
   sdcc keeps these in DE so a later compare folds to `sbc hl,de` and the value
   survives the HL-clobber without a push-spill; 80cc funnels them through HL →
   `push hl` + byte-wise compare (OPERAND_RESIDENCY_SPEC.md §1). Eligible for a
   GENERAL DE-home (CF_DE_GENERAL: speculative
   — the lowerer reverts it to a spill if no DE-clean region forms, so a
   mis-proposal is byte-safe). Single-def (write_count<=1, distinguishes it from
   the loop-carried de_general/de_acc shapes), reused (use_count>=2), width-2,
   not addr-taken/volatile/param, not a deref base (bases want pointer-like
   homes), def is a deref (IR_LD_MEM) or an ALU binop. DE-freeness across the
   range is the ARBITER's interference call (it competes for the one general
   DE-home against the loop-carried words), NOT a proposer gate. */
static int opres_on(void) { static int c = -1; if (c < 0) c = getenv("IR_OPRES") != NULL; return c; }
/* IR_RANGED gate: the fail-safe DE-cache fold brick (DENSITY_HANDOVER §4). A
   reused deref/binop that stays IR_PR_SPILL leaves a DE cache at its def so a
   later in-range read prefers DE instead of re-materialising in HL + spilling.
   Distinct from opres_on() (the reverting real-DE-home experiment). */
static int ranged_on(void) { static int c = -1; if (c < 0) c = getenv("IR_RANGED") != NULL; return c; }
/* Call-bounded live-range splitting: DEFAULT-ON after the full byte+ticks
   matrix (all 9 CPUs x candidate benches x sp/fp: 0 regressed cells, -1500B;
   z80/gbz80/8085 ticks all faster-or-neutral). Opt out with IR_CALLSPLIT=0
   (byte-identical to pre-flip). The dear-slot CPU gate (deref_gap>=15) inside
   the selection keeps cheap-slot CPUs byte-identical regardless. */
static int callsplit_on(void) { static int c = -1; if (c < 0) { const char *e = getenv("IR_CALLSPLIT"); c = !(e && e[0] == '0'); } return c; }
static int de_operand_realizable(const Func *f, int v,
                                 const int *use_count, const int *write_count,
                                 const int *def_kind, const int *wd_base)
{
    if (!opres_on() && !ranged_on()) return 0;
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM))
        return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (wd_base[v]) return 0;                          /* not a deref base */
    if (write_count[v] > 1) return 0;                  /* single def */
    if (use_count[v] < 2) return 0;                    /* reused */
    int dk = def_kind[v];
    int is_deref = (dk == IR_LD_MEM);
    int is_binop = (dk == IR_ADD || dk == IR_SUB || dk == IR_AND
                    || dk == IR_OR || dk == IR_XOR);
    return is_deref || is_binop;
}
/* True when a DE cache for v can PAY (DENSITY §4). The def leaves v in HL and a
   use BEFORE any HL clobber reads HL directly — so the DE copy is dead overhead
   UNLESS a use follows an HL-clobbering op in the same BB (then that read would
   otherwise reload the slot; the DE fallback replaces it). Measured (2026-07-28):
   firing unconditionally is a net +36B corpus regression — the common case has
   no in-BB HL gap, so this gate is what makes the brick net-positive. Cross-BB
   reuse (safe()'s ri) resets the DE cache at the BB boundary → NOT captured here
   (that is §5, the ranged DE home). */
static int de_fold_pays(const Func *f, int v)
{
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        int seen_def = 0, hl_clob = 0;
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if (!seen_def) { if (o->dst == v) seen_def = 1; continue; }
            /* A use after an in-BB HL clobber would otherwise reload the slot;
               the DE cache serves it instead. NOTE: we deliberately do NOT also
               require DE to be clean def→use. That condition depends on the
               lowerer's precise DE belief, and op_clobbers (a conservative
               superset) over-reports DE clobbers — gating on it zeroes every win.
               Consequence: a rare false positive (an `ex de,hl` store that
               already stages v to DE) survives. Net still a win; the accurate
               fix lives in the lowerer, not here. */
            if (hl_clob) {
                int u[16]; int nu = ir_op_uses(o, u, 16);
                for (int q = 0; q < nu; q++) if (u[q] == v) return 1;
            }
            if (op_clobbers(f, o) & IR_R_HL) hl_clob = 1;
        }
    }
    return 0;
}


/* idx3 array-index (hostility) closure, factored from idx3_propose so
   home_realizable can rebuild it. wd_addr[v]=1 iff v is an ARRAY INDEX: v (or
   v<<k) is a DIRECT operand of an ADD/SUB whose dst is a deref base. TWO levels
   only — NOT a transitive closure through plain ALU (`mid=lo+hi` makes MID the
   index, but lo/hi stay eligible). wd_addr sized f->n_vregs,
   caller-zeroed; wd_base already filled by scan_wd_props. */
static void build_idx3_addr(const Func *f, const int *wd_base, int *wd_addr)
{
    size_t nv = f->n_vregs > 0 ? (size_t)f->n_vregs : 0;
    /* Step 1: into_base[x] — x is directly added to a deref base (reuse wd_addr
       as the intermediate set). */
    int *into_base = wd_addr;
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            const Op *o = &f->bbs[i].ops[j];
            if (o->kind != IR_ADD && o->kind != IR_SUB) continue;
            if (o->dst < 0 || o->dst >= f->n_vregs || !wd_base[o->dst]) continue;
            for (int s = 0; s < 2; s++)
                if (o->src[s] >= 0 && o->src[s] < f->n_vregs)
                    into_base[o->src[s]] = 1;
        }
    /* Step 2: v is also hostile if it feeds a SHL/SHR (index scaling) whose
       result is into_base. Compute disjointly, then union. */
    int *scaled = calloc(nv, sizeof(int));
    if (scaled) {
        for (int i = 0; i < f->n_bbs; i++)
            for (int j = 0; j < f->bbs[i].n_ops; j++) {
                const Op *o = &f->bbs[i].ops[j];
                if (o->kind != IR_SHL && o->kind != IR_SHR) continue;
                if (o->dst < 0 || o->dst >= f->n_vregs || !into_base[o->dst])
                    continue;
                if (o->src[0] >= 0 && o->src[0] < f->n_vregs)
                    scaled[o->src[0]] = 1;
            }
        for (int v = 0; v < f->n_vregs; v++) if (scaled[v]) wd_addr[v] = 1;
        free(scaled);
    }
}

/* B4 — idx3-home realizability (extracted from idx3_propose's per-vreg gate).
   TRUE iff loop-carried width-2 v can ride the second spare index register:
   non-param/base/accumulator local, not addr-taken/volatile, not homed,
   loop-defined, hot write-many with a def-first entry-bb0 init, and NOT a
   deref-address feeder (wd_addr — `arr[v]` would push;pop;add every iter). Maps
   (wd_base/wd_acc/wd_ldef/wd_addr) are caller-precomputed; the func envelope
   (idx3_reg present, not interrupt/naked, IY-clean callees) stays in the
   proposer (it also guards building the maps). */
static int idx3_home_realizable(const Func *f, int v,
                                const int *use_count, const int *write_count,
                                const int *wd_base, const int *wd_acc,
                                const int *wd_ldef, const int *wd_addr)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM))
        return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (wd_base[v]) return 0;                     /* not a deref base */
    if (wd_acc[v]) return 0;                      /* accumulators → word_acc */
    if (!wd_ldef[v]) return 0;                    /* must be loop-carried */
    if (use_count[v] < 4) return 0;
    if (write_count[v] < 2) return 0;
    DefUseIdx du = vreg_def_first(f, v);
    if (du.first_def >= f->bbs[0].n_ops) return 0; /* init def in entry bb0 */
    if (du.first_def >= du.first_read) return 0;   /* def-first */
    if (wd_addr[v]) return 0;                      /* array-index feeder */
    return 1;
}


/* B4 — exx-home realizability (extracted from exx_propose's per-vreg gate).
   TRUE iff loop-INVARIANT width-2 v can ride the exx/alt bank: not addr-taken/
   volatile, not homed, read in-loop but NEVER written in-loop (so it survives
   `exx` with no write-back), not a deref base, hot, and EVERY use an ordered/
   equality compare operand (the alt-bank home pays off only through the
   A-bridge compare). The func-level enabler (>=2 competing writable loop words,
   exx_reg present, acc-free, call-free) stays in the proposer. */
static int exx_home_realizable(const Func *f, int v, const int *use_count,
                               const int *wd_base, const int *wd_ldef,
                               const int *wd_lread)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (!wd_lread[v] || wd_ldef[v]) return 0;   /* read in loop, never written */
    if (wd_base[v]) return 0;                    /* deref base wants a gp reg */
    if (use_count[v] < 4) return 0;
    /* Every use must be an ordered/equality compare operand — an invariant used
       in address arithmetic / general ALU gains nothing and needs an expensive
       materialize; home it in a gp reg instead. */
    for (int bi = 0; bi < f->n_bbs; bi++)
        for (int bj = 0; bj < f->bbs[bi].n_ops; bj++) {
            const Op *o = &f->bbs[bi].ops[bj];
            int u[16];
            int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
            int uses_v = 0;
            for (int k = 0; k < nu; k++) if (u[k] == v) { uses_v = 1; break; }
            if (!uses_v) continue;
            switch (o->kind) {
            case IR_CMP_LT: case IR_CMP_LE: case IR_CMP_GT:
            case IR_CMP_GE: case IR_CMP_ULT: case IR_CMP_ULE:
            case IR_CMP_UGT: case IR_CMP_UGE: case IR_CMP_EQ:
            case IR_CMP_NE: break;
            default: return 0;
            }
        }
    return 1;
}


/* B4 — byte-home realizability (extracted from byte_home_propose's per-vreg
   gate). TRUE iff width-1 v can ride a byte home (C slotless / E slot-backed):
   call-free function, not addr-taken/volatile, not homed, hot (>=8 reads),
   written, and its def dominates its reads (first def in entry bb0, before
   first read). The CF_BYTE_SINGLE_BB discriminator (slotless-C eligibility)
   stays in the proposer — it's a tag, not a realizability gate. */
static int byte_home_realizable(const Func *f, int v,
                                const int *use_count, const int *write_count)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 1) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (use_count[v] < 8) return 0;
    if (write_count[v] < 1) return 0;
    if (!func_is_call_free(f)) return 0;              /* BC/DE must survive */
    DefUseIdx du = vreg_def_first(f, v);
    if (du.first_def >= f->bbs[0].n_ops) return 0;    /* def in entry bb0 */
    if (du.first_def >= du.first_read) return 0;      /* def-first */
    return 1;
}


/* B4 — IV-residency realizability (extracted from iv_propose's per-vreg gate).
   TRUE iff a write-many int IV can ride BC across BBs: width-2 non-param/
   non-induction local, not addr-taken/volatile, not homed, no prepushed call,
   not read-before-def (entry_live), write-many with EVERY def a BC-stamping
   producer (all_defs_ok → BC always holds the current value), and hot. */
static int iv_home_realizable(const Func *f, int v,
                              const int *use_count, const int *write_count,
                              const int *all_defs_ok, int has_prepushed_call,
                              const BitSet *entry_live)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                     | IR_VREG_PARAM | IR_VREG_INDUCTION)) return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (has_prepushed_call) return 0;
    if (entry_live && ir_bitset_get(entry_live, v)) return 0;  /* read-before-def */
    if (write_count[v] < 2) return 0;   /* write-many */
    if (!all_defs_ok[v]) return 0;      /* every def stamps BC */
    if (use_count[v] < 8) return 0;     /* hot → in a loop */
    return 1;
}


/* ==== B4 — home_realizable: the single candidate-GENERATION query ==========
   "Can value v be correctly kept in register class R over op-interval [lo,hi]
   with a coherent slot backing outside it?" It is the union of (a) the class's
   per-vreg realizability predicate (extracted above) and (b) the class's
   func-level ENABLER (envelope + opt flags) — together they reproduce exactly
   which (v,R) the proposers put in the pool. Increment 3's colouring calls this
   per (v, class) to GENERATE candidates, retiring the proposer loops; the inert
   agreement check (IR_HR_CHECK) validates home_realizable == pool membership
   for every (v, class) across the corpus first. [lo,hi] is ignored today
   (whole-function homes); increment 4 passes a tight range for ranging.

   The per-function precomputes live in HomeCtx, built once by the caller (the
   agreement check now, the colouring later) — the same maps the proposers
   build, so the query needs no per-call scanning. */
typedef struct {
    const int *use_count, *write_count, *def_kind, *all_defs_ok;
    int has_prepushed_call;
    const BitSet *entry_live;
    const int *is_base, *cstep, *cinit, *cother;      /* idx2 maps */
    const int *wd_base, *wd_acc, *wd_ldef, *wd_lread, *wd_addr; /* de/idx3/exx */
    int exx_writables;                                /* exx enabler count */
} HomeCtx;

/* Func-level enablers (envelopes + opt flags) — the whole-function conditions
   that gate a class's proposer, hoisted so home_realizable and the proposers
   agree. */
static int idx2_home_available(const Func *f)
{
    if (f->idx2_reg == IR_PR_NONE || f->uses_acc || f->is_interrupt) return 0;
    if (func_is_call_free(f)) return 1;
    /* [Part C] idx2 home ACROSS CALLS — SP MODE, DEAR-SLOT TARGETS ONLY. The win
       is replacing sp's dear `ld hl,N; add hl,sp` local-slot walk with a value
       resident in idx2=IX across the call (a good byte-for-cycle trade on z80).
       Two exclusions:
        - fp mode (idx2=IY, cheap (ix+d) slots): lose/lose — the push/pop access
          + the caller-IX save beat nothing. Keep the blunt call-free gate.
        - cheap-sp-slot CPUs: ez80 (native `ld hl,(ix+d)`), rabbit and kc160 all
          address sp locals cheaply, so the dear-slot premise doesn't hold and
          the idx2 home doesn't pay (same class the g0 dear-slot cost gates use).
          Only the z80 family (z80/z180/z80n) has the dear `add hl,sp` walk.
       IX is callee-saved (Part A saves it via frame_has_saved_ix; the library is
       IX-safe); reject when the function uses IX itself (fnptr dispatch/far). */
    if (c_framepointer_is_ix != -1) return 0;          /* sp mode only */
    if (IS_EZ80() || IS_RABBIT() || IS_KC160()) return 0;   /* cheap sp slots */
    if (func_call_clobbers(f) & CLOB_IX) return 0;     /* sp idx2 = IX */
    if (func_idx2_self_use(f)) return 0;
    return 1;
}
static int idx3_home_available(const Func *f)
{
    if (f->idx3_reg == IR_PR_NONE || f->is_interrupt || f->is_naked) return 0;
    if (!func_is_call_free(f) && (func_call_clobbers(f) & CLOB_IY)) return 0;
    return 1;
}
static int exx_home_available(const Func *f, int exx_writables)
{
    return f->exx_reg != IR_PR_NONE && !f->is_interrupt && !f->is_naked
        && !f->uses_acc && func_is_call_free(f) && exx_writables >= 2;
}
static int de_home_available(const Func *f)
{
    if (!func_is_call_free(f)) return 0;
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vreg_to_phys[v] == IR_PR_E || f->vreg_to_phys[v] == IR_PR_D)
            return 0;   /* DE low half already a byte E/D home */
    return 1;
}

static int home_realizable(const Func *f, int v, unsigned R,
                           int lo, int hi, const HomeCtx *c)
{
    (void)lo; (void)hi;   /* whole-function homes today; ranging = increment 4 */
    switch (R) {
    case RC_BC:
        return bc_home_realizable(f, v, c->use_count, c->write_count,
                                  c->def_kind, c->has_prepushed_call,
                                  c->entry_live)
            || (!opt_disabled("iv-resident")
                && iv_home_realizable(f, v, c->use_count, c->write_count,
                                      c->all_defs_ok, c->has_prepushed_call,
                                      c->entry_live));
    case RC_BYTE:
        return c_byte_resident && !opt_disabled("byte-resident")
            && byte_home_realizable(f, v, c->use_count, c->write_count);
    case RC_IDX2:
        return idx2_home_available(f)
            && idx2_home_realizable(f, v, c->use_count, c->write_count,
                                    c->is_base, c->cstep, c->cinit, c->cother);
    case RC_IDX3:
        return idx3_home_available(f)
            && idx3_home_realizable(f, v, c->use_count, c->write_count,
                                    c->wd_base, c->wd_acc, c->wd_ldef,
                                    c->wd_addr);
    case RC_EXX:
        return exx_home_available(f, c->exx_writables)
            && exx_home_realizable(f, v, c->use_count, c->wd_base, c->wd_ldef,
                                   c->wd_lread);
    case RC_DE_ACC:
        if (!de_home_available(f)) return 0;
        if (c_word_resident && !opt_disabled("word-resident")
            && de_acc_realizable(f, v, c->use_count, c->write_count,
                                 c->wd_base, c->wd_acc))
            return 1;
        if (!opt_disabled("de-home")
            && de_general_realizable(f, v, c->use_count, c->write_count,
                                     c->wd_base, c->wd_acc, c->wd_ldef))
            return 1;
        if (!opt_disabled("de-home") && !opt_disabled("loop-ra")
            && de_ptr_realizable(f, v, c->use_count, c->wd_base, c->wd_ldef))
            return 1;
        if (opres_on() && !opt_disabled("de-home")
            && de_operand_realizable(f, v, c->use_count, c->write_count,
                                     c->def_kind, c->wd_base))
            return 1;
        return 0;
    default:
        return 0;
    }
}

/* Inert agreement check (env IR_HR_CHECK): validates that home_realizable
   reproduces the proposers' pool EXACTLY — for every (v, class), the query
   agrees with pool membership. Run pre-arbitration (vreg_to_phys still all
   SPILL, the state the proposers saw). Logs any mismatch (false yes or false
   no); expect ZERO on the corpus → home_realizable is a faithful generator,
   ready for increment 3 to drive the colouring. Builds its OWN maps (independent
   recomputation via the factored helpers), so a mismatch would catch a real gap. */
static void hr_agreement_check(const Func *f, const Cand *pool, int np,
                               const int *use_count, const int *write_count,
                               const int *def_kind, const int *all_defs_ok,
                               int has_prepushed_call, const BitSet *entry_live,
                               const int *bb_in_loop)
{
    if (!getenv("IR_HR_CHECK") || f->n_vregs <= 0) return;
    size_t nv = (size_t)f->n_vregs;
    int *is_base = calloc(nv, sizeof(int)), *cstep = calloc(nv, sizeof(int));
    int *cinit = calloc(nv, sizeof(int)), *cother = calloc(nv, sizeof(int));
    int *wd_base = calloc(nv, sizeof(int)), *wd_acc = calloc(nv, sizeof(int));
    int *wd_ldef = calloc(nv, sizeof(int)), *wd_lread = calloc(nv, sizeof(int));
    int *wd_addr = calloc(nv, sizeof(int));
    if (is_base && cstep && cinit && cother && wd_base && wd_acc && wd_ldef
        && wd_lread && wd_addr) {
        build_idx2_maps(f, is_base, cstep, cinit, cother);
        scan_wd_props(f, bb_in_loop, wd_base, wd_acc, wd_ldef, wd_lread);
        build_idx3_addr(f, wd_base, wd_addr);
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
        HomeCtx c = { use_count, write_count, def_kind, all_defs_ok,
                      has_prepushed_call, entry_live,
                      is_base, cstep, cinit, cother,
                      wd_base, wd_acc, wd_ldef, wd_lread, wd_addr, writables };
        static const unsigned CLASSES[] =
            { RC_BC, RC_BYTE, RC_IDX2, RC_IDX3, RC_EXX, RC_DE_ACC };
        for (int v = 0; v < f->n_vregs; v++)
            for (int ci = 0; ci < (int)(sizeof CLASSES / sizeof CLASSES[0]); ci++) {
                unsigned R = CLASSES[ci];
                int in_pool = 0;
                for (int i = 0; i < np; i++)
                    if (pool[i].vreg == v && (pool[i].allowed & R)) { in_pool = 1; break; }
                int hr = home_realizable(f, v, R, INT_MIN, INT_MAX, &c) ? 1 : 0;
                if (hr != in_pool)
                    fprintf(stderr, "IR_HR_CHECK: %s v%d class %#x "
                            "home_realizable=%d pool=%d MISMATCH\n",
                            f->fn ? ir_sym_name(f->fn) : "?", v, R, hr, in_pool);
            }
    }
    free(is_base); free(cstep); free(cinit); free(cother);
    free(wd_base); free(wd_acc); free(wd_ldef); free(wd_lread); free(wd_addr);
}

/* Residency window of vreg v in its register home = live-range ∩ the ranged
   home interval [home_lo,home_hi] (outside which ir_home_at returns SPILL, so
   the register is free there). Returns 0 for an empty/invalid window. Today
   home_lo/hi is whole-function (INT_MIN/MAX) so this equals the live range; it
   narrows automatically once ranging (P3.2) makes home_lo/hi non-degenerate,
   at which point disjoint windows in the same register are legal time-sharing. */
static int hr_residency_window(const Func *f, int v, int *lo, int *hi)
{
    const LiveRange *lr = ir_live_range(f, v);
    if (!lr || lr->start < 0) return 0;
    int a = lr->start, b = lr->end;
    if (f->home_lo && f->home_lo[v] > a) a = f->home_lo[v];
    if (f->home_hi && f->home_hi[v] < b) b = f->home_hi[v];
    if (a > b) return 0;   /* home interval disjoint from the live range */
    *lo = a; *hi = b;
    return 1;
}

/* Inert home-recoverability verifier (env IR_HOME_VERIFY) — Phase-3 keystone.
   The invariant ranged sharing MUST preserve: two vregs committed to the SAME
   register home must not be simultaneously resident. Running it inert now proves
   the net has zero false positives on the shipping corpus before it gates
   anything, and it becomes the gate that rejects an unrealisable ranged home
   once home_lo/hi go non-degenerate (increment 4). Logs to stderr;
   IR_HOME_VERIFY_ABORT makes it fatal.

   Scope + predicate, learned from the inert corpus run (see RANGED_ALLOC_PLAN):
   - STRICT (exclusive) overlap. Inclusive `ir_live_ranges_overlap` over-reports:
     a touching endpoint (u's last-use == v's def) is register REUSE, not
     interference — the standard def/last-use coincidence. A real conflict needs
     an op where BOTH are live: max(starts) < min(ends).
   - Restrict to the spillable pair / byte homes Phase 3 ranges (DE/BC + halves).
     The idx family (IX/IY + halves) is managed by dedicated in-place stepping
     that fuses a counter's step-temp into the same index register — there,
     vreg_to_phys=IY does NOT mean two continuous occupants, so it is out of
     scope for this net. HL/DEHL are cache-only; SPILL/NONE are
     not register homes.
   - Half-register cross-conflicts (PR_BC vs PR_C/PR_B, PR_DE vs PR_E/PR_D) are a
     deliberate follow-up — a superset conflict model lands with ranging. */
static int hr_recoverability_verify(const Func *f)
{
    if (!getenv("IR_HOME_VERIFY") || !f || f->n_vregs <= 0
        || !f->vreg_to_phys)
        return 0;
    int viol = 0;
    const char *fn = f->fn ? ir_sym_name(f->fn) : "?";
    for (int u = 0; u < f->n_vregs; u++) {
        PhysReg pu = f->vreg_to_phys[u];
        if (!(pu == IR_PR_DE || pu == IR_PR_BC || pu == IR_PR_C
              || pu == IR_PR_E || pu == IR_PR_D || pu == IR_PR_B))
            continue;
        int ulo, uhi;
        if (!hr_residency_window(f, u, &ulo, &uhi)) continue;
        for (int v = u + 1; v < f->n_vregs; v++) {
            if (f->vreg_to_phys[v] != pu) continue;
            int vlo, vhi;
            if (!hr_residency_window(f, v, &vlo, &vhi)) continue;
            int s = ulo > vlo ? ulo : vlo;
            int e = uhi < vhi ? uhi : vhi;
            if (s >= e) continue;   /* strict: touching endpoints = reuse */
            fprintf(stderr,
                "IR_HOME_VERIFY: %s v%d res[%d,%d] & v%d res[%d,%d] both home %s "
                "— OVERLAPPING residency, unrecoverable share\n",
                fn, u, ulo, uhi, v, vlo, vhi, ir_phys_name(pu));
            viol++;
        }
    }
    if (viol && getenv("IR_HOME_VERIFY_ABORT")) abort();
    return viol;
}

/* B4 increment 3 — the single candidate GENERATOR (retires the 7 proposers).
   Builds the per-function maps ONCE (was 4 redundant scans across de/idx2/idx3/
   exx) and emits candidates by calling the class realizability predicates + the
   func-level enablers directly, in the EXACT former proposer order and with the
   EXACT tags (the arbiter's stable tie-break depends on collection order:
   pr_bc, exx-before-idx2, byte, de{acc,general,ptr}, idx3, iv). home_realizable
   is the coarse point-query (used by the colouring's decisions / ranging + the
   agreement check); generation uses the finer per-source predicates because it
   needs per-source position + tag (RC_BC has two sources — bc tag 0 early, iv
   CF_SPECULATIVE last — that a class-level OR query can't separate). Fills
   pool[] (caller-sized f->n_vregs*6), returns the candidate count. */
static int collect_home_candidates(const Func *f,
                                   const int *use_count, const int *write_count,
                                   const int *def_kind, const int *all_defs_ok,
                                   int has_prepushed_call, const BitSet *entry_live,
                                   const int *bb_in_loop,
                                   const int *first_use, const int *last_use,
                                   Cand *pool)
{
    int n = 0;
    size_t nv = f->n_vregs > 0 ? (size_t)f->n_vregs : 0;
    int *is_base = calloc(nv, sizeof(int)), *cstep = calloc(nv, sizeof(int));
    int *cinit = calloc(nv, sizeof(int)), *cother = calloc(nv, sizeof(int));
    int *wd_base = calloc(nv, sizeof(int)), *wd_acc = calloc(nv, sizeof(int));
    int *wd_ldef = calloc(nv, sizeof(int)), *wd_lread = calloc(nv, sizeof(int));
    int *wd_addr = calloc(nv, sizeof(int));
    if (!(is_base && cstep && cinit && cother && wd_base && wd_acc && wd_ldef
          && wd_lread && wd_addr))
        goto done;
    build_idx2_maps(f, is_base, cstep, cinit, cother);
    scan_wd_props(f, bb_in_loop, wd_base, wd_acc, wd_ldef, wd_lread);
    build_idx3_addr(f, wd_base, wd_addr);

    /* (1) BC — read-free/write-once/IVSR word (tag 0). */
    for (int v = 0; v < f->n_vregs; v++)
        if (bc_home_realizable(f, v, use_count, write_count, def_kind,
                               has_prepushed_call, entry_live))
            add_cand(pool, &n, v, use_count[v], first_use[v], last_use[v],
                     RC_BC, 0);
    /* (2) EXX co-design FIRST (an alt-bank invariant frees IX for a writable
       loop var) — must precede idx2 so the stable arbiter grabs it first. */
    if (f->exx_reg != IR_PR_NONE && !f->is_interrupt && !f->is_naked
        && !f->uses_acc && func_is_call_free(f)) {
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
        if (writables >= 2)
            for (int v = 0; v < f->n_vregs; v++)
                if (exx_home_realizable(f, v, use_count, wd_base, wd_ldef,
                                        wd_lread))
                    add_cand(pool, &n, v, use_count[v], first_use[v],
                             last_use[v], RC_EXX, 0);
    }
    /* (3) idx2 — spare index register (counter or read-only param). */
    if (idx2_home_available(f))
        for (int v = 0; v < f->n_vregs; v++) {
            unsigned fl = idx2_home_realizable(f, v, use_count, write_count,
                                               is_base, cstep, cinit, cother);
            if (fl)
                add_cand(pool, &n, v, use_count[v], first_use[v], last_use[v],
                         RC_IDX2, fl);
        }
    /* (4) byte home (C slotless if single-BB, else E slot-backed). */
    if (c_byte_resident && !opt_disabled("byte-resident"))
        for (int v = 0; v < f->n_vregs; v++)
            if (byte_home_realizable(f, v, use_count, write_count))
                add_cand(pool, &n, v, use_count[v], first_use[v], last_use[v],
                         RC_BYTE,
                         (vreg_single_bb(f, v) >= 0) ? CF_BYTE_SINGLE_BB : 0);
    /* (5) DE-class — three sub-shapes in pool order: acc, general, ptr. */
    if (de_home_available(f)) {
        if (c_word_resident && !opt_disabled("word-resident"))
            for (int v = 0; v < f->n_vregs; v++)
                if (de_acc_realizable(f, v, use_count, write_count,
                                      wd_base, wd_acc))
                    add_cand(pool, &n, v, use_count[v], first_use[v],
                             last_use[v], RC_DE_ACC, 0);
        if (!opt_disabled("de-home"))
            for (int v = 0; v < f->n_vregs; v++)
                if (de_general_realizable(f, v, use_count, write_count,
                                          wd_base, wd_acc, wd_ldef))
                    add_cand(pool, &n, v, use_count[v], first_use[v],
                             last_use[v], RC_DE_ACC, CF_DE_GENERAL);
        if (!opt_disabled("de-home") && !opt_disabled("loop-ra"))
            for (int v = 0; v < f->n_vregs; v++)
                if (de_ptr_realizable(f, v, use_count, wd_base, wd_ldef))
                    add_cand(pool, &n, v, use_count[v], first_use[v],
                             last_use[v], RC_DE_ACC, CF_DE_GENERAL | CF_DE_PTR);
        /* OPRES (opt-in IR_OPRES): reused deref/binop operand → general DE-home.
           The IR_RANGED fail-safe brick does NOT enter this competition — it keeps
           the value SPILL and only leaves a DE cache at its def (hint set in a
           post-placement pass in ir_alloc). */
        if (opres_on() && !opt_disabled("de-home"))
            for (int v = 0; v < f->n_vregs; v++)
                if (de_operand_realizable(f, v, use_count, write_count,
                                          def_kind, wd_base))
                    add_cand(pool, &n, v, use_count[v], first_use[v],
                             last_use[v], RC_DE_ACC, CF_DE_GENERAL);
    }
    /* (6) idx3 — second spare index register (opt-in). */
    if (idx3_home_available(f))
        for (int v = 0; v < f->n_vregs; v++)
            if (idx3_home_realizable(f, v, use_count, write_count,
                                     wd_base, wd_acc, wd_ldef, wd_addr))
                add_cand(pool, &n, v, use_count[v], first_use[v], last_use[v],
                         RC_IDX3, 0);
    /* (7) IV-residency — hot write-many BC-stamped int IV (CF_SPECULATIVE). */
    if (!opt_disabled("iv-resident"))
        for (int v = 0; v < f->n_vregs; v++)
            if (iv_home_realizable(f, v, use_count, write_count, all_defs_ok,
                                   has_prepushed_call, entry_live))
                add_cand(pool, &n, v, use_count[v], first_use[v], last_use[v],
                         RC_BC, CF_SPECULATIVE);
done:
    free(is_base); free(cstep); free(cinit); free(cother);
    free(wd_base); free(wd_acc); free(wd_ldef); free(wd_lread); free(wd_addr);
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

/* Grounded cost-model kinds/registers (defined with g0_word_cost below) — declared
   here so the arbiter's contention comparison can reference GR_BC. */
enum { GK_READ, GK_WRITE, GK_DEREF, GK_STEP, GK_N };
enum { GR_SLOT, GR_BC, GR_DE, GR_IX, GR_IY, GR_N };
static int  g0_word_cost(int reg, int kind);
static int  is_compared_counter(const Func *f, int v);
static int  is_deref_base(const Func *f, int v);
static int  is_stepped(const Func *f, int v);
static long interval_benefit_x(const Func *f, int v, const int *bb_loop_depth,
                               int R, int discount);


/* A compared counter should give up BC/DE for its uncontended index home ONLY when a
   deref-base genuinely competes for BC — i.e. the same overlapping, localized
   deref-base contender the BC yield looks for. Without a contender the counter's
   best home IS the cheap GP pair (must NOT be pushed to the dearer index). With one,
   parking the counter in the free index frees BC for the deref-base AND keeps the
   counter cheap. Requires: v is a compared counter, its index is free + not
   cost-rejected, AND such a contender w exists. */
static int is_compared_counter(const Func *f, int v);
static int is_deref_base(const Func *f, int v);
static int is_stepped(const Func *f, int v);
static int counter_yields_bc_to_index(const Func *f, const Cand *pool, int n, int v,
                                       const long *idx_ben, int idx2_taken,
                                       int idx3_taken)
{
    if (!is_compared_counter(f, v)) return 0;
    if (idx_ben && idx_ben[v] <= 0) return 0;
    /* Only redirect where the INDEX is a genuinely cheap home — its read is ~as cheap
       as a GP pair (ez80 native `lea` = 3 ≈ DE 2). On dear-index CPUs (kc160/rabbit/
       z80) the counter belongs in the cheap GP pair, NOT the index, so redirecting
       there would lose the shipped BC wins. This is the CPU distinction; the
       counter→BC yield (below, deref_gap≥15) still covers the dear-slot z80 bucket by
       SPILLING the counter instead. */
    if (g0_word_cost(GR_IX, GK_READ) > g0_word_cost(GR_DE, GK_READ) + 1) return 0;
    int has_free_idx = 0;
    for (int k = 0; k < n && !has_free_idx; k++) {
        if (pool[k].vreg != v) continue;
        if ((pool[k].allowed & RC_IDX2) && !idx2_taken && f->idx2_reg != IR_PR_NONE)
            has_free_idx = 1;
        if ((pool[k].allowed & RC_IDX3) && !idx3_taken && f->idx3_reg != IR_PR_NONE)
            has_free_idx = 1;
    }
    if (!has_free_idx) return 0;
    for (int j = 0; j < n; j++) {           /* an overlapping LOCALIZED deref-base? */
        int w = pool[j].vreg;
        if (w == v || !(pool[j].allowed & RC_BC)) continue;
        if (is_compared_counter(f, w) || !is_deref_base(f, w) || is_stepped(f, w))
            continue;
        if (!ir_live_ranges_overlap(f, v, w)) continue;
        const LiveRange *lv = ir_live_range(f, v), *lw = ir_live_range(f, w);
        if (lv && lw && 2*(lw->end - lw->start) >= (lv->end - lv->start)) continue;
        return 1;   /* a deref-base wants BC + the index is cheap → counter → index */
    }
    return 0;
}

/* idx_ben (opt-in IR_GRAPH_ALLOC, else NULL): grounded benefit of an index home per
   vreg. When present, an index (idx2/idx3) assignment is REJECTED for a vreg whose
   idx_ben ≤ 0 — a read-only value on a cheap-slot target where `push ix;pop hl`
   reads cost more than the slot.
   idx_keep (G2, else NULL): overrides the reject. A stepped counter whose READS are
   no deeper than its STEP is kept in the index even at idx_ben ≤ 0 — the in-loop cost
   marginally favours the slot, but the cheap `ld ix,nn` init (vs slot init+frame) and
   the `inc ix` step win over a short, frequently-entered loop. When a counter is
   instead read in a DEEPER loop than its step, the frequency-amplified index-read cost
   dominates → idx_keep is false → the grounded reject stands (slot wins). */
static void unified_arbitrate(Func *f, Cand *pool, int n, const long *idx_ben,
                              const int *idx_keep, const int *bb_loop_depth)
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
            /* G1 grounded gate: skip an index home that costs more than the slot
               for this value (read-only value on a cheap-slot target). G2: unless
               the setup/step keep-rule protects it (queen-pattern counter). */
            if (idx_ben && idx_ben[v] <= 0 && !(idx_keep && idx_keep[v])) continue;
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
            if (idx_ben && idx_ben[v] <= 0 && !(idx_keep && idx_keep[v]))
                continue;   /* G1 grounded gate + G2 keep-rule */
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
            /* A compared COUNTER that is index-eligible belongs in the
               UNCONTENDED index (`inc ix`, `lea` read), NOT the `ex de,hl`-scratch
               DE. interval_benefit rates ib_de==ib_bc>ib_ix so the DE candidate is
               tried before the IX one, but DE's scratch contention makes it lose to
               IX in practice (the `lea` idx-read gain). Skip DE here so v's own
               idx candidate (processed later) parks it in the free index. */
            if (counter_yields_bc_to_index(f, pool, n, v, idx_ben,
                                           idx2_taken, idx3_taken))
                continue;
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
            /* An index-eligible compared COUNTER belongs in the uncontended
               index (`inc ix`), not a GP pair it will contend for and then get promoted
               out of (BC→DE via the general phase). Skip BC so its idx candidate parks
               it in the free index — freeing BC for the deref-base. This is the
               index-available generalisation of the counter→deref-base BC yield
               below (which handles the no-index case, e.g. fp where IX is the frame
               pointer). Only when the index is genuinely free and not cost-rejected. */
            if (counter_yields_bc_to_index(f, pool, n, v, idx_ben,
                                           idx2_taken, idx3_taken))
                continue;
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
            /* CONTENTION-CONDITIONAL counter yield. A compared counter
               ranks high globally (its STEP saving vs the frame slot) so it grabs
               BC first — but if it OVERLAPS an unassigned BC contender whose true
               benefit-in-BC exceeds the counter's benefit under its REAL (stack-
               transient) spill baseline, the counter should yield: it spills to the
               cheap `pop;dec;push` transient while the contender (e.g. a `bins[idx]`
               deref-base, `ld a,(bc)`) takes BC. Gated on is_compared_counter so a
               non-counter BC value never yields. Unopposed, the counter keeps BC. */
            /* The yield only pays where a deref-base's BC-exclusive `ld a,(bc)`
               beats a DEAR slot deref: (slot−BC) deref gap ≈39 on the z80 bucket
               vs ≈2-5 on ez80/kc160/rabbit (cheap `(ix+d)`/`ld rr,(idx)`), where
               displacing the counter loses more than the deref-base gains. */
            int deref_gap = g0_word_cost(GR_SLOT, GK_DEREF)
                          - g0_word_cost(GR_BC, GK_DEREF);
            if (ok && bb_loop_depth && deref_gap >= 15
                && is_compared_counter(f, v)) {
                long vben = interval_benefit_x(f, v, bb_loop_depth, GR_BC, 1);
                for (int j = 0; j < n; j++) {
                    int w = pool[j].vreg;
                    if (w == v) continue;
                    if (!(pool[j].allowed & RC_BC)) continue;
                    if (f->vreg_to_phys[w] != IR_PR_SPILL) continue;
                    if (is_compared_counter(f, w)) continue;   /* counters don't out-bid */
                    if (!is_deref_base(f, w)) continue;        /* only a BC-exclusive deref */
                    if (is_stepped(f, w)) continue;            /* a walking ptr is loop-ra, not a stable base */
                    if (!ir_live_ranges_overlap(f, v, w)) continue;
                    /* Yield only when w is a LOCALIZED hot deref (a short window inside
                       the counter's broad life), not a value CO-EXTENSIVE with the
                       counter. When both span the whole loop the swap is a coin-flip on
                       a thin margin (keep); a deref window strictly inside the counter's
                       life is a genuine localized deref → yield. */
                    {
                        const LiveRange *lv = ir_live_range(f, v);
                        const LiveRange *lw = ir_live_range(f, w);
                        if (lv && lw && 2*(lw->end - lw->start) >= (lv->end - lv->start))
                            continue;
                    }
                    long wben = interval_benefit_x(f, w, bb_loop_depth, GR_BC, 1);
                    /* Eviction hysteresis: yield only when the deref-base beats the
                       counter by a clear margin (≥1.4×). The counter's stack-transient
                       spill baseline is OPTIMISTIC (a multi-def counter may land in a
                       dearer slot), so a thin win does not justify evicting it. */
                    if (5*wben > 7*vben) {
                        ok = 0; break;                         /* yield BC to w */
                    }
                }
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
       loop-extension in unified_arbitrate guards against, and what makes tight
       intervals safe here);
     - call-free span, and every op strictly after the def is BC-preserving
       (bc_pack_span_kind_ok) with no width-4 operand.
   The admitted candidates share the single BC register by greedy interval
   scheduling on their flat op ranges, skipping any overlap with an existing
   (loop-home) PR_BC tenant's extended interval. Winners are tagged
   IR_VREG_BC_PACK so gen_call's whole-function BC-save ignores them.

   Default ON; IR_NO_BC_PACK opts out (restores the pre-pack codegen exactly). */

/* LRA Phase 2c: is IY available as a reduction-chain home in this function?
   Needs a CPU with IY + `add iy,de` (excludes gbz80/808x), IY not reserved by
   the platform (--reserve-regs-iy) nor claimed by idx2/idx3/exx, and not an
   interrupt/naked function. IY is free in both sp-mode (-1) and fp-mode (1, IX
   is the frame). */
static int lra_iy_available(const Func *f)
{
    if (f->is_interrupt || f->is_naked) return 0;
    if (c_reserve_iy) return 0;                 /* IY reserved by the platform */
    /* CPU must have IY + `add iy,de` (excludes gbz80/8080/8085). z180/ez80/rabbit
       support the full-word add iy,rr (only the index-HALF ops trap on z180). */
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || c_cpu == CPU_Z180
          || IS_EZ80() || IS_RABBIT())) return 0;
    /* fp soundness: the fp epilogue frame fix + IY-occupancy arbitration (below)
       + the FULL-live-range IY-clean check (rejects an accumulator live across an
       IY-clobbering call — the remat.c fp miscompile, now fixed). */
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

/* LRA Phase 2c: home a DE-dirty straight-line reduction chain in
   IY. A chain is a run of width-2 ADDs c0=x+y, c1=c0+z, c2=c1+w… where each
   partial feeds the NEXT add as an operand and is otherwise dead (single use),
   all spilling in one loop-body BB. The addends' address computation owns HL+DE
   (and BC holds the loop ptr/IV), so the partials can't home in BC/DE and spill
   to slots. IY is immune to that clobbering, so the whole chain time-shares ONE
   IY register: c0 inits it (`push hl; pop iy` via commit_hl_result), c1.. via
   `add iy,de` (Phase 2b emitter). Sets f->idx3_reg=IY so vreg_idx_home sees the
   members and the prologue saves IY (frame_has_saved_iy). Runs AFTER ir_bc_pack
   (takes the SPILL losers) and before ir_stack_spill. DEFAULT ON; IR_NO_LRA
   opts out (--reserve-regs-iy also disables it via lra_iy_available). */
static void ir_iy_reduction_pack(Func *f, const int *bb_in_loop,
                                 const int *use_count)
{
    if (opt_disabled("lra")) return;
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
       against the best chain below — one IY user per function, take the hotter
       (e.g. a COLD outer checksum accumulator vs a HOT inner stencil chain; the
       score picks the chain). */
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
       different BBs can be simultaneously live (a row-offset chain living across
       a neighbour-sum chain) and would collide in the one IY register. Proper
       inter-chain interference needs live ranges (not built
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
        /* Single-BB confinement via the shared helper (step 1d). Its ref set
           — dst ∪ POSTSTEP src[0] ∪ ir_op_uses — equals this scan's ref set,
           since IR_POSTSTEP's src[0] is itself an ir_op_uses member, so this is
           byte-identical to the former inline multi-BB detection. */
        int bb_of = vreg_single_bb(f, v);
        if (bb_of < 0) continue;                       /* multi-BB or unreferenced */
        const BB *bb = &f->bbs[bb_of];
        if (bb->live_out && ir_bitset_get((const BitSet *)bb->live_out, v)) continue;
        if (bb->live_in  && ir_bitset_get((const BitSet *)bb->live_in,  v)) continue;
        /* Tight local interval [lo,hi], use count, and first-is-def within that
           BB. first_is_def keeps the plain o->dst==v notion — NOT vreg_def_first,
           which counts POSTSTEP src[0] as a def; unifying those two def notions is
           a behaviour change reserved for a later gated step, not this one. */
        int lo = INT_MAX, hi = -1, first_is_def = 0, uses = 0, seen = 0;
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            int is_def = (o->dst == v);
            int u[16]; int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
            int is_use = 0;
            for (int k = 0; k < nu; k++) if (u[k] == v) { is_use = 1; uses++; }
            if (!is_def && !is_use) continue;
            if (!seen) { first_is_def = is_def; seen = 1; }
            if (j < lo) lo = j;
            if (j > hi) hi = j;
        }
        if (hi < 0 || !first_is_def) continue;
        sh[v].local = 1; sh[v].bb_of = bb_of; sh[v].lo = lo; sh[v].hi = hi;
        sh[v].uses = uses;
    }
    return sh;
}

/* Shared producer-side admission for the single-BB spill WORD temps that both
   ir_bc_pack and ir_stack_spill pack: width-2, currently SPILL, not
   param/addr-taken/volatile, and exactly one def by a register-stampable
   producer (bc_safe_producer). Each pass adds its own shape/span/use gates. */
static int spill_word_producer_ok(const Func *f, int v,
                                  const int *write_count, const int *def_kind)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    if (vr->flags & (IR_VREG_PARAM | IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
        return 0;
    if (write_count[v] != 1) return 0;
    if (!bc_safe_producer(def_kind[v])) return 0;
    return 1;
}

/* The flat interval a PR_BC tenant occupies for a pack/evict clash test: an
   iteration-local (itloc) tenant releases BC outside its TIGHT span, so it only
   blocks [itlo,ithi]; a genuine loop-carried tenant (not itloc) blocks its
   EXTENDED [first_use,last_use]. */
static void bc_tenant_interval(int j, const int *itloc, const int *itlo,
                               const int *ithi, const int *first_use,
                               const int *last_use, int *lo, int *hi)
{
    *lo = itloc[j] ? itlo[j] : first_use[j];
    *hi = itloc[j] ? ithi[j] : last_use[j];
}

/* A packed word-temp's tight flat interval [flo,fhi] plus its BB and def-op
   index (local to that BB). Shared by ir_bc_pack and ir_iy_temp_pack; sorted by
   flo for greedy scheduling. */
typedef struct { int vreg, flo, fhi, bb, dop; } PackCand;

/* Born-killed short spill WORD temp discovery — the candidate set shared by BC
   packing (ir_bc_pack) and the IY temp packer (ir_iy_temp_pack, S3 Tier A).
   Computes the per-vreg iteration-local SHAPE into the caller-allocated itloc/
   itlo/ithi arrays (indexed by vreg; BC needs them for its clash/evict tests):
   a vreg is `itloc` iff all refs are in one bb, the first ref is its def, it is
   neither live-in nor live-out of that bb (born-and-killed each execution), and
   every op after the def up to its last use is call-free + BC-preserving +
   width-4-free. itlo/ithi are its TIGHT flat op interval. Then fills cand[]
   (caller-allocated, >= n_vregs entries) with the admitted candidates — itloc
   AND write-once by a register-stampable producer AND a LIVE spill store AND (on
   cheap-slot targets) not a deref base — sorted by flo. Returns the count. */
static int collect_bc_temp_cands(const Func *f, const int *bb_first_op,
                                 const int *def_kind, const int *write_count,
                                 const int *use_count, int *itloc, int *itlo,
                                 int *ithi, PackCand *cand)
{
    int *itbb  = calloc((size_t)f->n_vregs, sizeof(int));
    int *itdop = calloc((size_t)f->n_vregs, sizeof(int));   /* def op idx in itbb */
    SpillShape *sh = compute_spill_shapes(f);
    if (!itbb || !itdop || !sh) { free(itbb); free(itdop); free(sh); return 0; }

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

    int nc = 0;
    for (int v = 0; v < f->n_vregs; v++) {
        if (!itloc[v]) continue;
        if (!spill_word_producer_ok(f, v, write_count, def_kind)) continue;
        if (use_count[v] < 1) continue;
        /* Only pack when the SPILL alternative actually costs frame traffic: if
           the def's spill store is dead (value HL-carried to a single adjacent
           use), a register home saves nothing and the stamp is pure overhead.
           Requiring a live spill captures exactly the store/reload the home
           eliminates. */
        if (op_dst_spill_is_dead(&f->bbs[itbb[v]], itdop[v])) continue;
        /* A value used as a MEM_VREG deref base wants to be in HL (`ld a,(hl)` /
           `ld (hl),a`), not a spare pair/index: a home forces a copy at the def
           and the deref still uses HL, so the stamp is wasted — UNLESS slots are
           expensive (sp mode on a CPU without cheap sp-relative addressing),
           where the home saves the pointer's slot reload and pays off (sp mode).
           So reject a deref-base candidate only when
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
        cand[nc].bb   = itbb[v];
        cand[nc].dop  = itdop[v];
        nc++;
    }

    /* Sort candidates by flo ascending (insertion sort — nc is small). */
    for (int i = 1; i < nc; i++) {
        PackCand c = cand[i];
        int j = i;
        while (j > 0 && cand[j - 1].flo > c.flo) { cand[j] = cand[j - 1]; j--; }
        cand[j] = c;
    }
    free(itbb); free(itdop);
    return nc;
}

static void ir_bc_pack(Func *f, const int *first_use, const int *last_use,
                       const int *bb_first_op, const int *def_kind,
                       const int *write_count, const int *use_count,
                       const long *cost_benefit)
{
    if (opt_disabled("bc-pack")) return;
    if (f->n_vregs <= 0) return;

    /* Per-vreg iteration-local shape (itloc/itlo/ithi) + the born-killed candidate
       set, shared with ir_iy_temp_pack. Existing PR_BC tenants that are itloc
       release BC outside their tight span, so a packed temp may reuse BC there —
       using the tight interval (not the loop-EXTENDED first_use/last_use) in the
       clash test is exactly the refinement unified_arbitrate's loop-extension is
       too coarse for (a genuinely loop-carried tenant is live-in or live-out →
       not itloc → keeps its extended interval and still blocks). */
    int *itloc = calloc((size_t)f->n_vregs, sizeof(int));
    int *itlo  = calloc((size_t)f->n_vregs, sizeof(int));
    int *ithi  = calloc((size_t)f->n_vregs, sizeof(int));
    PackCand *cand = calloc((size_t)f->n_vregs, sizeof(PackCand));
    if (!itloc || !itlo || !ithi || !cand) {
        free(itloc); free(itlo); free(ithi); free(cand); return;
    }
    int nc = collect_bc_temp_cands(f, bb_first_op, def_kind, write_count,
                                   use_count, itloc, itlo, ithi, cand);

    /* 5a: cost-benefit EVICTION, folded into the packer (default ON;
       --opt-disable=bc-evict opts out). The BC pickers give a picker-placed tenant
       absolute priority BY ORDER — it takes BC by running before this pack, not by
       out-competing the denser born-killed temps that then all spill (candidates
       all blocked by one param/IV in BC). Turn that fixed
       order into a competition: a picker-placed tenant (param, IV or write-once
       local — NOT an IR_VREG_BC_PACK tenant, i.e. a temp this pass already
       packed) that BLOCKS a candidate is an EVICTION candidate. If freeing all such
       blockers lets the greedy place enough extra benefit to out-weigh their
       combined benefit, revert them to SPILL — the greedy below then packs the
       freed BC. Reverting is sound for ANY tenant: this runs inside ir_alloc, so
       ir_assign_slots (which runs after) materialises a slot for every now-SPILL
       vreg (a param reads its caller slot in place). Benefit is the depth-weighted
       cost model (unit-weighted, not T-state-grounded, which future cost tuning
       tightens). IR_ALLOC_PROBE prints the decision. */
    if (!opt_disabled("bc-evict") && cost_benefit && nc > 0) {
        int *evictable = calloc((size_t)f->n_vregs, sizeof(int));
        if (evictable) {
            long evict_ben = 0;
            for (int j = 0; j < f->n_vregs; j++) {
                if (f->vreg_to_phys[j] != IR_PR_BC) continue;
                if (f->vregs[j].flags & IR_VREG_BC_PACK) continue;  /* our own */
                int jlo, jhi;
                bc_tenant_interval(j, itloc, itlo, ithi, first_use, last_use, &jlo, &jhi);
                int blocks = 0, hotter = 0;
                for (int i = 0; i < nc; i++) {                      /* blocks a cand? */
                    int s = cand[i].flo > jlo ? cand[i].flo : jlo;
                    int e = cand[i].fhi < jhi ? cand[i].fhi : jhi;
                    if (s <= e) { blocks = 1;
                        if (use_count[cand[i].vreg] >= use_count[j]) hotter = 1;
                    }
                }
                /* Don't evict a WRITTEN loop-carried tenant (wc≥2 = an IV
                   redefined each iteration) for a mere AGGREGATE of colder disjoint
                   temps — the sum ignores the per-temp
                   BC-reload churn, and spilling a hot recomputed loop resident costs
                   more than the summed temps save. Evict it only when SOME single
                   blocking temp is at least as hot (a genuinely denser replacement).
                   A read-only PARAM (wc==0) or write-once local (wc<2) has no such
                   in-loop recompute cost — its caller/def slot is a cheap home — so it
                   stays freely evictable. */
                if (blocks && !itloc[j] && !hotter && write_count[j] >= 2)
                    continue;
                if (blocks) { evictable[j] = 1; evict_ben += cost_benefit[j]; }
            }
            /* Greedy benefit of the placeable set with the blockers PRESENT (base)
               vs ABSENT (free) — identical flo-order greedy + clash logic as the
               real pass, so `free_ben` is exactly what will be packed if we evict. */
            long ben[2] = { 0, 0 };
            for (int pass = 0; pass < 2 && evict_ben > 0; pass++) {
                int last = -1;
                for (int i = 0; i < nc; i++) {
                    if (cand[i].flo <= last) continue;
                    int clash = 0;
                    for (int j = 0; j < f->n_vregs && !clash; j++) {
                        if (f->vreg_to_phys[j] != IR_PR_BC) continue;
                        if (f->vregs[j].flags & IR_VREG_BC_PACK) continue;
                        if (pass == 1 && evictable[j]) continue;   /* freed */
                        int jlo, jhi;
                        bc_tenant_interval(j, itloc, itlo, ithi, first_use, last_use, &jlo, &jhi);
                        int s = cand[i].flo > jlo ? cand[i].flo : jlo;
                        int e = cand[i].fhi < jhi ? cand[i].fhi : jhi;
                        if (s <= e) clash = 1;
                    }
                    if (clash) continue;
                    ben[pass] += cost_benefit[cand[i].vreg];
                    last = cand[i].fhi;
                }
            }
            int evicted = 0;
            if (evict_ben > 0 && ben[1] - ben[0] > evict_ben)
                for (int j = 0; j < f->n_vregs; j++)
                    if (evictable[j]) { f->vreg_to_phys[j] = IR_PR_SPILL; evicted++; }
            if (getenv("IR_ALLOC_PROBE"))
                fprintf(stderr, "UNIFIED_EVICT evict_ben=%ld gain=%ld evicted=%d\n",
                        evict_ben, ben[1] - ben[0], evicted);
            free(evictable);
        }
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
            int jlo, jhi;
            bc_tenant_interval(j, itloc, itlo, ithi, first_use, last_use, &jlo, &jhi);
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
    if (getenv("IR_ALLOC_PROBE"))
        fprintf(stderr, "BC_PACK packed=%d of candidates=%d\n", packed, nc);
    free(cand); free(itloc); free(itlo); free(ithi);
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
    if (opt_disabled("stack-spill")) return;   /* default ON; opts out */
    if (f->n_vregs <= 0) return;
    /* Gate: z80/z80n/z180/8080/8085/gbz80, sp AND fp — every CPU with expensive
       word slot access (fp: 2× ld (ix+d) ~38T; sp: ld hl,N;add hl,sp;…) vs
       push/pop 21T, so parking pays. Correctness rests on: copt strips pointless
       adjacent parks (push %1/pop %1); the commutative-addend reject (above) stops
       parking values that ride HL into a reduction; and NO slot-store path emits
       the -1 sentinel for a PR_STACK vreg —
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
        if (!spill_word_producer_ok(f, v, write_count, def_kind)) continue;

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
           being parked. Reject it. */
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

/* Inert measurement (IR_RANGED_PROBE): quantify the ranged-residency opportunity
   left AFTER all pickers ran — the residual SPILL word temps, their interval
   graph's max simultaneous overlap (= min registers to keep them all resident),
   and the count. A function with many spill-word temps but a small overlap is a
   ranged consumer (disjoint temps that time-share a few registers). No codegen
   effect. */
/* G0 (opt-in IR_GRAPH_PROBE, INERT — no codegen effect). The first stage of the
   interference/pressure-aware allocator (src/80cc/GRAPH_ALLOC_PLAN.md): build the
   grounded per-(access-kind × register × target × mode) benefit and REPORT where it
   disagrees with the placement `unified_arbitrate`+the packs actually chose. It does
   NOT apply anything — the divergence report is the measurement that decides which
   register class G1 flips first, and it validates the queen canary (does the model
   agree that a stepped counter belongs in an index reg on cheap-slot targets?).

   Grounded WORD costs (cyc) are from z88dk-ticks micro-benchmarks (see
   cost-model-grounding-finding.md), bucketed: KC160 (cheap slot, cheap idx),
   RABBIT/EZ80 (cheap slot, DEAR idx), Z80CLASS (dear slot). Access-kinds:
   READ / WRITE / DEREF(base in reg) / STEP(in-place `i++` = RMW). Estimates where
   unmeasured are marked; the table IS the tuning surface. */
/* (GK and GR enums are declared earlier, before unified_arbitrate.) */
static int g0_word_cost(int reg, int kind)
{
    /* [reg][kind] word cycles. SLOT row is sp-mode; fp adjusts SLOT below. */
    static const int KC160[GR_N][GK_N] = {           /* measured: slot4.1 bc2.1 ix6.1 incIy2.1 rmw9.1 */
        /*SLOT*/{4,4,4,9}, /*BC*/{2,2,2,2}, /*DE*/{2,2,2,2}, /*IX*/{6,6,4,2}, /*IY*/{6,6,4,2} };
    /* rabbit idx READ/WRITE now LOWER to `ld hl,<idx>` / `ld <idx>,hl` (4 cyc,
       HL only — emit_idx_word_to_reg / emit_hl_to_idx_word), so an EXISTING home
       is cheap. But the rd/wr cost here is DELIBERATELY kept at 19 (not the true
       4): dropping it to 4 makes idx_ben OPEN new homes that regress — the g0
       model lacks the loop-HL-pressure / per-invocation-setup term, so it
       over-values homing a hot counter in an index reg (the same gap G2's
       keep-rule patches for z80). Keep the reject conservative until that term
       exists; the lowering wins on the homes the reduction pack already makes. */
    static const int RABBIT[GR_N][GK_N] = {           /* measured: slot9.2 bc4.2 ld-hl-ix4.2 rmw20.2 incIx4.2 */
        /*SLOT*/{9,9,9,20}, /*BC*/{4,4,4,4}, /*DE*/{4,4,4,4}, /*IX*/{19,19,10,4}, /*IY*/{19,19,10,4} };
    static const int Z80[GR_N][GK_N] = {              /* measured: slot45.6 bc8.6 ix25.6; deref/step est */
        /*SLOT*/{46,46,46,92}, /*BC*/{9,9,7,6}, /*DE*/{9,9,7,6}, /*IX*/{26,26,19,10}, /*IY*/{26,26,19,10} };
    /* ez80 is its OWN bucket, NOT rabbit's: it runs Z80-mode so an sp-slot needs the
       z80-style `ld hl,n; add hl,sp` address formation (DEAR), but it has a native
       16-bit `ld hl,(ix+d)` so an fp slot is CHEAP (fp-adjusted below), and its
       push/pop + `ld ix,nn` + `inc ix` index ops are FAST (not rabbit's dear 19). The
       old RABBIT bucket charged ez80 a dear idx read/write (19) → idx_ben ≤ 0 → G1b
       wrongly rejected beneficial index homes (sp mode). Measured
       z88dk-ticks -mez80_z80 (#asm microbench, empty-loop anchored, cyc): slot-sp
       rd/wr 8 drf 6 rmw~16; slot-fp 2; idx wr 5 drf 4 step 2; bc 2.
       idx READ is now `lea <rr>,<idx>` (3 cyc, one ED op — see emit_idx_word_to_reg)
       not `push;pop` (was 7): so IX/IY READ = 3, cheapening every ez80 index home
       and letting idx_ben value ez80 sp homes correctly (fp slot stays cheaper). */
    static const int EZ80[GR_N][GK_N] = {
        /*SLOT*/{8,8,6,16}, /*BC*/{2,2,2,2}, /*DE*/{2,2,2,2}, /*IX*/{3,5,4,2}, /*IY*/{3,5,4,2} };
    const int (*t)[GK_N] = IS_KC160() ? KC160
                         : IS_EZ80() ? EZ80
                         : IS_RABBIT() ? RABBIT : Z80;
    int c = t[reg][kind];
    if (reg == GR_SLOT) {                             /* fp slot = (ix+d) */
        int fp = (c_framepointer_is_ix != -1);
        if (fp) {
            if (t == Z80    && kind <= GK_WRITE) c = 39;  /* two byte loads: dear */
            else if (t == RABBIT && kind <= GK_WRITE) c = 11; /* slightly dearer than sp */
            else if (t == EZ80) c = (kind == GK_STEP) ? 4 : 2; /* native ld hl,(ix+d): cheap */
        }
    }
    return c;
}
/* Per-vreg depth-weighted access-kind tallies (weight = in-loop?4:1) — the shared
   input to both the divergence probe and the grounded index-benefit gate. A STEP
   (in-place ++/-- : IR_INC/IR_DEC with dst==src[0], or IR_POSTSTEP src[0]) is one
   RMW event, not a separate read+write. Width-2 only. */
static void g0_access_tally(const Func *f, const int *bb_in_loop,
                            long (*tally)[GK_N])
{
    for (int i = 0; i < f->n_bbs; i++) {
        const BB *bb = &f->bbs[i];
        int w = bb_in_loop[i] ? 4 : 1;
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            int step_v = -1;
            if ((o->kind == IR_INC || o->kind == IR_DEC) && o->dst >= 0
                && o->src[0] == o->dst) step_v = o->dst;
            else if (o->kind == IR_POSTSTEP && o->src[0] >= 0) step_v = o->src[0];
            if (step_v >= 0 && step_v < f->n_vregs && f->vregs[step_v].width == 2)
                { tally[step_v][GK_STEP] += w; continue; }   /* RMW; don't double-count */
            if (o->dst >= 0 && o->dst < f->n_vregs && f->vregs[o->dst].width == 2)
                tally[o->dst][GK_WRITE] += w;
            int mem_base = ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                            && o->mem.kind == IR_MEM_VREG) ? o->mem.base : -1;
            int u[16]; int nu = ir_op_uses(o, u, 16);
            for (int k = 0; k < nu; k++) {
                int v = u[k];
                if (v < 0 || v >= f->n_vregs || f->vregs[v].width != 2) continue;
                tally[v][v == mem_base ? GK_DEREF : GK_READ] += w;
            }
        }
    }
}
/* Grounded benefit of homing v in an index register (IX/IY, push/pop value access)
   vs the slot: Σ_kind tally × (slot_cost − idx_cost). ≤ 0 means the index home
   costs MORE than the slot for v (a read-only value on a cheap-slot target) — the
   G1 gate rejects such an index assignment. A stepped counter stays POSITIVE
   (`inc iy` ≪ slot RMW), so this leaves queen-style counters index-homed. */
static long g0_index_benefit(const long *tally_v)
{
    long b = 0;
    for (int k = 0; k < GK_N; k++)
        b += tally_v[k] * (g0_word_cost(GR_SLOT, k) - g0_word_cost(GR_IX, k));
    return b;
}

/* S3 Tier A: pack the born-killed short spill WORD temps that BC couldn't take
   (BC held by a higher-benefit tenant) into IY over DISJOINT tight ranges. The
   first real form of the range allocator (ADR 0017): the born-killed temps
   time-share ONE IY register over non-overlapping sub-ranges, exactly like the
   reduction-pack chain members do — so this reuses the proven IY word lowering
   (push hl;pop iy def via commit_hl_result, push iy;pop hl read via load_to_hl)
   and the prologue IY save (frame_has_saved_iy, keyed on idx3_reg=IY + a vreg
   homed there). IY (not DE) because DE is the lowerer's scratch (`ex de,hl` /
   `add hl,de` nearly every op) so a temp's span is almost never DE-clean.

   Cost gate: an IY value access is push/pop (~19cyc), so it beats a slot only on
   DEAR-slot targets. The grounded g0_index_benefit encodes this (GR_IX == GR_IY
   cost in every table): it fires on z80/z180/z80n (dear sp slot) and is ≤ 0 on
   cheap-slot rabbit/kc160 and marginal-slot ez80, which stay byte-identical.

   The narrow winner is a straight-line-in-loop temp that is COMPUTED (not
   memory-loaded), then STORED across an HL-clobbering gap — there the SPILL
   alternative pays a real store+reload while an IY home survives the clobber.
   The four gates below (in-loop, not a deref base, not LD_MEM-defined,
   HL-clobber gap) exclude the losers: born-killed temps that transit HL
   naturally add only push/pop churn in IY (`sum += a->f` regressed before
   the gates).

   Runs AFTER ir_iy_reduction_pack: a reduction accumulator/chain has first claim
   on IY (it is live the whole loop, saving more), and if it (or an idx2/idxhalf/
   idx3 home) already owns IY we bail — one IY owner in this whole-function model.
   Multi-owner IY interference is a later (Tier B) concern. Born-killed
   disjointness ⇒ no home_lo/hi boundary sync needed. Behaviour-changing;
   fail-safe lowering aborts (long_ir) catch any gap loudly.
   --opt-disable=iy-temp-pack opts out; --reserve-regs-iy disables via
   lra_iy_available. */
static void ir_iy_temp_pack(Func *f, const int *bb_first_op,
                            const int *bb_in_loop, const int *def_kind,
                            const int *write_count, const int *use_count)
{
    if (opt_disabled("iy-temp-pack")) return;
    if (!lra_iy_available(f)) return;
    if (f->n_vregs <= 0) return;

    /* IY already owned (reduction pack, idx2/idxhalf, idx3 proposer)? One IY
       owner per function — leave the temps spilled. */
    if (f->idx3_reg != IR_PR_NONE) return;
    for (int v = 0; v < f->n_vregs; v++) {
        PhysReg p = f->vreg_to_phys[v];
        if (p == IR_PR_IY || p == IR_PR_IYL || p == IR_PR_IYH) return;
    }

    long (*g0t)[GK_N] = calloc((size_t)f->n_vregs, sizeof(*g0t));
    int *itloc = calloc((size_t)f->n_vregs, sizeof(int));
    int *itlo  = calloc((size_t)f->n_vregs, sizeof(int));
    int *ithi  = calloc((size_t)f->n_vregs, sizeof(int));
    PackCand *cand = calloc((size_t)f->n_vregs, sizeof(PackCand));
    if (!g0t || !itloc || !itlo || !ithi || !cand) {
        free(g0t); free(itloc); free(itlo); free(ithi); free(cand); return;
    }
    g0_access_tally(f, bb_in_loop, g0t);
    int nc = collect_bc_temp_cands(f, bb_first_op, def_kind, write_count,
                                   use_count, itloc, itlo, ithi, cand);

    /* Greedy: pack the BC LEFTOVERS (still SPILL) that clear the cost gate into
       IY over disjoint tight ranges. Same flo-ordered non-overlap greedy as
       ir_bc_pack; last_fhi tracks only the IY-packed temps (BC-packed cands ride
       BC, so they don't constrain IY). */
    int packed = 0, last_fhi = -1;
    for (int i = 0; i < nc; i++) {
        int v = cand[i].vreg;
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;      /* BC took it */
        /* IN-LOOP only. An IY home costs a per-CALL prologue save (push iy /
           pop iy) that the isolated g0_index_benefit cannot see. It amortises
           only when the temp spills every loop iteration (the saved per-iter
           slot traffic × trip count ≫ the one-time save); a straight-line temp
           in IY is a net loss. Loop-only also matches ir_iy_reduction_pack's
           scope. */
        if (!bb_in_loop[cand[i].bb]) continue;
        /* Never home a DEREF BASE in IY: unlike BC (where `ld a,(bc)` derefs
           directly) or a slot, an IY-resident pointer needs `push iy; pop hl`
           before EVERY `ld a,(hl)` — the g0 GK_DEREF term models a direct
           (ix+d) access and badly undercounts this. */
        int is_membase = 0;
        for (int b = 0; b < f->n_bbs && !is_membase; b++)
            for (int j = 0; j < f->bbs[b].n_ops; j++) {
                const Op *o = &f->bbs[b].ops[j];
                if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                    && o->mem.kind == IR_MEM_VREG && o->mem.base == v) {
                    is_membase = 1; break;
                }
            }
        if (is_membase) continue;
        /* Reject a memory-LOAD-defined temp: `LD_MEM v <- [ptr]` produces the
           value in HL and it is almost always consumed by an ADJACENT ALU op
           (`add acc,v`) that also wants it in HL. IY is not ALU-addressable, so
           the home forces `push hl;pop iy` then `push iy;pop hl` — a pure round
           trip saving no slot traffic (`sum += a->f`). The
           g0 GK_READ term treats IY like a directly-addressable (ix+d) slot and
           misses this. Register homes pay off for values that must otherwise be
           STORED and RELOADED across an HL-clobbering gap. */
        if (def_kind[v] == IR_LD_MEM) continue;
        if (g0_index_benefit(g0t[v]) <= 0) continue;          /* cheap slot: no win */
        if (cand[i].flo <= last_fhi) continue;                /* overlaps a packed sibling */
        /* Require an HL-CLOBBERING op strictly between the def and the last use.
           This is the missing HL-pressure term: only then does the SPILL
           alternative actually pay a store+reload (HL is needed for the
           intervening work — e.g. computing a store address — so a slotted v
           must be evicted from HL and reloaded). An IY home, immune to the HL
           clobber, wins there (`t = a+b; store [addr], t` with addr computed in
           HL between). With no HL clobber the value simply stays in HL from def
           to use and IY only adds a `push/pop` round trip (an adjacent
           `t = x+y; store [p+4], t`). */
        {
            const BB *gb = &f->bbs[cand[i].bb];
            int glo = cand[i].flo - bb_first_op[cand[i].bb];
            int ghi = cand[i].fhi - bb_first_op[cand[i].bb];
            int hl_gap = 0;
            for (int k = glo + 1; k < ghi && !hl_gap; k++)
                if (op_clobbers(f, &gb->ops[k]) & IR_R_HL) hl_gap = 1;
            if (!hl_gap) continue;
        }
        /* The value must survive in IY across its live span: any op after the
           def that CLOBBERS IY while v is still live would corrupt it. The
           born-killed candidate span is already call-free (collect_bc_temp_cands
           rejects CALL/HCALL/ASM), but check op_clobbers over (def..last-use] to
           be correct-by-construction, mirroring the reduction pack. */
        const BB *bb = &f->bbs[cand[i].bb];
        int lo = cand[i].flo - bb_first_op[cand[i].bb];
        int hi = cand[i].fhi - bb_first_op[cand[i].bb];
        int clean = 1;
        for (int k = lo + 1; k <= hi && clean; k++)
            if (op_clobbers(f, &bb->ops[k]) & IR_R_IY) clean = 0;
        if (!clean) continue;
        f->vreg_to_phys[v] = IR_PR_IY;
        f->idx3_reg = IR_PR_IY;
        last_fhi = cand[i].fhi;
        packed++;
    }
    if (packed && getenv("IR_ALLOC_PROBE"))
        fprintf(stderr, "IY_TEMP_PACK packed=%d of candidates=%d\n", packed, nc);
    free(g0t); free(itloc); free(itlo); free(ithi); free(cand);
}
/* B1 (inert, IR_B1_PROBE): quantitative depth-graded + setup cost term — the
   ranking function the ranged-homing allocator needs. The shipped
   g0_index_benefit weights in-loop accesses BINARY (in_loop?4:1), so a depth-3
   read scores like a depth-1 read — it CANNOT separate a deep-loop counter with
   dear idx READS (→ REJECT idx) from a shallow-loop counter with a cheap STEP
   (→ KEEP idx): identical tallies, opposite optima (the G2 wall). B1 fixes it
   with (a) TRIP^depth depth-grading of the per-iteration term + (b) a one-time
   SETUP benefit paid once at region entry (the `ld ix,nn` index init the slot
   doesn't pay), which tips a SHALLOW-loop counter toward the index even though
   its per-iter benefit is slightly negative.

   Prints per width-2 REGISTER-homed value: g0(binary) benefit vs b1 benefit, the
   keep/reject each implies, the per-depth access split, and the value's
   LIVE-RANGE span [start..end] (the ranged dimension — a value resident only over
   a sub-range frees its register elsewhere). TRIP (IR_B1_TRIP, default 4) and
   SETUP (IR_B1_SETUP, default 12) are tunable so the shallow-KEEP / deep-REJECT
   separation can be calibrated before this is wired into unified_arbitrate. */
static void b1_hotness_probe(const Func *f, const int *bb_loop_depth)
{
    if (!getenv("IR_B1_PROBE")) return;
    if (f->n_vregs <= 0) return;
    const char *te = getenv("IR_B1_TRIP"), *se = getenv("IR_B1_SETUP");
    long TRIP = te ? atol(te) : 4;
    long SETUP = se ? atol(se) : 12;
    if (TRIP < 1) TRIP = 1;
    int line = 0;
    for (int i = 0; i < f->n_bbs && !line; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++)
            if (f->bbs[i].ops[j].line > 0) { line = f->bbs[i].ops[j].line; break; }
    int fp = (c_framepointer_is_ix != -1);
    for (int v = 0; v < f->n_vregs; v++) {
        if (f->vregs[v].width != 2) continue;
        int ph = f->vreg_to_phys[v];
        int areg = ph == IR_PR_BC ? GR_BC : ph == IR_PR_DE ? GR_DE
                 : ph == IR_PR_IX ? GR_IX : ph == IR_PR_IY ? GR_IY : -1;
        if (areg < 0) continue;                     /* only register homes */
        /* Per-depth access tally for v (depth capped at 5). Mirrors g0_access_tally
           kind classification, but keeps the depth so the per-iter term can be
           TRIP^depth-graded rather than binary. */
        long td[6][GK_N] = {{0}};
        long binw[GK_N] = {0};                      /* binary in_loop?4:1 (g0 model) */
        for (int i = 0; i < f->n_bbs; i++) {
            int d = bb_loop_depth[i]; if (d > 5) d = 5;
            int bw = d ? 4 : 1;
            const BB *bb = &f->bbs[i];
            for (int j = 0; j < bb->n_ops; j++) {
                const Op *o = &bb->ops[j];
                int sv = -1;
                if ((o->kind==IR_INC||o->kind==IR_DEC) && o->dst>=0 && o->src[0]==o->dst) sv=o->dst;
                else if (o->kind==IR_POSTSTEP && o->src[0]>=0) sv=o->src[0];
                if (sv==v) { td[d][GK_STEP]++; binw[GK_STEP]+=bw; continue; }
                if (o->dst==v) { td[d][GK_WRITE]++; binw[GK_WRITE]+=bw; }
                int mb = ((o->kind==IR_LD_MEM||o->kind==IR_ST_MEM)&&o->mem.kind==IR_MEM_VREG)?o->mem.base:-1;
                int u[16]; int nu = ir_op_uses(o,u,16);
                for (int k=0;k<nu;k++) if (u[k]==v) {
                    int gk = (v==mb)?GK_DEREF:GK_READ; td[d][gk]++; binw[gk]+=bw;
                }
            }
        }
        /* idx vs slot per-kind benefit (slot_cost - idx_cost); >0 favours the reg. */
        long g0ben = 0, b1iter = 0;
        for (int k = 0; k < GK_N; k++) {
            long diff = g0_word_cost(GR_SLOT,k) - g0_word_cost(GR_IX,k);
            g0ben += binw[k] * diff;
            long w = 1;
            for (int d = 0; d < 6; d++) { b1iter += td[d][k]*w*diff; w *= TRIP; }
        }
        long b1ben = b1iter + SETUP;                /* setup: one-time idx-init advantage */
        const char *rn[GR_N] = {"SLOT","BC","DE","IX","IY"};
        const LiveRange *lr = ir_live_range(f, v);
        int is_idx = (areg == GR_IX || areg == GR_IY);
        if (fp && areg == GR_IX) continue;          /* IX = frame ptr in fp mode */
        fprintf(stderr,
            "B1_PROBE line=%d v%d home=%s span=[%d..%d] g0=%ld(%s) b1=%ld(%s)%s | "
            "d[rd wr st df]: 0[%ld %ld %ld %ld] 1[%ld %ld %ld %ld] 2[%ld %ld %ld %ld] 3[%ld %ld %ld %ld]\n",
            line, v, rn[areg], lr?lr->start:-1, lr?lr->end:-1,
            g0ben, g0ben>0?"keep":"REJECT", b1ben, b1ben>0?"keep":"REJECT",
            is_idx?" IDX":"",
            td[0][GK_READ],td[0][GK_WRITE],td[0][GK_STEP],td[0][GK_DEREF],
            td[1][GK_READ],td[1][GK_WRITE],td[1][GK_STEP],td[1][GK_DEREF],
            td[2][GK_READ],td[2][GK_WRITE],td[2][GK_STEP],td[2][GK_DEREF],
            td[3][GK_READ],td[3][GK_WRITE],td[3][GK_STEP],td[3][GK_DEREF]);
    }
}



/* ===== PHASE 0: interval_benefit — the realisation-aware cost/ranking function
   (RANGED_ALLOC_PLAN.md Phase 0). Inert oracle (IR_ALLOC_ORACLE) for now. =====
   Fixes the (b) failure: an idx-homed value's read cost depends on HOW the target
   realises it, not one flat number. Steps (`inc ix`), deref-bases (`(ix+d)`), and
   reduction RMW (`add iy,de`) never touch HL. A plain value read goes THROUGH HL
   only when the CPU can't read it in place: a compare folds byte-wise via `(ix+d)`
   on z80/z80n, reaches a non-HL pair via `lea`/`ld rr,(idx)` on ez80/kc160 — but
   goes through `ld hl,ix` on rabbit and (no fold → form the pair) on z180.
   Arithmetic must form the pair → through HL everywhere except ez80/kc160. Only
   through-HL reads inside a pointer-walk BB pay the HL-contention penalty. */
static int is_cmp_op(int k)
{
    return k==IR_CMP_EQ||k==IR_CMP_NE||k==IR_CMP_LT||k==IR_CMP_LE
        || k==IR_CMP_GT||k==IR_CMP_GE||k==IR_CMP_ULT||k==IR_CMP_ULE
        || k==IR_CMP_UGT||k==IR_CMP_UGE;
}
static int idx_read_thru_hl(int opk)
{
    if (IS_EZ80() || IS_KC160()) return 0;               /* lea / ld rr,(idx) → non-HL pair */
    if (is_cmp_op(opk)) return !(c_cpu==CPU_Z80 || IS_Z80N()); /* (ix+d) byte-fold on z80/z80n */
    return 1;                                            /* arith / other: form the pair in HL */
}
/* A compared loop counter's cheap spill home: the stack-spill pass homes a
   born-killed single-def word on the STACK TRANSIENT (`pop;dec;push` ≈27 z80 /
   8 ez80 / 6 kc160 / 20 rabbit), far below the frame-slot RMW (g0 GK_STEP ≈92).
   Used ONLY in the arbiter's pairwise BC-contention comparison — never as a
   global rank/threshold (that demoted UNOPPOSED counters). */
static int g0_stack_step(void)
{
    return IS_KC160() ? 6 : IS_EZ80() ? 8 : IS_RABBIT() ? 20 : 27;
}
/* True if v is an in-place-stepped word counter tested against zero / compared to
   drive a branch — a down/up loop counter. Its register `dec rr`/`inc rr` sets no
   flags (needs an extra test) and its spill home is the cheap stack transient, so
   in a BC contest it should yield to a higher-benefit deref-base rather than starve
   it — but ONLY on contention (unopposed it still wants the register). */
/* True if v is used as the base of a VREG-relative memory access (`a[v]`, `*v`) —
   a deref-base has a BC-EXCLUSIVE advantage (`ld a,(bc)` load/store with no pointer
   reload) that a counter's step/read saving cannot match, so it legitimately
   out-bids a compared counter for BC. */
static int is_deref_base(const Func *f, int v)
{
    if (v < 0 || v >= f->n_vregs) return 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if ((o->kind==IR_LD_MEM||o->kind==IR_ST_MEM)
                && o->mem.kind==IR_MEM_VREG && o->mem.base==v)
                return 1;
        }
    }
    return 0;
}
/* True if v is stepped in place (`v++`/`v--`/POSTSTEP base) — a walking pointer or
   counter. A stepped deref-base is a loop-ra walking pointer (its own BC/DE home
   mechanism), not a stable base a counter should be evicted for. */
static int is_stepped(const Func *f, int v)
{
    if (v < 0 || v >= f->n_vregs) return 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if ((o->kind==IR_INC||o->kind==IR_DEC) && o->dst==v && o->src[0]==v)
                return 1;
            if (o->kind==IR_POSTSTEP && o->src[0]==v) return 1;
        }
    }
    return 0;
}
static int is_compared_counter(const Func *f, int v)
{
    if (v < 0 || v >= f->n_vregs || f->vregs[v].width != 2) return 0;
    int stepped = 0, compared = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if ((o->kind==IR_INC||o->kind==IR_DEC) && o->dst==v && o->src[0]==v)
                stepped = 1;
            else if (o->kind==IR_POSTSTEP && o->src[0]==v)
                stepped = 1;
            if (o->kind==IR_BR_ZERO || o->kind==IR_BR_COND) {
                if (o->src[0]==v) compared = 1;
            } else if (is_cmp_op(o->kind)) {
                if (o->src[0]==v || o->src[1]==v) compared = 1;
            }
        }
    }
    return stepped && compared;
}
/* Grounded benefit of homing width-2 v in register class R over the slot, summed
   depth-weighted (TRIP=4 per loop level) with per-op realisation costs + the
   HL-contention penalty for through-HL reads during a pointer walk. >0 = the
   register home wins. This is the Phase-0 ranking function; the ranged
   sub-interval variant (restrict the op scan to [lo,hi]) is Phase 3.
   R is a GR_* index class (GR_IX/GR_IY — identical cost rows). Phase-2 increment
   #1 generalises the realisation-path logic below (idx_read_thru_hl, deref/step
   lowerings) to the non-index classes GR_BC/GR_DE; today only the g0 cost lookups
   are parameterised (GR_IX==GR_IY ⇒ byte-identical to the pre-parameter form). */
static long interval_benefit_x(const Func *f, int v, const int *bb_loop_depth,
                               int R, int discount)
{
    int penc = IS_RABBIT() ? 10 : (c_cpu==CPU_Z180 ? 15 : 0);
    /* Index classes stage value-reads through HL (push/pop or `ld hl,ix`) so pay
       the realisation-path + contention model below. BC/DE are ordinary pairs: a
       value read is a direct `ld l,c;ld h,b` / `ld h,d;ld l,e` reg copy (the g0
       BC/DE READ column already encodes it) — no through-HL staging, no contention,
       no (ix+d) in-place fold. */
    int is_index = (R == GR_IX || R == GR_IY);
    /* discount (contention comparison only): a compared counter in a NON-index pair
       has the cheap stack transient as its spill alternative, so its STEP saving vs
       the register is far smaller than the frame-slot RMW baseline suggests. */
    long step_base = g0_word_cost(GR_SLOT, GK_STEP);
    if (discount && !is_index && is_compared_counter(f, v)) {
        int ss = g0_stack_step();
        if (ss < step_base) step_base = ss;
    }
    long ben = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        int d = bb_loop_depth[b]; long w = 1; for (int i=0;i<d&&i<8;i++) w *= 4;
        const BB *bb = &f->bbs[b];
        int has_deref = 0;
        for (int j=0;j<bb->n_ops&&!has_deref;j++) {
            const Op *o=&bb->ops[j];
            if ((o->kind==IR_LD_MEM||o->kind==IR_ST_MEM)&&o->mem.kind==IR_MEM_VREG) has_deref=1;
        }
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            int sv = -1;
            if ((o->kind==IR_INC||o->kind==IR_DEC)&&o->dst>=0&&o->src[0]==o->dst) sv=o->dst;
            else if (o->kind==IR_POSTSTEP&&o->src[0]>=0) sv=o->src[0];
            if (sv==v) { ben += w*(step_base-g0_word_cost(R,GK_STEP)); continue; }
            /* reduction RMW s=s±x: stays in the index (`add iy,de`), never HL */
            int rmw = (o->dst==v && (o->src[0]==v||o->src[1]==v));
            if (rmw) { ben += w*(step_base-g0_word_cost(R,GK_STEP)); continue; }
            if (o->dst==v) ben += w*(g0_word_cost(GR_SLOT,GK_WRITE)-g0_word_cost(R,GK_WRITE));
            int mb=((o->kind==IR_LD_MEM||o->kind==IR_ST_MEM)&&o->mem.kind==IR_MEM_VREG)?o->mem.base:-1;
            int u[16]; int nu=ir_op_uses(o,u,16);
            for (int k=0;k<nu;k++) if (u[k]==v) {
                if (v==mb)
                    ben += w*(g0_word_cost(GR_SLOT,GK_DEREF)-g0_word_cost(R,GK_DEREF));
                else if (!is_index)                           /* BC/DE: direct reg copy */
                    ben += w*(g0_word_cost(GR_SLOT,GK_READ)-g0_word_cost(R,GK_READ));
                else if (idx_read_thru_hl(o->kind)) {
                    /* DESTINATION-AWARE (Phase 1c): the lowerer stages src[0] in HL,
                       src[1]/other in DE (load_binop_operands). On rabbit reading an
                       idx-homed value INTO HL is the cheap `ld hl,ix` (4); into DE it
                       is the dear `push iy;pop de` (~table). So the src-position picks
                       the cost — a counter compared as src[0]→HL stays cheap → keep;
                       a `mid` index (`base+mid`, src[1]→DE) is dear → its IY home
                       loses to the cheap native `ld de,(ix+d)` fp slot.
                       The contention penalty (HL held by a pointer walk) applies to
                       the HL-consumed reads. z80/z180 through-HL reads stay dear. */
                    int to_hl = (o->src[0] == v);
                    int rc = (IS_RABBIT() && to_hl) ? 4 : g0_word_cost(R,GK_READ);
                    ben += w*(g0_word_cost(GR_SLOT,GK_READ)-rc);
                    if (to_hl && has_deref) ben -= penc*w;   /* HL held by the walk */
                } else                                        /* in-place (ix+d)/lea read */
                    ben += w*(g0_word_cost(GR_SLOT,GK_READ)-g0_word_cost(R,GK_DEREF));
            }
        }
    }
    return ben;
}
/* Default entry (rank/gate/oracle): no contention discount — every existing caller
   keeps the pre-existing benefit, byte-for-byte. The discount is used ONLY by the
   arbiter's pairwise BC-contention comparison. */
static long interval_benefit(const Func *f, int v, const int *bb_loop_depth, int R)
{
    return interval_benefit_x(f, v, bb_loop_depth, R, 0);
}
/* The UNIFIED RANKER (the sole allocator ranking; the old cost_benefit hotness
   heuristic + keep-rules are retired). Rank each candidate
   by the grounded `interval_benefit` of its BEST allowed word-register class,
   replacing the register-AGNOSTIC `cost_benefit[]` hotness key with a register-AWARE
   one (a value on a cheap-slot target values a reg home less → ranks lower). RC_*
   word classes map to GR_* cost columns (GR_IX==GR_IY cost). Byte/exx-only
   candidates (no word class in the mask) keep `cost_benefit` — their byte / alt-bank
   cost model is not yet folded into interval_benefit. Gate-off ⇒ byte-identical. */
static long rank_benefit(const Func *f, int v, unsigned allowed,
                         const long *cost_benefit, const int *bb_loop_depth)
{
    long best = 0; int have = 0;
    if (allowed & RC_BC) {
        long b = interval_benefit(f, v, bb_loop_depth, GR_BC);
        if (!have || b > best) { best = b; have = 1; }
    }
    if (allowed & RC_DE_ACC) {
        long b = interval_benefit(f, v, bb_loop_depth, GR_DE);
        if (!have || b > best) { best = b; have = 1; }
    }
    if (allowed & (RC_IDX2 | RC_IDX3)) {
        long b = interval_benefit(f, v, bb_loop_depth, GR_IX);
        if (!have || b > best) { best = b; have = 1; }
    }
    return have ? best : cost_benefit[v];
}



/* IR_SPILL_WHY (inert) — Stage-0 diagnostic for RANGED homes (TASK6_COLDLOCAL_PLAN.md).
   Per spilled width-1/2 non-param/non-addr-taken local: is it CALL-CROSSING, how many
   calls it crosses vs how many times it is accessed, and the NET single-value byte
   benefit of a ranged home (accesses*acc_bytes − crossings*2 for push/pop). Per
   function: best1 = the one value single-value-BC ranging captures (max net); netpos =
   Σ all net-positive (the ceiling once values SHARE a register); share = netpos − best1
   (what Stage-2 sharing adds). Rough byte model (word access ~4B saved, byte ~2B,
   push/pop ~2B/crossing) — an ESTIMATE to rank levers + pick a small first target, not
   the real cost model (that's g0_word_cost, in cycles). IR_SPILL_WHY=2 prints per-vreg. */
static void ir_spill_why_probe(const Func *f)
{
    if (!getenv("IR_SPILL_WHY")) return;
    int verbose = getenv("IR_SPILL_WHY")[0] == '2';
    /* flat call positions in ir_live_range's sequential op-index space. */
    int ncall = 0;
    for (int b = 0; b < f->n_bbs; b++)
        for (int j = 0; j < f->bbs[b].n_ops; j++) {
            OpKind k = f->bbs[b].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL) ncall++;
        }
    int *callpos = ncall ? malloc((size_t)ncall * sizeof(int)) : NULL;
    if (ncall && !callpos) return;
    { int ci = 0, flat = 0;
      for (int b = 0; b < f->n_bbs; b++)
          for (int j = 0; j < f->bbs[b].n_ops; j++) {
              OpKind k = f->bbs[b].ops[j].kind;
              if (k == IR_CALL || k == IR_HCALL) callpos[ci++] = flat;
              flat++;
          } }
    int best1 = 0, best_v = -1, netpos = 0, ncross = 0;
    int bestw = 0, bestw_v = -1, bestw_refs = 0, bestw_cross = 0;  /* best WORD */
    for (int v = 0; v < f->n_vregs; v++) {
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
        const VReg *vr = &f->vregs[v];
        if (vr->width != 1 && vr->width != 2) continue;
        if (vr->flags & (IR_VREG_PARAM | IR_VREG_ADDR_TAKEN)) continue;
        const LiveRange *r = ir_live_range(f, v);
        if (!r || r->start < 0 || r->end < r->start) continue;
        int refs = 0;
        for (int b = 0; b < f->n_bbs; b++)
            for (int j = 0; j < f->bbs[b].n_ops; j++) {
                const Op *o = &f->bbs[b].ops[j];
                if (o->dst == v) refs++;
                int u[16]; int nu = ir_op_uses(o, u, 16);
                for (int k = 0; k < nu; k++) if (u[k] == v) refs++;
            }
        int cross = 0;
        for (int c = 0; c < ncall; c++)
            if (callpos[c] >= r->start && callpos[c] <= r->end) cross++;
        int acc_bytes = (vr->width == 2) ? 4 : 2;
        int net = refs * acc_bytes - cross * 2;
        if (cross > 0) ncross++;
        if (net > 0) { netpos += net; if (net > best1) { best1 = net; best_v = v; } }
        if (vr->width == 2 && net > bestw) {
            bestw = net; bestw_v = v; bestw_refs = refs; bestw_cross = cross;
        }
        if (verbose && (cross > 0 || net > 0))
            fprintf(stderr, "  v%d w%d refs=%d cross=%d net=%dB %s\n",
                    v, vr->width, refs, cross, net, net > 0 ? "cap" : "neg");
    }
    if (best1 > 8 || bestw > 8)
        fprintf(stderr, "SPILL_WHY %-22s xcross=%d best1=%dB(v%d) netpos=%dB share=%dB "
                "bestWORD=%dB(v%d,refs=%d,xc=%d) vregs=%d\n",
                f->fn ? ir_sym_name(f->fn) : "?", ncross, best1, best_v, netpos,
                netpos - best1, bestw, bestw_v, bestw_refs, bestw_cross, f->n_vregs);
    free(callpos);
}

/* [inert, IR_LDSLOT_WHY=<substr>] TASK #6 FIX #1 probe — "deliver read_l(p)
   straight to its slot, skip DEHL" (HL_ARITH_PLAN.md). The gap is
   pointer-indirect long loads (`read_l(p)`, p=type8*) that 80cc materialises
   into DEHL then spills to a slot (push/park juggle), whereas sdcc writes the 4
   bytes straight to a fixed slot and does memory-operand arith. This probe
   locates the candidate load sites BEFORE codegen: per width-4 IR_LD_MEM whose
   base is a vreg-held pointer (IR_MEM_VREG, no post-step), classify (a) is the
   dst SLOT-homed (would spill — the win case) vs register-resident (PR_DEHL —
   must NOT touch), (b) the FIRST in-BB consumer's shape: width-4 ALU
   (add/sub/and/or/xor — already memory-operand, so slot delivery is a pure
   win), ST_MEM (write_l — the store paired), or other/none. A slot-homed load
   feeding ALU or ST_MEM is a "deliverable" site. Reports per-function and a
   corpus roll-up so the ceiling + consumer mix is known before building the
   gated codegen. Also counts IR_MEM_SYM w4 loads (global longs) separately.
   IR_LDSLOT_WHY=2 prints per-site. Zero codegen effect. */
static void ir_ldslot_why_probe(const Func *f)
{
    const char *e = getenv("IR_LDSLOT_WHY");
    if (!e) return;
    int verbose = e[0] == '2';
    int n_ptr = 0, n_ptr_slot = 0, n_ptr_reg = 0;
    int deliver = 0, c_alu = 0, c_stmem = 0, c_other = 0, c_none = 0;
    int n_sym = 0, n_sym_slot = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if (o->kind != IR_LD_MEM || o->dst < 0) continue;
            if (f->vregs[o->dst].width != 4) continue;
            if (o->mem.kind == IR_MEM_SYM) {
                n_sym++;
                if (f->vreg_to_phys[o->dst] == IR_PR_SPILL) n_sym_slot++;
                continue;
            }
            if (o->mem.kind != IR_MEM_VREG) continue;
            if (o->mem.post_step != 0 || o->mem.base < 0) continue;
            n_ptr++;
            PhysReg ph = f->vreg_to_phys[o->dst];
            int slot = (ph == IR_PR_SPILL);
            int reg  = (ph == IR_PR_DEHL);
            if (slot) n_ptr_slot++;
            if (reg)  n_ptr_reg++;
            /* first in-BB consumer of dst */
            OpKind ck = (OpKind)-1;
            for (int k = j + 1; k < bb->n_ops; k++) {
                const Op *ko = &bb->ops[k];
                int u[16]; int nu = ir_op_uses(ko, u, 16);
                int hit = 0;
                for (int q = 0; q < nu; q++) if (u[q] == o->dst) { hit = 1; break; }
                if (hit) { ck = ko->kind; break; }
            }
            int is_alu = (ck == IR_ADD || ck == IR_SUB || ck == IR_AND
                          || ck == IR_OR || ck == IR_XOR);
            int is_st = (ck == IR_ST_MEM);
            if ((int)ck < 0) c_none++;
            else if (is_alu) c_alu++;
            else if (is_st) c_stmem++;
            else c_other++;
            if (slot && (is_alu || is_st)) deliver++;
            if (verbose)
                fprintf(stderr, "  LDSLOT v%d %s cons=%s %s\n", o->dst,
                        slot ? "SLOT" : reg ? "REG" : "oth",
                        (int)ck < 0 ? "none" : ir_op_name(ck),
                        (slot && (is_alu || is_st)) ? "DELIVER" : "");
        }
    }
    if (n_ptr || n_sym)
        fprintf(stderr, "LDSLOT_WHY %-22s ptr=%d slot=%d reg=%d deliver=%d "
                "[alu=%d st=%d oth=%d none=%d] sym=%d(slot=%d)\n",
                f->fn ? ir_sym_name(f->fn) : "?", n_ptr, n_ptr_slot, n_ptr_reg,
                deliver, c_alu, c_stmem, c_other, c_none, n_sym, n_sym_slot);
}

/* [inert, IR_OPRES_WHY] Phase-2 operand-residency probe (OPERAND_RESIDENCY_SPEC.md).
   Quantifies the Regime-A population before any codegen: a width-2 vreg V whose def
   is a deref (IR_LD_MEM) or a binop (ADD/SUB/AND/OR/XOR), which is SPILLED (so it
   materialises in HL then `push hl` to survive), reused (>=2 uses or a cross-BB use),
   and for which DE is FREE across V's live range (no IR_PR_DE-homed vreg overlaps).
   These are exactly the values sdcc keeps in DE (`sbc hl,de`) that 80cc spills.
   Regime-B (DE busy) counted separately: it must NOT be steered.
   Reports per-function + the ~2 B/value ceiling. IR_OPRES_WHY=2 prints per-vreg.
   Zero codegen effect. */
static void ir_opres_why_probe(const Func *f)
{
    const char *e = getenv("IR_OPRES_WHY");
    if (!e) return;
    int verbose = e[0] == '2';
    int nv = f->n_vregs;
    if (nv <= 0) return;
    int pop = 0, regA = 0, regB = 0, regB_flip = 0, regB_conv = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *o = &bb->ops[j];
            if (o->dst < 0) continue;
            int V = o->dst;
            if (f->vregs[V].width != 2) continue;
            int is_deref = (o->kind == IR_LD_MEM);
            int is_binop = (o->kind == IR_ADD || o->kind == IR_SUB
                            || o->kind == IR_AND || o->kind == IR_OR
                            || o->kind == IR_XOR);
            if (!is_deref && !is_binop) continue;
            if (f->vreg_to_phys[V] != IR_PR_SPILL) continue;
            /* reused? (>=2 uses, or any cross-BB use) — else no preservation needed */
            int uses = 0, cross = 0;
            for (int b2 = 0; b2 < f->n_bbs; b2++)
                for (int k = 0; k < f->bbs[b2].n_ops; k++) {
                    int u[16]; int nu = ir_op_uses(&f->bbs[b2].ops[k], u, 16);
                    for (int q = 0; q < nu; q++)
                        if (u[q] == V) { uses++; if (b2 != b) cross = 1; }
                }
            if (uses < 2 && !cross) continue;
            pop++;
            /* DE free across V's range? find the blocking DE-homed vreg W. */
            int de_free = 1, blocker = -1;
            for (int w = 0; w < nv; w++) {
                if (w == V) continue;
                if (f->vreg_to_phys[w] != IR_PR_DE) continue;
                if (ir_live_ranges_overlap(f, V, w)) { de_free = 0; blocker = w; break; }
            }
            if (de_free) { regA++;
                if (verbose)
                    fprintf(stderr, "  OPRES v%d %s uses=%d DE-FREE(A)\n", V,
                            is_deref ? "deref" : "binop", uses);
                continue;
            }
            /* Regime B: could the blocker W relocate to BC (BC whole-range free
               for W)? Then the flip is a clean net win — V gets DE, W→BC, no
               spill. This is the rebalance-benefit estimate (increment 1b): the
               DE-busy cases are mostly 80cc's own choice, not hard constraints. */
            int bc_free = 1;
            for (int x = 0; x < nv && bc_free; x++) {
                if (x == blocker) continue;
                if (f->vreg_to_phys[x] != IR_PR_BC) continue;
                if (ir_live_ranges_overlap(f, blocker, x)) bc_free = 0;
            }
            regB++;
            if (bc_free) regB_flip++;
            /* Increment 1c: SUB-RANGE pressure — the real feasibility test. Max #
               of word (width-2) vregs competing for HL/DE/BC that are
               simultaneously live at any point in V's range (idx-homed excluded).
               <=3 ⇒ a feasible HL/DE/BC assignment gives V a pair (convertible,
               even if whole-range "busy"); >3 ⇒ genuine pressure. */
            const LiveRange *rV = ir_live_range(f, V);
            int convertible = 0;
            if (rV && rV->start >= 0) {
                int maxp = 0;
                for (int p = rV->start; p <= rV->end; p++) {
                    int live = 0;
                    for (int w = 0; w < nv; w++) {
                        if (f->vregs[w].width != 2) continue;
                        PhysReg ph = f->vreg_to_phys[w];
                        /* only HL/DE/BC-competing homes — frame-resident (spill)
                           and idx (IX/IY) values don't occupy a GP pair */
                        if (ph != IR_PR_HL && ph != IR_PR_DE && ph != IR_PR_BC)
                            continue;
                        const LiveRange *r = ir_live_range(f, w);
                        if (!r || r->start < 0) continue;
                        if (r->start <= p && p <= r->end) live++;
                    }
                    if (live > maxp) maxp = live;
                }
                convertible = (maxp <= 3);
            }
            if (convertible) regB_conv++;
            if (verbose)
                fprintf(stderr, "  OPRES v%d %s uses=%d DE-busy(B) blocker=v%d "
                        "%s %s\n", V, is_deref ? "deref" : "binop", uses, blocker,
                        bc_free ? "FLIP(BC-free)" : "hard(BC-busy)",
                        convertible ? "CONVERTIBLE(pressure<=3)" : "pressured");
        }
    }
    if (pop)
        fprintf(stderr, "OPRES_WHY %-22s reused=%d A=%d B=%d flip=%d conv=%d "
                "ceil: whole~%dB subrange~%dB\n",
                f->fn ? ir_sym_name(f->fn) : "?", pop, regA, regB, regB_flip,
                regB_conv, (regA + regB_flip) * 2, (regA + regB_conv) * 2);
}



void ir_alloc(Func *f)
{
    if (!f) return;
    free(f->vreg_to_phys);
    f->vreg_to_phys = NULL;
    free(f->home_lo); f->home_lo = NULL;
    free(f->home_hi); f->home_hi = NULL;
    free(f->de_fold_hint); f->de_fold_hint = NULL;
    if (f->n_vregs <= 0) return;
    f->vreg_to_phys = calloc((size_t)f->n_vregs, sizeof(*f->vreg_to_phys));
    f->home_lo = calloc((size_t)f->n_vregs, sizeof(*f->home_lo));
    f->home_hi = calloc((size_t)f->n_vregs, sizeof(*f->home_hi));
    f->de_fold_hint = calloc((size_t)f->n_vregs, sizeof(*f->de_fold_hint));
    if (!f->vreg_to_phys || !f->home_lo || !f->home_hi || !f->de_fold_hint) return;

    /* Default: every vreg gets a slot, then narrow to the register
       pools below. Ranged-residency intervals default to whole-function
       (home_at == vreg_to_phys everywhere) until the ranged pack narrows them. */
    for (int v = 0; v < f->n_vregs; v++) {
        f->vreg_to_phys[v] = IR_PR_SPILL;
        f->home_lo[v] = INT_MIN;
        f->home_hi[v] = INT_MAX;
    }

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
           pass non-overlap yet clobber BC every iteration. */
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
           outer value sits in a register.
           depth 0 → 1, depth 1 → 4 (identical to the old flat in-loop×4, so
           functions with no nesting deeper than one loop stay byte-identical);
           depth n → 4^n, capped. IR_NO_DEPTH_WEIGHT restores the flat weight. */
        int depth_flat = opt_disabled("depth-weight");
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
        /* Register-residency ORCHESTRATOR (the sole placement path). Collects ALL
           proposers into one pool and assigns via the single cost-model-ranked
           cross-class arbiter. (The old per-class proposer/arbiter fallback —
           --opt-disable=orchestrator — was retired: the orchestrator has been the
           validated default for a long time, and the dual path only complicated the
           interactions the unified allocator is consolidating.) */
        {
            Cand *pool = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1) * 6,
                                sizeof(Cand));
            if (pool) {
                /* B4 increment 3: one generator emits ALL candidates (in the
                   former proposer order + tags), calling the class realizability
                   predicates directly — the 7 *_propose wrappers are retired. */
                int np = collect_home_candidates(f, use_count, write_count,
                                                 def_kind, all_defs_ok,
                                                 has_prepushed_call, entry_live,
                                                 bb_in_loop, first_use, last_use,
                                                 pool);
                /* B4 (inert, IR_HR_CHECK): home_realizable == pool membership? */
                hr_agreement_check(f, pool, np, use_count, write_count,
                                   def_kind, all_defs_ok, has_prepushed_call,
                                   entry_live, bb_in_loop);
                /* Rank each candidate by the grounded interval_benefit of its best
                   allowed register class (rank_benefit) — the unified cost model that
                   replaced the old cost_benefit hotness heuristic + keep-rules as the
                   selection mechanism ("tuning = costs, not passes"). Byte/exx-only
                   candidates still fall back to cost_benefit inside rank_benefit. */
                for (int i = 0; i < np; i++)
                    pool[i].benefit = rank_benefit(f, pool[i].vreg, pool[i].allowed,
                                                   cost_benefit, bb_loop_depth);
                /* Index gate (DEFAULT-ON; --opt-disable=graph-alloc removes it →
                   pre-gate codegen). Driven by the realisation-aware interval_benefit
                   (RANGED_ALLOC_PLAN Phase 0-1c): reject an index home whose grounded
                   per-(access-kind × register × target × mode) cost — with the
                   consumer-direction idx-read classification (src[0]→HL cheap,
                   src[1]→DE dear) and the HL-contention term — loses to the slot.
                   Reproduces the old conservative-cost + keep-rule heuristic
                   byte-identically in sp on all CPUs and improves fp (z180 matrix
                   −4.76%, ez80 struct −2.09%); the keep-rule is subsumed. */
                long *idx_ben = NULL;
                if (!opt_disabled("graph-alloc")) {
                    idx_ben = calloc((size_t)f->n_vregs, sizeof(long));
                    if (idx_ben)
                        for (int v = 0; v < f->n_vregs; v++)
                            idx_ben[v] = interval_benefit(f, v, bb_loop_depth, GR_IX);
                }
                unified_arbitrate(f, pool, np, idx_ben, NULL, bb_loop_depth);
                free(idx_ben);
                free(pool);
            }
        }
        /* Live-range packing of call-free word temps into BC (default on,
           --opt-disable=bc-pack opts out) — a second pass over the SPILL losers
           using tight per-op intervals. Runs after every register class is placed
           so it only claims BC where no loop home owns it. ir_bc_pack folds in the
           5a cost-benefit eviction (default on, --opt-disable=bc-evict): it may
           first evict a picker-placed BC tenant that a denser disjoint temp group
           out-benefits, then pack the freed BC. */
        ir_bc_pack(f, first_use, last_use, bb_first_op, def_kind,
                   write_count, use_count, cost_benefit);
        /* LRA Phase 2c (default on, IR_NO_LRA opts out): home a DE-dirty
           reduction chain in IY (add iy,de), taking the spill losers BC couldn't. */
        ir_iy_reduction_pack(f, bb_in_loop, use_count);
        /* S3 Tier A (default on, --opt-disable=iy-temp-pack opts out): pack the
           born-killed word temps BC declined into IY over disjoint ranges, if a
           reduction pack didn't already claim IY. Cost-gated to dear-slot CPUs. */
        ir_iy_temp_pack(f, bb_first_op, bb_in_loop, def_kind, write_count, use_count);
        /* Stack-transient spill (default on, IR_NO_STACK_SPILL opts out): the register-pressure
           fallback below BC-pack — a single-def/single-use word transient with
           no register free goes on the stack (push/pop) instead of a slot. */
        ir_stack_spill(f, bb_first_op, def_kind, write_count);
        /* DENSITY §4 fail-safe DE-cache fold hint (opt-in IR_RANGED). Runs after
           ALL register placement so it fires ONLY on reused deref/binop values
           that stayed IR_PR_SPILL. The lowerer reads f->de_fold_hint and leaves a
           DE cache at the def; the value's slot stays coherent so any DE clobber
           falls back to it (byte-safe by construction).
           DEAR-SLOT COST GATE: the DE cache replaces a SLOT read, so it only pays
           where the slot is DEAR relative to DE. On cheap-slot CPUs (ez80 native
           `ld hl,(ix+d)`=2, kc160=4, rabbit `ld hl,ix`=9) the fixed `ld d,h;ld e,l`
           copy is dead overhead → the whole-corpus split (ez80/rabbit/kc160
           regressed +19..+48B, z80/z180/808x/gbz80 won −5..−29B). Same `≥15`
           dear-slot threshold the BC counter→deref-base yield uses (deref_gap). */
        if (ranged_on() && f->de_fold_hint
            && g0_word_cost(GR_SLOT, GK_READ) - g0_word_cost(GR_DE, GK_READ) >= 15) {
            int *wd_base_h = calloc((size_t)f->n_vregs, sizeof(int));
            if (wd_base_h) {
                scan_wd_props(f, bb_in_loop, wd_base_h, NULL, NULL, NULL);
                for (int v = 0; v < f->n_vregs; v++)
                    if (de_operand_realizable(f, v, use_count, write_count,
                                              def_kind, wd_base_h)
                        && de_fold_pays(f, v))
                        f->de_fold_hint[v] = 1;
                free(wd_base_h);
            }
        }
        b1_hotness_probe(f, bb_loop_depth);
        /* [IR_OPRES_PROBE] INERT — size the operand-residency (address/word-temp)
           lever on the CURRENT tree (refreshes OPERAND_RESIDENCY_SPEC's July
           numbers). Population = reused deref/binop RESULT values the allocator
           left SPILL (they funnel through HL then spill+reload). Tiers:
             de_free       = no DE/BC GP-pair home overlaps V's whole range
                             (Regime-A, buildable on the whole-range model);
             de_or_bc_free = a DE or BC pair is whole-range-free (Tier-1 ceiling);
             convertible   = POINT pressure <=2 GP-pair (HL/DE/BC) homes anywhere
                             in V's range, so a 3rd pair is free for V at every
                             point (Increment-1c sub-range ceiling — the meat that
                             needs ranged/split homing). No codegen change. */
        if (getenv("IR_OPRES_PROBE")) {
            int nv = f->n_vregs;
            int *wdb = calloc((size_t)(nv > 0 ? nv : 1), sizeof(int));
            if (wdb) scan_wd_props(f, bb_in_loop, wdb, NULL, NULL, NULL);
            int cand = 0, de_free = 0, de_or_bc_free = 0, conv = 0;
            for (int v = 0; v < nv; v++) {
                const VReg *vr = &f->vregs[v];
                if (vr->width != 2) continue;
                if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                                 | IR_VREG_PARAM)) continue;
                if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                if (wdb && wdb[v]) continue;                /* not a deref base */
                if (write_count[v] > 1 || use_count[v] < 2) continue;
                int dk = def_kind[v];
                if (!(dk == IR_LD_MEM || dk == IR_ADD || dk == IR_SUB
                      || dk == IR_AND || dk == IR_OR || dk == IR_XOR)) continue;
                int lo = first_use[v], hi = last_use[v];
                if (lo < 0 || hi < 0 || hi < lo) continue;
                cand++;
                /* whole-range interference vs DE/BC GP homes */
                int de_busy = 0, bc_busy = 0;
                for (int w = 0; w < nv; w++) {
                    if (w == v) continue;
                    int ph = f->vreg_to_phys[w];
                    if (ph != IR_PR_DE && ph != IR_PR_BC) continue;
                    if (first_use[w] < 0 || last_use[w] < 0) continue;
                    int s = lo > first_use[w] ? lo : first_use[w];
                    int e = hi < last_use[w] ? hi : last_use[w];
                    if (s <= e) { if (ph == IR_PR_DE) de_busy = 1; else bc_busy = 1; }
                }
                if (!de_busy) de_free++;
                if (!de_busy || !bc_busy) de_or_bc_free++;
                /* Sub-range ceiling (Increment-1c): peak simultaneous HL/DE/BC word
                   homes over V's TRUE live range (ir_live_range, NOT the allocator's
                   loop-extended first/last_use — loop extension overstates liveness
                   and hides the sub-range room a split allocator could exploit).
                   peak<=2 ⇒ a 3rd GP pair is free at every point ⇒ convertible. */
                const LiveRange *lrv = ir_live_range(f, v);
                if (lrv && lrv->start >= 0) {
                    int tlo = lrv->start, thi = lrv->end;
                    int span = thi - tlo + 1;
                    int *cov = span > 0 ? calloc((size_t)span, sizeof(int)) : NULL;
                    if (cov) {
                        for (int w = 0; w < nv; w++) {
                            if (w == v) continue;
                            int ph = f->vreg_to_phys[w];
                            if (ph != IR_PR_HL && ph != IR_PR_DE && ph != IR_PR_BC)
                                continue;
                            const LiveRange *lw = ir_live_range(f, w);
                            if (!lw || lw->start < 0) continue;
                            int a = lw->start > tlo ? lw->start : tlo;
                            int b = lw->end   < thi ? lw->end   : thi;
                            if (a > b) continue;
                            cov[a - tlo]++;
                            if (b - tlo + 1 < span) cov[b - tlo + 1]--;
                        }
                        int run = 0, peak = 0;
                        for (int k = 0; k < span; k++) { run += cov[k]; if (run > peak) peak = run; }
                        if (peak <= 2) conv++;
                        free(cov);
                    }
                }
            }
            free(wdb);
            if (cand > 0)
                fprintf(stderr, "OPRESPROBE %s cand=%d de_free=%d de_or_bc_free=%d "
                        "convertible=%d\n", f->fn ? ir_sym_name(f->fn) : "?",
                        cand, de_free, de_or_bc_free, conv);
        }
        /* [IR_GPHOME_PROBE / IR_SPLIT_PROBE] INERT — size call-bounded live-range
           SPLITTING (RANGED_CALLSPLIT_PLAN.md §7). Population = width-2 spilled
           reused (use_count>=2) non-param/addr-taken/volatile locals — the values a
           general (non-role-specialised) BC/DE proposer could home.
             GPHOME: free_pair = no other BC/DE-homed vreg's [first_use,last_use]
               overlaps V's [lo,hi]; call-free = no IR_CALL/IR_HCALL global index in
               [lo,hi]. Reports spilled / free_pair / free_pair_callfree — showing
               caller-clobber (not specialisation) is the whole-range limiter.
             SPLIT: for the call-CROSSING free-pair values, walk V's refs and reset a
               running count at each call → max refs in any call-free span; reports
               call_crossing / span_ge2 / span_ge3 — the splittable residue. */
        if (getenv("IR_GPHOME_PROBE") || getenv("IR_SPLIT_PROBE")) {
            int nv = f->n_vregs;
            /* Call positions in the allocator's global op-index space (same space
               first_use/last_use live in: bb_first_op[b] + j). */
            int ncall = 0;
            for (int b = 0; b < f->n_bbs; b++)
                for (int j = 0; j < f->bbs[b].n_ops; j++) {
                    OpKind k = f->bbs[b].ops[j].kind;
                    if (k == IR_CALL || k == IR_HCALL) ncall++;
                }
            int *callpos = ncall ? malloc((size_t)ncall * sizeof(int)) : NULL;
            if (!(ncall && !callpos)) {
                int ci = 0;
                for (int b = 0; b < f->n_bbs; b++)
                    for (int j = 0; j < f->bbs[b].n_ops; j++) {
                        OpKind k = f->bbs[b].ops[j].kind;
                        if (k == IR_CALL || k == IR_HCALL)
                            callpos[ci++] = bb_first_op[b] + j;
                    }
                int spilled = 0, free_pair = 0, free_pair_callfree = 0;
                int call_crossing = 0, span_ge2 = 0, span_ge3 = 0;
                for (int v = 0; v < nv; v++) {
                    const VReg *vr = &f->vregs[v];
                    if (vr->width != 2) continue;
                    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                                     | IR_VREG_PARAM)) continue;
                    if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                    if (use_count[v] < 2) continue;
                    int lo = first_use[v], hi = last_use[v];
                    if (lo < 0 || hi < 0 || hi < lo) continue;
                    spilled++;
                    /* whole-range interference vs DE/BC GP homes (tracked
                       separately: "free pair" = at least ONE of BC/DE is free
                       over V's whole range — the splittable-if-one-pair-free
                       population the plan's §2 narrative counts). */
                    int de_busy = 0, bc_busy = 0;
                    for (int w = 0; w < nv; w++) {
                        if (w == v) continue;
                        int ph = f->vreg_to_phys[w];
                        if (ph != IR_PR_DE && ph != IR_PR_BC) continue;
                        if (first_use[w] < 0 || last_use[w] < 0) continue;
                        int s = lo > first_use[w] ? lo : first_use[w];
                        int e = hi < last_use[w] ? hi : last_use[w];
                        if (s <= e) { if (ph == IR_PR_DE) de_busy = 1; else bc_busy = 1; }
                    }
                    int pair_busy = de_busy && bc_busy;   /* NEITHER pair free */
                    int callfree = 1;
                    for (int c = 0; c < ncall; c++)
                        if (callpos[c] >= lo && callpos[c] <= hi) { callfree = 0; break; }
                    if (!pair_busy) {
                        free_pair++;
                        if (callfree) free_pair_callfree++;
                        if (!callfree) {
                            /* SPLIT: max USES (reads) in any call-free sub-span of
                               [lo,hi]. Reads — not defs — are what the post-call
                               reload amortises (a def writes the reg directly), so
                               the ≥3-use gate counts ir_op_uses members only. */
                            call_crossing++;
                            int cur = 0, maxspan = 0;
                            for (int b = 0; b < f->n_bbs; b++)
                                for (int j = 0; j < f->bbs[b].n_ops; j++) {
                                    int g = bb_first_op[b] + j;
                                    if (g < lo || g > hi) continue;
                                    const Op *o = &f->bbs[b].ops[j];
                                    if (o->kind == IR_CALL || o->kind == IR_HCALL) {
                                        cur = 0; continue;
                                    }
                                    int u[16]; int nu = ir_op_uses(o, u, 16);
                                    for (int k = 0; k < nu; k++)
                                        if (u[k] == v) cur++;
                                    if (cur > maxspan) maxspan = cur;
                                }
                            if (maxspan >= 2) span_ge2++;
                            if (maxspan >= 3) span_ge3++;
                            /* IR_SPLIT_PROBE=2: per-candidate detail for picking a
                               Phase-1 target — vreg, max uses in a call-free span,
                               def kind, allocator interval, and whether V is DEF'd
                               inside the richest span (no entry reload needed). */
                            const char *sv = getenv("IR_SPLIT_PROBE");
                            if (sv && sv[0] == '2' && maxspan >= 3)
                                fprintf(stderr, "  splitcand %s v%d maxuses=%d "
                                        "dk=%d lo=%d hi=%d wc=%d uc=%d\n",
                                        f->fn ? ir_sym_name(f->fn) : "?", v, maxspan,
                                        def_kind[v], lo, hi, write_count[v],
                                        use_count[v]);
                        }
                    }
                }
                if (getenv("IR_GPHOME_PROBE") && spilled > 0)
                    fprintf(stderr, "GPHOMEPROBE %s spilled=%d free_pair=%d "
                            "free_pair_callfree=%d\n", f->fn ? ir_sym_name(f->fn) : "?",
                            spilled, free_pair, free_pair_callfree);
                if (getenv("IR_SPLIT_PROBE") && call_crossing > 0)
                    fprintf(stderr, "SPLITPROBE %s call_crossing=%d span_ge2=%d "
                            "span_ge3=%d\n", f->fn ? ir_sym_name(f->fn) : "?",
                            call_crossing, span_ge2, span_ge3);
            }
            free(callpos);
        }
        /* [IR_CALLSPLIT] Phase-1 call-bounded live-range splitting (opt-in).
           For a spilled reused width-2 value with a call-free span of >=3 READS
           and NO write inside that span, make it BC-resident across the span:
           set vreg_to_phys=IR_PR_BC + home_lo/hi (op-index) + IR_VREG_CALL_SPLIT.
           ir_home_at then serves in-span reads from BC (entry reload via
           emit_bc_reload on a cold belief) and out-of-span accesses from the
           slot; ir_assign_slots keeps the slot. Read-only-in-span ⇒ the slot
           never diverges ⇒ no exit spill, correct by construction (a WRITTEN-in-
           span value would need def→BC + exit-spill machinery — Phase 2).
           CPU cost gate (§2.1): only pays where a frame-slot read is DEAR
           relative to BC (dear-slot z80/z180/808x); cheap-slot CPUs (ez80/kc160/
           rabbit) self-suppress → byte-identical. */
        if (callsplit_on()
            && g0_word_cost(GR_SLOT, GK_READ) - g0_word_cost(GR_BC, GK_READ) >= 15) {
            int nv = f->n_vregs;
            /* Call positions in the allocator's global op-index space. */
            int ncall = 0;
            for (int b = 0; b < f->n_bbs; b++)
                for (int j = 0; j < f->bbs[b].n_ops; j++) {
                    OpKind k = f->bbs[b].ops[j].kind;
                    if (k == IR_CALL || k == IR_HCALL) ncall++;
                }
            int *callpos = ncall ? malloc((size_t)ncall * sizeof(int)) : NULL;
            /* Deref-base map: a pointer used as a deref base is read straight out
               of BC (`ld a,(bc)`) with no load_to_* reload, so an opportunistic
               BC cache can't serve it — exclude (Phase-1 read-only-via-load class). */
            int *wdb = calloc((size_t)(nv > 0 ? nv : 1), sizeof(int));
            if (wdb) scan_wd_props(f, bb_in_loop, wdb, NULL, NULL, NULL);
            if (!(ncall && !callpos)) {
                int ci = 0;
                for (int b = 0; b < f->n_bbs; b++)
                    for (int j = 0; j < f->bbs[b].n_ops; j++) {
                        OpKind k = f->bbs[b].ops[j].kind;
                        if (k == IR_CALL || k == IR_HCALL)
                            callpos[ci++] = bb_first_op[b] + j;
                    }
                for (int v = 0; v < nv; v++) {
                    const VReg *vr = &f->vregs[v];
                    if (vr->width != 2) continue;
                    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                                     | IR_VREG_PARAM)) continue;
                    if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                    if (wdb && wdb[v]) continue;         /* deref base — direct (bc) */
                    if (use_count[v] < 2) continue;
                    int lo = first_use[v], hi = last_use[v];
                    if (lo < 0 || hi < 0 || hi < lo) continue;
                    /* Must CROSS a call. Extending to loop-carried multi-BB
                       values (GENERAL_LOOP_HOME_PLAN Phase 1a) was a NO-OP: the
                       only new BC-free-safe admit was ptrbench init_data v1 —
                       the same 0-byte Phase-4 mirage (multi-BB but cache-served).
                       The tractable BC-free subset is exhausted; the rest of the
                       A_loopMB=48 is DE-free (needs a DE-home path) or deref-base/
                       stepped pointer groups (the hard, GEP-CSE / coloring case).
                       The win is call-bounded, as measured. */
                    int crosses = 0;
                    for (int c = 0; c < ncall; c++)
                        if (callpos[c] >= lo && callpos[c] <= hi) { crosses = 1; break; }
                    if (!crosses) continue;
                    /* Richest call-free span: max reads, [first_read,last_read]. */
                    int best_reads = 0, best_lo = -1, best_hi = -1;
                    int cur = 0, cfirst = -1, clast = -1;
                    for (int b = 0; b < f->n_bbs; b++)
                        for (int j = 0; j < f->bbs[b].n_ops; j++) {
                            const Op *o = &f->bbs[b].ops[j];
                            if (o->kind == IR_CALL || o->kind == IR_HCALL) {
                                if (cur > best_reads) {
                                    best_reads = cur; best_lo = cfirst; best_hi = clast;
                                }
                                cur = 0; cfirst = -1; clast = -1;
                                continue;
                            }
                            int g = bb_first_op[b] + j;
                            int u[16]; int nu = ir_op_uses(o, u, 16);
                            for (int k = 0; k < nu; k++)
                                if (u[k] == v) {
                                    cur++;
                                    if (cfirst < 0) cfirst = g;
                                    clast = g;
                                }
                        }
                    if (cur > best_reads) {
                        best_reads = cur; best_lo = cfirst; best_hi = clast;
                    }
                    /* ≥3 reads is the BYTE-correct floor. The per-span CYCLE benefit
                       (§2.1) turns positive at N≥2 on dear-slot CPUs, but a 2-read
                       span REGRESSES bytes (sortbench +20/+32): the entry reload
                       `ld bc,(slot); ld hl,bc` isn't amortised over only 2 reuses.
                       Density is the primary metric, so keep ≥3; the ≥15 CPU gate
                       above already byte-suppresses cheap-slot CPUs. */
                    if (best_reads < 3 || best_lo < 0 || best_hi < best_lo) continue;
                    /* Reject the span if, inside [best_lo,best_hi], V is consumed
                       by an op that reads BC DIRECTLY (compare/branch-test/step/
                       fused/deref) rather than through load_to_hl/load_to_de: those
                       paths don't reload a cold BC belief, so they'd read
                       stale/garbage BC. Only load-based binop/mov/store consumers
                       reload on first access and are safe.
                       In-span WRITES are now ALLOWED (Phase 2 write-both): an
                       in-span def writes BOTH the slot (canonical home, kept
                       coherent) and BC (cheap-read cache), so the slot never
                       diverges — same safety as the read-only case, no exit spill.
                       unsafe_write is still tracked (diagnostics) but not a
                       rejection. */
                    int unsafe_write = 0, unsafe_consumer = 0, unsafe_kind = -1;
                    for (int b = 0; b < f->n_bbs; b++)
                        for (int j = 0; j < f->bbs[b].n_ops; j++) {
                            int g = bb_first_op[b] + j;
                            if (g < best_lo || g > best_hi) continue;
                            const Op *o = &f->bbs[b].ops[j];
                            int dd[8]; int nd = ir_op_defs(o, dd, 8);
                            for (int k = 0; k < nd; k++)
                                if (dd[k] == v) unsafe_write = 1;
                            if (o->kind == IR_POSTSTEP && o->src[0] == v)
                                unsafe_write = 1;
                            /* Direct-BC-read consumers: reject if V is a source.
                               Plain compares (IR_CMP_*) are ADMITTED — cmp_byte_src
                               is safe for a slot-backed split value: it reads BC
                               halves only on a WARM belief (which holds v by the
                               cache invariant), and on a COLD belief reads the
                               coherent slot (fp `(ix+d)`, class 2) or returns 0 so
                               the fused compare bails to the general load_to_*
                               reload (sp). Phase-2c's fp miscompile was NOT the
                               compare — it was the in-place `inc bc` (gpderef p++)
                               skipping the write-both slot store, so the slot went
                               stale and the out-of-span compare read it; fixed in
                               gen_inc (exclude CALL_SPLIT from the in-place bump).
                               Still excluded: deref/step/branch/fused kinds that
                               read BC INLINE with no slot fallback. */
                            switch (o->kind) {
                            case IR_BR_COND: case IR_BR_ZERO:
                            case IR_POSTSTEP: case IR_LEA:
                            case IR_DEREF_CMP_BR: case IR_ACC_CMP:
                            case IR_COPY_STEP_BRZ: {
                                int uu[16]; int nu = ir_op_uses(o, uu, 16);
                                for (int k = 0; k < nu; k++)
                                    if (uu[k] == v) {
                                        unsafe_consumer = 1;
                                        if (unsafe_kind < 0) unsafe_kind = (int)o->kind;
                                    }
                                break;
                            }
                            default: break;
                            }
                        }
                    int span_unsafe = unsafe_consumer;   /* writes are write-both */
                    (void)unsafe_write;                  /* tracked for diagnostics */
                    const char *cslog = getenv("IR_CALLSPLIT_LOG");
                    int cslog2 = cslog && cslog[0] == '2';
                    if (span_unsafe) {
                        if (cslog2) fprintf(stderr, "  cs-reject %s v%d unsafe "
                            "write=%d consumer=%d ckind=%d reads=%d span=[%d,%d]\n",
                            f->fn?ir_sym_name(f->fn):"?", v, unsafe_write,
                            unsafe_consumer, unsafe_kind, best_reads,
                            best_lo, best_hi);
                        continue;
                    }
                    /* BC must be free over the span — no other BC-homed vreg is
                       actually LIVE there. Use the TENANT's TRUE live range
                       (ir_live_range), NOT the allocator's loop-extended
                       first_use/last_use: a born-killed per-iteration BC temp
                       (e.g. a 2-op multiply operand) has its interval blown up to
                       the whole loop by loop-extension, which spuriously blocks a
                       split whose span is disjoint from the temp's real use. The
                       tight per-op BC packer (ir_bc_pack) already time-multiplexes
                       BC across disjoint tight ranges within a loop, so true-range
                       disjointness is the sound test. A loop-CARRIED BC value has a
                       true range spanning the loop, so it still (correctly) blocks.
                       Correctness holds regardless of the win: a stray BC clobber
                       just forces a reload from the coherent slot. */
                    int bc_busy = 0, bc_blocker = -1;
                    for (int w = 0; w < nv && !bc_busy; w++) {
                        if (w == v) continue;
                        if (f->vreg_to_phys[w] != IR_PR_BC) continue;
                        const LiveRange *lw = ir_live_range(f, w);
                        int wlo, whi;
                        if (lw && lw->start >= 0) { wlo = lw->start; whi = lw->end; }
                        else { wlo = first_use[w]; whi = last_use[w]; }  /* fallback */
                        if (wlo < 0 || whi < 0) continue;
                        int s = best_lo > wlo ? best_lo : wlo;
                        int e = best_hi < whi ? best_hi : whi;
                        if (s <= e) { bc_busy = 1; bc_blocker = w; }
                    }
                    if (bc_busy) {
                        if (cslog2) {
                            const LiveRange *blr = ir_live_range(f, bc_blocker);
                            fprintf(stderr, "  cs-reject %s v%d bc_busy span=[%d,%d] "
                                "blocker=v%d ext=[%d,%d] true=[%d,%d] uc=%d wc=%d\n",
                                f->fn?ir_sym_name(f->fn):"?", v, best_lo, best_hi,
                                bc_blocker, first_use[bc_blocker], last_use[bc_blocker],
                                blr?blr->start:-1, blr?blr->end:-1,
                                use_count[bc_blocker], write_count[bc_blocker]);
                        }
                        continue;
                    }
                    /* Commit the split. */
                    f->vreg_to_phys[v] = IR_PR_BC;
                    if (f->home_lo && f->home_hi) {
                        f->home_lo[v] = best_lo;
                        f->home_hi[v] = best_hi;
                    }
                    f->vregs[v].flags |= IR_VREG_CALL_SPLIT;
                    if (getenv("IR_CALLSPLIT_LOG"))
                        fprintf(stderr, "CALLSPLIT %s v%d reads=%d span=[%d,%d]\n",
                                f->fn ? ir_sym_name(f->fn) : "?", v, best_reads,
                                best_lo, best_hi);
                }
            }
            free(callpos);
            free(wdb);
        }
        /* [IR_SPILLAUDIT] Phase-0 spill-cause audit (POINTER/general-allocation
           arc). For every SPILLED width-1/2 non-param/addr-taken/volatile value
           with >=3 raw refs (the ones that cost bytes), classify WHY it spilled,
           to decide if "better general allocation" is a real lever:
             pair_free = at least one of BC/DE has NO other homed vreg whose TRUE
                         live range (ir_live_range — NOT the loop-extended
                         first/last_use; the call-split lesson) overlaps V's true
                         range. pair_free ⇒ role-specialisation left a register
                         idle (bucket A). !pair_free ⇒ genuine pressure (B/C).
             in_loop   = V is accessed inside a loop ⇒ reloaded per iteration
                         (the back-edge invalidates the reg cache like a call) ⇒
                         a REAL opportunity, same structure the call-split took.
                         pair_free && !in_loop = straight-line cache-served reuse
                         ⇒ the Phase-4 no-op.
           So A_loop is the recoverable bucket; A_straight is a mirage; pressure
           is the hard/floor case. Reports counts + Σrefs (byte-weight proxy). */
        if (getenv("IR_SPILLAUDIT")) {
            int nv = f->n_vregs;
            int a_loop = 0, a_straight = 0, pressure = 0, a_loop_mb = 0;
            long r_aloop = 0, r_astraight = 0, r_press = 0, r_aloop_mb = 0;
            /* PEAK register pressure: max simultaneously-live GP-candidate values
               (width-1/2, >=2 uses, non-addr/vol/param — all that compete for a
               register HOME) over the function, via interval coverage on the true
               live ranges. This is the decisive "would coloring help" number:
               if peak <= cheap-reg capacity (BC/DE + their byte halves ~= 2-4) yet
               values spill, the greedy allocator left registers idle → coloring
               wins; if peak >> capacity it is genuine over-subscription → floor. */
            int peak_gp = 0, max_end = -1;
            for (int v = 0; v < nv; v++) {
                const LiveRange *lr = ir_live_range(f, v);
                if (lr && lr->end > max_end) max_end = lr->end;
            }
            if (max_end >= 0) {
                int span = max_end + 2;
                int *cov = calloc((size_t)span, sizeof(int));
                if (cov) {
                    for (int v = 0; v < nv; v++) {
                        const VReg *vr = &f->vregs[v];
                        if (vr->width != 1 && vr->width != 2) continue;
                        if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                                         | IR_VREG_PARAM)) continue;
                        if (use_count[v] < 2) continue;
                        const LiveRange *lr = ir_live_range(f, v);
                        if (!lr || lr->start < 0) continue;
                        cov[lr->start]++;
                        if (lr->end + 1 < span) cov[lr->end + 1]--;
                    }
                    int run = 0;
                    for (int k = 0; k < span; k++) {
                        run += cov[k];
                        if (run > peak_gp) peak_gp = run;
                    }
                    free(cov);
                }
            }
            /* PRECISE peak: same count but from per-op liveness (live_in_per_op),
               which has HOLES — a value dead between an early def and a late use
               is NOT counted live in the gap. This is the pressure sdcc actually
               allocates against; peak_gp (solid interval) overstates it. If
               precise << peak_gp, the "hardware floor" is really 80cc's coarse
               whole-interval liveness (no live-range splitting), NOT the z80. */
            int peak_precise = 0;
            for (int b = 0; b < f->n_bbs; b++) {
                const BB *bb = &f->bbs[b];
                if (!bb->live_in_per_op) continue;
                for (int j = 0; j < bb->n_ops; j++) {
                    const BitSet *lin = (const BitSet *)bb->live_in_per_op[j];
                    if (!lin) continue;
                    int cnt = 0;
                    for (int v = 0; v < nv; v++) {
                        const VReg *vr = &f->vregs[v];
                        if (vr->width != 1 && vr->width != 2) continue;
                        if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                                         | IR_VREG_PARAM)) continue;
                        if (use_count[v] < 2) continue;
                        if (ir_bitset_get(lin, v)) cnt++;
                    }
                    if (cnt > peak_precise) peak_precise = cnt;
                }
            }
            /* which BBs are in a loop (for the in_loop test) */
            for (int v = 0; v < nv; v++) {
                const VReg *vr = &f->vregs[v];
                if (vr->width != 1 && vr->width != 2) continue;
                if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                                 | IR_VREG_PARAM)) continue;
                if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                const LiveRange *lv = ir_live_range(f, v);
                if (!lv || lv->start < 0) continue;
                /* raw refs + whether any ref is in a loop BB + how many DISTINCT
                   BBs hold accesses (>1 ⇒ accesses span a belief-reset ⇒ actually
                   reloaded per span; ==1 ⇒ single-BB, cache-served = Phase-4
                   mirage). multi_bb is the "actually pays" refinement. */
                int refs = 0, in_loop = 0, acc_bbs = 0;
                for (int b = 0; b < f->n_bbs; b++) {
                    int hit = 0;
                    for (int j = 0; j < f->bbs[b].n_ops; j++) {
                        const Op *o = &f->bbs[b].ops[j];
                        if (o->dst == v) { refs++; hit = 1; }
                        int u[16]; int nu = ir_op_uses(o, u, 16);
                        for (int k = 0; k < nu; k++)
                            if (u[k] == v) { refs++; hit = 1; }
                    }
                    if (hit) acc_bbs++;
                    if (hit && bb_in_loop[b]) in_loop = 1;
                }
                if (refs < 3) continue;
                int multi_bb = acc_bbs > 1;
                /* true-range-free BC/DE pair */
                int bc_busy = 0, de_busy = 0;
                for (int w = 0; w < nv; w++) {
                    if (w == v) continue;
                    int ph = f->vreg_to_phys[w];
                    if (ph != IR_PR_BC && ph != IR_PR_DE) continue;
                    const LiveRange *lw = ir_live_range(f, w);
                    if (!lw || lw->start < 0) continue;
                    if (lw->start <= lv->end && lv->start <= lw->end) {
                        if (ph == IR_PR_BC) bc_busy = 1; else de_busy = 1;
                    }
                }
                int pair_free = !bc_busy || !de_busy;
                if (pair_free && in_loop) { a_loop++; r_aloop += refs;
                                            if (multi_bb) { a_loop_mb++; r_aloop_mb += refs; } }
                else if (pair_free)       { a_straight++; r_astraight += refs; }
                else                      { pressure++; r_press += refs; }
                if (getenv("IR_SPILLAUDIT")[0] == '2')
                    fprintf(stderr, "  spv %s v%d refs=%d loop=%d mbb=%d bcfree=%d "
                            "defree=%d -> %s\n", f->fn?ir_sym_name(f->fn):"?", v,
                            refs, in_loop, multi_bb, !bc_busy, !de_busy,
                            pair_free ? (in_loop?"A_loop":"A_straight") : "pressure");
            }
            if (a_loop + a_straight + pressure > 0)
                fprintf(stderr, "SPILLAUDIT %-20s peakGP=%d peakPrec=%d A_loop=%d(r%ld) "
                        "A_loopMB=%d(r%ld) A_straight=%d(r%ld) pressure=%d(r%ld)\n",
                        f->fn?ir_sym_name(f->fn):"?", peak_gp, peak_precise, a_loop, r_aloop,
                        a_loop_mb, r_aloop_mb,
                        a_straight, r_astraight, pressure, r_press);
        }
        /* [IR_VRED] Value-reduction audit. sdcc "spills less" because its
           middle-end has FEWER live values, not a better allocator (peak
           pressure is similar). Classify each spilled GP-candidate by whether an
           UPSTREAM optimisation would ELIMINATE it (dropping it from the live set)
           rather than needing a register:
             remat  = def is a constant / &sym / &string — recomputable at use
                      (should not be kept live+spilled at all);
             copy   = def is IR_MOV v=w — coalescable into w's home;
             cse    = an IDENTICAL def op (same kind+srcs+imm+mem) exists on
                      another vreg — a redundant computation CSE would merge;
             distinct = a genuinely-distinct live value (the real floor).
           If remat+copy+cse dominate, VALUE-REDUCTION (CSE/remat/coalesce) is the
           lever, upstream of allocation; if distinct dominates, the pressure is
           real. (Upper bound: no redef-between check on cse — sizing only.) */
        if (getenv("IR_VRED")) {
            int nv = f->n_vregs;
            const Op **defop = calloc((size_t)(nv > 0 ? nv : 1), sizeof(Op *));
            int *ndef = calloc((size_t)(nv > 0 ? nv : 1), sizeof(int));
            int *stbase = calloc((size_t)(nv > 0 ? nv : 1), sizeof(int));
            if (defop && ndef && stbase) {
                for (int b = 0; b < f->n_bbs; b++)
                    for (int j = 0; j < f->bbs[b].n_ops; j++) {
                        const Op *o = &f->bbs[b].ops[j];
                        if (o->dst >= 0 && o->dst < nv && !defop[o->dst])
                            defop[o->dst] = o;
                        int dd[8]; int ndd = ir_op_defs(o, dd, 8);
                        for (int k = 0; k < ndd; k++)
                            if (dd[k] >= 0 && dd[k] < nv) ndef[dd[k]]++;
                        if (o->kind == IR_ST_MEM && o->mem.kind == IR_MEM_VREG
                            && o->mem.base >= 0 && o->mem.base < nv)
                            stbase[o->mem.base] = 1;
                    }
                int remat = 0, copy = 0, cse = 0, distinct = 0;
                int remat_imm = 0, remat_sym = 0;
                /* Actionable remat = SINGLE-def (ndef==1) width-2 LD_IMM/LD_SYM
                   that's still spilled. Split: storebase (the known bitfield
                   exclusion), else "clean" (a genuine gap). multidef / byte are
                   NOT rematerializable (value changes / different machinery). */
                int rm_storebase = 0, rm_clean = 0, rm_multidef = 0, rm_byte = 0;
                int cse_lea = 0, cse_ldmem = 0, cse_rest = 0;
                for (int v = 0; v < nv; v++) {
                    const VReg *vr = &f->vregs[v];
                    if (vr->width != 1 && vr->width != 2) continue;
                    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE
                                     | IR_VREG_PARAM | IR_VREG_NO_SLOT)) continue;
                    if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                    if (use_count[v] < 2) continue;
                    const Op *d = defop[v];
                    if (!d) continue;
                    if (d->kind == IR_LD_IMM || d->kind == IR_LD_SYM
                        || d->kind == IR_LD_STR) { remat++;
                        if (d->kind == IR_LD_IMM) remat_imm++; else remat_sym++;
                        if (ndef[v] > 1) rm_multidef++;
                        else if (vr->width == 1) rm_byte++;
                        else if (stbase[v]) rm_storebase++;
                        else rm_clean++;
                        continue; }
                    if (d->kind == IR_MOV) { copy++; continue; }
                    int dup = 0;
                    for (int w = 0; w < nv && !dup; w++) {
                        if (w == v) continue;
                        const Op *e = defop[w];
                        if (!e || e->kind != d->kind) continue;
                        if (e->src[0] == d->src[0] && e->src[1] == d->src[1]
                            && e->imm == d->imm && e->imm_sym == d->imm_sym
                            && e->mem.kind == d->mem.kind
                            && e->mem.sym == d->mem.sym
                            && e->mem.offset == d->mem.offset
                            && e->mem.base == d->mem.base
                            && d->src[0] >= 0)   /* has a real operand to share */
                            dup = 1;
                    }
                    if (dup) { cse++;
                        /* Break the CSE opportunity down by def kind: ADDRESSES
                           (LEA=&frameslot, LD_MEM=*p deref) that broadening
                           cse_eligible would newly catch, vs the rest (arith,
                           already eligible → a scope/table/cross-BB miss). */
                        if (d->kind == IR_LEA) cse_lea++;
                        else if (d->kind == IR_LD_MEM) cse_ldmem++;
                        else cse_rest++;
                        continue; }
                    distinct++;
                    if (getenv("IR_VRED")[0] == '2')
                        fprintf(stderr, "  vred-distinct %s v%d defkind=%d uc=%d\n",
                                f->fn?ir_sym_name(f->fn):"?", v, (int)d->kind,
                                use_count[v]);
                }
                if (remat + copy + cse + distinct > 0)
                    fprintf(stderr, "VRED %-20s remat=%d[sb%d/clean%d/mdef%d/byte%d] "
                            "copy=%d cse=%d[lea%d/ldmem%d/rest%d] distinct=%d\n",
                            f->fn?ir_sym_name(f->fn):"?", remat, rm_storebase,
                            rm_clean, rm_multidef, rm_byte, copy, cse,
                            cse_lea, cse_ldmem, cse_rest, distinct);
            }
            free(defop); free(ndef); free(stbase);
        }
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

    /* P3.2 step 1 (opt-in IR_TIGHT_HOMES): narrow whole-function homes to the
       tight live range. A vreg is only accessed WITHIN its live range, where
       its home is unchanged, so this is byte-identical — it makes home_lo/hi
       TRUTHFUL (the substrate for disjoint sub-range time-sharing) and gives the
       range-aware verifier real residency windows. A byte-diff that is NOT clean
       reveals a lowerer access outside the IR live range (the "invisible
       residency" the plan warns about) — high-value to surface before ranging.
       HL/DEHL (cache-only) and SPILL/NONE are skipped. */
    if (getenv("IR_TIGHT_HOMES") && f->home_lo && f->home_hi) {
        for (int v = 0; v < f->n_vregs; v++) {
            PhysReg pr = f->vreg_to_phys[v];
            if (pr == IR_PR_SPILL || pr == IR_PR_NONE
                || pr == IR_PR_HL || pr == IR_PR_DEHL)
                continue;
            const LiveRange *lr = ir_live_range(f, v);
            if (!lr || lr->start < 0) continue;
            f->home_lo[v] = lr->start;
            f->home_hi[v] = lr->end;
        }
    }

    alloc_probe(f);
    ir_spill_why_probe(f);
    ir_ldslot_why_probe(f);
    ir_opres_why_probe(f);
    hr_recoverability_verify(f);
}
