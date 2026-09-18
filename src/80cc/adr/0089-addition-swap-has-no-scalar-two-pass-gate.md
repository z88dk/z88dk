# ADR 0089 — The addition swap has no scalar two-pass gate

Status: **Rejected**. Not built; the existing addition lowering stays.

## Context

Addition is commutative, so a DEHL-resident operand could be kept in place
while the other operand is read from its slot. The old measurement showed a
large win in `md5`, but the read changes the evidence used by lazy-spill's
second pass: a slot read in pass 1 can make a store live in pass 2.

## Model

The lowerer already records pass-1 slot stores, reloads, and genuine cache
reads, then computes `ss_store_dead` before the real pass. A temporary probe
was run at the width-4 `IR_ADD` site on the Z80 corpus, both frame modes, the
real witnesses, and `binary-trees`.

The result is that `ss_store_dead` is conditional on the un-swapped render.
It cannot answer the hypothetical swap: changing the operand roles changes
which slot reads pass 1 records, which changes the backward liveness result.
The exact model would need a second complete pass-1 render with the candidate
swap applied, followed by a second liveness solve. A candidate count or a
residency test is therefore not a sound gate.

The existing A/B evidence remains the decision boundary:

| witness | effect of the swap |
|---|---|
| `md5` | −6% ticks |
| `binary-trees` | +0.39% ticks and +28 bytes |
| `emu.c` | +75 bytes |

## Decision

Do not build the swap or a private probe. The dual-render model costs another
whole lowering pass and still needs a policy for the resulting size/cycle
trade; it does not produce a useful general optimisation gate. Keep addition
as-is and retain ADR 0072 as the historical A/B record.

The next density experiment is the constant right shift of a word on CPUs that
have `srl`.
