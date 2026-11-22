# ADR 0011 — Index-register (IX/IY) allocation and reservation

Status: Accepted

## Context

The z80 family has exactly two index registers, IX and IY. They are precious:
they enable `(ix+d)`/`(iy+d)` addressing and are the only spare 16-bit homes once
BC/DE are committed to loop pointers/IVs (ADR 0002), but each `(ix+d)` access is
slow (2 opcodes / ~19T) and IX/IY are **callee-saved**, so using one costs a
prologue/epilogue push-pop. The back end has two competing consumers for them:

- a **frame pointer** (fp-mode, `-fframe-pointer`), addressing locals via `ix+d`;
- **residency**: `idx2` (a loop-invariant base, ADR 0003) and the **LRA reduction
  accumulator** (IY reduction-chain home, ADR 0003 / LIVERANGE_ALLOC_PLAN).

The choice of frame mode changes which index register is free for residency, and
some platforms reserve an index register for their own use (interrupt state,
runtime). We need one coherent model for who gets IX and who gets IY.

## Decision

Roles are assigned by frame mode:

|                             | IX                         | IY                        |
|-----------------------------|----------------------------|---------------------------|
| **sp-mode** (default)       | idx2 — loop-invariant base | LRA reduction accumulator |
| **fp-mode** (`-fframe-pointer`) | frame pointer          | LRA reduction accumulator |

Consequences of the layout:

1. **The LRA accumulator is always IY**, in both modes — which is why the
   accumulate primitive is standardised on `add iy,de` rather than `add ix,de`
   (IX is the one already spoken for in fp-mode).
2. **sp-mode is the sweet spot**: both index registers are productive at once —
   IX parks the invariant base, IY carries the reduction accumulator. fp-mode
   spends IX on the frame, leaving only IY for residency, so the LRA wins are
   smaller in fp than sp.
3. `-frameiy` (IY-as-frame) was **removed**: a target that must reserve IX
   assembles with `z80asm -IXIY` (which swaps the two throughout), so a second
   frame-register mode buys nothing.

**Reservation.** A platform removes an index register from play with:

- `--reserve-regs-iy` → IY is never used for residency (LRA, idx3, the fp-mode
  idx2, and byte-half homes of IYL/IYH).
- `--reserve-regs-ix` (sp-mode) → IX is not used as the idx2 spare. (In fp-mode
  IX is unconditionally the frame pointer, so this flag only affects sp-mode.)

With the default residency set (idx3 and, historically, LRA gated), **sp-mode
plus `--reserve-regs-ix` uses no index register at all** — the escape hatch for a
platform that needs both IX and IY untouched (combine with `--reserve-regs-iy`
once other IY features are on).

**Naming.** The user-facing controls are the frame mode and `--reserve-regs-*`
("what may the compiler touch"). The residency strategy knobs are internal tuning:
`--reg-index-invariant` (idx2; the *spare* index reg — IX in sp, IY in fp) stays
on by default; `--reg-iy-half` (idx3; a second word in IY via **undocumented**
index-half opcodes, z80/z80n only) and `--exx` stay off — experimental, with a
history of callee-saved miscompiles.

## Consequences

- Every site that decides to use IX or IY consults the mode (`c_framepointer_is_ix`)
  and the reserve flags (`c_reserve_ix`/`c_reserve_iy`): `ir_idx2_reg`,
  `ir_idx3_reg`, `lra_iy_available`, and the byte-half candidate offering in the
  lowerer. Adding a new index-register consumer means gating it the same way.
- Because the LRA accumulator and the frame never both want IX, there is no
  arbitration between them; the only intra-mode contention is idx2-vs-LRA for IY
  in fp-mode, resolved by benefit ranking (ADR 0003).
- The reserve flags are off by default and, when off, are **byte-identical** to
  the prior compiler (ADR 0004).
