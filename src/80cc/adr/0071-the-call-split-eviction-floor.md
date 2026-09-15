# ADR 0071 — The call-split eviction floor is honest tuning

Status: **Accepted**. `IR_CS_EVICT_MIN` retunes it.

## Context

No monotone function of the available numbers separates the confirmed evictions
from the refuted one. This ADR records that plainly rather than dressing a
threshold as a derivation.

Measured, z80:

| bench | gain | adj | outcome |
|---|---|---|---|
| divbench | 304 | 51 | recovers the regression in full |
| shiftbench | 304 | 51 | recovers the regression in full |
| bitfieldbench | 304 | 276 | recovers the regression in full |
| lexbench | 41 | 17 | **costs 13 %** |

`lexbench` has the **best ratio of the four** — 2.4x against `bitfieldbench`'s
1.1x — and is the one that is wrong.

## So the discriminator is magnitude, not ratio

The good cases are deep-loop values scoring in the **hundreds**; `lexbench`'s are
straight-line values scoring in the **tens**, where two unit-weighted access
counts are inside the model's own error.

## Decision

Decline below a floor rather than pretend the model can rank there. 100 sits
between the measured 41 that was wrong and the 304 that was right.

This is the general form of a lesson this codebase keeps relearning: a cost
model has an error floor, and below it the honest move is to refuse rather than
to rank.
