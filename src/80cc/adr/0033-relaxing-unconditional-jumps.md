# ADR 0033 — Relaxing unconditional jumps is a per-CPU question

Status: Accepted (the per-CPU policy), with `IR_JR_UNCOND` as a staged override

Amends ADR 0025 (post-render code layout), which describes the relaxation stage
but not why its unconditional case is CPU-dependent.

## Context

Branch relaxation rewrites `jp` as `jr` where the displacement fits. The byte
saving is always 1 and always in our favour. The **timing** is not, and it
differs by CPU.

## Decision

Relax **conditional** branches everywhere. `jr cc` costs 12 T taken and 7 not
taken, against `jp cc`'s flat 10, so the not-taken path pays for the taken one
and the branch is cheaper on average.

Relax **unconditional** jumps only where `jr` is not slower:

| CPU | `jr` vs `jp` | |
|---|---|---|
| z80, z80n | +2 T | **do not relax** |
| z180 | 8 T vs 9 | relax |
| gbz80 | 12 T vs 16 | relax |
| rabbit | 5–6 T vs 7 | relax |
| ez80, kc160 | no penalty | relax |

The asymmetry has a reason worth stating: **an unconditional jump is taken every
time it is reached, so it cannot amortise a slower form.** A conditional branch
can — its not-taken path is cheaper — which is why the same instruction choice
goes the other way for the two cases.

## The override, and what it measures

`IR_JR_UNCOND=1` forces unconditional relaxation on every CPU, including the two
where the policy says no. Measured across 30 benchmarks x 12 CPU variants x both
frame modes: **−350 bytes, 114 cells smaller, no cell larger.**

That is exactly what the policy predicts — the bytes were never in doubt. It is
not evidence for flipping it, because the cost is in ticks on z80 and z80n, and
this measurement does not contain ticks.

Promote it only with a tick matrix showing no z80 or z80n cell slower. If ticks
do regress there and the bytes are wanted anyway, that is a deliberate
byte-for-tick policy and must be recorded as one — not slipped in as a size win.
