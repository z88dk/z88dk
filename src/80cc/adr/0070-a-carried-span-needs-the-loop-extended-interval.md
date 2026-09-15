# ADR 0070 — A carried span needs the loop-extended interval

Status: **Accepted**. Part of call-bounded live-range splitting.

## The hazard

A candidate is live-**carried** beyond its chosen call-free span iff its
loop-extended interval `[first_use,last_use]` exceeds `[best_lo,best_hi]`. When
it is, BC must survive a region that is flat-**outside** the span but
control-flow **inside** it.

Block layout can place a nested loop body at flat indices past `best_hi` while
control flow runs it between the span's uses. `sieve_count`'s `i_sq` is carried
across the inner `flags[k]=1` loop on index-less 808x/gbz80, where `i_sq` cannot
escape to IX/IY. A tenant living in that carried region clobbers BC, yet a plain
flat-overlap test against `[best_lo,best_hi]` misses it.

## Decision

Widen the occupancy to the loop-extended interval — but only in that case, under
two conditions that each cost a regression when they were absent:

**Gate on an in-span WRITE (`unsafe_write`).** A loop-carried accumulator or IV
is written each iteration and must hold BC across the whole loop body; a
read-only reused temp dies at `best_hi` and needs no widening. Widening it
spuriously blocked `matrixbench` and `hashbench` call-splits.

**Only under a real layout inversion** — a BB placed flat-after `best_hi` with a
control-flow edge back **into** `[best_lo,best_hi]` (the inner loop whose body
sits after the outer increment in op order, as in `sieve`). Without such a
re-entry the flat span is control-flow-contiguous and the loop extension is
spurious, and `matrixbench`'s carried split stays.

## The general lesson

**Flat op order is not control-flow order.** Any interval test that assumes it
will be wrong wherever block layout has moved a loop body, and the failure is a
clobbered register rather than a missed optimisation.
