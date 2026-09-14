# ADR 0021 — Per-value spill heuristics

Status: Rejected (2026-09)

Relates to ADR 0003 (register residency) and ADR 0011 (index-register
allocation).

## Context

When an index register is oversubscribed the allocator must choose which value
loses it. The tempting fix, each time a benchmark regresses, is a rule about the
*kind* of value: "never reject a stepped counter", "prefer a dereference base",
"a loop-carried word wins".

## Decision

Do not add per-value placement heuristics. They have been refuted twice, and
the second refutation identifies why they cannot work.

Two benchmarks on the same CPU contain counters that are identical by every
per-value property — both stepped, both loop-carried, both the same width — and
their optimal placements are **opposite**. Rejecting the index home wins one and
loses the other. A rule keyed on the value therefore cannot separate them,
because the discriminating fact is not a property of the value at all: it is the
whole-function consequence of who *else* then gets the register.

The decision is interference and pressure, not value kind. A correct version
compares the cost of {v in the index home} against {v in a slot, plus whatever
value then takes the index home} — that is, it prices the displaced claim. That
is the opportunity-cost term the cost ledger is meant to supply, not a rule.

A related refutation sits in the same family: a blunt "DE-home this word" rule
was built and reverted twice. Its failure case is a loop temporary that is live
across a dereference and its compares, where three push/pop pairs around the
home cost more than the reloads the home avoids.

## Reopening

Not as a heuristic. The replacement is the realised-cost ledger: score each
`(vreg, home, window)` claim including the value of the claim it displaces. If
that ledger picks the right answer on both of the contradictory counters above,
it has succeeded where the heuristics failed — that pair is the discriminating
test, and any proposal should be run against it first.
