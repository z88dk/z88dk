---
name: cpu-z180
description: >
  Z180 notes for z88dk: mlt multiply, math32_z180, eZ80 Z80-mode mlt share,
  ticks -mz180 / -mez80_z80, ASCI/IO context for yaz180/scz180 targets. Use when
  writing or measuring Z180 or eZ80-Z80-mode float/mul code.
---

# CPU — Z180

Z80-compatible with extras (e.g. **`mlt`**). Used by `+z180`, `+yaz180`, `+scz180`, and related products.

## Agent facts

| Topic | Detail |
|-------|--------|
| ticks | `z88dk-ticks -mz180` (eZ80 Z80-mode: `-mez80_z80`) |
| HW mul | `mlt bc/de/hl/sp` = `ED 4C/5C/6C/7C` — same encodings on **eZ80 Z80-mode**. Helps mul/inv-heavy float; restoring div does not use it |
| math32 | `math32_z180.lib`; eZ80 Z80-mode product is **`math32_ez80_z80.lib`** (`newlibfiles_ez80_z80.lst` → same Z180 `mlt` helpers) |
| CPU define | `-mz180` → `__CPU_Z180__`. `-mez80_z80` → **`__CPU_EZ80_Z80__`** (not `__CPU_EZ80__`; that is ADL `-mez80`) |
| Targets | See `target/z180`, `target/yaz180`, `target/scz180`; classic `+test -clib=ez80_z80` for eZ80 Z80-mode |

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

- `library-math32`, `tool-ticks`
