# ADR 0059 — Revisit a yielded index home

Status: **Accepted**, default on. `--opt-disable=idx2-revisit` opts out.

## Context

A pointer parameter that is admissible in the spare index register will **yield**
it to a loop counter, on the reasoning that the counter wants it more.

But the counter is normally also a BC candidate, and the BC arm runs first and
places it there — after which the counter's own IDX2 candidate is skipped as
already-placed. The yield has then bought nothing: the index register is sitting
**empty** and the parameter is in a slot.

## Decision

After placement, if the deferred parameter is still unplaced and the index
register is still genuinely free, give it the register.

Both conditions are load-bearing: the yield is preserved whenever the counter
**did** collect the index, and the revisit only fires in the case where the
yield was wasted.

## Evidence

`recordbench/churn` on kc160: the struct pointer was the **top IDX2 candidate**
(benefit 288) and ended up **spilled**, costing **−67 B and −24.6 % ticks**
against simply letting it have the register.

## Note

This is a second instance of the pattern ADR 0058 records — a sequenced
allocator making a decision that a later step invalidates, with nothing looking
back. The fix in both cases is a narrow, explicitly-conditioned second pass
rather than a change to the pricing.

It was also the case that exposed a latent arbiter bug when the index home
became an addressing mode: inert on its own, visible only once index homes
started paying.
