---
name: cpu-8080
description: >
  Intel 8080 coding for z88dk classic: no 8085 extended ops, no Z80 IX/IY/exx.
  Use when writing 8080 library runtime or +cpm -clib=8080 style products.
---

# CPU — 8080

Subset of 8085 without the ten extended opcodes. Classic products use
`libsrc/l/sccz80/8-8080/` and `8080_crt0.lib`.

## Rules

1. **Zilog mnemonics** everywhere (z88dk house style).
2. **No** `sub hl,bc`, `ld de,sp+*`, `ld hl,(de)`, `ld (de),hl`, `rl de`, `sra hl`, `jp k/nk`, `rst v`.
3. **No** Z80 `exx`, IX/IY, `djnz`.
4. SP-relative work: `ld hl,nn` / `add hl,sp` (watch flag clobber of `add hl,sp`).
5. Stack-only locals still preferred for reentrancy.

## Assembler capability (last resort)

Fixtures: `src/z80asm/dev/cpu/cpu_test_8080_{ok,err}.asm` and `*_strict_*`.

| File | Meaning |
|------|---------|
| `*_ok.asm` | Assembles successfully; `;` comment = encoding |
| `*_err.asm` | Must fail (`; Error`) |
| `*_strict_*` | **Strict mode: synthetics forbidden** |

z80asm may accept **Intel** mnemonics on 8080 for **external-code compatibility** (fixtures list them). **Do not write Intel in the z88dk tree** — emit Zilog only; translate imports.

**ok** may still be a synthetic (normal mode) or `__z80asm__` helper — not always one native opcode. **`_strict_`** forbids synthetics. Full decode: **`tool-z80asm`**. `rg` only.

## Related

- Contrast extended ops: `cpu/8085`
- Runtime tree: `libsrc/l/sccz80/8-8080/`
