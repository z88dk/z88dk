# ADR 0041 — A dead store is blocked only by a channel reader

Status: **Accepted**, default on. `IR_OFF=dead-store-share` opts out and
restores the pre-flip codegen byte for byte.

## Context

Dead-store elision was vetoed by *any* reader sharing the byte slot. That is
stronger than necessary: the shape that actually needs the store is a **channel**
— a reader that never writes its own slot, and so depends on someone else having
written it.

## Decision

Block a dead store only when a byte-sharing reader never writes its own slot.

## Consequences

Flipped on after a 391-cell matrix (23 benches × 10 CPUs × sp/fp): **0 cells
slower on any CPU, 0 cells larger on any CPU, net −1200 B**, every cell built and
run in both configurations with no failures.

Bytes and cycles move together here, because eliding a store removes memory
traffic — there was no byte-for-tick trade to weigh.

The r4k byte regression the first matrix showed was **not** this pass. It was the
HL→DE staging copy being spelled as two page-prefixed 8-bit moves on Rabbit,
fixed in `1b43c3a4c7` (see `emit_hl_to_de`). Worth remembering that a matrix can
attribute a regression to whatever is being tested at the time.

## The trap

"Reads a slot it never wrote" is **not** `rec_slotwrite == 0`. A multi-def reader
can have one def that stores and another that rides a register. The first version
shipped that way and miscompiled `emu.c`. The predicate is enforced at the
marking site, and that comment stays in the code.
