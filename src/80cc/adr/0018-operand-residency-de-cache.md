# ADR 0018 — Operand residency via a DE cache

Status: Rejected (2026-09-13)

Relates to ADR 0003 (register residency) and ADR 0017 (ranged residency SSoT).

## Context

80cc lowers through a fixed bus: HL and A are the codegen ports, and a value
that is not register-homed funnels through HL and spills. sdcc, on the same
shapes, keeps the second operand of a word operation in DE and emits
`sbc hl,de` against it directly.

That contrast made an attractive thesis: the density gap is *operand*
residency. Keep a reused deref or binop result in DE rather than spilling it,
and the reload traffic disappears. Two forms were built and measured behind
inert probes — an unconditional single-BB DE cache, and a cross-basic-block DE
carry.

## Decision

Do not pursue operand residency as a DE cache. Neither form pays.

- The unconditional DE cache costs bytes rather than saving them: the evacuation
  and restore traffic around each use exceeds the reload it removes.
- The cross-BB DE carry wins nothing at all, because the value it would carry
  across the edge is already being carried — in HL. The carry duplicates work
  the belief cache already does.

The single-BB remnant survives only as an opt-in (`IR_RANGED`), and even there
it needs a dear-slot cost gate to avoid regressing the CPUs where a frame slot
is cheap (ez80, kc160, rabbit). It is marginal with the gate and harmful
without it.

The measurement probes `IR_OPRES_WHY` and `IR_OPRES_PROBE` are retired; their
source is kept under `src/80cc/probes-retired/` so the census can be re-run
without re-deriving it. The numbers are in `BENCH_MATRIX.txt` and the
operand-residency handover.

## Reopening

This is closed on the current model, not in principle. Reopen only with a new
idea, not a re-measurement — specifically, if the cost of moving a value between
HL and DE changes, or if ranged residency (ADR 0017) makes DE available over a
sub-range rather than a whole live range. A fresh census on the same model will
reproduce the same answer.
