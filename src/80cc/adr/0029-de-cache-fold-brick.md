# ADR 0029 — The fail-safe DE cache fold

Status: Proposed, **in flight** — the conservative form of stage 3 of ADR 0017's
ranging arc (park in the slot when the range is interrupted), staged behind
`IR_RANGED`.

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

## The EXPENSIVE form of stage 3 is refused (2026-09-15)

This ADR is the *fail-safe* form — a belief, no promise, no park. The obvious
alternative is the expensive one: when a candidate is blocked by a live tenant,
**park the tenant to its slot over the window and resume after**. That is what
would free the 83 BC-pack candidates ADR 0017 found blocked by live tenants.

Measured, it does not pay. Of 145 blocked candidates across the corpus in both
frame modes, **74 have a tenant that is completely idle inside the window** —
the best possible shape, where the park costs only a store and a reload. Pricing
that park against the candidate's `interval_benefit_x`:

**7 of 145 sites pay (5 %)**, and only **6 of the 74** idle-tenant cases.

A park is a slot store plus a slot reload — ~86 cycles on z80-sp — and it runs
every time the window runs, so it is weighted by loop depth exactly as the gain
is. That cost simply exceeds what a born-killed temp gains from BC.

**So the expensive form is refused**, and this ADR's fail-safe form is the only
live version of stage 3. It has no park cost at all — which, given the above, is
the entire reason it might work where the other cannot. Its own measurement
(a real char- and pointer-heavy file) is still owed.

### The unit trap, recorded because it inverted the answer

The first version of this measurement priced the park with `g0_word_bytes` and
the gain with `interval_benefit_x`. Those are **different denominations** —
`interval_benefit_x` is cycle-based (`g0_word_cost`: a z80-sp slot read is 45
cycles against BC's 8) while `g0_word_bytes` is bytes. Comparing them reported
**145 of 145 sites paying, by 3-7x**. In the same units it is 7 of 145.

A 100 % result is not a discovery, it is a symptom. Check the units.
