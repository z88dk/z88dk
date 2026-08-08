---
name: library-math16
description: >
  math16 half-float library for z88dk: f16/f24 cores, restoring div vs NR inv,
  classic +test recipes need z88dk-classic sources. Use when editing
  libsrc math16 or measuring half-float.
---

# Library — math16

Home under classic/newlib float trees (see `libsrc/math/float/` math16 paths and
`--math16` on `zcc`). Policy mirrors math32:

| Op | Algorithm |
|----|-----------|
| **div** / `asm_f16_div` | **Restoring** |
| **inv** / `asm_f16_inv` | Newton–Raphson |

## Agent rules

1. One major function per file; CPU copies under matching asm CPU dirs.
2. 8085: stack-only; no EXX/IX/IY; legal `(de)` stores only (`a`/`hl`/post-inc).
3. Classic TIMER benches for math16: use **`z88dk-classic/*.c`** (parent sources may lack `_Float16`).
4. 8085 math16 often also needs `-lmath32_8085` for higher helpers — match classic recipes.
5. Suite: `make -C test/suites/math test_math16.bin test_math16_8085.bin` (and peers).

## Related

- `library/math32`, `cpu/8085`, `methodology/measure`
- Product readme: math16 `README.md` under the float tree
