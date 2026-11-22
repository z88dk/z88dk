# ADR 0047 — DE liveness follows branches, but not calls or returns

Status: **Accepted**, default on. `IR_OFF=de-flow` opts out.

> **Superseded in part by ADR 0084.** The "calls and returns stay conservative"
> half below is no longer the standing position: a `ret` reads DE only where
> the function returns in DE, and a `call` only where the emitter placed an
> argument there. The branch-following rule this ADR decided is unchanged, and
> so is the reason it could not simply ride the BC rules.

## Context

In the park sweep, a branch was a black box that "may read DE". That keeps an
8085 slot-load park alive whose target provably never reads the pair.

## Decision

Follow intra-function branches when deciding DE liveness, exactly as `[bc-flow]`
does for BC — one fixpoint serves both, and DE is computed only when asked for,
so opting out leaves the BC and F answers bit-for-bit unchanged.

## Why DE could not simply ride the BC rules

The difference is recorded in `instr_effects`, and it is an ABI fact, not a
modelling choice:

* a **`ret` reads DE** — the long and float result ABI is DE:HL — where BC is
  dead at exit;
* a **call reads DE** — `__sdcccall(1)` passes arguments there.

So only the *branch* assumption is lifted. Calls and returns stay conservative,
which is exactly what separates this from the wider opportunity sized by
`[IR_DELIVE_PROBE]` — that probe measures what a full DE liveness would reach,
and most of the gap is behind those two ABI readers.
