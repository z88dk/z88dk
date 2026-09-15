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
#include "ir_lower.h"   /* ir_assign_slots — the revert re-slots */

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

/* Richest span for a ranged BC home: the longest run of reads of v containing
   no call (BC is caller-clobbered) and, when `read_only`, no write of v either.
   Returns the read count; reports the flat op indices of the first/last read.
   `read_only` is what a PARAM needs — its home is backed by the caller's
   in-place slot, which must stay the authoritative copy. */
static int cs_best_span(const Func *f, int v, const int *bb_first_op,
                        int read_only, int *out_lo, int *out_hi)
{
    int best = 0, blo = -1, bhi = -1;
    int cur = 0, cfirst = -1, clast = -1;
    for (int b = 0; b < f->n_bbs; b++)
        for (int j = 0; j < f->bbs[b].n_ops; j++) {
            const Op *o = &f->bbs[b].ops[j];
            int boundary = (o->kind == IR_CALL || o->kind == IR_HCALL);
            if (!boundary && read_only) {
                int dfs[8]; int nd = ir_op_defs(o, dfs, 8);
                for (int x = 0; x < nd; x++)
                    if (dfs[x] == v) { boundary = 1; break; }
                if (!boundary && o->kind == IR_POSTSTEP && o->src[0] == v)
                    boundary = 1;
            }
            if (boundary) {
                if (cur > best) { best = cur; blo = cfirst; bhi = clast; }
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
    if (cur > best) { best = cur; blo = cfirst; bhi = clast; }
    *out_lo = blo; *out_hi = bhi;
    return best;
}


/* Record a home decided AFTER the word-home pre-pick snapshot was taken. That
   snapshot is what the lowerer restores when the speculative DE word-home fails
   to form a region, and the restore is a WHOLE-ARRAY memcpy — so a decision made
   later (the call-split's ranged BC home, ~2700 lines further down) was silently
   wiped, leaving IR_VREG_CALL_SPLIT set with phys == SPILL. Mirror it into the
   snapshot so it survives the revert. */
static void alloc_note_late_home(Func *f, int v, PhysReg pr)
{
    f->vreg_to_phys[v] = pr;
    if (word_home_prepick && v >= 0 && v < f->n_vregs)
        word_home_prepick[v] = pr;
}

/* ---- The word DE-home pick, and its one legal rejection -------------------
   The allocator picks a word DE-home before lowering can tell whether a
   resident region will actually form for it. Only the render can answer that,
   so the answer comes back as a REJECTION — and the revert is applied here, by
   the owner of the allocation, from a snapshot that never leaves this file.
   The lowerer used to take the snapshot array and memcpy it back itself, which
   made it a second writer of vreg_to_phys.

   This is a revert to a saved plan, not a re-arbitration: re-running ir_alloc
   with the value vetoed would re-place everything else too, and that is a
   different (and not byte-identical) decision. */
int ir_alloc_word_home_picked(void)
{
    return word_home_prepick != NULL;
}

void ir_alloc_word_home_reject(Func *f)
{
    if (!f || !word_home_prepick || !f->vreg_to_phys) return;
    memcpy(f->vreg_to_phys, word_home_prepick,
           (size_t)f->n_vregs * sizeof(int));
    f->word_home_vreg = -1;
    f->de_home_general = 0;
    f->de_home_is_ptr = 0;
    ir_assign_slots(f);
}

/* [home-demote] The render found a register home it could not realize — a
   slotless value read with its register gone. The lowerer names the vreg; the
   demotion itself is applied here, because it is an edit to the allocation.
   The three cleared flags all suppress a slot, and the point of a demotion is
   to get one. Costs the slot traffic the home was meant to save; the
   alternative was exit(1). */
int ir_alloc_demote_home(Func *f, int v)
{
    if (!f || v < 0 || v >= f->n_vregs) return 0;
    if (f->vreg_to_phys) f->vreg_to_phys[v] = IR_PR_SPILL;
    f->vregs[v].flags &= ~(IR_VREG_NO_SLOT | IR_VREG_DEAD_SPILL
                           | IR_VREG_PARAM_IN_PLACE);
    if (f->home_lo) f->home_lo[v] = 0;
    if (f->home_hi) f->home_hi[v] = INT_MAX;
    return 1;
}

void ir_alloc_word_home_done(void)
{
    free(word_home_prepick);
    word_home_prepick = NULL;
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

/* ---- The point query: where is v homed AT A GIVEN POINT? ------------------
   Pure: the flat op index is passed in, not read from lowerer state, so
   allocation, slot assignment, the verifiers and a test can all ask the same
   question the lowerer asks. Pass g < 0 for "no ambient point" (a prologue or
   an assignment-level question), which yields the raw assignment.

   Today a home is whole-function — one interval per vreg — so the bounds test
   is a no-op and this returns the assignment. That is the degenerate case of
   the interval table, not a different model: when a home becomes ranged, only
   this body changes. Anything that reads the assignment directly to make a
   POINT decision silently ignores the bounds and will be wrong then. */
PhysReg ir_home_at_op(const Func *f, int v, int g)
{
    if (!f || !f->vreg_to_phys || v < 0 || v >= f->n_vregs) return IR_PR_SPILL;
    PhysReg pr = (PhysReg)f->vreg_to_phys[v];
    if (pr != IR_PR_SPILL && f->home_lo && g >= 0
        && (g < f->home_lo[v] || g > f->home_hi[v]))
        return IR_PR_SPILL;
    return pr;
}

/* The window bounds, for a diagnostic that prints them. -1 when absent. */
int ir_home_lo_of(const Func *f, int v)
{
    return (f && f->home_lo && v >= 0 && v < f->n_vregs) ? f->home_lo[v] : -1;
}
int ir_home_hi_of(const Func *f, int v)
{
    return (f && f->home_hi && v >= 0 && v < f->n_vregs) ? f->home_hi[v] : -1;
}

/* Is v's home RANGED — a window narrower than the whole function? The window
   is the allocator's, so the test for "is it the degenerate one" is too. */
int ir_home_is_ranged(const Func *f, int v)
{
    if (!f || !f->home_lo || !f->home_hi || v < 0 || v >= f->n_vregs) return 0;
    return f->home_lo[v] != INT_MIN || f->home_hi[v] != INT_MAX;
}

/* Does v's home window COVER its whole live range?
   `ir_home_is_ranged` answers a narrower question than most of its callers
   want: it is true for any window that is not literally whole-function. Two
   very different things satisfy that, and only one is a hazard:
     - the window is NARROWER than the live range — the allocator split the
       range, so outside the window the value is SLOTTED and an access there
       reaches memory. This is what frameless_ok and the dead-frame verdict
       must reject.
     - the window merely equals the live range (what IR_TIGHT_HOMES does) —
       outside it the value is DEAD, not slotted, so no access exists to
       reach memory at all. Harmless.
   Conflating them made IR_TIGHT_HOMES look like a regression: narrowing every
   home to its live range made every PARAM "ranged", frameless_ok rejected them
   all, and functions that were frameless grew a frame (`push ix; ld ix,0;
   add ix,sp`). See ADR 0027. */
int ir_home_covers_live_range(const Func *f, int v)
{
    if (!f || v < 0 || v >= f->n_vregs) return 0;
    if (!f->home_lo || !f->home_hi) return 1;       /* no windows: whole-function */
    if (f->home_lo[v] == INT_MIN && f->home_hi[v] == INT_MAX) return 1;
    const LiveRange *lr = ir_live_range(f, v);
    if (!lr || lr->start < 0) return 0;             /* no range: cannot prove it */
    return f->home_lo[v] <= lr->start && f->home_hi[v] >= lr->end;
}

/* v's home window as a flat op-index range, clamped into [*lo,*hi]. Callers
   pass the live range and get back the part of it the home actually covers. */
void ir_home_window(const Func *f, int v, int *lo, int *hi)
{
    if (!f || v < 0 || v >= f->n_vregs || !lo || !hi) return;
    if (f->home_lo && f->home_lo[v] > *lo) *lo = f->home_lo[v];
    if (f->home_hi && f->home_hi[v] < *hi) *hi = f->home_hi[v];
}

/* The whole-function question: is v EVER homed in a register? Not a point
   query — it deliberately ignores the interval, and callers that scan every
   vreg (prepasses, "does this function use BC at all") want exactly that. */
PhysReg ir_home_assigned(const Func *f, int v)
{
    if (!f || !f->vreg_to_phys || v < 0 || v >= f->n_vregs) return IR_PR_SPILL;
    return (PhysReg)f->vreg_to_phys[v];
}

/* ---- The backing requirement: one owner, one answer -----------------------
   ir_slots.c used to re-derive these rules, which meant the question "does this
   value have a slot?" had two implementations that had to agree. It is an
   allocation fact, so it lives here. The order below is significant: the
   register assignment decides first, the clobberable and split homes add a slot
   back, and the three value flags override everything. */
int ir_home_reg_is_slotbacked(PhysReg pr)
{
    return pr == IR_PR_E || pr == IR_PR_D;
}

int ir_home_requires_slot(const Func *f, int v)
{
    if (!f || v < 0 || v >= f->n_vregs) return 0;
    PhysReg pr = f->vreg_to_phys ? (PhysReg)f->vreg_to_phys[v] : IR_PR_SPILL;

    /* No register home: the slot IS the home. */
    int needs = (f->vreg_to_phys && pr != IR_PR_SPILL) ? 0 : 1;

    /* A clobberable byte home is spilled to its slot before a DE-clobbering op
       and reloaded after, so the register home does not remove the slot. */
    if (f->vreg_to_phys && ir_home_reg_is_slotbacked(pr)) needs = 1;

    /* The word DE-home (a multi-def PR_DE accumulator) is likewise slot-backed:
       it rides DE across its loop, but the loop test or a DE-scratch op
       clobbers DE. Ordinary single-def PR_DE transients stay slotless. */
    if (v == f->word_home_vreg && f->vreg_to_phys && pr == IR_PR_DE) needs = 1;

    /* [call-split] BC only inside the call-free span; the slot stays the
       canonical home outside it and for the entry reload. */
    if (f->vregs[v].flags & IR_VREG_CALL_SPLIT) needs = 1;

    /* A read-only param lives in the caller's pushed-arg slot, and slot_off
       returns that caller offset directly — no frame slot of its own. */
    if (f->vregs[v].flags & IR_VREG_PARAM_IN_PLACE) needs = 0;
    /* An A-only byte temp: every def is dst-dead, so the value rides A. */
    if (f->vregs[v].flags & IR_VREG_NO_SLOT) needs = 0;
    /* [dead-store] Written but never read: the store is skipped on the
       re-lower and the value rides A, so the frame can shrink. */
    if (f->vregs[v].flags & IR_VREG_DEAD_SPILL) needs = 0;

    return needs;
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
    /* [IR_BYTETIE] STATIC bytes the best allowed home saves, used ONLY to break a
       tie in `benefit`. The cycle model goes BLIND on a target whose slot and
       register cost the same — ez80 fp is the case: a slot read is a native
       `ld hl,(ix+d)` at 2 cycles, exactly what `ld l,c; ld h,b` costs, so
       interval_benefit rates every read and write at ZERO and the arbiter's
       order, not merit, decides. Bytes still separate them there (fp slot 3 B
       against BC's 2), so rank lexicographically: cycles first, bytes to break
       the tie. Kept as a SEPARATE field rather than summed — the two are in
       different units and adding them would let a 3-byte candidate outrank a
       2-cycle one. */
    long     bytes;
    int      lo, hi;    /* live interval [first_use, last_use] */
    unsigned allowed;   /* RC_* mask */
    unsigned flags;     /* CF_* */
} Cand;

/* Append a proposal to the arbiter pool. The single point where a candidate enters
   the pool (every proposer used the same 6-field fill). benefit is a placeholder —
   unified_arbitrate overwrites it with cost_benefit[v] before ranking. */
/* [home-rearb] Values the LOWERER proved unrealizable. `[home-demote]` demotes
   such a value to SPILL and re-renders, which fixes correctness but leaves the
   register it vacated OFFERED TO NOBODY — the arbiter does not run again, so
   the next-best candidate never gets its chance. histbench's `hist_pass` on
   gbz80 is the witness: v1 takes BC, cannot realize it, is demoted, and v26 —
   which would have used BC perfectly well — stays spilled for the rest of the
   function.

   So record the veto and let the driver re-arbitrate: a vetoed value is not
   proposed at all, and the register goes to whoever is next. */
static int alloc_veto[64];
static int alloc_nveto;

void ir_alloc_veto_reset(void) { alloc_nveto = 0; }

void ir_alloc_veto_add(int v)
{
    if (v < 0) return;
    for (int i = 0; i < alloc_nveto; i++) if (alloc_veto[i] == v) return;
    if (alloc_nveto < (int)(sizeof alloc_veto / sizeof alloc_veto[0]))
        alloc_veto[alloc_nveto++] = v;
}

static int alloc_vetoed(int v)
{
    for (int i = 0; i < alloc_nveto; i++) if (alloc_veto[i] == v) return 1;
    return 0;
}

/* Worst-case candidates per vreg: collect_home_candidates has exactly this many
   proposal paths, and each one runs its own `for v` loop that adds at most one
   candidate per vreg. The bound is therefore provable rather than observed —
   but it is only provable while that stays true, so add_cand checks it. A new
   proposal path means raising this number. */
#define CAND_PER_VREG 10

static size_t cand_pool_len(const Func *f)
{
    return (size_t)(f->n_vregs > 0 ? f->n_vregs : 1) * CAND_PER_VREG;
}

static inline void add_cand(Cand *out, int *n, int cap, int v, long benefit,
                            int lo, int hi, unsigned allowed, unsigned flags)
{
    if (alloc_vetoed(v)) return;          /* [home-rearb] proved unrealizable */
    if (*n >= cap) {
        /* CAND_PER_VREG is wrong: a proposal path was added without raising it.
           Drop the candidate rather than write past the pool, and say so — a
           silently shorter pool would look like an allocator quality change. */
        static int told;
        if (!told) {
            told = 1;
            fprintf(stderr, "ir_alloc: candidate pool full at %d "
                            "(raise CAND_PER_VREG)\n", cap);
        }
        return;
    }
    out[*n].vreg = v;
    out[*n].benefit = benefit;
    out[*n].lo = lo;
    out[*n].hi = hi;
    out[*n].allowed = allowed;
    out[*n].flags = flags;
    (*n)++;
}

/* [IR_CS_EVICT] The residency benefit v draws from BC over the op-index range
   [lo,hi], in the SAME units ir_alloc builds cost_benefit in: depth-weighted
   COST_WRITE_W per def and COST_DEREF_W / COST_READ_W per use. cost_benefit
   itself is whole-function, which is the wrong measure for a call-split — the
   split only owns BC over its span — so this is the ranged form of it. Pass the
   whole function ([0, INT_MAX]) to reproduce cost_benefit for a tenant.

   Deliberately the SAME weights rather than the g0 T-state row: this number is
   compared against cost_benefit for the eviction decision, and two numbers in
   different units cannot be compared. */
/* [IR_CS_EVICT] Depth-weighted count of the calls inside [lo,hi]. A BC tenant
   whose home spans a call does not hold BC across it: gen_call save/restores the
   pair and the register belief goes COLD, so the first read after every call
   reloads from the slot. cost_benefit credits those reads as if the register
   served them. A call-bounded split has no such calls in its span by
   construction, which is exactly why comparing the two on raw cost_benefit
   favours the wrong one. */
/* [IR_GRAPH_PROBE] Which vregs the realizability predicates actually NOMINATED.
   The probe's `ideal` credits homing any deserving value in any free register, but
   the lowerer has FIXED per-op register roles — it cannot home every shape — so an
   ideal that ignores that overstates the gap. The pool IS the encoding of what the
   lowerer can serve, so capture is reported twice: over all deserving values (which
   mixes in proposal coverage) and over nominated ones only (pure SELECTION quality).
   Set when the real pool is built, cleared at teardown. */


/* Defined with the iteration-weight block below (trip-count term). */
static long bb_iter_weight(const int *bb_loop_depth, int b, int depth_flat);

static long cs_call_weight(const Func *f, int lo, int hi,
                           const int *bb_first_op, const int *bb_loop_depth)
{
    long n = 0;
    int depth_flat = opt_disabled("depth-weight");
    for (int b = 0; b < f->n_bbs; b++) {
        long w = bb_iter_weight(bb_loop_depth, b, depth_flat);
        for (int j = 0; j < f->bbs[b].n_ops; j++) {
            int g = bb_first_op[b] + j;
            if (g < lo || g > hi) continue;
            OpKind k = f->bbs[b].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL) n += w;
        }
    }
    return n;
}

static long cs_span_benefit(const Func *f, int v, int lo, int hi,
                            const int *bb_first_op, const int *bb_loop_depth)
{
    long ben = 0;
    int depth_flat = opt_disabled("depth-weight");
    for (int b = 0; b < f->n_bbs; b++) {
        long w = bb_iter_weight(bb_loop_depth, b, depth_flat);
        for (int j = 0; j < f->bbs[b].n_ops; j++) {
            int g = bb_first_op[b] + j;
            if (g < lo || g > hi) continue;
            const Op *o = &f->bbs[b].ops[j];
            if (o->dst == v) ben += w * COST_WRITE_W;
            int mb = ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                      && o->mem.kind == IR_MEM_VREG) ? o->mem.base : -1;
            int u[16]; int nu = ir_op_uses(o, u, (int)(sizeof u / sizeof u[0]));
            for (int k = 0; k < nu; k++)
                if (u[k] == v) ben += w * (v == mb ? COST_DEREF_W : COST_READ_W);
        }
    }
    return ben;
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
    /* §3a″ a stepped-pointer PARAM may ride BC only in a call-free function (a
       call evicts BC → emit_bc_reload restores from the STALE caller slot once
       the pointer stepped). Phase-1 `inc bc` keeps BC coherent on the step.
       Default-on; ADR 0031 has the evidence and the landmine it once exposed. */
    int allow_step_param = !opt_disabled("bc-step-param");
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

#define IDX2_BASE_STEPPED  0x10000   /* v is a stepped / post-stepped base */
#define IDX2_BASE_NMASK    0x0FFFF   /* ...and how many plain deref uses */

/* idx2 map builder (factored from idx2_propose so home_realizable can rebuild
   it independently). is_base = LD_MEM/ST_MEM MEM_VREG base + POSTSTEP src[0] +
   COPY_STEP_BRZ pointers (a deref'd/stepped pointer, never an idx2 counter/
   bound); cstep/cinit/cother = per-vreg def-shape counts. Buffers sized
   f->n_vregs, caller-zeroed.

   [IR_IDX2BASE] is_base is now COUNTED, not just flagged: the low bits hold how
   many times v is a plain deref base and IDX2_BASE_STEPPED marks a stepped /
   post-stepped one. Every existing test is `if (is_base[v])`, which nonzero
   still satisfies; only idx2_home_realizable decodes it. The distinction is the
   one the measurement demanded — a struct pointer dereffed at SEVERAL fixed
   offsets wants (iy+d), a WALKING pointer wants HL/BC and regressed strbench
   +19 B when both were admitted alike. */
static void build_idx2_maps(const Func *f, int *is_base, int *cstep,
                            int *cinit, int *cother)
{
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            const Op *o = &f->bbs[i].ops[j];
            if ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                && o->mem.kind == IR_MEM_VREG
                && o->mem.base >= 0 && o->mem.base < f->n_vregs) {
                is_base[o->mem.base]++;                  /* counted */
                if (o->mem.post_step != 0)
                    is_base[o->mem.base] |= IDX2_BASE_STEPPED;
            }
            if (o->kind == IR_POSTSTEP && o->src[0] >= 0
                && o->src[0] < f->n_vregs)
                is_base[o->src[0]] |= IDX2_BASE_STEPPED | 1;
            if (o->kind == IR_COPY_STEP_BRZ)
                for (int q = 0; q < 2; q++)
                    if (o->src[q] >= 0 && o->src[q] < f->n_vregs)
                        is_base[o->src[q]] |= IDX2_BASE_STEPPED | 1;
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
static int idx2base_on(void)
{ return !opt_disabled("idx2-base"); }                                   /* default ON */

static unsigned idx2_home_realizable(const Func *f, int v,
                                     const int *use_count, const int *write_count,
                                     const int *is_base, const int *cstep,
                                     const int *cinit, const int *cother)
{
    const VReg *vr = &f->vregs[v];
    if (vr->width != 2) return 0;
    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE)) return 0;
    if (f->vreg_to_phys[v] != IR_PR_SPILL) return 0;
    /* [IR_IDX2BASE] Admit a deref base at this gate, where it used to be
       rejected outright. The win is NOT that the pointer derefs more cheaply —
       it is the EVICTED scalar getting cheaper. adr/0062. Admit only the shape
       that measured positive; the assignment site's grounded idx_ben gate then
       prices it as usual. IR_IDX2BASE=0 opts out. */
    if (is_base[v]) {
        if (!idx2base_on()) return 0;
        if (is_base[v] & IDX2_BASE_STEPPED) return 0;   /* walking ptr: wants HL/BC */
        if (!(vr->flags & IR_VREG_PARAM) || write_count[v] != 0) return 0;
        if ((is_base[v] & IDX2_BASE_NMASK) < 2) return 0;  /* one deref: no spread */
        /* falls through to the read-only-param rule below */
    }
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
/* Call-bounded live-range splitting: DEFAULT-ON after the full byte+ticks
   matrix (all 9 CPUs x candidate benches x sp/fp: 0 regressed cells, -1500B;
   z80/gbz80/8085 ticks all faster-or-neutral). Opt out with IR_OFF=call-split
   (byte-identical to pre-flip). The dear-slot CPU gate (deref_gap>=15) inside
   the selection keeps cheap-slot CPUs byte-identical regardless. */
static int callsplit_on(void) { static int c = -1; if (c < 0) c = !opt_disabled("call-split"); return c; }

/* [IR_OFF=iy-long] Opt OUT of running the IY packs in a function the BC veto
   excludes. They self-guard with a per-op op_clobbers IR_R_IY check over the
   candidate's live range, so the BC veto buys them nothing — it names another
   register's restriction. adr/0060. */
static int iylong_off(void) { static int c = -1; if (c < 0) c = opt_disabled("iy-long"); return c; }

/* [IR_CS_EVICT=0/1] Let a call-bounded split EVICT a picker-placed BC tenant it
   out-benefits, instead of silently losing BC to whoever the picker placed
   first. Defaults to whatever prepush-narrow is — the arbitration gap only
   becomes reachable once the narrowing admits whole-function BC candidates into
   functions with pre-pushed calls, so the default build stays byte-identical.
   Force either way to isolate it. adr/0061. */
static int prepushnarrow_on(void);
static int cs_evict_on(void)
{
    static int c = -1;
    if (c < 0) {
        /* Follows prepush-narrow unless explicitly disabled. (The old
           IR_CS_EVICT=1 could also force it ON against that default; nothing
           used that direction, so the switch is disable-only now.) */
        c = !opt_disabled("cs-evict") && prepushnarrow_on();
    }
    return c;
}

/* [prepush-narrow=1] Narrow the whole-function pre-pushed-call veto to the
   calls that can really lose BC (prepush_bc_hazard).
   DEFAULT-ON; `IR_OFF=prepush-narrow` opts out (and takes IR_CS_EVICT with it).

   ►► IT IS A PAIR WITH bc-save-live — DO NOT SEPARATE THEM. Alone, the
   narrowing regresses divbench and shiftbench badly, because it adds `push bc` /
   `pop bc` pairs around calls; bc-save-live removes the ones whose tenant is
   not live there, and together the regressions go to exactly zero. Flipping this
   one on its own reinstates them. Evidence: adr/0063. */
static int prepushnarrow_on(void)
{
    static int c = -1;
    if (c < 0) c = !opt_disabled("prepush-narrow");
    return c;
}

/* [mwbc] The corrected loop-depth weight plus the two cost-model repairs that
   ride with it (the conditional-execution discount in interval_benefit_x and the
   equal-DE-score tie-break). One accessor for all three, because they are one
   behaviour: the depth correction is what makes the other two necessary.
   DEFAULT-ON; `IR_OFF=mwbc` opts out, byte-identical to pre-flip. */
static int mwbc_on(void)
{
    static int c = -1;
    if (c < 0) c = !opt_disabled("mwbc");
    return c;
}
/* [mwbc-pressure] The BC reservation that keeps a loop-carried accumulator
   available to the IY reduction pack. Independent of mwbc_on() — it is a pass
   ORDERING repair, not a cost-model one — but only observable in practice when
   the ranking has changed enough to take the value in the first place. */
static int mwbc_pressure_on(void)
{
    static int c = -1;
    if (c < 0) c = !opt_disabled("mwbc-pressure");
    return c;
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
    return 1;
}

/* Grounded cost-model kinds/registers (defined with g0_word_cost below) — declared
   here so the arbiter's contention comparison, and the IV hotness gate below,
   can reference GR_BC. */
enum { GK_READ, GK_WRITE, GK_DEREF, GK_STEP, GK_N };
enum { GR_SLOT, GR_BC, GR_DE, GR_IX, GR_IY, GR_N };

static long interval_benefit_x(const Func *f, int v, const int *bb_loop_depth,
                               const int *bb_cond_shift, int R, int discount);
static inline int iv_overlap(const Func *f, int a, int b,
                             int alo, int ahi, int blo, int bhi);
static long bc_call_save_charge(const Func *f, int v, const int *bb_loop_depth,
                                const int *bb_cond_shift);

/* The hotness half, split out from the shape half above.
   `use_count >= 8` is an UNGROUNDED CONSTANT — the only raw count left in the
   candidate gates, everything else having moved to interval_benefit. It exists
   to mean "in a loop", but it says so by counting static uses, which misses the
   accumulator shape: `s = s OP x` four times over is 4 writes and 4 uses, so it
   fails BOTH gates — bc_home_realizable wants write_count == 1 (write-once) and
   this wants 8 uses (hot). widthbench's mix_char is exactly that value.
   IR_IVWHY reports every candidate that clears the shape but not this. */
static int iv_home_hot_enough(const Func *f, int v, const int *use_count,
                              const int *bb_loop_depth, const int *bb_cond_shift)
{
    static int thr = -1;
    if (thr < 0) {
        const char *e = getenv("IR_IVHOT");
        thr = e ? atoi(e) : 8;
    }
    if (use_count[v] >= thr) return 1;
    /* [IR_IVACC] The REASSIGNED-VALUE arm, for a value WRITTEN many times and
       read once per write — an accumulator (`acc = acc + t; ...`) or a clamp
       chain (`if (v > 255) v = 255;`). Such a value clears the IV shape but
       never `use_count >= thr`, and bc_home_realizable demands write_count == 1,
       so it falls between both BC gates and lands in a slot, paying a round trip
       per term.

       ADMISSION IS BY CONTENTION, not hotness and not interval_benefit — that is
       a cycle model, and the outcome here is byte- and mode-driven (it rates the
       same candidate identically on z80 and gbz80, where admitting it costs
       bytes and ticks on one and saves both on the other). Call-freeness does not
       separate them either: the losers are call-free too, and their cost is
       register PRESSURE. The test is whether the value out-earns the rival it
       would displace — see iv_acc_bc_wins for the margin.

       So: call-free AND it out-earns its rival 3:1.

       `IR_IVACC=0` / `--opt-disable=iv-acc` opts out. `IR_IVHOT=<N>` re-sweeps
       the constant, `IR_IVACCK=<N>` the margin, `IR_IVWHY` prints the census. */
    {
        static int acc_on = -1;
        if (acc_on < 0) {
            /* opt_disabled("iv-acc") below is the switch; this was a duplicate. */
            acc_on = 1;
        }
        if (!acc_on || opt_disabled("iv-acc")) return 0;
    }
    if (!bb_loop_depth) return 0;      /* no loop map: keep the old answer */
    return bc_call_save_charge(f, v, bb_loop_depth, bb_cond_shift) == 0;
}

/* Second half of the accumulator gate: is BC actually FREE over v's life?
   The accumulator only wins if it is not displacing something better. Every
   other proposer has already filled the pool by the time the IV arm runs, so
   an overlapping candidate that also wants BC is visible right here. */
/* The strongest overlapping BC rival's benefit, on the SAME scale as the
   accumulator's (interval_benefit_x with discount=1) so the two are comparable.
   Returns 0 for "no rival", -1 when there is no loop map to price with. */
static long iv_acc_rival_benefit(const Func *f, int v, const Cand *pool, int n,
                                 const int *first_use, const int *last_use,
                                 const int *bb_loop_depth, const int *bb_cond_shift,
                                 int *nrivals)
{
    long best = 0;
    if (nrivals) *nrivals = 0;
    if (!bb_loop_depth) return -1;
    for (int j = 0; j < n; j++) {
        if (pool[j].vreg == v) continue;
        if (!(pool[j].allowed & RC_BC)) continue;
        if (pool[j].flags & CF_SPECULATIVE) continue;
        if (!iv_overlap(f, v, pool[j].vreg, first_use[v], last_use[v],
                        pool[j].lo, pool[j].hi))
            continue;
        if (nrivals) (*nrivals)++;
        long b = interval_benefit_x(f, pool[j].vreg, bb_loop_depth,
                                    bb_cond_shift, GR_BC, 1);
        if (b > best) best = b;
    }
    return best;
}

/* Does v WIN its contention for BC outright? Not "is it uncontended" — an
   accumulator almost always overlaps something — but "does it beat the best
   thing it would displace, by a wide margin".

   THE MARGIN IS 3x AND IT IS NOT ARBITRARY: benefit here is a CYCLE model and
   cannot arbitrate a register home alone. The per-candidate sweep that places
   the cut between 2.7 and 3.0 is in adr/0064. IR_IVACCK=<N> re-sweeps it. */
static int iv_acc_bc_margin(void)
{
    static int k = -1;
    if (k < 0) { const char *e = getenv("IR_IVACCK"); k = e ? atoi(e) : 3; }
    return k;
}

static int iv_acc_bc_wins(const Func *f, int v, const Cand *pool, int n,
                          const int *first_use, const int *last_use,
                          const int *bb_loop_depth, const int *bb_cond_shift)
{
    int nrivals = 0;
    long rival = iv_acc_rival_benefit(f, v, pool, n, first_use, last_use,
                                      bb_loop_depth, bb_cond_shift, &nrivals);
    if (rival < 0) return 0;               /* no loop map: keep the old answer */
    if (nrivals == 0) return 1;            /* BC is genuinely free over the window */
    /* Rivals EXIST but the model prices them all at zero. That is not "BC is
       free", it is the model being BLIND — see the ez80 fp row of g0_word_cost,
       where a slot read costs the same 2 cycles as `ld l,c; ld h,b`. Ask for a
       real gap before displacing anything; distinguishing the two cases is why
       iv_acc_rival_benefit reports a COUNT as well as a maximum. adr/0064. */
    if (rival == 0) return 0;
    long ben = interval_benefit_x(f, v, bb_loop_depth, bb_cond_shift, GR_BC, 1);
    return ben >= (long)iv_acc_bc_margin() * rival;
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
    /* [IR_IVACC] the reassigned-value arm's inputs: a loop map to price call
       saves, and the candidate pool to test BC contention. */
    const int *bb_loop_depth, *bb_cond_shift, *first_use, *last_use;
    const Cand *pool; int npool;
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
static int de_home_available(const Func *f)
{
    if (!func_is_call_free(f)) return 0;
    for (int v = 0; v < f->n_vregs; v++)
        if (f->vreg_to_phys[v] == IR_PR_E || f->vreg_to_phys[v] == IR_PR_D)
            return 0;   /* DE low half already a byte E/D home */
    return 1;
}


/* Inert agreement check (env IR_HR_CHECK): validates that home_realizable
   reproduces the proposers' pool EXACTLY — for every (v, class), the query
   agrees with pool membership. Run pre-arbitration (vreg_to_phys still all
   SPILL, the state the proposers saw). Logs any mismatch (false yes or false
   no); expect ZERO on the corpus → home_realizable is a faithful generator,
   ready for increment 3 to drive the colouring. Builds its OWN maps (independent
   recomputation via the factored helpers), so a mismatch would catch a real gap. */
/* How many SPILLED, writable, non-address-taken width-2 values could take a
   loop home? The idx2 and EXX arms both gate on this same count, and they must
   agree — keeping one copy is what stops them drifting apart. */
static int count_writable_loopvars(const Func *f, const int *use_count,
                                   const int *write_count, const int *wd_base,
                                   const int *wd_acc, const int *wd_ldef)
{
    int n = 0;
    for (int v = 0; v < f->n_vregs; v++) {
        const VReg *vr = &f->vregs[v];
        if (vr->width != 2) continue;
        if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE | IR_VREG_PARAM))
            continue;
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
        if (wd_base[v] || wd_acc[v] || !wd_ldef[v]) continue;
        if (use_count[v] < 4 || write_count[v] < 2) continue;
        n++;
    }
    return n;
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
                                   const int *bb_loop_depth, const int *bb_cond_shift,
                                   const int *first_use, const int *last_use,
                                   Cand *pool, int pool_cap)
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
            add_cand(pool, &n, pool_cap, v, use_count[v], first_use[v], last_use[v],
                     RC_BC, 0);
    /* (2) EXX co-design FIRST (an alt-bank invariant frees IX for a writable
       loop var) — must precede idx2 so the stable arbiter grabs it first. */
    if (f->exx_reg != IR_PR_NONE && !f->is_interrupt && !f->is_naked
        && !f->uses_acc && func_is_call_free(f)) {
        int writables = count_writable_loopvars(
            f, use_count, write_count, wd_base, wd_acc, wd_ldef);
        if (writables >= 2)
            for (int v = 0; v < f->n_vregs; v++)
                if (exx_home_realizable(f, v, use_count, wd_base, wd_ldef,
                                        wd_lread))
                    add_cand(pool, &n, pool_cap, v, use_count[v], first_use[v],
                             last_use[v], RC_EXX, 0);
    }
    /* (3) idx2 — spare index register (counter or read-only param). */
    if (idx2_home_available(f))
        for (int v = 0; v < f->n_vregs; v++) {
            unsigned fl = idx2_home_realizable(f, v, use_count, write_count,
                                               is_base, cstep, cinit, cother);
            if (fl)
                add_cand(pool, &n, pool_cap, v, use_count[v], first_use[v], last_use[v],
                         RC_IDX2, fl);
        }
    /* (4) byte home (C slotless if single-BB, else E slot-backed). */
    if (c_byte_resident && !opt_disabled("byte-resident"))
        for (int v = 0; v < f->n_vregs; v++)
            if (byte_home_realizable(f, v, use_count, write_count))
                add_cand(pool, &n, pool_cap, v, use_count[v], first_use[v], last_use[v],
                         RC_BYTE,
                         (vreg_single_bb(f, v) >= 0) ? CF_BYTE_SINGLE_BB : 0);
    /* (5) DE-class — three sub-shapes in pool order: acc, general, ptr. */
    if (de_home_available(f)) {
        if (c_word_resident && !opt_disabled("word-resident"))
            for (int v = 0; v < f->n_vregs; v++)
                if (de_acc_realizable(f, v, use_count, write_count,
                                      wd_base, wd_acc))
                    add_cand(pool, &n, pool_cap, v, use_count[v], first_use[v],
                             last_use[v], RC_DE_ACC, 0);
        if (!opt_disabled("de-home"))
            for (int v = 0; v < f->n_vregs; v++)
                if (de_general_realizable(f, v, use_count, write_count,
                                          wd_base, wd_acc, wd_ldef))
                    add_cand(pool, &n, pool_cap, v, use_count[v], first_use[v],
                             last_use[v], RC_DE_ACC, CF_DE_GENERAL);
        if (!opt_disabled("de-home") && !opt_disabled("loop-ra"))
            for (int v = 0; v < f->n_vregs; v++)
                if (de_ptr_realizable(f, v, use_count, wd_base, wd_ldef))
                    add_cand(pool, &n, pool_cap, v, use_count[v], first_use[v],
                             last_use[v], RC_DE_ACC, CF_DE_GENERAL | CF_DE_PTR);
    }
    /* (6) idx3 — second spare index register (opt-in). */
    if (idx3_home_available(f))
        for (int v = 0; v < f->n_vregs; v++)
            if (idx3_home_realizable(f, v, use_count, write_count,
                                     wd_base, wd_acc, wd_ldef, wd_addr))
                add_cand(pool, &n, pool_cap, v, use_count[v], first_use[v], last_use[v],
                         RC_IDX3, 0);
    /* (7) IV-residency — hot write-many BC-stamped int IV (CF_SPECULATIVE). */
    if (!opt_disabled("iv-resident"))
        for (int v = 0; v < f->n_vregs; v++)
            if (iv_home_realizable(f, v, use_count, write_count, all_defs_ok,
                                   has_prepushed_call, entry_live)) {
                /* [IR_IVWHY] INERT census of the gap between the two BC gates:
                   a value that clears the IV shape but is turned away as "cold"
                   is one bc_home_realizable also refused (it is write-many). */
                int hot = iv_home_hot_enough(f, v, use_count,
                                             bb_loop_depth, bb_cond_shift)
                       && (use_count[v] >= 8
                           || iv_acc_bc_wins(f, v, pool, n, first_use, last_use,
                                             bb_loop_depth, bb_cond_shift));
                if (getenv("IR_IVWHY"))
                    fprintf(stderr, "IVWHY %s v%d w=%d u=%d ben=%ld rival=%ld %s\n",
                            f->fn ? ir_sym_name(f->fn) : "?", v,
                            write_count[v], use_count[v],
                            bb_loop_depth ? interval_benefit_x(f, v, bb_loop_depth,
                                                bb_cond_shift, GR_BC, 1) : -1L,
                            iv_acc_rival_benefit(f, v, pool, n, first_use,
                                                 last_use, bb_loop_depth,
                                                 bb_cond_shift, NULL),
                            hot ? "ADMIT" : "REJECT cold");
                if (!hot) continue;
                add_cand(pool, &n, pool_cap, v, use_count[v], first_use[v], last_use[v],
                         RC_BC, CF_SPECULATIVE);
            }
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
/* [IR_BYTETIE] OPT-IN (default OFF). `IR_BYTETIE=1` enables, `=<N>` sets a
   minimum byte gap before the tie-break fires.

   On ez80 fp the cost row genuinely CANNOT separate a register from a slot, and
   that is the hardware, not a modelling gap: a slot read is a native
   `ld hl,(ix+d)` at 2 cycles, exactly what `ld l,c; ld h,b` costs. Bytes do
   separate them (fp slot 3 B against BC's 2), so ranking by bytes is a clean
   size win on the cheap-slot targets — ez80 fp, rabbit, kc160.

   It stays opt-in because bytes carry no information about the tick outcome
   here: the same ranking wins one bench and loses another on the same CPU, mode
   and shape, which is the trade IR_BCCALLCOST already measured and refused. */
