# ADR 0029 — The fail-safe DE cache fold

Status: Proposed (staged behind `IR_RANGED`)

Relates to ADR 0018, which **rejects** the DE *home* for the same class of
value, and to ADR 0016 (the belief cache).

## Context

A reused dereference or binop result that the allocator leaves in a frame slot
is re-materialised in HL at each use and spilled again around the next
HL-clobber. sdcc keeps such a value in DE, where a later compare folds to
`sbc hl,de`.

ADR 0018 records that giving this class a DE *home* does not pay: the
evacuation traffic around the home exceeds the reloads it removes, and the
cross-basic-block carry wins nothing because HL already carries the value.

## Decision

Keep the value spilled, and leave a **DE cache** at its definition, so a later
read within range prefers DE instead of re-materialising in HL and spilling
again.

The distinction from ADR 0018 is the whole design:

| | DE home (rejected) | DE cache fold (this) |
|---|---|---|
| Allocation | value is homed in DE | value stays `SPILL` |
| Obligation | the home must be preserved | none — it is a belief, not a promise |
| If DE is clobbered | evacuate and restore | drop the belief, reload from the slot |
| Failure mode | costs bytes everywhere | costs nothing; the fold just does not fire |

It is fail-safe because it promises nothing. The slot remains the value's home,
so no code has to preserve DE for it; the cache is an opportunity taken when DE
happens to be free, in exactly the way the lowerer already caches HL and A.

## Why it is not yet accepted

Its value is unproven. The fold only pays where DE is genuinely idle across the
gap between definition and use, and the population of such values has never been
measured on real files — the corpus does not contain the shape in quantity. It
needs a measurement on a real char- and pointer-heavy file before promotion.

The risk is not correctness but **clutter**: an opportunistic fold that fires
rarely is a permanent complication to the belief cache for little return. If a
measurement shows a thin population, refuse it and record that here, as 0018
records its sibling.
