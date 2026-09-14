# ADR 0030 — Under `-debug`, a named local lives in its frame slot

Status: Accepted (implemented)

Relates to ADR 0003 (register residency) and ADR 0007 (the vreg model).

## Context

A debugger can only show a local if the value is somewhere it can name. Two
independent things stopped that working.

**The value is not in the slot.** 80cc lowers register-first: a local that fits
in a register is never written to memory, even with every optimisation
disabled. The value flows from one expression into the next and is never stored,
so a debug record pointing at a frame slot points at nothing.

**The offset is a guess.** Debug symbol records were written at *parse* time,
carrying the front end's nominal frame offset — computed before the IR back end
lays the frame out. It does not match the slot the back end actually chose.

## Decision

Under `-debug`, force every named local to a coherent frame slot, and emit its
offset from the back end's real layout.

Two specifics matter, and both are deviations from how it was first sketched:

- **The mechanism is the address-taken flag**, not `volatile` and not a new
  flag. 80cc legitimately elides a local that never escapes — *including a
  volatile one*, which keeps its value in a register with no store. Only
  "escaped" forces a slot that survives every pass coherently, so `-debug`
  marks named locals as address-taken. Nothing else in the pipeline needed to
  change to respect it.
- **The offset is emitted after lowering**, from the back end's own slot
  placement, not at parse time. Parameters are the exception: their offsets are
  frame-independent, so the front-end value is correct for them.

This rests on one local being one vreg: the IR builder maps a symbol to a single
vreg, so `s = a; s = b;` reuse it and a named local is one vreg, one slot, one
debug record. Compiler temporaries have no symbol and are unaffected.

## Consequences

`-debug` deliberately costs code quality: forcing locals to memory defeats
residency, which is the compiler's main optimisation. That is the right trade
for a debug build, and it is why the behaviour is tied to the flag.

With the flag off the compiler is byte-identical, which is what makes the
feature safe to carry.

Verified on z80 (IX frame), 8080 and gbz80: locals, parameters and reassigned
values all resolve at a breakpoint.
