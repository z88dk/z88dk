# ADR 0028 — Weighting a cost by real trip counts

Status: Proposed (staged behind `IR_TRIPW`, measured by `IR_TRIPPROBE`)

Relates to ADR 0003 (register residency) and the cost model generally.

## Context

Every residency decision multiplies a per-access cost by how often the access
runs. The cost half is micro-benchmarked against the datasheets. The frequency
half is the constant `4^loop_depth` — a stand-in for "how often does this block
execute".

A probe measured that stand-in against trip counts derivable from the loop
bounds. About 60% of loops resolve, and where they do the constant is wrong by
more than 10x in most of them, by more than 100x in a dozen, and worst case by
512x. The error is almost entirely in one direction: it under-weights.

Grounding the per-access costs while leaving the frequency fictional only
sharpens a decision that is being made on the wrong number.

## Decision

Use the derived per-block iteration weight — the product of the trip counts of
the loops containing the block — where the counts are derivable.

**The fallback is part of the decision, not a detail.** A loop whose count is
not derivable needs a weight on *the same scale* as the real counts. Using a
real count where known and `4^depth` elsewhere mixes two scales: a
literal-bounded thousand-trip loop would outrank an unknown loop at the same
depth by 250 to 1, for no reason except that one bound happened to be a
literal. So the fallback is a single tuned constant on the real-count scale.

## Why it is not yet accepted

This changes the input to every residency decision at once, so it cannot be
judged by a corpus total: a large aggregate win could hide the cost model now
making systematically different choices in the loops it can resolve. It needs
the per-cell size and tick reports, and a check that the resolved-loop cells and
the fallback cells move for the reasons claimed.

Promote or refuse it as one decision with `IR_TRIPPROBE`'s measurements
attached; do not ship it as a quiet default flip.
