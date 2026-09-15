# ADR 0065 — The deref-offset term is what tells an index home from a GP pair

Status: **Accepted**. Part of the cost model.

## Context

A deref at a nonzero constant field offset does not cost the same in every home
— but until the `idx-deref` lowering rung existed it did not matter, because
nothing could reach a field at a displacement and every class paid the walk, so
the difference cancelled.

Now IX/IY spell the displacement inside the instruction (`ld a,(iy+3)` is the
same 3 bytes and 19 T as `ld a,(iy+0)`) and every other class still has to walk:

| home | cost of reaching a field at offset K |
|---|---|
| IX/IY | **free**, at any offset inside the displacement byte |
| BC/DE | copy the pointer into HL first (`ld l,c; ld h,b`) — `ld a,(bc)` has no displaced form — then step |
| SLOT | the read already left the address in HL; step only |

The walk is `emit_hl_add_offset`'s: `inc hl` per unit up to 3, and
`ld de,K; add hl,de` beyond — 4 bytes however large K is. Both arms are priced
off the existing rows, so a new CPU inherits them.

## Why the term is necessary

Without it the model rates a BC home and an index home **alike** for a struct
pointer read at four different field offsets. BC ranks first, takes the pointer,
and the index home falls to a scalar that must be pushed and popped at every
read — the exact inversion `bitfieldbench/reg_set` showed
(`ALLOCMAP v1 phys=IX` being the *value*, `v0` the *pointer*, in BC).

**The asymmetry is the whole point**: an index register cannot feed the ALU, so
a value homed there pays at every read, while a pointer homed there pays nothing
at all. See ADR 0058, which fixes the same inversion from the search side.
