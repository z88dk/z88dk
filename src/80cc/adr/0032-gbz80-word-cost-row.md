# ADR 0032 — The measured gbz80 cost row

Status: Proposed, **in flight** — the per-CPU cost correctness that ADR 0017's
ranging arc depends on. Staged behind `IR_GBZ80_COST`; blocked, not undecided.

Relates to ADR 0006 (multi-CPU retargeting) and ADR 0003 (residency).

## Context

The allocator prices a frame-slot access per CPU. gbz80 was using the **Z80
numbers**, which are wrong for it: a gbz80 slot access really is about 30 %
cheaper than the Z80 row claims.

So this is not a tuning preference. It is a **correction**: one CPU's cost row
does not describe that CPU.

## Decision

Not yet. The corrected row is staged behind a gate, and gbz80 keeps the wrong
but tuned Z80 row as its default.

The reason is that making the row truthful flips a **near-tie** in one
benchmark's inner loop: BC moves from a value live over a short hot interval to
a shorter, colder one. The corrected row is worth about 14 bytes across two
benchmarks and costs about **10 % ticks** on another. The row is right and the
outcome is worse.

That is the signature of a ranking problem, not a costing problem: when two
candidates are within noise of each other, the tie is settled by something other
than the number — and correcting the number just moves which side of the tie a
value lands on.

## What unblocks it

Break the ranking tie on something real before making the row default. The
candidate is the opportunity-cost term — pricing what a claim *displaces*, not
only what it costs — which is the same missing term ADR 0021 identifies for
per-value spill heuristics. If that lands and the histogram loop still regresses,
the tie-break is elsewhere and this ADR needs re-opening on its own evidence.

Do **not** resolve this by tuning the gbz80 row away from its measured value.
That would restore the good benchmark result by putting a known-false number
back into the cost model, and the next decision that consults it would be wrong
for the same reason this one is right.
