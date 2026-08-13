---
name: cpu-z180
description: >
  Z180 notes for z88dk: mlt multiply, math32_z180, ticks -mz180, ASCI/IO
  context for yaz180/scz180 targets. Use when writing or measuring Z180 code.
---

# CPU — Z180

Z80-compatible with extras (e.g. **`mlt`**). Used by `+z180`, `+yaz180`, `+scz180`, and related products.

## Agent facts

| Topic | Detail |
|-------|--------|
| ticks | `z88dk-ticks -mz180` |
| HW mul | `mlt` helps mul/inv-heavy float; restoring div loop does not |
| math32 | `math32_z180.lib` via multi-CPU layout under `libsrc/math/float/math32/` |
| Targets | See `target/z180`, `target/yaz180`, `target/scz180` |

## Synthetic opcodes (z80asm)

Same **word-copy** set as Z80 (normal mode): any of **`bc` / `de` / `hl`** ← any
of those pairs (`ld de,hl`, `ld bc,hl`, `ld hl,bc`, …) = two 8-bit loads.
Prefer to park/restore a pair instead of swap chains. **Not** **`af`** / **`sp`**.

Strict forbids free synthetics — **`tool-z80asm`**.

## Assembler capability (last resort)

Fixtures under `src/z80asm/dev/cpu/` answer: does **z80asm** accept this **source line** for this CPU, and what encoding does it emit?

| File | Meaning |
|------|---------|
| `cpu_test_<cpu>_ok.asm` | Assembles successfully; comment after `;` is expected encoding |
| `cpu_test_<cpu>_err.asm` | Must fail (`; Error`) |
| `*_strict_*` | **Strict mode: synthetics forbidden** (real ops / accepted aliases only) |

**ok is not always one native chip opcode** (normal mode may allow synthetics or `CD @__z80asm__…` helpers).

**8080/8085 only:** z80asm may accept **Intel** spellings for **external-code compatibility** (see fixtures). **z88dk writes Zilog only** everywhere.

How to read lines, map `-m` → filename, and `rg` without loading huge files: skill **`tool-z80asm`**.

## Related

- `library/math32`, `tool/ticks`
