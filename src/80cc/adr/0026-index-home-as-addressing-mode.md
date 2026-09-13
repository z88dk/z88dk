# ADR 0026 — The index home is an addressing mode, not only a value carrier

Status: Accepted (2026-09-13)

Amends ADR 0011 (index-register allocation) and relates to ADR 0003 (residency).

## Context

An index home (IX or IY) had always been treated as a place to *keep* a value.
Reading it emitted `push iy; pop hl`, so a pointer living in an index register
still had to travel to HL before it could be dereferenced. The consequence was
visible in the emitted code: the corpus contained **zero** `(iy+d)` accesses
where sdcc's contained 47. The one addressing mode the Z80 offers over a
register pair was never used.

## Decision

When the base of a memory access is homed in IX or IY and the field offset fits
the displacement byte, read or write the field **in place** as `(ix+d)` /
`(iy+d)`.

This has two halves and neither pays without the other:

- the **lowering** rung, which emits the displaced access; and
- the **offset folding** that puts a field offset into the access itself rather
  than into a separate address temporary, so there is a displacement to use.

It also has a matching **cost term** in allocation. A value homed in an index
register pays at every read, because the index registers have no ALU; a pointer
homed there now pays nothing at all. The term describes this lowering and lives
and dies with it: switching the rung off restores the old allocation as well as
the old codegen, so the opt-out is byte-identical.

Only IX and IY qualify. The KR580VM1's second index is the prefixed shadow pair,
which has no displaced form — so the test is on the physical register, not on
its printed name, which would spell it as a plain pair. 8080-family CPUs and
gbz80 have no index home at all.

The exclusions mirror the existing frame rung: a post-stepping access reads the
base itself, a banked access recovers its namespace through the base, and a word
access needs the displacement **and** displacement+1 in range.

## Consequences

The cost term matters more than the lowering: separating them with a knob showed
most of the gain came from allocation choosing differently once index homes were
priced correctly, not from the emitted access alone.

Index homes require call-free functions, so real files benefit less than the
corpus does. The feature also exposed a latent arbitration defect, inert on its
own, where a parameter that yields the index register to a counter was never
revisited.

Opt out with `--opt-disable=idx-deref` or `IR_OFF=idx-deref`.
