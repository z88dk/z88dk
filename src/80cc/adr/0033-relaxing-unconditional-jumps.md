# ADR 0033 — Relaxing unconditional jumps is a per-CPU question

Status: Accepted (the per-CPU policy). The `IR_JR_UNCOND` override is
**Rejected** and removed — see the measurement below.

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

## The override: measured, and refused

`IR_JR_UNCOND=1` forced unconditional relaxation on every CPU, including the two
where the policy says no.

On size it looked attractive — 30 benchmarks x 12 CPU variants x both frame
modes gave **−350 bytes, 114 cells smaller, no cell larger.** The bytes were
never in doubt; the policy says so itself.

The tick matrix (30 benchmarks x 11 CPU variants x both frame modes, 660 cells,
no new failures) settles it:

| | ticks | cells slower | cells faster |
|---|---|---|---|
| z80 | +0.141 % | **57** | **0** |
| z80n | +0.147 % | **57** | **0** |
| every other CPU | 0.000 % | 0 | 0 |

Two things stand out. The nine other CPUs show **exactly zero** change, because
they already relax by default — so the override only ever acts on z80 and z80n.
And there it is **uniformly slower, never faster**: 114 cells of 1-byte savings
bought at 57 slower cells per CPU, worst `listbench` +1.30 %, `crcbench` +0.40 %.

So the whole −350 bytes is a byte-for-tick trade on precisely the two CPUs whose
timing says not to make it. The override is removed; the per-CPU policy stands
unchanged and needs no switch.

## Reopening

Only if `jr`'s timing on z80 changes, which it will not. A future variant with a
different `jr` cost gets a row in the table above, not a global override.