static int bytetie_gap(void)
{
    static int g = -1;
    if (g < 0) {
        const char *e = getenv("IR_BYTETIE");
        g = e ? atoi(e) : 0;               /* default OFF: tick coin-flip */
    }
    return g;
}
static int bytetie_on(void)
{
    return bytetie_gap() > 0 && !opt_disabled("byte-tie");
}

static int cand_more_important(const Cand *a, const Cand *b)
{
    if (a->benefit != b->benefit) return a->benefit > b->benefit;
    /* [IR_BYTETIE] cycles tied — ask BYTES before falling back to pool order.
       This is the whole of the ez80 fp problem: there a slot and a register cost
       the same 2 cycles, so every candidate ties at 0 and the winner was decided
       by the order the proposers happened to run in. */
    if (bytetie_on()) {
        long d = a->bytes - b->bytes;
        if (d >= bytetie_gap() || -d >= bytetie_gap()) return d > 0;
    }
    /* most-constrained-first: fewer allowed classes wins the tie */
    unsigned pa = a->allowed, pb = b->allowed;
    int na = 0, nb = 0;
    while (pa) { na += pa & 1; pa >>= 1; }
    while (pb) { nb += pb & 1; pb >>= 1; }
    return na < nb;
}

static int  g0_word_cost(int reg, int kind);
static int  is_compared_counter(const Func *f, int v);
static int  is_deref_base(const Func *f, int v);
static int  is_stepped(const Func *f, int v);
static long interval_benefit_x(const Func *f, int v, const int *bb_loop_depth,
                               const int *bb_cond_shift,
                               int R, int discount);

