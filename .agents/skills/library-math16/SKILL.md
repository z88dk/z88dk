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

In **C higher functions** (`c/*.c`):

| Need | Write | Do not write |
|------|--------|----------------|
| Reciprocal `1/n` | `1.0/x` (restoring `div`) | `invf16(x)` |
| Inverse square root | `invsqrtf16(x)` | `1.0/sqrtf16(x)` |
| Square `x*x` | `sqrf16(x)` (fastcall, always +) | `mulf16(x,x)` / a `sqrf16` macro |
| IEEE bits | `union float16_int` from `c/math16.h` | a local `uint16_t` union |

`pow(x, -0.5)` keeps `invsqrtf16`. Packed-half hi byte after abs: `|x|>=128` iff `m16_ieee_hi >= 0x58`. Do not fmod for `|x|<128`.

## Agent rules

1. One major function per file; CPU copies under matching asm CPU dirs.
2. 8085: stack-only; no EXX/IX/IY; legal `(de)` stores only (`a`/`hl`/post-inc).
3. Classic TIMER benches for math16: use **`z88dk-classic/*.c`** (parent sources may lack `_Float16`).
4. 8085 math16 often also needs `-lmath32_8085` for higher helpers — match classic recipes.
5. Suite: `make -C test/suites/math test_math16.bin test_math16_z180.bin test_math16_ez80_z80.bin test_math16_z80n.bin test_math16_r2ka.bin test_math16_r4k.bin test_math16_r6k.bin test_math16_kc160.bin test_math16_8085.bin test_math16_8080.bin test_math16_gbz80.bin`. Newlib: `+rc2014 -clib=new` with `-lmath16 -lmath32` (mirror math32 rc2014 recipe).
6. Higher funcs layout: `c/z80/` (sccz80 +new), `c/8085/`, `c/8080/`, `c/gbz80/`. **`c/Makefile` clean:** only remove C-derived `*.asm` in those dirs (`$(AFILES8085)` / `$(AFILES8080)` / `$(AFILESGBZ80)`); keep hand-written `cm16_sccz80_*.asm`.
7. Cores: `asm/{z80,8085,8080,gbz80}/`. Packed `*` / `sqrf16` = 11×11 (`asm_f16_mul_callee` / `asm_f16_sqr`). Poly, inv, sqrt NR, hypot, fma = f24 16×16 (`asm_f24_mul_f24`).
8. Unrolled 11×11 / 16×16 mulu is **`IF __CPU_Z80__` only**. z80n / z180 / ez80 / kc160 / rabbit call **`l_mulu_32_16x16`** (HW integer). Do not assemble the unrolled body into those products.
9. `--math16` is **adjunct** (no conflict with math32/math48). Classic: `math16.lib` + `math16_{8085,8080,gbz80,…}.lib`. Newlib sccz80 **bakes math16 into `lib/clibs/sccz80/z80.lib`**. After core edits: delete `*math16*` `.o` under `libsrc/newlib/target/{math16,z80}/obj`, then `make -C libsrc/newlib math16 z80`. Prove `cm16_sccz80_mul_callee` is `G =` onto `asm_f16_mul_callee` (stale is `G A` at a later line).
10. Classic 8085/8080/gbz80 Makefile targets have **no OBJECTS deps**. `rm` `obj/<cpu>/…/asm_f16_*.o` and `libsrc/math16*.lib`, then `make -C libsrc math16.lib` and `cp` into `lib/clibs/`.
11. Specials stay off the finite path. Classify Inf/NaN on overflow / zero / equal-exp 255 (packed exp 31) only. `inc r` / `jp Z` tests exp==255 (8-bit inc sets Z, not C). Pack underflow is unsigned `jp C` after `sub 112` (not `jp M`: d=255 → 143 looks minus). Packed Inf × tiny finite (sum−15 < 31) may not be Inf.
12. gbz80: no cheap `ex (sp),hl` (148c helper). Open-code: park DE, `ld hl,sp+n`, swap through `(hl)`, restore DE; **BC is often the return**. No `jp P` / `ret m` (no S): `bit 7,h`.
13. MPL v2 panel on **`asm/`** cores only — not `c/` glue, lm16 aliases, or C (some C is GPL).
14. Restoring f24 div: z80 uses `exx` + `djnz` (count in `B'`). 8085 / 8080 / gbz80 have no spare count register (B is the divisor). After prenorm, DE is free: **stacked ret** — push `div_pack`, 15× `div_bit`, `jp div_bit`; `div_bit` ends in `ret`. Do **not** `call div_bit` 16 times. 8080/gbz80 inner `push de`/`push af` sit above those words. z80 keeps the `djnz` loop.

### Calling vs math32

Many half API symbols are plain `defc sinf16 = _m16_sinf` (true DEHL) even with
`-D__CLASSIC` — **not** the math32 stack-bridge trap. Still prefer map proof
(`sinf16` / `sqrtf16` / `invsqrtf16`) after link. Fair n-body: math16 may keep
`invsqrtf16`; math32 TIMER source should use `1.0/sqrt` on both classic and newlib.

## Related

- `library-math32`, `cpu-8085`, `methodology-measure`, `library-newlib` (header regen)
- Product readme: math16 `README.md` under the float tree
