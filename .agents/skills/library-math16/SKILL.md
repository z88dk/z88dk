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
5. Suite: `make -C test/suites/math test_math16.bin test_math16_8085.bin` (and peers). Newlib: `+rc2014 -clib=new` with `-lmath16 -lmath32` (mirror math32 rc2014 recipe).
6. Higher funcs layout: `c/z80/` (sccz80 +new) and `c/8085/`. **`c/Makefile` clean:** only remove C-derived `z80/*.asm` and `8085/*.asm` (`$(AFILES8085)`); keep hand-written `cm16_sccz80_*.asm` in `c/8085/`.

### Calling vs math32

Many half API symbols are plain `defc sinf16 = _m16_sinf` (true DEHL) even with
`-D__CLASSIC` — **not** the math32 stack-bridge trap. Still prefer map proof
(`sinf16` / `sqrtf16` / `invsqrtf16`) after link. Fair n-body: math16 may keep
`invsqrtf16`; math32 TIMER source should use `1.0/sqrt` on both classic and newlib.

## Related

- `library-math32`, `cpu-8085`, `methodology-measure`, `library-newlib` (header regen)
- Product readme: math16 `README.md` under the float tree
