# ADR 0024 — A byte home for a single-use temporary

Status: Rejected (2026-09)

Relates to ADR 0003 (register residency) and ADR 0002 (the register model).

## Context

Byte temporaries spill to frame slots, and there are many of them. The byte-home
predicate requires a high use count, which single-use temporaries never reach,
so the obvious move is to lower that threshold.

## Decision

Do not lower the byte-home use-count threshold. Measured, relaxing it all the
way to one costs **+307 bytes**, with four times as many cells larger as smaller.
Intermediate thresholds change nothing at all, because the count measures reads
and a write-once/read-once temporary scores one.

Two independent reasons, and both constrain any future design:

1. **The E home is slot-backed.** E and D are clobberable by DE-scratch
   operations, so the lowerer lazy-spills them to a slot and reloads at
   boundaries. Homing a single-use temporary in E therefore does **not** remove
   its slot — it adds register traffic on top of the slot that remains. C and B
   are slotless; E and D are not.
2. **One byte home per function.** The arbiter's byte arm takes the first
   candidate and refuses every later one. Even where the home pays, only one
   temporary in a function can have it.

So the gate is not what stands between byte temporaries and their slots. The
binding constraints are the backing requirement of the chosen register and the
one-home-per-function arbitration.

## Reopening

The route is not the threshold. It is either a slotless register (C or B) for
this class of value, or lifting the one-byte-home-per-function restriction so
that several temporaries can be homed at once. Either is a real change to
arbitration, and needs its own measurement — re-running the threshold probe will
only reproduce the +307.