/* [IR_BCCALLCOST=1] Charge a whole-function BC home for the call saves it forces.

   A PR_BC tenant is preserved across every call its live range covers — gen_call
   and friends emit the `push bc`/`pop bc`, and [bc-save-live] emits it on
   exactly the calls where a tenant IS live, so "calls inside the live range" is
   the emitted code, not an estimate. interval_benefit prices the accesses a
   register home saves and charges nothing for that traffic, and the BC arm has
   no benefit gate, so on a CHEAP-SLOT target a home worth a few cycles is taken
   and then pays a pair at every call it spans.

   It is a cheap-slot problem: on ez80 an fp slot is a native `ld hl,(ix+d)`, so
   a marginal BC home wins on cycles and loses on the saves. On z80 the slot is
   dear enough that BC wins anyway and the value takes a call-free RANGED home
   instead — which is also what declining here leaves it with, since ir_bc_pack
   and the call-bounded split still place it over a call-free range.

   The gate is deliberately narrow: only when a charge exists, only when it is
   what sinks the home, only when the home does not SAVE bytes, and only where
   the cycle model can tell a slot from a register at all.

   DEFAULT-ON at margin 2; `IR_OFF=bc-call-cost` opts out, `=<N>` sets the margin. */
static int bccallcost_on(void)
{
    static int c = -1;
    if (c < 0) c = !opt_disabled("bc-call-cost");
    return c;
}

/* Eviction hysteresis, as the arbiter's counter-yield uses at 1.4x: decline the
   home only when the charge beats the benefit by this factor. A thin margin is
   a coin-flip the cycle-only cost model cannot call, and losing it costs BYTES —
   a cheap-slot CPU's slot access is cheap in cycles and still 3-4 bytes against
   a 1-2 byte register copy. IR_BCCALLCOST=<N> sets the factor. */
static int bccallcost_margin(void)
{
    static int m = -1;
    if (m < 0) { const char *e = getenv("IR_BCCALLCOST"); m = (e && e[0] >= '1' && e[0] <= '9') ? e[0] - '0' : 2; }
    return m;
}

/* Cycles one `push bc` / `pop bc` pair costs. Datasheet, in the same units as
   g0_word_cost: z80 11+10, rabbit 10+7, gbz80 16+12, ez80 z80-mode 4+4,
   kc160 2+2. The 8080/8085/VM1 all share the z80 pair. */
static int g0_bc_call_save(void)
{
    if (IS_KC160())  return 4;
    if (IS_EZ80())   return 8;
    if (IS_RABBIT()) return 17;
    if (IS_GBZ80())  return 28;
    return 21;
}

/* Word-access BYTES, the size companion to g0_word_cost's cycles. [reg][kind],
   SLOT row is sp-mode and fp adjusts below, exactly as the cycle table does.

   Measured by assembling the idioms the lowerer emits (z88dk-z80asm -m<cpu> -b,
   byte count of the produced binary), not derived from a datasheet:

     BC read/write `ld l,c; ld h,b`            2 on every CPU here
     BC deref      `ld a,(bc)`                 1 (gbz80 has no such op: 3, via HL)
     BC step       `inc bc`                    1
     slot fp       `ld hl,(ix-2)`              z80 6, ez80 3, RABBIT 2, kc160 3
     slot sp       `ld hl,n; add hl,sp; ...`   8; rabbit `ld hl,(sp+n)` 2; gbz80 5
     push bc / pop bc                          1 + 1

   The RABBIT row is the reason this table has to exist. Its native
   `ld hl,(ix+d)` and `ld hl,(sp+n)` are BOTH two bytes — the same as the
   `ld l,c; ld h,b` a BC home costs — so on rabbit a whole-function BC home saves
   ZERO bytes per access while still paying two at every call it spans. It is
   byte-NEGATIVE. On ez80 the same home is byte-POSITIVE (+1 an access, 3 vs 2).
   The cycle model cannot see that difference and rates the two the same way,
   which is why charging cycles alone made rabbit smaller and ez80 +424 B larger.

   Bytes are STATIC: this table is summed over the op scan with NO loop-depth
   weighting, unlike the cycle model. A body inside a loop is not bigger. */
static int g0measured_on(void);   /* defined with the cycle table below */

static int g0_word_bytes(int reg, int kind)
{
    /* ASSEMBLED 11/9/2026 (z88dk-z80asm -b, byte counts of the sequences the
       lowerer emits). Three errors, and the sp STEP one is the SAME bug the cycle
       table had: a step is read + inc + write and EACH slot access re-forms its
       own address, so it cannot be ~1.4x a read.
         SLOT write 8 -> 7    SLOT step 11 -> 16    IX/IY read+write 4 -> 3
       SLOT read 8, deref 9, BC 2/2/1/1, IX deref 3, IX step 2 and the whole fp
       row (6/6/7/13) assemble EXACTLY as priced. `IR_G0MEASURED=0` reverts.
       This table feeds bc_byte_benefit, which is on the DEFAULT-ON IR_BCCALLCOST
       path — it is not just the opt-in byte tie-break. */
    static const int Z80B[GR_N][GK_N] = {
        /*SLOT*/{8,7,9,16}, /*BC*/{2,2,1,1}, /*DE*/{2,2,1,1},
        /*IX*/{3,3,3,2}, /*IY*/{3,3,3,2} };
    static const int Z80B_EST[GR_N][GK_N] = {
        /*SLOT*/{8,8,9,11}, /*BC*/{2,2,1,1}, /*DE*/{2,2,1,1},
        /*IX*/{4,4,3,2}, /*IY*/{4,4,3,2} };
    /* ez80 forms an sp address the z80 way (see the cycle row), so it carries the
       same write and step errors; assembled -mez80_z80: read 8, write 7. */
    static const int EZ80B[GR_N][GK_N] = {
        /*SLOT*/{8,7,9,16}, /*BC*/{2,2,1,1}, /*DE*/{2,2,1,1},
        /*IX*/{3,3,3,2}, /*IY*/{3,3,3,2} };
    static const int EZ80B_EST[GR_N][GK_N] = {
        /*SLOT*/{8,8,9,11}, /*BC*/{2,2,1,1}, /*DE*/{2,2,1,1},
        /*IX*/{3,3,3,2}, /*IY*/{3,3,3,2} };
    static const int RABBITB[GR_N][GK_N] = {
        /*SLOT*/{2,2,3,5}, /*BC*/{2,2,1,1}, /*DE*/{2,2,1,1},
        /*IX*/{2,2,3,2}, /*IY*/{2,2,3,2} };
    static const int KC160B[GR_N][GK_N] = {
        /*SLOT*/{3,3,4,7}, /*BC*/{2,2,1,1}, /*DE*/{2,2,1,1},
        /*IX*/{3,3,3,2}, /*IY*/{3,3,3,2} };
    /* No `ld a,(bc)` and no index registers — see the GBZ80 cycle row. */
    /* gbz80's slot is NATIVE (`ld hl,sp+n`, 2 B) so read 5 / write 5 / deref 6 are
       right — but the step assumed address reuse too. Assembled -mgbz80: 11. */
    static const int GBZ80B[GR_N][GK_N] = {
        /*SLOT*/{5,5,6,11}, /*BC*/{2,2,3,1}, /*DE*/{2,2,3,1},
        /*IX*/{99,99,99,99}, /*IY*/{99,99,99,99} };
    static const int GBZ80B_EST[GR_N][GK_N] = {
        /*SLOT*/{5,5,6,9}, /*BC*/{2,2,3,1}, /*DE*/{2,2,3,1},
        /*IX*/{99,99,99,99}, /*IY*/{99,99,99,99} };
    int meas = g0measured_on();
    const int (*t)[GK_N] = IS_KC160() ? KC160B
                         : IS_EZ80()  ? (meas ? EZ80B  : EZ80B_EST)
                         : IS_GBZ80() ? (meas ? GBZ80B : GBZ80B_EST)
                         : IS_RABBIT() ? RABBITB
                         : (meas ? Z80B : Z80B_EST);
    int b = t[reg][kind];
    if (reg == GR_SLOT && c_framepointer_is_ix != -1) {   /* fp slot = (ix+d) */
        if (t == Z80B || t == Z80B_EST)
                              b = (kind == GK_STEP) ? 13 : (kind == GK_DEREF) ? 7 : 6;
        else if (t == EZ80B || t == EZ80B_EST)
                              b = (kind == GK_STEP) ?  7 : (kind == GK_DEREF) ? 4 : 3;
        else if (t == KC160B) b = (kind == GK_STEP) ?  7 : (kind == GK_DEREF) ? 4 : 3;
        /* rabbit fp `ld hl,(ix+d)` is 2 as well — the sp row already says 2. */
    }
    return b;
}

/* ---- Deref OFFSET: the term that tells an index home from a GP pair -------
   A deref at a NONZERO constant field offset does not cost the same in every
   home: IX/IY spell the displacement inside the instruction, BC/DE must copy
   the pointer into HL first (`ld a,(bc)` has no displaced form) and then step,
   and a SLOT read already left the address in HL so it steps only. The walk is
   emit_hl_add_offset's; both arms are priced off the existing rows so a new CPU
   inherits them.

   ►► Without this term the model rates a BC home and an index home ALIKE for a
   struct pointer read at four field offsets, and the index home falls to a
   scalar that must be pushed and popped at every read. The asymmetry is the
   whole point: an index register cannot feed the ALU. adr/0065. */
static int g0_deref_walk(int ofs) { int k = ofs < 0 ? -ofs : ofs;
                                    return k < 4 ? k : 4; }

/* The term describes the `idx-deref` lowering, so it lives and dies with it:
   with the rung off an index home reaches its pointee through `push iy;pop hl`
   and then walks like everything else, which is what the un-adjusted rows
   already price. Switching the rung off therefore restores the old ALLOCATION
   as well as the old codegen — the gate-off build stays byte-identical. */
static int idx_deref_pricing(void)
{
    /* IR_IDXPRICE=0 keeps the RUNG but drops the OFFSET TERM — the knob that
       attributes a size move to the lowering or to the allocation it caused.
       Both are on by default; --opt-disable=idx-deref takes away both. */
    /* The knob that split the cost TERM from the RUNG is gone: it existed to
       attribute the size move to one or the other, and ADR 0026 records the
       answer (most of it was the term). */
    return !opt_disabled("idx-deref");
}

static int g0_deref_offset_bytes(int reg, int ofs)
{
    if (ofs == 0 || !idx_deref_pricing()) return 0;
    if (reg == GR_IX || reg == GR_IY) return 0;
    int b = g0_deref_walk(ofs) * g0_word_bytes(GR_BC, GK_STEP);
    if (reg == GR_BC || reg == GR_DE) b += g0_word_bytes(GR_BC, GK_READ);
    return b;
}

static int g0_deref_offset_cost(int reg, int ofs)
{
    if (ofs == 0 || !idx_deref_pricing()) return 0;
    if (reg == GR_IX || reg == GR_IY) return 0;
    int c = g0_deref_walk(ofs) * g0_word_cost(GR_BC, GK_STEP);
    if (reg == GR_BC || reg == GR_DE) c += g0_word_cost(GR_BC, GK_READ);
    return c;
}

/* The offset a deref op carries, or 0 for anything that is not one. Only a
   MEM_VREG access based on `v` walks; a post-stepped one reaches its field
   through the step and is left at 0. */
static int g0_deref_ofs_of(const Op *o, int v)
{
    if (!o || (o->kind != IR_LD_MEM && o->kind != IR_ST_MEM)) return 0;
    if (o->mem.kind != IR_MEM_VREG || o->mem.base != v) return 0;
    if (o->mem.post_step != 0) return 0;
    return o->mem.offset;
}

/* STATIC bytes a whole-function BC home for v saves over the slot, net of the
   `push bc` / `pop bc` (2 B) it adds at every call inside its live range. >0
   means the home pays for itself in SIZE. No loop weighting — see above. */
/* [IR_BYTETIE] bc_byte_benefit generalised to any register class, for the
   tie-break. Same walk, same STATIC (unweighted) accounting — a body inside a
   loop is not bigger — and the same `push`/`pop` charge at every call the live
   range spans, which is what stops a call-heavy value from looking free. */
static long g0_byte_benefit(const Func *f, int v, int R)
{
    const LiveRange *lr = ir_live_range(f, v);
    long ben = 0;
    int flat = 0;
    int save = (R == GR_IX || R == GR_IY) ? 4 : 2;   /* push/pop pair, idx is 2+2 */
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++, flat++) {
            const Op *o = &bb->ops[j];
            if ((o->kind == IR_CALL || o->kind == IR_HCALL)
                && lr && lr->start >= 0
                && flat >= lr->start && flat <= lr->end)
                ben -= save;
            int sv = -1;
            if ((o->kind == IR_INC || o->kind == IR_DEC) && o->dst >= 0
                && o->src[0] == o->dst) sv = o->dst;
            else if (o->kind == IR_POSTSTEP && o->src[0] >= 0) sv = o->src[0];
            if (sv == v || (o->dst == v && (o->src[0] == v || o->src[1] == v))) {
                ben += g0_word_bytes(GR_SLOT, GK_STEP) - g0_word_bytes(R, GK_STEP);
                continue;
            }
            if (o->dst == v)
                ben += g0_word_bytes(GR_SLOT, GK_WRITE) - g0_word_bytes(R, GK_WRITE);
            int mb = ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                      && o->mem.kind == IR_MEM_VREG) ? o->mem.base : -1;
            int u[16]; int nu = ir_op_uses(o, u, 16);
            int dofs = g0_deref_ofs_of(o, v);
            for (int k = 0; k < nu; k++) if (u[k] == v)
                ben += (v == mb)
                     ? (g0_word_bytes(GR_SLOT, GK_DEREF)
                        + g0_deref_offset_bytes(GR_SLOT, dofs))
                       - (g0_word_bytes(R, GK_DEREF)
                          + g0_deref_offset_bytes(R, dofs))
                     : g0_word_bytes(GR_SLOT, GK_READ)  - g0_word_bytes(R, GK_READ);
        }
    }
    return ben;
}

