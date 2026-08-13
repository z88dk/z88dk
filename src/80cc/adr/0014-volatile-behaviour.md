# ADR 0014 — Volatile behaviour

Status: Accepted

## Context

`volatile` is a correctness contract, not an optimisation hint: every access to a
volatile object must actually be performed, in program order, and must never be
fused with, reordered against, or eliminated by another access. On an 8-bit
target the classic uses are memory-mapped I/O through a `volatile T *`, and
`volatile` automatics that must survive `setjmp`/`longjmp`.

The difficulty is that 80cc optimises a value at **three** layers, each of which
could silently break volatile if left unguarded:

1. **AST** — constant/copy propagation, CSE, dead-store elimination (ADR 0010).
2. **IR** — `ir_match` fusion (e.g. store-then-load, `*p++` folds) and `ir_opt`
   (CSE, load forwarding).
3. **copt** — the external, text-level peephole pass that runs on the emitted
   assembly (see ADR 0013). copt cannot see IR types or flags at all.

A volatile access can be broken at *any* of these, so each layer needs its own
guard. There is no single choke point.

## Decision

Volatile is honoured with one mechanism per layer, keyed off the source type
qualifier (`type->isvolatile`):

- **AST layer.** `ast_opt` already tests `isvolatile` and declines to CSE,
  copy-propagate, or dead-store-eliminate across a volatile access.

- **Volatile locals → forced to memory.** A `volatile`-qualified local sets
  `IR_VREG_VOLATILE` on its vreg (from `sym->ctype->isvolatile` in ir_build).
  A VOLATILE vreg is never register-homed by the allocator, so every read and
  write is a real slot load/store.

- **Volatile-pointee derefs → `mem.volatile_`.** For `*(volatile T *)` accesses
  (the MMIO case) ir_build sets `op->mem.volatile_` on the `LD_MEM`/`ST_MEM`
  (helper `deref_is_volatile`, which walks the deref node's type and pointee like
  `deref_bank_fn`). `ir_match`/`ir_opt` read this flag and refuse to fuse or
  eliminate the access. (The flag predated its producer — the guards existed but
  were inert because ir_build never set it; wiring `deref_is_volatile` activated
  them.)

- **copt → `;volatile` stamp.** Because copt matches whole lines (ADR 0013) and
  is blind to IR flags, the lowerer appends a trailing `;volatile` comment to
  every emitted volatile memory instruction (both `IR_VREG_VOLATILE` slot
  accesses and `mem.volatile_` derefs). A stamped line never matches a
  store-then-reload — or any — peephole, so a mandatory volatile load/store is
  never elided. Non-volatile accesses stay comment-free and fully optimisable.

**Volatile automatics may still be folded when it is observationally safe.**
A never-address-taken `volatile` automatic with no intervening statement or call
(`volatile int c = 5; return c;`) may be constant-folded away: nothing can
observe the elided accesses in a conforming program, and every situation in which
a volatile automatic genuinely matters — its address escaping, aliasing, or a
`setjmp`/`longjmp` barrier — independently blocks the fold. This is deliberate,
not a defect.

## Consequences

- **Every new fusion, peephole, or residency path must honour volatile at its
  layer**: check `IR_VREG_VOLATILE` / `op->mem.volatile_` before fusing or
  register-homing, and preserve the `;volatile` stamp (never emit a mem access
  that copt could pair with a stamped one such that the stamp stops mattering).
  The store-then-reload copt rules (#269 and the `#R*` family, ADR 0013) depend
  entirely on the stamp for their volatile safety.
- `deref_is_volatile` errs toward over-marking (it treats pointer-to-volatile as
  volatile); over-marking only suppresses an optimisation, never miscompiles.
- Coverage of `mem.volatile_` is currently the common scalar deref sites (plain
  load/store, compound RMW, address-yielding store). Rarer sites (bitfield,
  float/fixed compound, wide values) are not yet marked; those are safe to
  optimise today only because their shapes don't reach the volatile-eliding
  peepholes, and marking them is future hardening rather than a live bug.
- The stamp is a copt-visibility device only; it has no effect on the assembler
  or the emitted binary.

See ADR 0013 (peephole/text-optimisation layer, `;volatile` and whole-line
matching), ADR 0010 (AST vs IR optimisation), and ADR 0004 (soundness/gating).
