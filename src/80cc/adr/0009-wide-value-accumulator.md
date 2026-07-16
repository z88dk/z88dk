# ADR 0009 — Wide (6/8-byte) value handling via a memory accumulator

Status: Accepted

## Context

The register file tops out at pairs (16 bits) and, with `DEHL`, 32 bits
(ADR 0002). But C on these targets also has `long long` (8 bytes) and `double` /
`long double` (6-byte MBF here). There is no register home wide enough, and
building one out of the alt bank + main bank would consume the entire machine.

## Decision

Wide (>4-byte) values live **in memory** and are computed through a **universal
memory accumulator + runtime helpers**, not registers:

- **`__i64_acc`** — the universal 64-bit integer accumulator; `l_i64_*` helpers
  operate on it.
- **FA** — the float accumulator; the float helpers operate on it.

Dedicated IR ops carry these instead of the register-oriented ALU ops:

- **`IR_ACC_BINOP`** — a wide binary op: two wide operands staged into the
  accumulator via `acc_prim(f, v, "load"/"push"/"loadpush")` (which selects the
  i64 vs FA primitive for the value's kind), then the `l_i64_*`/float helper.
- **`IR_ACC_CMP`** — a wide compare (same operand staging, flag result).
- **`IR_ACC_UNOP`** — a wide unary op; `AccSubkind` selects how the accumulator
  is wired.

Calls follow suit: a wide argument is loaded into the accumulator (`__i64_acc` or
FA) and the callee binds it there; a `long long` return pushes a hidden pointer
to `&__i64_acc` as the result buffer and reads it back into the dst's slot
(`CallInfo.ret_longlong`).

## Consequences

- In `op_clobbers` (ADR 0004), `IR_ACC_BINOP/CMP/UNOP` are modelled as
  **`IR_R_ALL`** — they are opaque wide-helper calls that may touch the whole
  register set, so no register residency survives across them.
- Wide values are **never candidates for the residency machinery** (BC/DE/IY
  homes, packing) — they are memory-resident by design. Residency reasons about
  width ≤ 2 (and DEHL width-4) only.
- Presence of any width-4 vreg already bars IVSR's BC envelope (ADR 0008); wide
  (6/8) values likewise sit outside the register-allocation model entirely. This
  keeps the register allocator's world small and the wide arithmetic correct via
  the audited helper library.
