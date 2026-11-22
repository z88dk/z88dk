# ADR 0048 — The 8085 DE park is decided on the rendered text

Status: **Accepted**, default on. `--opt-disable=de-park` reverts to always
parking, byte for byte.

## Context

`load_slot_to_hl` reads a frame word with LDSI+LHLX, which needs the slot address
in DE — but `load_to_hl` must hand DE back untouched, so it parks it:

```
push de / ld de,sp+N+2 / ld hl,(de) / pop de      5 B / 42 c
```

Unparked that is `ld de,sp+N / ld hl,(de)` — **3 B / 20 c**.

## Why the residency cache could not answer it

Whether the park is needed is a question about the **future**: is the old DE read
before it is overwritten? Every attempt to answer it from the residency cache
failed, for three separate reasons:

* the cache is a record of the **past**, not the future;
* it tracks **whole pairs**, so a byte staged in E is invisible to it;
* the producing idiom does not distinguish the two cases — measured on the
  corpus, `ld de,sp+N` and `pop de` each precede roughly as many needed parks as
  dead ones, because the nearest preceding DE write is usually the *previous*
  park's own code.

That last point is the interesting one: the signal a local test would key on is
manufactured by the very transformation being decided.

## Decision

Decide it on the rendered function, in the same backward liveness sweep that
drops dead `ld bc,hl` parks. That sweep already has the two properties this
needs: **sub-register tracking** (a park protecting only E must survive) and
**straight-line-only proof** (a branch or call means live).

The BC rules do not transfer wholesale: `ret` is a boundary for BC but **reads
DE**, since the long result ABI is DE:HL. See also ADR 0047.

## Consequences

`IR_DEPARK_SWEEP=1` runs a forward-walk cross-check and reports the counts; `=3`
dumps the instruction window at any disagreement. That cross-check is the reason
to trust a sweep whose proof obligation is this easy to get subtly wrong.