static long bc_byte_benefit(const Func *f, int v)
{
    const LiveRange *lr = ir_live_range(f, v);
    long ben = 0;
    int flat = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        const BB *bb = &f->bbs[b];
        for (int j = 0; j < bb->n_ops; j++, flat++) {
            const Op *o = &bb->ops[j];
            if ((o->kind == IR_CALL || o->kind == IR_HCALL)
                && lr && lr->start >= 0
                && flat >= lr->start && flat <= lr->end)
                ben -= 2;                       /* push bc + pop bc */
            int sv = -1;
            if ((o->kind == IR_INC || o->kind == IR_DEC) && o->dst >= 0
                && o->src[0] == o->dst) sv = o->dst;
            else if (o->kind == IR_POSTSTEP && o->src[0] >= 0) sv = o->src[0];
            if (sv == v) {
                ben += g0_word_bytes(GR_SLOT, GK_STEP) - g0_word_bytes(GR_BC, GK_STEP);
                continue;
            }
            if (o->dst == v && (o->src[0] == v || o->src[1] == v)) {
                ben += g0_word_bytes(GR_SLOT, GK_STEP) - g0_word_bytes(GR_BC, GK_STEP);
                continue;
            }
            if (o->dst == v)
                ben += g0_word_bytes(GR_SLOT, GK_WRITE) - g0_word_bytes(GR_BC, GK_WRITE);
            int mb = ((o->kind == IR_LD_MEM || o->kind == IR_ST_MEM)
                      && o->mem.kind == IR_MEM_VREG) ? o->mem.base : -1;
            int u[16]; int nu = ir_op_uses(o, u, 16);
            int dofs = g0_deref_ofs_of(o, v);
            for (int k = 0; k < nu; k++) if (u[k] == v)
                ben += (v == mb)
                     ? (g0_word_bytes(GR_SLOT, GK_DEREF)
                        + g0_deref_offset_bytes(GR_SLOT, dofs))
                       - (g0_word_bytes(GR_BC, GK_DEREF)
                          + g0_deref_offset_bytes(GR_BC, dofs))
                     : g0_word_bytes(GR_SLOT, GK_READ)  - g0_word_bytes(GR_BC, GK_READ);
        }
    }
    return ben;
}

/* Depth-weighted cost of the saves a whole-function BC home for v would force,
   over the calls inside v's live range. Same weights as interval_benefit_x, so
   the two are directly comparable. */
static long bc_call_save_charge(const Func *f, int v, const int *bb_loop_depth,
                                const int *bb_cond_shift)
{
    const LiveRange *lr = ir_live_range(f, v);
    if (!lr || lr->start < 0) return 0;
    int pair = g0_bc_call_save();
    long charge = 0;
    int flat = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        long w = bb_loop_depth ? bb_iter_weight(bb_loop_depth, b, 0) : 1;
        if (bb_cond_shift)
            for (int i = 0; i < bb_cond_shift[b] && w > 1; i++) w /= 2;
        for (int j = 0; j < f->bbs[b].n_ops; j++, flat++) {
            OpKind k = f->bbs[b].ops[j].kind;
            if (k != IR_CALL && k != IR_HCALL) continue;
            if (flat < lr->start || flat > lr->end) continue;
            charge += w * pair;
        }
    }
    return charge;
}


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
/* Stable tie-break for two equally-ranked general-DE candidates. In a binary
   search the low bound and the high bound have the same interval and the same
   use count, so `benefit` cannot separate them and the pool order decides. The
   high bound is the better resident: its update is a subtract, which the Z80
   compare/update sequence reaches directly, while the low bound's update is an
   add that has to go the long way round. Score = (subtract defs - add defs), so
   the bound that is decremented wins. [mwbc] */
static int de_upper_bound_score(const Func *f, int v)
{
    int score = 0;
    for (int b = 0; b < f->n_bbs; b++)
        for (int j = 0; j < f->bbs[b].n_ops; j++) {
            const Op *o = &f->bbs[b].ops[j];
            if (o->kind == IR_SUB && o->dst == v) score++;
            if (o->kind == IR_ADD && o->dst == v) score--;
        }
    return score;
}
/* [IR_LIVEPROBE] The allocator's REAL interference test: inclusive overlap of
   two [lo,hi] intervals. Six sites inline this over three different interval
   arrays (pool[].lo/hi, cand[].flo/fhi, first_use[]/last_use[]) — routing them
   through one helper is what lets the probe see the decisions that actually
   allocate. `ir_live_ranges_overlap` is NOT that test: it is reached only by one
   narrow counter-yield tie-break. Behaviour identical to the inlined form. */
