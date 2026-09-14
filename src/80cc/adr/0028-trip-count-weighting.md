# ADR 0028 — Weighting a cost by real trip counts

Status: **Rejected** (2026-09-14). The diagnosis stands; this fix for it does not.

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

## Measured, and refused

It loses on **both** axes.

- **Size**: 30 benchmarks x 12 CPU variants x both frame modes —
  **+845 bytes**, 48 cells smaller, 81 larger.
- **Ticks**: 11 CPU variants x both frame modes, 660 cells, no new failures —
  **+0.066 %**, 54 cells faster, **70 slower**. Worst `lexbench` on gbz80
  **+8.51 %**, then `hashbench` +2.47 %.

A frequency model is allowed to cost bytes if it buys ticks. This costs both, so
there is nothing to trade.

## Why it fails, which is the part worth keeping

The diagnosis is not what failed. The weight really is wrong by 10x to 100x, in
one direction, and that finding stands.

What fails is the assumption that a more accurate input makes a better decision.
The tell is `hashbench`: it is among the **worst** regressions on one CPU and
frame mode (+2.47 %) and among the **best** improvements on another (−1.29 %).
The same benchmark, the same code, moving both ways. That is not a model getting
sharper — it is a near-tie being flipped, and which side it lands on is
incidental.

So the ranking that consumes the weight cannot absorb a more truthful number.
Feeding it one just re-rolls the dice on every decision that was close.

This is the **third** independent finding pointing at the same missing term:

- ADR 0021 — per-value spill heuristics fail because two identical values have
  opposite optimal placements; the decision is interference, not value kind.
- ADR 0032 — the corrected gbz80 cost row is right and makes the outcome worse,
  by flipping a near-tie.
- this ADR — a corrected frequency weight does the same.

In each case a **more correct input produced a worse result**, because nothing
prices what a claim displaces. Until the resolver compares competing claims
rather than scoring them in isolation, improving any single input is as likely
to hurt as help.

## Reopening

Not on its own. Reopen it **after** the opportunity-cost term lands, and then
only as a re-measurement — the implementation here is sound and needs no
redesign. If the resolver can compare claims and this weight still does not pay,
the diagnosis itself is wrong, which would be worth knowing.

The gate, its default-constant knob and the probe that measured the original
error are all removed; their numbers are recorded above.
