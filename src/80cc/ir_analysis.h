/*
 * ir_analysis.h — analyses over the IR: liveness, loop info, etc.
 *
 * Per-BB live_in / live_out via iterative dataflow. Drives the
 * allocator's choice of which vregs to keep in registers vs spill
 * to the frame.
 */

#ifndef IR_ANALYSIS_H
#define IR_ANALYSIS_H

#include "ir.h"
#include <stddef.h>

/* Vreg-indexed bit set. Opaque to callers; ir_analysis.c owns layout.
   The BB struct's `live_in` / `live_out` are stored as `BitSet *`. */
typedef struct BitSet BitSet;

BitSet *ir_bitset_new(int n);
void    ir_bitset_free(BitSet *bs);
int     ir_bitset_get(const BitSet *bs, int v);
void    ir_bitset_set(BitSet *bs, int v);
void    ir_bitset_clear(BitSet *bs, int v);

/* Iterate over the set members in ascending order. Visits each set
   vreg id once; callback returns 0 to continue, non-zero to stop. */
void    ir_bitset_for_each(const BitSet *bs,
                           int (*cb)(int vreg, void *ud), void *ud);

/* Compute liveness over the function. Populates each bb->live_in and
   bb->live_out as `BitSet *` over the full vreg space (size = f->n_vregs).
   Idempotent — calling twice replaces the previous result. */
void ir_compute_liveness(Func *f);

/* Compute per-op live-in sets within each BB. Requires
   ir_compute_liveness to have run first (per-op iteration starts from
   bb->live_out). After this call, bb->live_in_per_op[k] is a `BitSet *`
   holding the vregs live at the entry to ops[k] for every BB.
   Idempotent — calling twice replaces the previous result.

   Memory: each set sized to f->n_vregs; n_ops × n_bbs sets total.
   Foundation for the typed allocator (PR_HL/PR_DE/PR_BC placement). */
void ir_compute_op_liveness(Func *f);

/* Returns the live-in set at op_idx within bb. NULL if op liveness
   hasn't been computed or op_idx is out of range. Caller must not
   mutate the returned set. */
const BitSet *ir_op_live_in(const BB *bb, int op_idx);

/* Writes the live-out set at op_idx into `out` (caller-allocated,
   sized to f->n_vregs). For op_idx < n_ops-1 this is live_in_per_op
   [op_idx+1]; for the last op it is bb->live_out. */
void ir_op_live_out(const BB *bb, int op_idx, BitSet *out);

/* Free every BB's liveness sets, including the per-op arrays. Safe
   to call multiple times. */
void ir_free_liveness(Func *f);

/* Per-vreg live ranges in linearised op-index space. Walks BBs in id
   order assigning each op a global index, then records [start, end] per
   vreg — start = first op where it's live (def/param-entry/first
   live_in), end = last (use or last live_out). Two vregs interfere iff
   their intervals overlap. Conservative: a vreg with holes gets one
   span covering the union (over- but never under-approximates, which is
   what a correct allocator needs).
   Requires ir_compute_liveness + ir_compute_op_liveness to have run. */
typedef struct {
    int start;       /* first global op-index where vreg is live; -1 if unused */
    int end;         /* last global op-index where vreg is live; -1 if unused */
} LiveRange;

void ir_compute_live_ranges(Func *f);
void ir_free_live_ranges(Func *f);

/* Accessor for the range of vreg v. Returns NULL if not computed or v
   is out of range. Caller must not mutate the returned struct. */
const LiveRange *ir_live_range(const Func *f, int v);

/* Returns 1 iff vregs a and b have overlapping live ranges (i.e., they
   are simultaneously live at some op). 0 means safe to share a phys
   reg. Both ranges must be computed; unused vregs (start == -1) never
   interfere. */
int ir_live_ranges_overlap(const Func *f, int a, int b);

/* Returns the total number of ops in linear (BB id) order — the size of
   the global op-index space used by live ranges. */
int ir_func_total_ops(const Func *f);

/* Op-level def/use accessors. Each writes up to `max` vreg ids into
   `out` and returns the count actually written (or the count it *would*
   have written if `max` had been larger — caller should re-call with
   a bigger buffer if return > max). vreg ids are non-negative. */
int  ir_op_defs(const Op *op, int *out, int max);
int  ir_op_uses(const Op *op, int *out, int max);

/* Structural IR verifier. Walks the function and reports invariant
   violations to stderr (vreg-operand bounds, branch/switch targets,
   BB succ/pred ids, required heap payloads, spilled-vreg slot validity,
   vreg widths). Read-only — never mutates `f`. Returns the number of
   violations found (0 = clean). `stage` is a label for the report line
   (e.g. "lower"). Cheap enough to gate on an env var per function. */
int ir_verify_func(const Func *f, const char *stage);

/* Report vregs that appear in no op slot and are not roots — abandoned
   builder temps. Read-only; returns the count, printing each when `verbose`. */
int ir_report_dead_vregs(const Func *f, const char *stage, int verbose);

/* Remove orphan vregs (in no op slot, not a root) and renumber survivors,
   rewriting every op slot. Run before liveness/allocation. Returns the count
   removed. */
int ir_compact_vregs(Func *f);

#endif /* IR_ANALYSIS_H */