static inline int iv_overlap(const Func *f, int a, int b,
                             int alo, int ahi, int blo, int bhi)
{
    int s = alo > blo ? alo : blo;
    int e = ahi < bhi ? ahi : bhi;
    int ans = s <= e;
    ir_liveprobe_count_iv(f, a, b, ans, alo, ahi, blo, bhi);
    return ans;
}

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
                              const int *idx_keep, const int *bb_loop_depth,
                              const int *bb_cond_shift, int bc_yield_v)
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
    int idx2_defer = -1;                 /* best param that yielded to a counter */
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
            if (idx2_taken) continue;
            if (f->idx2_reg == IR_PR_NONE) continue;
            /* G1 grounded gate: skip an index home that costs more than the slot
               for this value (read-only value on a cheap-slot target). G2: unless
               the setup/step keep-rule protects it (queen-pattern counter). */
            if (idx_ben && idx_ben[v] <= 0 && !(idx_keep && idx_keep[v])) continue;
            /* A home that is DEAR TO FILL cannot take a parameter: the value
               must be read from the caller's slot and moved into the pair
               before the home serves anything, and the pair is callee-saved
               across the whole function. A COUNTER pays back at once because
               the home absorbs the STEP as well as the reads; idx_ben cannot
               tell them apart because it prices accesses and charges nothing
               for filling the home. This asks about THIS home rather than about
               the CPU — the general setup term is still missing. adr/0066. */
            if ((c->flags & CF_IDX2_PARAM) && f->idx2_reg == IR_PR_HL_ALT)
                continue;
            if (c->flags & CF_IDX2_PARAM) {
                int counter_waiting = 0;
                for (int k = 0; k < n; k++)
                    if ((pool[k].allowed & RC_IDX2)
                        && (pool[k].flags & CF_IDX2_COUNTER)
                        && f->vreg_to_phys[pool[k].vreg] == IR_PR_SPILL) {
                        counter_waiting = 1; break;
                    }
                /* ►► THE DEFERRAL MUST BE REVISITED. Yielding to a counter is
                   right only if the counter GOES ON to take the index, and it
                   often does not — the BC arm below places it there and its own
                   IDX2 candidate is then skipped as already-placed, leaving the
                   register claimed by NOBODY. Remember the best deferred param
                   and give it the index after the loop if it is still free.
                   adr/0059. */
                if (counter_waiting) {
                    if (idx2_defer < 0 || c->benefit > pool[idx2_defer].benefit)
                        idx2_defer = (int)(c - pool);
                    continue;
                }
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
            /* [IR_BCCALLCOST] The home must out-earn the saves it forces. */
            if (bccallcost_on() && bb_loop_depth) {
                long chg = bc_call_save_charge(f, v, bb_loop_depth, bb_cond_shift);
                long ben = interval_benefit_x(f, v, bb_loop_depth,
                                              bb_cond_shift, GR_BC, 0);
                /* Decline only when the home loses on BOTH axes. A home that
                   loses cycles but SAVES bytes is a byte-for-tick trade the
                   allocator has no mandate to make on its own — and on ez80 fp
                   that trade is the whole of a +424 B corpus regression. */
                /* Only where the cycle model can SEE a difference. On ez80 fp
                   a slot read is a native `ld hl,(ix+d)` costing the same 2
                   cycles as `ld l,c; ld h,b`, so interval_benefit rates EVERY
                   candidate 0 and the arbiter's tie is broken by pool order,
                   not merit. Declining on a benefit the model cannot compute is
                   churn: it wins queenbench 2.81% and loses hashbench 1.76% on
                   the same CPU, mode and shape. Ask for a real gap first. */
                int seen = g0_word_cost(GR_SLOT, GK_READ)
                         > g0_word_cost(GR_BC, GK_READ);
                if (seen && chg > 0 && bccallcost_margin() * ben <= chg
                    && bc_byte_benefit(f, v) <= 0)
                    continue;
            }
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
            /* [mwbc-pressure] A loop-carried accumulator prices high for
               BC but is worth less there than the value it displaces. Give BC
               to an overlapping candidate that is still unplaced; where a spare
               index exists ir_iy_reduction_pack picks this one up afterwards,
               and where none does it spills, which still measured better on
               every target. Uncontended BC is kept — see
               contended_acc_yields_bc. */
            if (v == bc_yield_v) {
                int contended = 0;
                for (int j = 0; j < n && !contended; j++) {
                    if (pool[j].vreg == v || !(pool[j].allowed & RC_BC)) continue;
                    if (f->vreg_to_phys[pool[j].vreg] != IR_PR_SPILL) continue;
                    contended = iv_overlap(f, v, pool[j].vreg, c->lo, c->hi,
                                           pool[j].lo, pool[j].hi);
                }
                if (contended) continue;
            }
            /* Interval overlap against already-assigned BC vregs, using the
               [lo,hi] each carries in the pool (BC is multi-occupant). */
            int ok = 1;
            ir_liveprobe_decision_begin_cand(0, v, c->lo, c->hi);
            for (int j = 0; j < n && ok; j++) {
                if (pool[j].vreg == v) continue;
                if (f->vreg_to_phys[pool[j].vreg] != IR_PR_BC) continue;
                if (iv_overlap(f, v, pool[j].vreg,
                               c->lo, c->hi, pool[j].lo, pool[j].hi)) ok = 0;
            }
            ir_liveprobe_decision_end();
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
                long vben = interval_benefit_x(f, v, bb_loop_depth, bb_cond_shift, GR_BC, 1);
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
                    long wben = interval_benefit_x(f, w, bb_loop_depth, bb_cond_shift, GR_BC, 1);
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
    /* ►► Revisit the param that yielded idx2 to a counter. If the counter did
       not in fact take the index — it is normally also a BC candidate and the
       BC arm above places it there, after which its own IDX2 candidate is
       skipped as already-placed — the register is sitting EMPTY and the param
       is in a slot. Give it the register. Only when idx2 is genuinely still
       free and the param is still unplaced, so the yield is preserved whenever
       the counter DID collect it. adr/0059. `--opt-disable=idx2-revisit`. */
    if (idx2_defer >= 0 && !idx2_taken && f->idx2_reg != IR_PR_NONE
        && !opt_disabled("idx2-revisit")
        && f->vreg_to_phys[pool[idx2_defer].vreg] == IR_PR_SPILL) {
        f->vreg_to_phys[pool[idx2_defer].vreg] = f->idx2_reg;
        idx2_taken = 1;
    }
    /* ---- PAIRWISE SWAP: BC <-> the index home ----------------------------
       The loop above is ISOLATION-PRICED GREEDY: it gives each candidate its
       own best class and never prices the PAIRING. For BC against an index
       home the pairing is what matters, because the two are not
       interchangeable in the same direction — a VALUE strongly prefers BC
       (`ld a,c` against `push iy;pop hl`, which cannot feed the ALU) while a
       BASE prefers it only narrowly (`ld a,(bc)` is offset-0 only, `(iy+d)` is
       any offset). The greedy order hands BC to the pointer. Worked numbers:
       adr/0058.

       Deliberately narrow: ONE BC tenant and ONE index tenant, both already
       placed, each admissible in the other's class, and the swap must WIN on
       the same interval_benefit the loop ranked by. `--opt-disable=home-swap`
       opts out. */
    if (!opt_disabled("home-swap") && f->idx2_reg != IR_PR_NONE && bb_loop_depth) {
        int v_bc = -1, v_idx = -1, n_bc = 0;
        for (int j = 0; j < f->n_vregs; j++) {
            if (f->vreg_to_phys[j] == IR_PR_BC) { v_bc = j; n_bc++; }
            else if (f->vreg_to_phys[j] == f->idx2_reg) v_idx = j;
        }
        /* BC is multi-occupant; a swap is only well-defined with a single
           tenant, and the index classes are one-tenant by construction. */
        if (n_bc == 1 && v_bc >= 0 && v_idx >= 0 && v_bc != v_idx) {
            /* Each must be ALLOWED in the other's class — the pool records
               what the proposers admitted, including the idx gates. */
            int bc_ok_idx = 0, idx_ok_bc = 0;
            for (int i = 0; i < n; i++) {
                if (pool[i].vreg == v_bc && (pool[i].allowed & (RC_IDX2 | RC_IDX3)))
                    bc_ok_idx = 1;
                if (pool[i].vreg == v_idx && (pool[i].allowed & RC_BC))
                    idx_ok_bc = 1;
            }
            if (bc_ok_idx && idx_ok_bc
                && (!idx_ben || idx_ben[v_bc] > 0)) {
                long now  = interval_benefit_x(f, v_bc,  bb_loop_depth, bb_cond_shift, GR_BC, 0)
                          + interval_benefit_x(f, v_idx, bb_loop_depth, bb_cond_shift, GR_IX, 0);
                long swp  = interval_benefit_x(f, v_bc,  bb_loop_depth, bb_cond_shift, GR_IX, 0)
                          + interval_benefit_x(f, v_idx, bb_loop_depth, bb_cond_shift, GR_BC, 0);
                if (swp > now) {
                    f->vreg_to_phys[v_bc]  = f->idx2_reg;
                    f->vreg_to_phys[v_idx] = IR_PR_BC;
                }
            }
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
            else if (mwbc_on() && c->benefit == pool[gbest].benefit
                     && de_upper_bound_score(f, c->vreg)
                        > de_upper_bound_score(f, pool[gbest].vreg))
                gbest = i;
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
/* What the pack would claim, separated from the claiming. The reduction pass
   runs late (after BC packing) and reads its candidates out of `vreg_to_phys`,
   so the value it wants is only visible to it once every earlier pass has
   declined that value. That makes the pick invisible to BC arbitration, which
   is where the two compete. Discovery is therefore a query, callable both from
   the pack and from the BC reservation below. */
typedef struct {
    int  acc, acc_bb;          /* loop-carried accumulator, or acc<0 */
    long acc_score;
    int  members[32], nm, chain_bb;   /* the best reduction chain */
    long chain_score;
    int  win_acc;              /* the accumulator outscored the chain */
    int  win;                  /* the vreg claimed first (acc, or chain head) */
    long win_score;
} IyPick;

static int lra_iy_discover(const Func *f, const int *bb_in_loop,
                           const int *use_count, int exclude, IyPick *pick)
{
    /* RAW use counts (the passed use_count is depth-weighted — no good for a
       single-use test). raw_uses[v] = number of ops that read v. Also mark
       deref bases: a value used as a MEM_VREG base (or POSTSTEP subject) is a
       POINTER — it must stay addressable (`ld a,(hl)` etc.), NOT get homed in IY
       via add-iy-de (its deref would need (iy+d) / a separate path). The
       accumulator detector otherwise matches a walking pointer `p = p + stride`
       (same `s = s OP x` shape); excluding bases prevents that (test_remat_counter). */
    int *raw_uses = calloc((size_t)f->n_vregs, sizeof(int));
    int *is_base  = calloc((size_t)f->n_vregs, sizeof(int));
    if (!raw_uses || !is_base) { free(raw_uses); free(is_base); return 0; }
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
        if (v == exclude) continue;
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
            if (d0 == exclude) continue;
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
                if (nb < 0 || nd == exclude) break;
                if (!lra_iy_chain_ok(f, nd) || is_base[nd]) break;
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
    free(raw_uses); free(is_base);

    /* One IY user per function: the higher-scoring of {accumulator, chain}. */
    pick->acc = acc; pick->acc_bb = acc_bb; pick->acc_score = acc_score;
    pick->nm = best_nm; pick->chain_bb = best_bb; pick->chain_score = best_score;
    for (int m = 0; m < best_nm; m++) pick->members[m] = best[m];
    pick->win_acc = (acc >= 0 && acc_score >= best_score);
    if (!pick->win_acc && best_nm < 2) return 0;             /* no candidate */
    pick->win = pick->win_acc ? acc : best[0];
    pick->win_score = pick->win_acc ? acc_score : best_score;
    return 1;
}

/* LRA Phase 2c proper: claim IY for whatever discovery picked. */
static void ir_iy_reduction_pack(Func *f, const int *bb_in_loop,
                                 const int *use_count)
{
    IyPick pick;
    if (opt_disabled("lra")) return;
    if (!lra_iy_available(f)) return;
    if (!lra_iy_discover(f, bb_in_loop, use_count, -1, &pick)) return;
    long win_score = pick.win_score;

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
        if (c_framepointer_is_ix != 1) return;
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

    if (pick.win_acc) {
        f->vreg_to_phys[pick.acc] = IR_PR_IY;
        f->idx3_reg = IR_PR_IY;
        if (getenv("IR_ALLOC_PROBE"))
            fprintf(stderr, "IY_ACC v%d bb%d score=%ld (loop-carried accumulator)\n",
                    pick.acc, pick.acc_bb, pick.acc_score);
    } else {
        for (int m = 0; m < pick.nm; m++) f->vreg_to_phys[pick.members[m]] = IR_PR_IY;
        f->idx3_reg = IR_PR_IY;
    }
}

/* [mwbc-pressure] Which value BC arbitration should NOT take.

   A loop-carried accumulator prices very high for a register home: every
   `s = s OP x` is an RMW, and interval_benefit credits the whole slot round
   trip against it. That is a fair price for the accumulator in isolation, but
   it says nothing about what BC is worth to the value it displaces — in
   lexbench's `lex` the accumulator outranks the loop counter and the walking
   state, takes BC, and leaves them in slots, which is worse on every target.

   So when an accumulator is CONTENDED — another BC candidate overlaps it and is
   still unplaced — it yields. Where a spare index register exists the
   accumulator is not penalised: `ir_iy_reduction_pack` collects it into IY
   afterwards. Where none does it simply spills, and that is still the better
   trade. Uncontended BC is never yielded: with nothing else wanting the
   register the accumulator should keep it.

   Two restrictions:
     - Accumulators only. A reduction chain member is a single-use partial, so
       it is not a BC candidate and has nothing to yield.
     - The yield must not COST an index home elsewhere. Discovery runs before
       any placement, so it sees every vreg as free and can name a value the IY
       pack would itself pass over — in sieve_count it names an accumulator the
       pack skips in favour of a longer-lived reduction chain, and yielding
       there moved that chain out of IY for a 49% loss. Re-run discovery with
       the candidate excluded: if the pack would still claim something, decline.

   In sp mode IY is idx3, a class the arbiter places itself, and the pack bails
   rather than evicts when it finds IY taken — so there, only yield when idx3 is
   off, or the accumulator could lose BC and find no index home either. */
static int contended_acc_yields_bc(const Func *f, const int *bb_in_loop,
                             const int *use_count)
{
    IyPick pick, without;
    if (!mwbc_pressure_on()) return -1;
    if (c_framepointer_is_ix != 1 && f->idx3_reg != IR_PR_NONE) return -1;
    if (!lra_iy_discover(f, bb_in_loop, use_count, -1, &pick)) return -1;
    if (!pick.win_acc) return -1;                     /* accumulators only */
    /* The yield must not cost an index home elsewhere — see the note above. */
    if (lra_iy_discover(f, bb_in_loop, use_count, pick.win, &without)) return -1;
    if (getenv("IR_ALLOC_PROBE"))
        fprintf(stderr, "BC_YIELD %s v%d score=%ld\n",
                f->fn ? ir_sym_name(f->fn) : "?", pick.win, pick.win_score);
    return pick.win;
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

/* [bc-per-cand] Per-candidate replacement for the whole-function BC veto.
   bc_region_ok is three PER-OP facts (width-4 low-half staging, non-char
   IR_SWITCH dispatch, IR_ACC_* helpers) promoted to a whole-function
   disqualification, so one long or one switch anywhere kills BC homing
   everywhere in the function. op_clobbers already returns the precise per-op
   answer, and both IY packs already consume it that way. This asks the narrow
   question instead: does anything inside THIS candidate's live range clobber BC?

   Conservative in two directions on purpose. The live range is the hole-free
   [start,end], so a value with a hole over the clobber still reads as crossing
   it (that imprecision is the interference work's problem, not this one), and a
   candidate is rejected outright if its range is unknown. */
static int vreg_reg_clean(const Func *f, int v, RegMask m)
{
    const LiveRange *lr = ir_live_range(f, v);
    if (!lr || lr->start < 0) return 0;
    int g = 0;
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++, g++) {
            if (g < lr->start || g > lr->end) continue;
            if (op_clobbers(f, &f->bbs[i].ops[j]) & m) return 0;
        }
    return 1;
}

static int vreg_bc_clean(const Func *f, int v)
{
    return vreg_reg_clean(f, v, IR_R_BC);
}

/* Mirrors BC_ARGS_SAVE_MAX in ir_lower_ops.inc.c — a different TU, so this
   cannot read it. If that cap moves, move this with it. */
#define BC_ARGS_SAVE_MAX_PROBE 8

/* [prepush-narrow] Does a pre-pushed-arg call in this function actually
   endanger a BC home?

   The whole-function `has_prepushed_call` veto was written when gen_call had no
   way to save BC around a call whose args were already on the stack — the save
   would have landed above the arg block — leaving only emit_bc_reload, a slot
   read that a slotless LOCAL cannot serve. The lowerer no longer works that
   way: gen_push_arg emits `push bc` at the call's FIRST push (op->imm == 1),
   BELOW the arg block, stacks the cache belief on bc_args_save_stack, and
   gen_call pops it after the cleanup. func_has_pr_bc gates it and does not care
   whether the tenant is a param or a local.

   Two things that save does NOT cover, and this reports either:

     (a) IR_PUSH_STRUCT. gen_push_struct emits no save and its block copy is
         ldir, which eats BC as the counter. It is rejected wherever it appears
         in the function, not just when it is the arg that goes first: the copy
         kills BC MID-GROUP, so a later arg in the same call cannot be served
         from BC either, and the pop only restores after the call.
     (b) A pre-pushed call reaching gen_call with the save stack EMPTY — nothing
         to pop. ir_build stamps the marker on the first IR_PUSH_ARG only (a
         struct taking that slot leaves the call unmarked), and gen_push_arg
         skips the save once BC_ARGS_SAVE_MAX is reached.

   Simulate the emitter rather than re-deriving the pairing: the save stack is
   pushed at every imm == 1 and popped at every pre-pushed call, in the order
   the ops are EMITTED, which is this linear walk. Reading the marker per call
   gets nesting wrong — for f(a, g(b)) the push of g's result carries imm == 0
   because it is f's SECOND push, yet f's save was already emitted at `push a`. */
static int prepush_bc_hazard(const Func *f)
{
    int depth = 0;
    for (int i = 0; i < f->n_bbs; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++) {
            const Op *o = &f->bbs[i].ops[j];
            if (o->kind == IR_PUSH_STRUCT)
                return 1;                                   /* (a) */
            if (o->kind == IR_PUSH_ARG && o->imm == 1) {
                if (depth < BC_ARGS_SAVE_MAX_PROBE) depth++;
            } else if (o->kind == IR_CALL && o->call
                       && o->call->pre_pushed > 0) {
                if (depth > 0) depth--;
                else return 1;                              /* (b) */
            }
        }
    return 0;
}


/* [IR_OFF=bc-per-cand] Default-on after the matrix: switchbench -1.96%..-5.63% and
   widthbench -0.14%..-1.43% on all six valid-tick CPUs, every other suite within
   12 ticks (the shared test.c, both signs); no new aborts over corpus x 10 CPUs x
   sp/fp; adv_a -4/-6, clisp -59/-8, enigma unchanged. Opt out to revert. */
static int bcpercand_on(void)
{
    static int on = -1;
    if (on < 0) on = !opt_disabled("bc-per-cand");
    return on;
}

static void ir_bc_pack(Func *f, const int *first_use, const int *last_use,
                       const int *bb_first_op, const int *def_kind,
                       const int *write_count, const int *use_count,
                       const long *cost_benefit, int vetoed,
                       const int *bb_loop_depth, const int *bb_cond_shift)
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
    /* [bc-per-cand] In a function the whole-function veto rejected, keep only the
       candidates whose own live range never crosses a BC clobber. */
    if (vetoed) {
        int k = 0;
        for (int i2 = 0; i2 < nc; i2++)
            if (vreg_bc_clean(f, cand[i2].vreg)) cand[k++] = cand[i2];
        nc = k;
    }

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
                ir_liveprobe_decision_begin_site(1);
                for (int i = 0; i < nc; i++) {                      /* blocks a cand? */
                    if (iv_overlap(f, cand[i].vreg, j,
                                   cand[i].flo, cand[i].fhi, jlo, jhi)) { blocks = 1;
                        if (use_count[cand[i].vreg] >= use_count[j]) hotter = 1;
                    }
                }
                ir_liveprobe_decision_end();
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
                    ir_liveprobe_decision_begin_site(2);
                    for (int j = 0; j < f->n_vregs && !clash; j++) {
                        if (f->vreg_to_phys[j] != IR_PR_BC) continue;
                        if (f->vregs[j].flags & IR_VREG_BC_PACK) continue;
                        if (pass == 1 && evictable[j]) continue;   /* freed */
                        int jlo, jhi;
                        bc_tenant_interval(j, itloc, itlo, ithi, first_use, last_use, &jlo, &jhi);
                        if (iv_overlap(f, cand[i].vreg, j,
                                       cand[i].flo, cand[i].fhi, jlo, jhi)) clash = 1;
                    }
                    ir_liveprobe_decision_end();
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
    int packed = 0, last_fhi = -1; int rej_sib = 0, rej_ten = 0;
    for (int i = 0; i < nc; i++) {
        int v = cand[i].vreg;
        if (cand[i].flo <= last_fhi) { rej_sib++; continue; }   /* packed sibling */
        int clash = 0;
        ir_liveprobe_decision_begin_site(3);
        for (int j = 0; j < f->n_vregs && !clash; j++) {
            if (f->vreg_to_phys[j] != IR_PR_BC) continue;
            if (f->vregs[j].flags & IR_VREG_BC_PACK) continue;   /* our own */
            int jlo, jhi;
            bc_tenant_interval(j, itloc, itlo, ithi, first_use, last_use, &jlo, &jhi);
            if (iv_overlap(f, cand[i].vreg, j,
                           cand[i].flo, cand[i].fhi, jlo, jhi)) clash = 1;
        }
        ir_liveprobe_decision_end();
        if (clash) {
            rej_ten++;
continue;
        }
        f->vreg_to_phys[v] = IR_PR_BC;
        f->vregs[v].flags |= IR_VREG_BC_PACK;
        last_fhi = cand[i].fhi;
        packed++;
    }
    if (getenv("IR_ALLOC_PROBE"))
        fprintf(stderr, "BC_PACK packed=%d of candidates=%d rejsib=%d rejten=%d\n",
                packed, nc, rej_sib, rej_ten);
    free(cand); free(itloc); free(itlo); free(ithi);
}


/* The weight of BB b before the conditional-shift halving each caller applies. */
static long bb_iter_weight(const int *bb_loop_depth, int b, int depth_flat)
{
    int depth = bb_loop_depth[b];
    if (depth_flat && depth > 1) depth = 1;
    long w = 1;
    for (int dw = 0; dw < depth && dw < 8; dw++) w *= 4;
    return w;
}




/* Ops that manipulate the stack or transfer control — forbidden between a
   stack-transient's def and its use (they'd break the push/pop TOS discipline
   or the LIFO balance). ALU/compare/load/store/conv are all fine: the value
   rides the stack across them untouched. */
/* KNOWN GAP: this switches on op KIND and never WIDTH, so it clears an op whose
   LOWERING stages through the stack — a width-4 IR_XOR/IR_AND/IR_OR emits
   `push de; push hl; … cur_sp_adjust += 4`, and a park spanning one is no longer
   at TOS when popped (emu.c miscompiles). Harmless today only because
   bc_region_ok vetoes the whole pass for such functions. The fix is to DERIVE
   this: teach op_clobbers to report IR_R_SP for ops that push (it never sets it
   for any op today, though instr_effects already does at text level), then test
   `op_clobbers(o) & (IR_R_SP|IR_R_MEM)` instead of listing kinds. An enumeration
   has already been wrong twice — IR_ACC_* below, and the width-4 case. */
static int stack_spill_span_hazard(OpKind k)
{
    switch (k) {
    case IR_CALL: case IR_HCALL: case IR_ASM:
    /* Wide (>4-byte) memory-accumulator ops are helper CALLS too — they carry a
       HelperInfo just like IR_HCALL. They were missing here, which was invisible
       while bc_region_ok vetoed the whole pass for such functions; lifting that
       veto exposed it as a long_ir/longlong hang. */
    case IR_ACC_BINOP: case IR_ACC_UNOP: case IR_ACC_CMP:
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
          || IS_808x() || IS_GBZ80())) return;

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

        /* A symbol ADDRESS whose one use is an ST_MEM base costs nothing at
           all: gen_st_mem folds `t = &sym; *t = v` into the direct absolute
           store `ld (sym+off),hl`, so the base is never materialised. Parking
           it BLOCKS that fold — the fold has to decline a PR_STACK base or the
           pushed word is never popped (see gen_st_mem) — and we pay the base
           load plus a push/pop plus the three-instruction store-through-pointer
           where one `ld (sym),hl` would do. Every `global.field = v` in a
           function that also reads the field takes this path, because folding
           the LOAD half of the RMW is what drops the base to the single use
           PR_STACK wants. Leave it alone and let the fold have it. */
        if (bb->ops[lo].kind == IR_LD_SYM && bb->ops[lo].mem.sym
            && bb->ops[hi].kind == IR_ST_MEM
            && bb->ops[hi].mem.kind == IR_MEM_VREG
            && bb->ops[hi].mem.base == v
            && !bb->ops[hi].mem.post_step
            && bb->ops[hi].src[0] >= 0)
            continue;

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
/* [IR_G0MEASURED=0] Restore the pre-measurement g0_word_cost estimates for the
   Z80 row. Default ON: the row is now micro-benchmarked (z80_cost_bench.py). */
static int g0measured_on(void)
{
    static int on = -1;
    if (on < 0) on = !opt_disabled("g0-measured");
    return on;
}

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
    /* MEASURED 11/9/2026 by z80_cost_bench.py (empty-loop anchored, every body
       `defb` so copt cannot fold it, the sequences the LOWERER emits). The row
       previously carried "deref/step est" and the estimates were wrong in BOTH
       DIRECTIONS, which is why the error survived — they cancel in aggregate:
         SLOT deref 46 -> 52   under-charged: the model UNDER-valued a register
                               home for pointer-ish values (the deref-base case).
         SLOT write 46 -> 41   over-charged.
       SLOT STEP STAYS 92. The first measurement said 73 and it was WRONG — the
       bench reused HL between the read and the write-back (`dec hl`), which the
       LOWERER NEVER DOES: every slot access re-forms its own address, so an
       in-place step is read(45) + inc + write(41) ~= 92. Caught by lexbench going
       +4.8 % ticks on 8080 while shrinking. This is the trap GRAPH_ALLOC_PLAN.md
       states outright — MEASURE THE SEQUENCE THE COMPILER ACTUALLY EMITS. The fp
       row is unaffected: (ix+d) needs no address formation, so fp step really is
       38 + 6 + 38 = 82 (it was wrongly using the sp row's 92).
         read 46->45, bc 9->8, ix 26->25: the measured sequences, off by one.
       bc deref 7 / step 6 and ix deref 19 / step 10 were already exact and are
       CONFIRMED to the cycle. `IR_G0MEASURED=0` restores the old estimates.
       NB DE is left equal to BC. Measured `ex de,hl` is 4, not 8 — but it is a
       SWAP, not a copy (it destroys HL), so a real DE read may need the swap back.
       That row needs the lowerer's actual DE-read sequence checked first. */
    static const int Z80[GR_N][GK_N] = {
        /*SLOT*/{45,41,52,92}, /*BC*/{8,8,7,6}, /*DE*/{8,8,7,6}, /*IX*/{25,25,19,10}, /*IY*/{25,25,19,10} };
    static const int Z80_EST[GR_N][GK_N] = {          /* pre-measurement estimates */
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
    /* gbz80 was falling through to the Z80 row, which is wrong in both
       directions at once. An sp-local is NATIVE here — `ld hl,sp+n` is one
       2-byte op — where the Z80 needs `ld hl,n; add hl,sp`, so the Z80 row
       over-charges the slot by ~30 %. And there is no `ld a,(bc)`-style deref in
       use and no `ex de,hl`, so reaching a GP-pair home's pointee costs
       `ld h,b; ld l,c; ld a,(hl)` — 16, not the Z80 row's 7. Both errors say
       "prefer a register home" where the hardware does not, which is what left
       lexbench and ptrbench paying for word-resident DE homes that do not earn
       their HL<->DE traffic. Measured with gbz80_cost_bench.py (empty-loop
       anchored, ticks -mgbz80): slot 32/36/40/76, bc+de 8/8/16/8 — the pairs are
       symmetric because neither has a cheap deref. IX/IY do not exist on this CPU, so
       they are priced ABOVE the slot: idx_ben then comes out strictly negative
       and every index home is rejected. Pricing them AT the slot instead makes
       idx_ben exactly 0, which is a boundary the BC/index yield reads as "an
       index is available" — that alone cost histbench 10 %. */
    static const int GBZ80[GR_N][GK_N] = {
        /*SLOT*/{32,36,40,76}, /*BC*/{8,8,16,8}, /*DE*/{8,8,16,8},
        /*IX*/{99,99,99,99}, /*IY*/{99,99,99,99} };
    /* KR580VM1: an 8080-class slot (measured 44 read / 39 write / 68 word-RMW,
       so the Z80 row is close) with h'l' as the index home. Its numbers are the
       measured RS-prefixed idioms - push/pop 25 either way, `ld a,(hl'\')` 11,
       `inc hl'\'` 9 - which beat IX/IY on deref because there is no
       displacement to encode. See vm1_cost_bench.py. */
    static const int VM1[GR_N][GK_N] = {
        /*SLOT*/{44,39,44,68}, /*BC*/{10,10,7,6}, /*DE*/{10,10,7,6},
        /*IX*/{25,25,11,9}, /*IY*/{25,25,11,9} };
    const int (*t)[GK_N] = IS_KC160() ? KC160
                         : IS_EZ80() ? EZ80
                         : IS_KR580VM1() ? VM1
                         : IS_RABBIT() ? RABBIT
                         : g0measured_on() ? Z80 : Z80_EST;
    /* gbz80 carries two corrections, both plain hardware facts and both now
       default-on: `ld hl,sp+n` makes its slot cheaper than the Z80 row claims,
       and a GP-pair deref costs more for want of `ld a,(bc)` and `ex de,hl`. */
    static int gb_slot[GR_N][GK_N];
    if (IS_GBZ80()) {
        /* `IR_GBZ80_MASK` selects which ROWS of the measured gbz80 table are
           used: bit0 SLOT, bit1 BC, bit2 DE, bit3 IX/IY. Default 3 = SLOT+BC,
           which is the whole of the effect — DE and IX/IY are measured inert.
           The sweep, and why the BC row was held back for a long time by what
           turned out to be a recovery bug rather than a ranking tie, are in
           ADR 0032. */
        static int gbmask = -1;
        if (gbmask < 0) { const char *e = getenv("IR_GBZ80_MASK");
                          gbmask = e ? atoi(e) : 3; }
        for (int r = 0; r < GR_N; r++) {
            int take = (r == GR_SLOT) ? (gbmask & 1)
                     : (r == GR_BC)   ? (gbmask & 2)
                     : (r == GR_DE)   ? (gbmask & 4) : (gbmask & 8);
            for (int k = 0; k < GK_N; k++)
                gb_slot[r][k] = take ? GBZ80[r][k] : t[r][k];
        }
        t = (const int (*)[GK_N])gb_slot;
    }
    int c = t[reg][kind];
    if (reg == GR_SLOT) {                             /* fp slot = (ix+d) */
        int fp = (c_framepointer_is_ix != -1);
        if (fp) {
            /* MEASURED fp (ix+d): read 38, write 38, DEREF 45, STEP 82. The old
               rule only covered kind <= GK_WRITE, so an fp DEREF and an fp STEP
               silently used the SP row — 46 and 92 against a true 45 and 82. */
            if (t == Z80) {
                static const int Z80_FP[GK_N] = {38,38,45,82};
                c = Z80_FP[kind];
            } else if (t == Z80_EST && kind <= GK_WRITE) c = 39;
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
    /* Cost of OPENING an IY home in a function that does not already own one:
       `push iy` in the prologue (2B) and `pop iy` at EVERY exit (2B each). The
       g0 model cannot see this — it is in CYCLES, where the save is ~29 per
       invocation however many exits exist, while the BYTE cost scales with
       them. Charge it against the tenants actually taken: each IY home removes
       about one slot store + reload (~11B in sp mode), so the k-th tenant is
       only worth opening when 11*(k+1) covers the save. adr/0067. */
    int iy_open_cost = 0;
    if (f->idx3_reg == IR_PR_NONE) {
        int n_ret = 0;
        for (int b = 0; b < f->n_bbs; b++)
            for (int j = 0; j < f->bbs[b].n_ops; j++)
                if (f->bbs[b].ops[j].kind == IR_RET) n_ret++;
        iy_open_cost = 2 + 2 * (n_ret > 0 ? n_ret : 1);
    }
    for (int i = 0; i < nc; i++) {
        int v = cand[i].vreg;
        if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;      /* BC took it */
        if (11 * (packed + 1) < iy_open_cost) continue;       /* save not covered */
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
                               const int *bb_cond_shift,
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
        long w = bb_iter_weight(bb_loop_depth, b, 0);
        if (bb_cond_shift)
            for (int i = 0; i < bb_cond_shift[b] && w > 1; i++) w /= 2;
        /* [mwbc] 4^depth counts ITERATIONS; it says nothing about which
           blocks an iteration actually runs. A block behind a conditional
           branch runs on a fraction of the trips, and weighting it as if it ran
           on all of them overvalues a value read only inside an if-chain
           against one read on every trip. lexbench's `lex` is exactly that: the
           tokeniser state `run_cls` is read in the arms of the classify chain
           (weight 31) while the loop counter `i` is read unconditionally
           (weight 8), so BC went to the state and the counter took a frame slot
           — 4% slower. Halve once per conditional branch on the way in. */
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
            int dofs = g0_deref_ofs_of(o, v);
            for (int k=0;k<nu;k++) if (u[k]==v) {
                if (v==mb)
                    ben += w*((g0_word_cost(GR_SLOT,GK_DEREF)
                               + g0_deref_offset_cost(GR_SLOT,dofs))
                              - (g0_word_cost(R,GK_DEREF)
                                 + g0_deref_offset_cost(R,dofs)));
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
static long interval_benefit(const Func *f, int v, const int *bb_loop_depth,
                             const int *bb_cond_shift, int R)
{
    return interval_benefit_x(f, v, bb_loop_depth, bb_cond_shift, R, 0);
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
                         const long *cost_benefit, const int *bb_loop_depth,
                         const int *bb_cond_shift)
{
    long best = 0; int have = 0;
    if (allowed & RC_BC) {
        long b = interval_benefit(f, v, bb_loop_depth, bb_cond_shift, GR_BC);
        if (!have || b > best) { best = b; have = 1; }
    }
    if (allowed & RC_DE_ACC) {
        long b = interval_benefit(f, v, bb_loop_depth, bb_cond_shift, GR_DE);
        if (!have || b > best) { best = b; have = 1; }
    }
    if (allowed & (RC_IDX2 | RC_IDX3)) {
        long b = interval_benefit(f, v, bb_loop_depth, bb_cond_shift, GR_IX);
        if (!have || b > best) { best = b; have = 1; }
    }
    return have ? best : cost_benefit[v];
}








/* Index-half homes used to be assigned by the LOWERER, after ir_alloc had
   returned. That made two owners of vreg_to_phys, and the re-arbitration
   retry silently erased them: it re-runs ir_alloc and never re-ran this.
   It is an allocation decision, so it runs as the last step of ir_alloc. */
/* Promote hot, currently-spilled SINGLE-DEF width-1 vregs to free index-register
   halves (PR_IYL/IYH/IXL/IXH) — a slotless, clobber-free extra byte home. Purely
   additive: only takes vregs the allocator left in a slot (IR_PR_SPILL), so it
   never displaces a register home; a value that can't be placed simply stays in
   its slot. Safe because:
   - SINGLE-DEF ⇒ the def dominates every use (SSA), so the half is always valid
     at a read (no belief/carry machinery needed);
   - NO calls/asm in the function ⇒ the index reg is never clobbered (the operand
     loader never stages there either);
   - index halves only reach BASE-page ops (ld/add/sub/and/or/xor/cp a,iyl) —
     the CB-page in-place shift paths gate on byte_home_phys, which excludes
     index halves, so `sla iyl` (which doesn't exist) is never emitted.
   z80/z80n/ez80 only (index-half ALU). Runs after ir_alloc, before
   ir_assign_slots (so promoted vregs get needs_slot=0).

   DEFAULT-ON, SP-MODE ONLY (--opt-disable=idxhalf opts out). Homing a byte in an index
   half CLOBBERS the whole IX/IY, both callee-saved in the z88dk ABI — e.g.
   l_qsort/l_bsearch hold the comparator fnptr in IY across the comparator call,
   so a leaf that homes a byte in IYL/IYH must preserve the caller's IY. That is
   now handled: frame_has_saved_ix / frame_has_saved_iy push/pop the index reg
   whenever a byte-half home occupies it (sp idx2=IX, idx3=IY). SP MODE ONLY for
   two reasons: (1) fp barely benefits (idx read ≈ cheap (ix+d) slot); (2) the
   frame_has_saved_iy +2 param-offset compensation is sp-relative — fp params are
   (ix+d) and would need separate handling. So we never idxhalf in fp: the value
   isn't there AND the fp offset path never runs. NET-BYTE gate below: only home
   when it saves code (in sp the dear `ld hl,N;add hl,sp` slot access makes byte
   and cycle savings correlate, so net-bytes>0 ⇒ a balanced win; the gate rejects
   break-even shapes that only pay the +4B IY-save). */
static int idxhalf_enabled(void)
{
    return !opt_disabled("idxhalf");   /* default on; --opt-disable=idxhalf opts out */
}
static void assign_idxhalf_homes(Func *f)
{
    if (!idxhalf_enabled()) return;                 /* default on; --opt-disable=idxhalf opts out */
    if (c_framepointer_is_ix != -1) return;         /* SP MODE ONLY (see above) */
    if (!(c_cpu == CPU_Z80 || IS_Z80N() || IS_EZ80())) return;
    if (!f || f->n_vregs <= 0 || !f->vreg_to_phys) return;
    /* No calls/asm — else IX/IY would be trashed mid-live-range. */
    for (int b = 0; b < f->n_bbs; b++)
        for (int j = 0; j < f->bbs[b].n_ops; j++) {
            OpKind k = f->bbs[b].ops[j].kind;
            if (k == IR_CALL || k == IR_HCALL || k == IR_ASM) return;
        }
    /* Candidate halves — never offer halves of the FRAME register (it's used as
       a pair by every (ix+d) access, and the frame isn't a vreg so the interval
       check can't see it), nor of a platform-reserved index register
       (--reserve-regs-ix/-iy). c_framepointer_is_ix == 1 → IX is the frame,
       == -1 → sp-mode (no frame). (fp_active is per-function but unreliable here
       — frame_size isn't set until ir_assign_slots runs after this pass; the
       global choice is the safe, stable gate.) A non-frame index reg's own
       tenant (an idx2 counter/param) IS a vreg, so its half availability is
       decided per byte by live-interval overlap below. */
    PhysReg halves[4]; int nhalves = 0;
    if (!c_reserve_iy) {               /* IY never the frame; offer unless reserved */
        halves[nhalves++] = IR_PR_IYL; halves[nhalves++] = IR_PR_IYH;
    }
    if (c_framepointer_is_ix != 1 && !c_reserve_ix) {   /* IX not the frame nor reserved */
        halves[nhalves++] = IR_PR_IXL; halves[nhalves++] = IR_PR_IXH;
    }
    if (nhalves == 0) { return; }
    /* Per-vreg def count, a DEPTH-WEIGHTED use score (a use in a loop body is
       worth far more than a straight-line one — a byte compared each inner
       iteration appears only ONCE statically but runs many times), and a
       conservative live interval [first,last] in linear op order. Params are
       live from entry (first=0). ir_op_defs is used so a self-stepped op
       (defines src[0], not dst) is counted correctly. */
    int nv = f->n_vregs;
    int *ndef = calloc((size_t)nv, sizeof(int));
    long *wuse = calloc((size_t)nv, sizeof(long));   /* depth-weighted use score (ticks) */
    int *ruse = calloc((size_t)nv, sizeof(int));     /* RAW use count (code-size / net-byte) */
    int *first = malloc((size_t)nv * sizeof(int));
    int *last  = malloc((size_t)nv * sizeof(int));
    if (!ndef || !wuse || !ruse || !first || !last) {
        free(ndef); free(wuse); free(ruse); free(first); free(last); return;
    }
    for (int v = 0; v < nv; v++) { first[v] = INT_MAX; last[v] = -1; }
    /* Cheap loop-nesting depth per BB (selection ranking only — never affects
       correctness): count the back-edge spans [target..source] (id-based,
       contiguous approximation) each BB falls in. f->bbs[].loop_depth is not
       populated at this stage. */
    int *bdep = calloc((size_t)f->n_bbs, sizeof(int));
    if (bdep)
        for (int i = 0; i < f->n_bbs; i++)
            for (int s = 0; s < ir_bb_n_succ(&f->bbs[i]); s++) {
                int t = ir_bb_succ_at(&f->bbs[i], s);
                if (t < 0 || t > i) continue;             /* back-edge: t <= i */
                for (int b = t; b <= i && b < f->n_bbs; b++) bdep[b]++;
            }
    int g = 0;
    for (int b = 0; b < f->n_bbs; b++) {
        int dep = bdep ? bdep[b] : 0;
        if (dep > 4) dep = 4;
        long w = 1L << (3 * dep);            /* depth 0→1, 1→8, 2→64, … (~8×/level) */
        for (int j = 0; j < f->bbs[b].n_ops; j++, g++) {
            const Op *o = &f->bbs[b].ops[j];
            int d[8], u[16];
            int nd = ir_op_defs(o, d, 8);
            for (int k = 0; k < nd; k++) if (d[k] >= 0 && d[k] < nv) {
                ndef[d[k]]++;
                if (g < first[d[k]]) first[d[k]] = g;
                if (g > last[d[k]])  last[d[k]]  = g;
            }
            int un = ir_op_uses(o, u, 16);
            for (int k = 0; k < un; k++) if (u[k] >= 0 && u[k] < nv) {
                wuse[u[k]] += w;
                ruse[u[k]]++;                        /* raw (unweighted) use site count */
                if (g < first[u[k]]) first[u[k]] = g;
                if (g > last[u[k]])  last[u[k]]  = g;
            }
        }
    }
    for (int v = 0; v < nv; v++)
        if (f->vregs[v].flags & (IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE))
            first[v] = 0;                                   /* live from entry */
    /* Greedily place the hottest eligible bytes; each into the first candidate
       half free over its interval (no overlapping vreg on the same half or on
       the whole pair). Multiple bytes can share a pair (IYL + IYH) or reuse a
       half's pair across disjoint ranges. */
    for (;;) {
        int best = -1;
        for (int v = 0; v < nv; v++) {
            if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;   /* additive only */
            if (f->vregs[v].width != 1) continue;
            /* PARAMs are live-in from the caller with NO def op that writes the
               half — the incoming value would never reach a slotless index home
               (and ndef counts only its in-body redefs, hiding this). Exclude. */
            if (f->vregs[v].flags & (IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE))
                continue;
            if (ndef[v] != 1) continue;                        /* SSA dominance */
            if (wuse[v] < 8) continue;                         /* hot: ≥1 loop use */
            if (last[v] < 0) continue;                         /* dead */
            /* NET-BYTE gate (sp): home only when the index-half saves code.
               `save_per` (3) is the dear sp slot byte access less `ld a,iyl`;
               `ovh` (10) folds the one-time index-reg save plus the setup slop
               a low-access half-home incurs. RAW (unweighted) access sites —
               code size is static, not per-iteration. Calibrated by sweep: home
               iff RAW accesses >= 4. adr/0068. */
            {
                long acc = (long)ndef[v] + ruse[v];
                if (acc * 3 - 10 <= 0) continue;
            }
            if (f->vregs[v].flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
                continue;
            if (best < 0 || wuse[v] > wuse[best]) best = v;
        }
        if (best < 0) break;
        int placed = 0;
        for (int h = 0; h < nhalves && !placed; h++) {
            PhysReg H = halves[h];
            PhysReg pair = (H == IR_PR_IYL || H == IR_PR_IYH) ? IR_PR_IY : IR_PR_IX;
            int conflict = 0;
            for (int u = 0; u < nv && !conflict; u++) {
                PhysReg pu = f->vreg_to_phys[u];
                if (pu != H && pu != pair) continue;   /* same half, or full-pair tenant */
                int s = first[best] > first[u] ? first[best] : first[u];
                int e = last[best]  < last[u]  ? last[best]  : last[u];
                if (s <= e) conflict = 1;              /* intervals overlap */
            }
            if (!conflict) { f->vreg_to_phys[best] = H; placed = 1; }
        }
        if (!placed) {
            /* No half free over its range — mark ineligible so the scan
               advances (keep it spilled). */
            ndef[best] = 0;
        }
    }
    free(ndef); free(wuse); free(ruse); free(first); free(last); free(bdep);
}

void ir_alloc(Func *f)
{
    if (!f) return;
    free(f->vreg_to_phys);
    f->vreg_to_phys = NULL;
    free(f->home_lo); f->home_lo = NULL;
    free(f->home_hi); f->home_hi = NULL;
    if (f->n_vregs <= 0) return;
    f->vreg_to_phys = calloc((size_t)f->n_vregs, sizeof(*f->vreg_to_phys));
    f->home_lo = calloc((size_t)f->n_vregs, sizeof(*f->home_lo));
    f->home_hi = calloc((size_t)f->n_vregs, sizeof(*f->home_hi));
    if (!f->vreg_to_phys || !f->home_lo || !f->home_hi) return;

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
    /* IY has its own veto, and it is far narrower than BC's. Only IR_ASM is
       genuinely opaque to IY — inline asm can blast anything and, unlike a
       call, the lowerer has no save/restore point around it. Everything else
       has_bc_clobber lists is BC-specific and provably IY-clean (see the
       op_clobbers notes): l_case walks its table through BC, dload/dstore
       clobber BC, width-4 arithmetic stages the low half through BC, and the
       acc helpers destroy IX but not IY.
       This stays a cheap whole-function belt to the packs' braces — both IY
       packs additionally test op_clobbers(o) & IR_R_IY per op across the
       candidate's live range, which subsumes it. */
    int has_iy_clobber = 0;
    for (int v = 0; v < f->n_vregs && !has_long; v++)
        if (f->vregs[v].width == 4) has_long = 1;
    /* Calls used to exclude PR_BC entirely. Task #319 added save/restore
       around IR_CALL / IR_HCALL in the lowerer, so calls no longer
       disqualify — they just add a push bc/pop bc pair around each
       call site when PR_BC is active. has_long and has_bc_clobber
       still exclude (long ops use BC for low-half staging, and
       IR_ST_MEM IR_MEM_VREG with offset clobbers BC for the
       `ld bc,N; add hl,bc` offset add). */
    for (int i = 0; i < f->n_bbs && !(has_bc_clobber && has_iy_clobber); i++) {
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
            if (o->kind == IR_ASM) {
                has_bc_clobber = 1;
                has_iy_clobber = 1;
            }
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
    /* A pre-pushed-arg call used to disqualify every non-param BC candidate in
       the function, because gen_call could only restore the tenant via
       emit_bc_reload (a slot read) which a slotless LOCAL cannot satisfy. The
       lowerer now saves BC below the arg block instead, so this is narrowed to
       the calls that genuinely lose it — see prepush_bc_hazard. */
    int has_prepushed_call = 0;
    for (int i = 0; i < f->n_bbs && !has_prepushed_call; i++)
        for (int j = 0; j < f->bbs[i].n_ops; j++)
            if (f->bbs[i].ops[j].kind == IR_CALL && f->bbs[i].ops[j].call
                && f->bbs[i].ops[j].call->pre_pushed > 0) {
                has_prepushed_call = 1;
                break;
            }
    if (has_prepushed_call && prepushnarrow_on() && !prepush_bc_hazard(f))
        has_prepushed_call = 0;
    /* has_long / has_bc_clobber are BC vetoes: long ops stage the low half
       through BC, l_case walks its table through BC, dload/dstore clobber BC
       with no save/restore point. They say nothing about IY, yet they gate the
       whole region — so one 32-bit value anywhere in a function also disables
       IY packing for it.

       The IY packs do not need a whole-function guarantee: both check
       op_clobbers(o) & IR_R_IY per op across the candidate's live range, which
       is strictly more precise. op_clobbers models exactly the cases the veto
       stands in for — IR_ASM / IR_SWITCH / IR_ACC_* / helper calls return
       IR_R_ALL, plain calls preserve IX/IY, and width-4 arithmetic clobbers
       HL/DE/BC but not IY. [iy-long] lets them run on that basis.

       The general picker (collect_home_candidates / unified_arbitrate) is NOT
       included: it proposes several register classes at once and its safety
       cannot be argued from the IY-clean check alone. */
    int bc_region_ok = !has_long && !has_bc_clobber;
    /* IR_OFF=iy-long restores the OLD gating (IY packing rides the BC veto), not
       "no IY packing at all" — the opt-out has to be a revert, not a third
       behaviour. */
    int iy_region_ok = iylong_off() ? bc_region_ok : !has_iy_clobber;
    if (bc_region_ok || iy_region_ok) {
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
        /* [mwbc] How many times to HALVE this BB's iteration weight because
           it sits behind conditional branches inside its loop. 0 = it runs on
           every trip. Only ever written by the dominance-based loop scan below,
           so it stays all-zero — and the cost model unchanged — when that scan
           does not run. */
        int *bb_cond_shift = calloc((size_t)f->n_bbs, sizeof(int));
        if (!write_count || !use_count || !first_use || !last_use
            || !bb_in_loop || !def_kind || !bb_loop_lo || !bb_loop_hi
            || !bb_first_op || !bb_last_op || !bb_loop_depth || !bb_cond_shift
            || !cost_benefit || !all_defs_ok) {
            free(write_count); free(use_count);
            free(first_use); free(last_use);
            free(bb_in_loop); free(def_kind);
            free(bb_loop_lo); free(bb_loop_hi);
            free(bb_first_op); free(bb_last_op);
            free(bb_loop_depth); free(bb_cond_shift);
            free(cost_benefit); free(all_defs_ok);
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

                    /* [mwbc] Recompute bb_loop_depth ONLY — real loops, from
                       DOMINANCE, one loop per HEADER.

                       The loop above calls any edge to a lower-numbered block a
                       back-edge, and counts one loop per back-edge. A natural
                       loop only means anything when h dominates p, and a loop
                       with several latches is still ONE loop. In `vm_run` the
                       six switch arms all jump to bb7, which has a lower id but
                       does not dominate them, so the backward closure ran past
                       the header and swallowed the whole function — and each
                       arm's edge counted again. Depth came out 7 on the
                       48-iteration init loop and 3 on the 48,024-iteration
                       dispatch bodies; the weight is 4^depth, so the cold loop
                       out-ranked the hot one 256:1 and took BC while `pc` sat in
                       a frame slot (7.30M T, 19.6% of the run).

                       Deliberately leaves bb_in_loop / bb_loop_lo / bb_loop_hi
                       to the loop above. Those drive the in-loop INTERVAL
                       EXTENSION (a BC home must be held across every iteration),
                       where the id-based test over-approximates and is therefore
                       safe; a dominance test finds no header at all in an
                       irreducible loop, which would under-extend an interval and
                       strand a stale register. Depth is only a cost weight, so
                       correcting it there carries no such risk. */
                    if (mwbc_on() && f->n_bbs > 0 && f->n_bbs <= 512) {
                        int n = f->n_bbs;
                        char *dom  = malloc((size_t)n * (size_t)n);
                        char *dtmp = malloc((size_t)n);
                        int  *every = calloc((size_t)n, sizeof(int));
                        int  *is_branch = calloc((size_t)n, sizeof(int));
                        int  *cond_from = calloc((size_t)n, sizeof(int));
                        if (dom && dtmp && every && is_branch && cond_from) {
                            /* Iterative dominators over the op-level CFG. */
                            memset(dom, 1, (size_t)n * (size_t)n);
                            for (int x = 0; x < n; x++) dom[x] = (x == 0);
                            int ch = 1;
                            while (ch) {
                                ch = 0;
                                for (int b = 1; b < n; b++) {
                                    if (pred_off[b + 1] == pred_off[b]) {
                                        for (int x = 0; x < n; x++)
                                            dtmp[x] = (x == b);   /* unreachable */
                                    } else {
                                        for (int x = 0; x < n; x++) dtmp[x] = 1;
                                        for (int k = pred_off[b]; k < pred_off[b+1]; k++) {
                                            const char *dr = &dom[(size_t)pred_list[k] * n];
                                            for (int x = 0; x < n; x++) dtmp[x] &= dr[x];
                                        }
                                        dtmp[b] = 1;
                                    }
                                    char *row = &dom[(size_t)b * n];
                                    if (memcmp(dtmp, row, (size_t)n)) {
                                        memcpy(row, dtmp, (size_t)n); ch = 1;
                                    }
                                }
                            }
                            for (int b = 0; b < n; b++) bb_loop_depth[b] = 0;
                            /* Branchiness is a property of the block, not of the
                               loop being scanned — hoist it out of the header
                               loop so the conditional-weight pass below is a
                               matrix walk rather than n^3 successor queries. */
                            for (int b = 0; b < n; b++)
                                is_branch[b] = alloc_bb_succ(&f->bbs[b], scratch,
                                        (int)(sizeof scratch / sizeof scratch[0])) >= 2;
                            for (int h = 0; h < n; h++) {
                                memset(inloop, 0, (size_t)n * sizeof(int));
                                int wn = 0, is_header = 0;
                                for (int p = 0; p < n; p++) {
                                    if (!dom[(size_t)p * n + h]) continue; /* h must dom p */
                                    int ns = alloc_bb_succ(&f->bbs[p], scratch,
                                            (int)(sizeof scratch / sizeof scratch[0]));
                                    for (int s2 = 0; s2 < ns; s2++) {
                                        if (scratch[s2] != h) continue;    /* back-edge */
                                        is_header = 1;
                                        inloop[h] = 1;
                                        if (!inloop[p]) { inloop[p] = 1; wl[wn++] = p; }
                                    }
                                }
                                if (!is_header) continue;
                                while (wn > 0) {
                                    int x = wl[--wn];
                                    for (int k = pred_off[x]; k < pred_off[x + 1]; k++) {
                                        int y = pred_list[k];
                                        if (!inloop[y]) { inloop[y] = 1; wl[wn++] = y; }
                                    }
                                }
                                for (int b = 0; b < n; b++)
                                    if (inloop[b]) bb_loop_depth[b]++;
                                /* Which of those blocks run on EVERY trip round
                                   the loop: the ones that dominate every latch.
                                   Every path from the header back to the header
                                   goes through them, so no branch can skip them.
                                   Anything else is conditional. `every[]` is
                                   reused by the shift pass below. */
                                for (int b = 0; b < n; b++) every[b] = inloop[b];
                                for (int p = 0; p < n; p++) {
                                    if (!inloop[p] || !dom[(size_t)p * n + h]) continue;
                                    int ns2 = alloc_bb_succ(&f->bbs[p], scratch,
                                            (int)(sizeof scratch / sizeof scratch[0]));
                                    int latch = 0;
                                    for (int s3 = 0; s3 < ns2; s3++)
                                        if (scratch[s3] == h) { latch = 1; break; }
                                    if (!latch) continue;
                                    for (int b = 0; b < n; b++)
                                        if (every[b] && !dom[(size_t)p * n + b])
                                            every[b] = 0;       /* this latch skips b */
                                }
                                /* How UNLIKELY each conditional block is, as a
                                   count of halvings. One for b's own entry
                                   condition, plus one for every conditional
                                   branch that dominates it — a block three arms
                                   deep in an if-chain runs about an eighth as
                                   often as one on the trip-every-time path. A
                                   branch that itself runs every iteration (the
                                   loop test, an if/else whose arms rejoin before
                                   the latch) does not count: it cannot skip what
                                   comes after it.

                                   Only the INNERMOST loop containing b gets to
                                   rule, which is what `cond_from` (the region
                                   size that last spoke) enforces. A
                                   conditionally-entered inner loop is not a
                                   conditionally-executed block: entering it once
                                   runs its body many times, and the 4^depth
                                   weight already says so. Letting the outer
                                   loop's `if` halve the inner loop's blocks
                                   double-counts the entry test and erases the
                                   nesting — in ez80 sieve_count it collapsed the
                                   k-loop values from 32 to 8, level with
                                   whole-function ones, and cost 10%. */
                                int rsize = 0;
                                for (int b = 0; b < n; b++) if (inloop[b]) rsize++;
                                for (int b = 0; b < n; b++) {
                                    if (!inloop[b]) continue;
                                    if (cond_from[b] && cond_from[b] <= rsize)
                                        continue;          /* a tighter loop already ruled */
                                    int k = 0;
                                    if (!every[b]) {
                                        k = 1;
                                        for (int d = 0; d < n && k < 4; d++) {
                                            if (d == b || !inloop[d] || every[d]) continue;
                                            if (!dom[(size_t)b * n + d]) continue;  /* d dom b */
                                            if (is_branch[d]) k++;
                                        }
                                    }
                                    cond_from[b] = rsize;
                                    bb_cond_shift[b] = k;
                                }
                            }
                        }
                        free(dom); free(dtmp); free(every); free(is_branch);
                        free(cond_from);
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
            long weight = bb_iter_weight(bb_loop_depth, i, depth_flat);
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
        /* [IR_BYTEPRESS] INERT — size the byte-pair opportunity by PRESSURE
           rather than hotness. Reports, per function:
             cands    width-1 vregs with no register home, not addr-taken or
                      volatile, def-first, whose interval crosses no call
                      (B/C/D/E are caller-clobbered)
             maxlive  most of those live at one op — the pressure a pair
                      allocator would have to cover
             hot      how many pass the use_count>=8 gate
             traffic  total accesses = frame traffic a byte home could remove
             top4     traffic of the four highest, i.e. what four homes capture
           Sizing only; no allocation decision is taken here. */
        if (getenv("IR_BYTEPRESS")) {
            int total_ops = 0;
            for (int i = 0; i < f->n_bbs; i++) total_ops += f->bbs[i].n_ops;
            for (int wsel = 1; wsel <= 2; wsel++) {
            int *delta = calloc((size_t)(total_ops + 2), sizeof(int));
            int *acc   = calloc((size_t)(f->n_vregs > 0 ? f->n_vregs : 1),
                                sizeof(int));
            if (delta && acc) {
                int cands = 0, hot = 0;
                long traffic = 0;
                for (int v = 0; v < f->n_vregs; v++) {
                    const VReg *vr = &f->vregs[v];
                    if (vr->width != wsel) continue;
                    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
                        continue;
                    if (f->vreg_to_phys[v] != IR_PR_SPILL) continue;
                    if (write_count[v] < 1) continue;
                    if (first_use[v] < 0 || last_use[v] < 0) continue;
                    DefUseIdx du = vreg_def_first(f, v);
                    if (du.first_def >= du.first_read) continue;  /* def-first */
                    /* Interval call-free? B/C/D/E do not survive a call. */
                    int callfree = 1, g = 0;
                    for (int i = 0; i < f->n_bbs && callfree; i++)
                        for (int j = 0; j < f->bbs[i].n_ops; j++, g++) {
                            OpKind k = f->bbs[i].ops[j].kind;
                            if (k != IR_CALL && k != IR_HCALL && k != IR_ASM)
                                continue;
                            if (g >= first_use[v] && g <= last_use[v]) {
                                callfree = 0; break;
                            }
                        }
                    if (!callfree) continue;
                    cands++;
                    if (use_count[v] >= 8) hot++;
                    acc[v] = use_count[v] + write_count[v];
                    traffic += acc[v];
                    int lo = first_use[v], hi = last_use[v];
                    if (lo < 0) lo = 0;
                    if (hi > total_ops) hi = total_ops;
                    delta[lo]++; delta[hi + 1]--;
                }
                if (cands > 0) {
                    int live = 0, maxlive = 0;
                    for (int g = 0; g <= total_ops; g++) {
                        live += delta[g];
                        if (live > maxlive) maxlive = live;
                    }
                    /* traffic of the 4 busiest candidates — what C/E/B/D could
                       actually capture. Selection sort over a tiny set. */
                    long top4 = 0;
                    for (int n = 0; n < 4; n++) {
                        int best = -1;
                        for (int v = 0; v < f->n_vregs; v++)
                            if (acc[v] > 0 && (best < 0 || acc[v] > acc[best]))
                                best = v;
                        if (best < 0) break;
                        top4 += acc[best];
                        acc[best] = 0;
                    }
                    /* CAVEAT: maxlive is an UPPER BOUND, not the real pressure.
                       It spans [first_use,last_use] and so ignores holes in a
                       live range, which over-states badly in one long BB full
                       of short temporaries. Measured against the frame the
                       allocator actually assigns (which does real interference):
                       interpbench vm_run maxlive=45 vs a 25-byte frame = 12
                       words; listbench list_compute 20 vs 4; sieve_count 13 vs
                       4. Treat maxlive>4 as "needs checking", not as proof the
                       values cannot fit. frame_size is not available here — the
                       probe runs before ir_assign_slots. */
                    fprintf(stderr,
                            "BYTEPRESS %-14s w=%d cands=%-3d maxlive=%-3d "
                            "hot=%-3d traffic=%-5ld top4=%ld\n",
                            f->fn ? ir_sym_name(f->fn) : "?", wsel,
                            cands, maxlive, hot, traffic, top4);
                }
            }
            free(delta); free(acc);
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
            /* General picker: BC region only — see the note on the gate. */
            Cand *pool = bc_region_ok
                ? calloc(cand_pool_len(f), sizeof(Cand))
                : NULL;
            if (pool) {
                /* B4 increment 3: one generator emits ALL candidates (in the
                   former proposer order + tags), calling the class realizability
                   predicates directly — the 7 *_propose wrappers are retired. */
                int np = collect_home_candidates(f, use_count, write_count,
                                                 def_kind, all_defs_ok,
                                                 has_prepushed_call, entry_live,
                                                 bb_in_loop, bb_loop_depth, bb_cond_shift,
                                                 first_use, last_use,
                                                 pool, (int)cand_pool_len(f));
                /* Rank each candidate by the grounded interval_benefit of its best
                   allowed register class (rank_benefit) — the unified cost model that
                   replaced the old cost_benefit hotness heuristic + keep-rules as the
                   selection mechanism ("tuning = costs, not passes"). Byte/exx-only
                   candidates still fall back to cost_benefit inside rank_benefit. */
                for (int i = 0; i < np; i++) {
                    pool[i].benefit = rank_benefit(f, pool[i].vreg, pool[i].allowed,
                                                   cost_benefit, bb_loop_depth,
                                                   bb_cond_shift);
                    /* [IR_BYTETIE] the tie-break companion, in BYTES. Best over
                       the same allowed classes rank_benefit considered. */
                    {
                        long bb2 = 0; int have = 0;
                        if (pool[i].allowed & RC_BC) {
                            long x = g0_byte_benefit(f, pool[i].vreg, GR_BC);
                            if (!have || x > bb2) { bb2 = x; have = 1; }
                        }
                        if (pool[i].allowed & RC_DE_ACC) {
                            long x = g0_byte_benefit(f, pool[i].vreg, GR_DE);
                            if (!have || x > bb2) { bb2 = x; have = 1; }
                        }
                        if (pool[i].allowed & (RC_IDX2 | RC_IDX3)) {
                            long x = g0_byte_benefit(f, pool[i].vreg, GR_IX);
                            if (!have || x > bb2) { bb2 = x; have = 1; }
                        }
                        pool[i].bytes = have ? bb2 : 0;
                    }
                }
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
                            idx_ben[v] = interval_benefit(f, v, bb_loop_depth, bb_cond_shift, GR_IX);
                }
                /* [IR_RANKDUMP] Inert: the arbiter's INPUTS — every candidate,
                   the classes it is allowed, and the benefit it was ranked by.
                   IR_HOMEMAP prints who won; this prints why. */
                if (getenv("IR_RANKDUMP"))
                    for (int i = 0; i < np; i++)
                        fprintf(stderr, "RANK %-12s v%-3d allowed=%#x ben=%-6ld lo=%d hi=%d uses=%d idxben=%ld flags=%#x\n",
                                f->fn ? ir_sym_name(f->fn) : "?", pool[i].vreg,
                                pool[i].allowed, pool[i].benefit, pool[i].lo, pool[i].hi,
                                use_count[pool[i].vreg], idx_ben ? idx_ben[pool[i].vreg] : -1,
                                f->vregs[pool[i].vreg].flags);
                unified_arbitrate(f, pool, np, idx_ben, NULL, bb_loop_depth,
                                  bb_cond_shift,
                                  contended_acc_yields_bc(f, bb_in_loop, use_count));
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
        if (bc_region_ok || bcpercand_on())
        ir_bc_pack(f, first_use, last_use, bb_first_op, def_kind,
                   write_count, use_count, cost_benefit, !bc_region_ok, bb_loop_depth, bb_cond_shift);
        /* LRA Phase 2c (default on, IR_NO_LRA opts out): home a DE-dirty
           reduction chain in IY (add iy,de), taking the spill losers BC couldn't. */
        if (iy_region_ok)
        ir_iy_reduction_pack(f, bb_in_loop, use_count);
        /* S3 Tier A (default on, --opt-disable=iy-temp-pack opts out): pack the
           born-killed word temps BC declined into IY over disjoint ranges, if a
           reduction pack didn't already claim IY. Cost-gated to dear-slot CPUs. */
        if (iy_region_ok)
        ir_iy_temp_pack(f, bb_first_op, bb_in_loop, def_kind, write_count, use_count);
        /* Stack-transient spill (default on, IR_NO_STACK_SPILL opts out): the
           register-pressure fallback below BC-pack — a single-def/single-use
           word transient with no register free goes on the stack (push/pop)
           rather than a slot.

           SP MODE ONLY, and that is a cost decision, not a safety one: in fp
           mode the slot is `(ix+d)`, cheap enough to invert the trade.
           8080/8085/gbz80 have no index register, so -fframe-pointer is a no-op
           there and they want the SP answer in BOTH modes — hence the CPU test
           below rather than a bare `c_framepointer_is_ix` one. Figures and the
           contrast with the remat-lea CPU test: adr/0050.

           `IR_PARK_VERIFY` checks the park's TOS invariant against the emitted
           text; run it before widening stack_spill_span_hazard. */
        int fp_ix_frame = (c_framepointer_is_ix != -1)
                       && !IS_808x() && !IS_GBZ80();
        if (bc_region_ok || !fp_ix_frame)
        ir_stack_spill(f, bb_first_op, def_kind, write_count);
        /* [IR_GRAPH_PROBE] inert divergence + pressure report. Placed here, after
           EVERY placement pass (arbiter, bc_pack, both IY packs, stack_spill), so
           vreg_to_phys is the final answer and the model is scored against what
           actually shipped — not against an intermediate state. */
        /* [call-split] Phase-1 call-bounded live-range splitting (opt-in).
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
        if (bc_region_ok && callsplit_on()
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
                    if (vr->flags & (IR_VREG_ADDR_TAKEN | IR_VREG_VOLATILE))
                        continue;
                    /* ONE eligibility rule for the ranged BC home: a value earns
                       it when it has a rich (>=3 read) span containing no call
                       (BC is caller-clobbered). A PARAM qualifies on the same
                       terms with one extra restriction — its span must also be
                       WRITE-free, so the caller's in-place slot stays the
                       authoritative copy and cannot go stale (the reason
                       bc_home_realizable rejects written params does not reach a
                       read-only span). A param need not CROSS a call either: a
                       call-free function has no crossing yet can still reload the
                       same slot eight times (histbench's const-multiply chain).
                       Both differences ride on `is_param`. */
                    int is_param = (vr->flags & IR_VREG_PARAM) != 0;
                    /* [IR_CALLSPLIT_LOG=3] Name the filter that drops a PARAM.
                       The cs-reject log further down only fires once a value has
                       survived to the span check, so anything dropped up here was
                       invisible — which is why the param class read as "not a
                       candidate" when it is really rejected one filter at a time.
                       Log only: the `continue` stays at the call site, because a
                       macro hiding `continue` inside do{}while(0) continues the
                       MACRO's loop and falls through to the next filter. */
                    const char *cslog0 = getenv("IR_CALLSPLIT_LOG");
                    int cslog3 = cslog0 && cslog0[0] == '3';
                    #define CS_WHY(why) do { if (cslog3 && is_param) \
                        fprintf(stderr, "  cs-skip %s v%d param=%d uses=%d %s\n", \
                            f->fn?ir_sym_name(f->fn):"?", v, is_param, \
                            use_count[v], (why)); } while (0)
                    if (f->vreg_to_phys[v] != IR_PR_SPILL) { CS_WHY("not-spill"); continue; }
                    if (wdb && wdb[v]) { CS_WHY("deref-base"); continue; }
                    if (use_count[v] < 2) { CS_WHY("uses<2"); continue; }
                    int lo = first_use[v], hi = last_use[v];
                    if (lo < 0 || hi < 0 || hi < lo) { CS_WHY("no-range"); continue; }
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
                    if (!crosses && !is_param) { CS_WHY("no-call-cross"); continue; }
                    int best_lo = -1, best_hi = -1;
                    int best_reads = cs_best_span(f, v, bb_first_op, is_param,
                                                  &best_lo, &best_hi);
                    /* ≥3 reads is the BYTE-correct floor. The per-span CYCLE benefit
                       (§2.1) turns positive at N≥2 on dear-slot CPUs, but a 2-read
                       span REGRESSES bytes (sortbench +20/+32): the entry reload
                       `ld bc,(slot); ld hl,bc` isn't amortised over only 2 reuses.
                       Density is the primary metric, so keep ≥3; the ≥15 CPU gate
                       above already byte-suppresses cheap-slot CPUs. */
                    if (best_reads < 3 || best_lo < 0 || best_hi < best_lo)
                        { CS_WHY("span<3"); continue; }
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
                    /* The candidate is live-CARRIED beyond its chosen call-free
                       span iff its loop-extended interval exceeds [best_lo,best_hi].
                       Then BC must survive a region that is flat-OUTSIDE the span
                       but CONTROL-FLOW inside it, and a plain flat-overlap test
                       misses it. Widen the occupancy to the loop-extended interval
                       — but ONLY under an in-span WRITE (a read-only temp dies at
                       best_hi; widening it blocked matrixbench/hashbench splits)
                       and ONLY under a real layout inversion (a BB placed
                       flat-AFTER best_hi with an edge back INTO the span, as in
                       sieve). Flat op order is not control-flow order. adr/0070. */
                    int occ_lo = best_lo, occ_hi = best_hi;
                    if (unsafe_write) {
                        int span_reentered = 0;
                        for (int b = 0; b < f->n_bbs && !span_reentered; b++) {
                            if (bb_first_op[b] <= best_hi) continue;   /* not flat-after */
                            int sc[64];
                            int ns = alloc_bb_succ(&f->bbs[b], sc,
                                        (int)(sizeof sc / sizeof sc[0]));
                            for (int s = 0; s < ns; s++) {
                                int sb = sc[s];
                                if (sb < 0 || sb >= f->n_bbs) continue;
                                /* successor whose op range intersects the span */
                                if (bb_first_op[sb] <= best_hi
                                    && bb_last_op[sb] >= best_lo) {
                                    span_reentered = 1; break;
                                }
                            }
                        }
                        if (span_reentered) {
                            if (first_use[v] >= 0 && first_use[v] < occ_lo) occ_lo = first_use[v];
                            if (last_use[v]  > occ_hi) occ_hi = last_use[v];
                        }
                    }
                    int bc_busy = 0, bc_blocker = -1;
                    for (int w = 0; w < nv && !bc_busy; w++) {
                        if (w == v) continue;
                        if (f->vreg_to_phys[w] != IR_PR_BC) continue;
                        const LiveRange *lw = ir_live_range(f, w);
                        int wlo, whi;
                        if (lw && lw->start >= 0) { wlo = lw->start; whi = lw->end; }
                        else { wlo = first_use[w]; whi = last_use[w]; }  /* fallback */
                        if (wlo < 0 || whi < 0) continue;
                        int s = occ_lo > wlo ? occ_lo : wlo;
                        int e = occ_hi < whi ? occ_hi : whi;
                        if (s <= e) { bc_busy = 1; bc_blocker = w; }
                    }
                    /* [IR_CS_EVICT] The split loses BC to whoever the picker
                       placed first, by ORDER, not by merit — the same fixed
                       priority ir_bc_pack's 5a eviction already turned into a
                       competition for its own packs. Turn it into one here too.

                       The comparison cannot be raw cost_benefit on both sides.
                       cost_benefit is whole-function, so it credits the tenant
                       for reads it does not actually serve: a tenant whose home
                       spans a call does NOT hold BC across it (gen_call
                       save/restores the pair and the belief goes cold), so the
                       first read after every call reloads from the slot anyway.
                       A call-bounded split has no calls in its span by
                       construction. Discount the tenant by what those calls cost
                       it — per spanned call, the push/pop pair (about a write,
                       COST_WRITE_W) plus one cold reload (a read, COST_READ_W).

                       Only a PICKER-placed tenant is evictable. An
                       IR_VREG_BC_PACK or IR_VREG_CALL_SPLIT blocker is another
                       ranged claim that already won its own competition; if one
                       of those overlaps, stand down. So is an IR_VREG_INDUCTION
                       blocker, and that one is load-bearing: an IV in BC is
                       stepped IN PLACE (`inc bc`) every iteration, so evicting it
                       turns a register step into a slot read-modify-write on
                       every trip — a cost no span-local read saving repays.
                       ir_bc_pack's 5a eviction carries the same guard; without
                       it lexbench trades its loop counter for a 5-read split.
                       Reverting to SPILL is sound here for the same reason it is
                       in 5a — ir_assign_slots runs later, in the lowerer, and
                       materialises a slot for every SPILL vreg — and goes
                       through alloc_note_late_home so the word-home prepick
                       snapshot stays in step. */
                    if (bc_busy && cs_evict_on()) {
                        long gain = cs_span_benefit(f, v, best_lo, best_hi,
                                                    bb_first_op, bb_loop_depth);
                        long adj_loss = 0;
                        int nblock = 0, blocked_hard = 0;
                        for (int w = 0; w < nv && !blocked_hard; w++) {
                            if (w == v || f->vreg_to_phys[w] != IR_PR_BC) continue;
                            const LiveRange *lw = ir_live_range(f, w);
                            int wlo = lw && lw->start >= 0 ? lw->start : first_use[w];
                            int whi = lw && lw->start >= 0 ? lw->end   : last_use[w];
                            if (wlo < 0 || whi < 0) continue;
                            int ss = occ_lo > wlo ? occ_lo : wlo;
                            int ee = occ_hi < whi ? occ_hi : whi;
                            if (ss > ee) continue;                  /* disjoint */
                            if (f->vregs[w].flags
                                & (IR_VREG_BC_PACK | IR_VREG_CALL_SPLIT
                                   | IR_VREG_INDUCTION)) {
                                blocked_hard = 1;                   /* stand down */
                                break;
                            }
                            long tenant = cost_benefit ? cost_benefit[w]
                                        : cs_span_benefit(f, w, 0, INT_MAX,
                                                          bb_first_op, bb_loop_depth);
                            long disc = cs_call_weight(f, wlo, whi, bb_first_op,
                                                       bb_loop_depth)
                                      * (COST_READ_W + COST_WRITE_W);
                            tenant -= disc;
                            if (tenant < 0) tenant = 0;
                            adj_loss += tenant;
                            nblock++;
                        }
                        /* A FLOOR, and it is honest tuning rather than a
                           derivation: no monotone function of these numbers
                           separates the confirmed evictions from the refuted
                           one, and the discriminator turns out to be MAGNITUDE
                           rather than ratio — below it two unit-weighted access
                           counts are inside the model's own error. Decline there
                           rather than pretend the model can rank. adr/0071.
                           IR_CS_EVICT_MIN retunes it. */
                        long min_gain = 100;
                        { const char *e = getenv("IR_CS_EVICT_MIN");
                          if (e) min_gain = strtol(e, NULL, 10); }
                        if (!blocked_hard && nblock > 0 && gain > adj_loss
                            && gain >= min_gain) {
                            for (int w = 0; w < nv; w++) {
                                if (w == v || f->vreg_to_phys[w] != IR_PR_BC) continue;
                                if (f->vregs[w].flags
                                    & (IR_VREG_BC_PACK | IR_VREG_CALL_SPLIT
                                       | IR_VREG_INDUCTION)) continue;
                                const LiveRange *lw = ir_live_range(f, w);
                                int wlo = lw && lw->start >= 0 ? lw->start : first_use[w];
                                int whi = lw && lw->start >= 0 ? lw->end   : last_use[w];
                                if (wlo < 0 || whi < 0) continue;
                                int ss = occ_lo > wlo ? occ_lo : wlo;
                                int ee = occ_hi < whi ? occ_hi : whi;
                                if (ss > ee) continue;
                                alloc_note_late_home(f, w, IR_PR_SPILL);
                            }
                            bc_busy = 0;
                            if (getenv("IR_CALLSPLIT_LOG") || getenv("IR_ALLOC_PROBE"))
                                fprintf(stderr, "CSEVICT %s split=v%d span=[%d,%d] "
                                        "gain=%ld adj_loss=%ld evicted=%d\n",
                                        f->fn ? ir_sym_name(f->fn) : "?", v,
                                        best_lo, best_hi, gain, adj_loss, nblock);
                        }
                    }
                    if (bc_busy && cslog2) {
                        /* The DECLINED evictions, under the same
                           IR_CALLSPLIT_LOG=2 as the other cs-reject lines: what
                           the split is worth over its span against what each
                           picker-placed blocker draws from BC over its whole
                           home, in one unit (cs_span_benefit reproduces
                           cost_benefit when given the whole function). Read it
                           beside the CSEVICT line above, which reports the
                           evictions that were TAKEN — the two together are what
                           you need to retune IR_CS_EVICT_MIN. */
                        long gain = cs_span_benefit(f, v, best_lo, best_hi,
                                                    bb_first_op, bb_loop_depth);
                        for (int w = 0; w < nv; w++) {
                            if (w == v || f->vreg_to_phys[w] != IR_PR_BC) continue;
                            const LiveRange *lw = ir_live_range(f, w);
                            int wlo = lw && lw->start >= 0 ? lw->start : first_use[w];
                            int whi = lw && lw->start >= 0 ? lw->end   : last_use[w];
                            if (wlo < 0 || whi < 0) continue;
                            int ss = occ_lo > wlo ? occ_lo : wlo;
                            int ee = occ_hi < whi ? occ_hi : whi;
                            if (ss > ee) continue;
                            fprintf(stderr, "CSEVICT %s split=v%d(uc=%d,wc=%d,reads=%d) "
                                    "span=[%d,%d] "
                                    "gain=%ld | blocker=v%d flags=%#x live=[%d,%d] "
                                    "loss=%ld cb=%ld uc=%d wc=%d\n",
                                    f->fn ? ir_sym_name(f->fn) : "?", v,
                                    use_count[v], write_count[v], best_reads,
                                    best_lo, best_hi, gain, w, f->vregs[w].flags,
                                    wlo, whi,
                                    cs_span_benefit(f, w, 0, INT_MAX, bb_first_op,
                                                    bb_loop_depth),
                                    cost_benefit ? cost_benefit[w] : -1,
                                    use_count[w], write_count[w]);
                            fprintf(stderr, "        wcalls_blocker=%ld wcalls_span=%ld\n",
                                    cs_call_weight(f, wlo, whi, bb_first_op, bb_loop_depth),
                                    cs_call_weight(f, best_lo, best_hi, bb_first_op,
                                                   bb_loop_depth));
                        }
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
                    alloc_note_late_home(f, v, IR_PR_BC);
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
                #undef CS_WHY
            }
            free(callpos);
            free(wdb);
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
        free(bb_loop_depth); free(bb_cond_shift);
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

    /* P3.2 step 1 (DEFAULT ON; --opt-disable=tight-homes, IR_OFF=tight-homes):
       narrow whole-function homes to the
       tight live range. A vreg is only accessed WITHIN its live range, where
       its home is unchanged, so this is byte-identical — it makes home_lo/hi
       TRUTHFUL (the substrate for disjoint sub-range time-sharing) and gives the
       range-aware verifier real residency windows. A byte-diff that is NOT clean
       reveals a lowerer access outside the IR live range (the "invisible
       residency" the plan warns about) — high-value to surface before ranging.
       HL/DEHL (cache-only) and SPILL/NONE are skipped.
       Flipped default-on 2026-09-15 once it was byte-clean: 720 cells, 20
       smaller, ZERO larger, ticks unchanged. Evidence and the two bugs that
       had to be fixed first (frameless_ok's ranged test, and this loop
       WIDENING an already-ranged window) are in adr/0027. */
    if (!opt_disabled("tight-homes") && f->home_lo && f->home_hi) {
        for (int v = 0; v < f->n_vregs; v++) {
            PhysReg pr = f->vreg_to_phys[v];
            if (pr == IR_PR_SPILL || pr == IR_PR_NONE
                || pr == IR_PR_HL || pr == IR_PR_DEHL)
                continue;
            const LiveRange *lr = ir_live_range(f, v);
            if (!lr || lr->start < 0) continue;
            /* CLAMP, never assign. A home may ALREADY be ranged — a call-split
               home carries a deliberately narrow window because the value is
               SLOTTED outside it. Overwriting that with the live range WIDENS
               it, and the lowerer then believes the register holds the value at
               points where it does not: shiftbench/shift_compute v3 went from
               home=[12,36] to home=[1,75] over a live range of [1,75], turning
               a true window into a false one. That is a latent miscompile, not
               a size regression — it only showed up as +14 bytes because the
               lowerer happened to reload from the slot anyway.
               Narrowing is the whole point of this step; widening is never
               correct. */
            if (lr->start > f->home_lo[v]) f->home_lo[v] = lr->start;
            if (lr->end   < f->home_hi[v]) f->home_hi[v] = lr->end;
        }
    }

    /* [IR_RANGEPROBE, inert] Stage 2 of the ranging arc (ADR 0017) is "a
       register time-shared between disjoint values". That is only measurable
       now that stage 1 made the intervals truthful — while every home spanned
       the whole function, nothing could be disjoint from anything.

       The question this answers is whether to BUILD stage 2, and it is the same
       question IR_PAIRPROBE asked before the pair allocator (which it refused,
       correctly, on zero opportunity). For each SPILLED value, is there a
       parking register whose every current tenant has a live range DISJOINT
       from it? If so that register could host it over its own window and the
       spill is avoidable; if the count is ~0 corpus-wide, stage 2 has nothing
       to collect and should not be built.

       Deliberately generous — it ignores admissibility (width, class masks,
       cleanliness) and counts only the interference question, so it is an UPPER
       BOUND. A small upper bound is a real answer; a large one still needs the
       admissibility gates applied before anyone believes it. */
    if (getenv("IR_RANGEPROBE")) {
        static const PhysReg park[] = { IR_PR_BC, IR_PR_DE, IR_PR_IX, IR_PR_IY };
        int n_spill = 0, n_share = 0, n_fn_share = 0;
        for (int v = 0; v < f->n_vregs; v++) {
            if (!f->vreg_to_phys || f->vreg_to_phys[v] != IR_PR_SPILL) continue;
            const LiveRange *lv = ir_live_range(f, v);
            if (!lv || lv->start < 0) continue;
            n_spill++;
            for (unsigned r = 0; r < sizeof park / sizeof park[0]; r++) {
                int occupied = 0, clash = 0;
                for (int w = 0; w < f->n_vregs && !clash; w++) {
                    if (w == v || f->vreg_to_phys[w] != park[r]) continue;
                    occupied = 1;
                    if (ir_live_ranges_overlap(f, v, w)) clash = 1;
                }
                /* Admissibility, without which the count above is fiction:
                     - width <= 2 (a long needs DEHL, not a parking pair);
                     - not address-taken (it must have a memory home);
                     - and NOTHING in the value's live range may clobber the
                       register. That last one is the real filter: a value whose
                       range crosses a call cannot sit in BC or DE without a
                       save/restore, which is stage 3's job, not stage 2's. */
                RegMask rmask = park[r] == IR_PR_BC ? IR_R_BC
                              : park[r] == IR_PR_DE ? IR_R_DE
                              : park[r] == IR_PR_IX ? IR_R_IX : IR_R_IY;
                int adm = f->vregs[v].width <= 2
                       && !(f->vregs[v].flags & IR_VREG_ADDR_TAKEN);
                if (adm) {
                    int g = 0;
                    for (int b2 = 0; b2 < f->n_bbs && adm; b2++)
                        for (int j2 = 0; j2 < f->bbs[b2].n_ops; j2++, g++) {
                            if (g < lv->start || g > lv->end) continue;
                            if (op_clobbers(f, &f->bbs[b2].ops[j2]) & rmask) {
                                adm = 0; break;
                            }
                        }
                }
                if (occupied && !clash && adm) {
                    n_share++;
                    if (getenv("IR_RANGEPROBE")[0] == '2')
                        fprintf(stderr, "RANGEPROBE:   %s v%d live=[%d,%d] could "
                                "time-share %s\n",
                                f->fn ? ir_sym_name(f->fn) : "?", v,
                                lv->start, lv->end, ir_phys_name(park[r]));
                    break;
                }
            }
        }
        if (n_share) n_fn_share = 1;
        if (n_spill)
            fprintf(stderr, "RANGEPROBE %-20s spilled=%d  time-shareable=%d%s\n",
                    f->fn ? ir_sym_name(f->fn) : "?", n_spill, n_share,
                    n_fn_share ? "" : "");
    }

    /* [IR_HOMEMAP] Inert: the final placement, one line per homed vreg. The
       question "who got which register, and over what range" is the first one
       any residency arc asks, and reading it back out of the asm is slow and
       lossy. Prints after every pass has run, so it is the allocator's answer,
       not a proposal. */
    if (getenv("IR_HOMEMAP"))
        for (int v = 0; v < f->n_vregs; v++) {
            if (!f->vreg_to_phys || f->vreg_to_phys[v] == IR_PR_SPILL) continue;
            const LiveRange *lr = ir_live_range(f, v);
            fprintf(stderr, "ALLOCMAP %-16s v%-4d phys=%-6s home=[%d,%d] "
                    "live=[%d,%d] flags=%#x\n",
                    f->fn ? ir_sym_name(f->fn) : "?", v,
                    ir_phys_name(f->vreg_to_phys[v]),
                    f->home_lo ? f->home_lo[v] : -1,
                    f->home_hi ? f->home_hi[v] : -1,
                    lr ? lr->start : -1, lr ? lr->end : -1, f->vregs[v].flags);
        }
    assign_idxhalf_homes(f);
    hr_recoverability_verify(f);
    ir_liveprobe_flush(f->fn ? ir_sym_name(f->fn) : "?");
}
