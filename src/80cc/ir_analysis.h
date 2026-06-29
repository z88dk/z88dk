/*
 * ir_analysis.h — analyses over the IR: liveness, loop info, etc.
 *
 * Phase 2 first slice: per-BB live_in / live_out via iterative
 * dataflow. Drives the allocator's choice of which vregs to keep in
 * registers vs spill to the frame.
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

   Memory: each set is sized to f->n_vregs. n_ops × n_bbs sets total —
   typical functions have ~50 ops × ~10 BBs, so ~500 small sets. Stage 1
   foundation for the typed allocator (PR_HL/PR_DE/PR_BC live-range
   placement). */
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

/* Per-vreg live ranges in linearised op-index space. ir_compute_live_ranges
   walks the BBs in id order, assigns each op a global index, and for each
   vreg records [start, end] — start = first op index where the vreg is
   live (def site, param entry, or first live_in occurrence); end = last
   op index where the vreg is live (use site, or last live_out occurrence).
   Two vregs interfere iff their [start, end] intervals overlap.
   Conservative: a vreg with holes in non-linear control flow gets one
   span covering the union — over-approximates interference but never
   under-approximates, which is what a correct allocator needs.
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

#endif /* IR_ANALYSIS_H */
