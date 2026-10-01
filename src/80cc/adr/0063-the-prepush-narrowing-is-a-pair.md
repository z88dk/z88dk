# ADR 0063 — The pre-push narrowing is a pair, and must not be separated

Status: **Accepted**, default on. `IR_OFF=prepush-narrow` opts out, and takes
`IR_CS_EVICT` with it (see ADR 0061).

## Decision

Narrow the whole-function pre-pushed-call veto to the calls that can really lose
BC (`prepush_bc_hazard`), instead of vetoing the whole function.

## It works with `bc-save-live`

Alone, the narrowing **regresses `divbench` and `shiftbench`**: it admits BC
homes into functions with pre-pushed calls. This adds `push bc` / `pop bc` pairs.
`bc-save-live` removes pairs whose tenant is not live there. Together, the
regressions reach **zero**.

Enabling the narrowing without `bc-save-live` restores the regressions. Keep the
two options coupled.

## Refuted en route

Pricing a BC home for the `push`/`pop` pair it pays at each spanned pre-pushed
call. At the natural weight `divbench` does not move; at 20x it recovers part of
the loss while distorting everything else. A cost term was not the answer — the
partner pass was.
