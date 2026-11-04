# ADR 0030 — Under `-debug`, a named local lives in its frame slot

Status: Accepted (implemented; amended for z88dk#3233)

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
  marks named locals as address-taken. That flag alone was not enough: the
  passes listed under *Passes that respect it* below dropped the slot store,
  the local or its width without looking at it.
- **The offset is emitted after lowering**, from the back end's own slot
  placement, not at parse time. Parameters are the exception: their offsets are
  frame-independent, so the front-end value is correct for them, unless the
  prologue copies a register-passed parameter into a slot (see below).

This rests on one local being one vreg: the IR builder maps a symbol to a single
vreg, so `s = a; s = b;` reuse it and a named local is one vreg, one slot, one
debug record. Compiler temporaries have no symbol and are unaffected.

## Passes that respect it

Each is gated on `-debug` (`c_debug_adb_defc`); statics are left alone, since
their storage is the BSS symbol, not a slot (`sym->storage == STKLOC` selects
the named locals and parameters).

- **IR dead-code elimination** (`ir_opt_dce`'s use-count loop) keeps a named
  local's def even when copy propagation has forwarded every reader: that def
  is the slot store. `ir_opt_dead_defs` and the mark-sweep already checked
  `IR_VREG_ADDR_TAKEN`; this loop did not.
- **AST dead-store elimination** (`ast_dse`) is off: it dropped a constant
  initialiser, and with it the local, after constant propagation.
- **The frameless auto-push** (`autopush_frameless`) is off: a function whose
  whole frame was an auto-pushed parameter lost IX, and with it the frame base.
- **The sp-flip re-lowering** (`ir_lower_func_flip`) is off: a flipped
  function maintains `__debug_framepointer`, and once that symbol is linked the
  debugger resolves every frame through it, IX-framed ones included.
- **Narrowing** (`ir_opt_narrow_byte`, `ir_opt_rmw_narrow`) leaves a named
  local at its declared width, which is the width its record states.
  (`ir_opt_narrow_iv` already refuses an address-taken counter.)
- **AST loop reversal** (`ast_loop_reverse`) is off: it replaced a named
  counter with a countdown temporary.
- **A register-passed parameter** (`__sdcccall(1)`) that the prologue copies
  into a slot is recorded at that slot.

**Parameters** get the same treatment: under `-debug` each parameter vreg is
`IR_VREG_VOLATILE` (as an `__sdcccall(1)` one already was), so it lives in, and is
read from, the slot its record names. A reassigned, fastcall, callee-cleanup or
`long` parameter shows its current value at a later breakpoint. This differs from
locals (address-taken, not `volatile`) because a parameter already owns a slot
that no pass can elide: `IR_VREG_PARAM` is pinned in `ir_assign_slots`. A stack
parameter's slot is the caller's argument area, a fastcall one is the prologue's
auto-push, an `__sdcccall(1)` one a prologue copy. What was missing was only that later reads
and writes went through it instead of a register, which `volatile` supplies.

## Consequences

`-debug` deliberately costs code quality: forcing locals to memory defeats
residency, which is the compiler's main optimisation. That is the right trade
for a debug build, and it is why the behaviour is tied to the flag.

With the flag off the compiler is byte-identical, which is what makes the
feature safe to carry.

Verified on z80 (IX frame), 8080 and gbz80: named locals and parameters, including
reassigned and constant-initialised ones, resolve at a breakpoint.
