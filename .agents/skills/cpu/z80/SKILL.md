---
name: cpu-z80
description: >
  Z80-family coding notes for z88dk library and app asm: IX/IY, exx, djnz,
  shadow registers, documented vs strict Z80. Use when writing or reviewing
  z80 (not 8085/8080/gbz80) assembly under libsrc or hand asm.
---

# CPU — Z80

Default classic and newlib CPU for most targets.

## Register model agents use

| Feature | Notes |
|---------|--------|
| **IX / IY** | Index registers; newlib sdcc often reserves IY; sccz80 may use both |
| **exx** | Alternate AF′/BC′/DE′/HL′ — common second long for float/math cores |
| **djnz** | B-counted loops |
| **sbc hl,de** etc. | 16-bit subtract with borrow (not on 8085) |
| **block I/O / LDIR** | Available; 8085 must open-code |

## Style in z88dk `libsrc`

- Prefer synthetics when the assembler expands them cleanly (see below).
- Match neighbour file whitespace (spaces in most math cores).
- One major function per file — see `style/libsrc-layout`.
- Hand-written library asm is **not** passed through `z88dk-copt`.

## Synthetic opcodes (z80asm, all CPUs generally)

**z80asm** (normal mode) expands many source forms into short real-op sequences.
One important family is **16-bit register-pair copies**: each is two 8-bit
loads (e.g. `ld de,hl` → `ld d,h` / `ld e,l`).

### Word copies — full set

| Form | Notes |
|------|--------|
| `ld bc,de` / `ld bc,hl` | any of **bc / de / hl** ← any of **bc / de / hl** |
| `ld de,bc` / `ld de,hl` | same |
| `ld hl,bc` / `ld hl,de` | same |

**Not** in this set: **`af`**, **`sp`** (do not write `ld bc,af` / `ld hl,sp` as
a “pair copy synthetic” for this purpose).

Prefer `ld bc,hl` / `ld hl,bc` (or other pair) to **park and restore** a word
instead of multi-instruction swap sequences when only one pair must move.

Other synthetics exist (e.g. `ld a,(hl+)`). **Strict** mode forbids free
synthetics — see **`tool-z80asm`** and `src/z80asm/dev/cpu/cpu_test_z80_*`.

## Contrast with 8085

Do **not** use `exx`, IX/IY, `djnz`, or Z80 prefix encodings in `asm/8085/` trees.
See `cpu/8085` for stack-only second longs and extended ops.

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

- Assembler: `tool/z80asm`
- Measure: `methodology/measure`, `tool/ticks`
