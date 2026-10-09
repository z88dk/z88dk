# ADR 0106 — Sinking a loop-carried init to its first use

Status: **Rejected** (2026-10)

Relates to ADR 0021 (per-value spill heuristics) and ADR 0105 (the framework
cost).

## Context

`index_walk_int` in `ptrbench` initialises its DE-resident sum and its stepped
BC pointer at the top of the function. The loop pre-header then computes the
signed-bound clamp `max(0,n)` with both registers already occupied, so every
clamp temporary parks on the stack (`pop de; push hl; ex de,hl`). Moving each
`LD_IMM` or register `MOV` down to just before its first use frees DE and BC
for that work.

## Decision

Do not ship the pass. It was measured as `ir_opt_sink_inits` (a local reorder
in one block, run just before the long-push inserter). The scans below are of
its final, narrowed form (word-width destinations with two or more defs, a
whitelist of value ops it may pass, no passed result read later in the block),
over the 720-cell size scan against HEAD, z80 sp and fp included, with the
exit-flush change (`home-exit-de`) as the second switch:

| `sink-init` | `home-exit-de` | total | smaller | larger |
|---|---|---|---|---|
| on | on | +92 B | 106 | 355 |
| off | on | −297 B | 23 | **0** |
| on | off | +628 B | 102 | 359 |
| off | off | 0 | 0 | 0 |

The pass alone is therefore +389 B over the corpus (the first two rows
differ only in it). Restricting it further to loop pre-headers was tried on six
benches and still left intbench, lexbench, histbench and divbench 1–4 B larger
per cell. The wins were `ptrbench` (−20 to −34 B on z80) and `sieve` (−3 to
−4 B).

The cause is not the move but what follows it. The lowerer's HL slot-address
cache and the allocator's home choice both depend on op order, so a reorder
that helps one block turns an `inc hl` into `ld hl,N; add hl,sp` in another.
Unguarded, it also produced two real miscompiles: a def moved past a
`BR_ZERO` (those branches are not flagged terminators, so the taken path skips
the def), and a def moved past the def of a call argument that the next op
reads (the half-float tests, argument order). Both were fixed in the pass, and
the remaining size loss was not.

## What would reopen it

A pass that knows the allocator's decision: sink only a def whose register
home the clamp's temporaries would otherwise displace, measured by a
`IR_HOMEMAP` diff rather than by op shape. Alternatively, build the clamp
without a register-hungry expansion (a guard branch instead of the branchless
mask), which removes the pressure rather than rescheduling around it.
