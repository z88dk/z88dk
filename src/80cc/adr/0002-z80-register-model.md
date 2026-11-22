# ADR 0002 — The z80 register reality and the vreg → physical-register model

Status: Accepted

## Context

A textbook register allocator assumes a bank of interchangeable registers and
free graph colouring. The z80 (and its 8-bit relatives) violate every part of
that assumption, and the allocator must respect the machine, not fight it.

The realities:

- **HL is reserved scratch**, not allocatable. Nearly every ALU op, dereference,
  and address calculation needs HL as the working register.
- **Two-address, fixed-register ops.** `add hl,rr` / `sbc hl,rr` require the
  accumulator in HL and the other operand in one of BC/DE/SP; `ex de,hl` is the
  word-move primitive. Operand registers are *constrained*, not freely coloured.
- **Operand staging clobbers registers.** The operand loader stages a binop's
  second operand through **DE** (`add hl,de`), and helper calls clobber A/BC/DE.
  So keeping a value in a register across an op is only sound if that op does
  not clobber the register.
- **The allocatable pool is tiny:** BC, DE, IX, IY, the byte halves
  (C/B/E/D/A and the index halves), and the config-gated alt/shadow bank
  (BC'/DE'/HL'). IX is the frame pointer under `-frameix`; IY under `-frameiy`.
- **CPU variance:** gbz80/8080/8085 have no IX/IY at all; z180 traps the
  undocumented index-half opcodes; kc160/rabbit have cheap native
  `ld rr,(sp+d)`; only some CPUs have hardware multiply.

## Decision

- Model each value as a **`VReg`** with a `Kind`, a `width` (1/2/4/8 bytes), and
  flags; give it a **`PhysReg`** home in `vreg_to_phys[]`: a register
  (`IR_PR_HL/DE/BC/DEHL`, the byte homes `IR_PR_C/B/E/D`, the index homes
  `IR_PR_IX/IY` + halves, the alt bank), a stack transient (`IR_PR_STACK`), or a
  **frame slot** (`IR_PR_SPILL`).
- Treat **HL as un-allocatable scratch** by construction — no vreg is ever homed
  in HL for a region; HL is where the lowerer computes.
- Encode register **effect sets** as a `RegMask` bitset (`IR_R_HL/DE/BC/IX/IY/…`)
  so soundness can be reasoned about uniformly (ADR 0004's `op_clobbers`).
- Make residency decisions **register-CONSTRAINED**: a pointer deref wants HL; an
  `add` operand wants DE or BC; an accumulator that must survive HL+DE-clobbering
  address arithmetic wants IY (the one pair ALU staging never touches).

## Consequences

- The allocator is **not** a classic linear-scan/colouring allocator; it is a set
  of constrained, benefit-ranked *pickers* plus live-range packing (ADR 0003).
- The scarcity is real: after HL (scratch) and the frame pointer (IX or IY),
  there are effectively **two-and-a-bit** allocatable word pairs (BC, the other
  index reg, and DE only when it is not needed for staging). This ceiling is why
  making a value's live range *shorter* (so registers can be reused) generalises
  better than trying to hold *more* values for a whole region.
- Everything is **CPU-gated**: a feature that needs `add iy,de` or a hardware
  multiply is enabled only where the CPU provides it.
