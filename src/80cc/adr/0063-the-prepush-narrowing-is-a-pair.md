# ADR 0063 — The pre-push narrowing is a pair, and must not be separated

Status: **Accepted**, default on. `IR_OFF=prepush-narrow` opts out, and takes
`IR_CS_EVICT` with it (see ADR 0061).

## Decision

Narrow the whole-function pre-pushed-call veto to the calls that can really lose
BC (`prepush_bc_hazard`), instead of vetoing the whole function.

## It is a PAIR with `bc-save-live` — do not separate them

Alone, the narrowing **regresses `divbench` and `shiftbench` badly**: it admits
BC homes into functions with pre-pushed calls, which adds `push bc` / `pop bc`
pairs around those calls. `bc-save-live` removes the pairs whose tenant is not
live there, and together the regressions go to **exactly zero**.

Flipping this one on its own reinstates them. That is the single most important
fact about this gate, and the reason it is recorded here rather than left to be
rediscovered by someone bisecting a regression.

## Refuted en route

Pricing a BC home for the `push`/`pop` pair it pays at each spanned pre-pushed
call. At the natural weight `divbench` does not move; at 20x it recovers part of
the loss while distorting everything else. A cost term was not the answer — the
partner pass was.
