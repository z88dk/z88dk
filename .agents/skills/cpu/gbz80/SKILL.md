---
name: cpu-gbz80
description: >
  Game Boy Z80 (gbz80) notes for z88dk classic Game Boy target. Use when
  editing gbz80 runtime or +gb code paths.
---

# CPU — gbz80

Game Boy CPU: Z80-like with important omissions and differences. Classic path
`libsrc/l/sccz80/8-gbz80/`, product `gbz80_crt0.lib`, target `+gb`.

## Agent rules

1. Match existing gbz80 sources; do not paste Z80 or 8085 cores blindly.
2. No 8085 extended encodings.
3. Verify with suite/ticks using the matching CPU model when available.
4. One major function per file under `libsrc`.

## Synthetic opcodes (z80asm)

**Word-copy** synthetics (normal mode): **`ld dst,src`** among **`bc` / `de` /
`hl`** (any → any). Each is two 8-bit loads. Prefer for parking a pair
(`ld bc,hl` / `ld hl,bc`) over multi-insn swaps. **Not** **`af`** / **`sp`**.

Still respect gbz80 ISA limits for everything else. Strict mode forbids free
synthetics — **`tool-z80asm`**.

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

- Target notes: wiki `platforms/` Gameboy page; config `lib/config/gb.cfg`
