# ADR 0035 — Claims are priced in isolation, and that is the binding limit

Status: Accepted (a finding, 2026-09-14)

Explains why ADR 0021 and ADR 0028 were refused, and what has to change before
either can be reconsidered.

## Context

Two independent attempts to make the allocator's cost model *more correct* made
the emitted code *worse*:

| | The correction | Result |
| --- | --- | --- |
| ADR 0021 | per-value spill heuristics | two identical counters have opposite optimal placements |
| ADR 0028 | true loop trip counts instead of `4^depth` | +845 bytes **and** +0.066 % ticks |

In both cases the number being fixed was genuinely wrong. The weight really is
off by 10x to 100x, in one direction. The fix was sound. The outcome was worse.

## The finding

The allocator scores each candidate **in isolation**. Nothing prices the claim a
decision *displaces*.

So when two candidates are close, the winner is settled by pass order rather
than by cost — and feeding the comparison a more accurate number does not
sharpen it, it just re-rolls which side of the tie a value lands on.

The clearest evidence is a single benchmark under ADR 0028: `hashbench` is among
the **worst** regressions on one CPU and frame mode (+2.47 %) and among the
**best** improvements on another (−1.29 %). The same source, the same
transformation, moving both ways. That is not a model getting sharper.

**Until the resolver compares competing claims, improving any single cost input
is as likely to hurt as to help.** This is why the realised-cost ledger —
scoring each `(vreg, home, window)` claim *including the opportunity cost of what
it displaces* — gates that work rather than competing with it.

## The diagnostic trap

"Truer cost, worse result" has **at least two causes**, and they look identical
from the outside.

The second is not a model limitation but a bug: a register is freed by a failed
home and then offered to nobody. That is what happened with the gbz80 cost row
(ADR 0032) — a value took BC, the lowerer could not realise the home,
`[home-demote]` dropped it to a slot, and the arbiter never ran again to
re-offer the register. Correcting the cost row looked like it had flipped a
ranking tie. Completing the recovery (`[home-rearb]`) made the benchmark neutral
and the correction shipped.

**Rule out the recovery bug first.** It is cheap to check and it is a defect;
the isolation limit is expensive to fix and is a design property.

## Reopening

Not applicable — this records a property of the current resolver, and it stops
being true when the ledger lands. At that point re-measure ADR 0021 and ADR 0028
rather than redesigning them: both implementations were sound, and it was the
consumer of their output that could not use it.
