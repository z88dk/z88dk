# math32 — IEEE-754 single-precision floating point

This is the z88dk 32-bit IEEE-754 (mostly) floating-point maths package. It works with the sccz80 and zsdcc IEEE-754 (mostly) 32-bit interfaces.

Link it with **`--math32`**. That alias selects the product for the active CPU through `@{ZCC_LIBCPU}`. Example: `math32_8085` with `-clib=8085`. It expands to the IEEE float mode, the math32 define set, `CLIB_32BIT_FLOATS=1`, and `-lmath32@{ZCC_LIBCPU}`.

This library is designed for z180 (eZ80), z80n, and Rabbit 2000 / 3000 processors. It is optimised for the z180 (eZ80) and [ZX Spectrum Next](https://www.specnext.com/) z80n, because those CPUs have a hardware `16_8×8` multiply that accelerates the floating-point mantissa. The Rabbit `32_16×16` signed multiply is also implemented for r2ka / r3k machines and provides the fastest Rabbit path.

The library is also designed to be as fast as possible on plain Z80, using a `32_24×8` basis multiply.

Intel 8080, 8085, and gbz80 have separate stack-based cores (`math32_8080.lib`, `math32_8085.lib`, `math32_gbz80.lib`). Those builds do not use the alternate register set or index registers. Higher-level C helpers for 8080, 8085, and gbz80 are built with **sccz80 only** (zsdcc is Z80-only).

*@feilipu, May 2019 – September 2026*

---

## Key features

- All intrinsic functions are written in assembly.
- All the code is re-entrant.
- Register use on the Z80-family cores is limited to the main and alternate set (including `af'`). No index registers. The 8080, 8085, and gbz80 cores use the main register set and the stack only.
- Made for the Spectrum Next (z80n) and Agon Lite (eZ80). The z80n `mul de`, the z180 (eZ80) `mlt`, and the Rabbit `mul` instructions accelerate floating-point calculation. Full support also covers Zilog Z80 and variants, Digi Rabbit processors, Intel 8080 and 8085, and the Nintendo Game Boy CPU (gbz80).
- Mantissa work uses 24 bits plus 8 bits for rounding. Product paths (mul, sqr, div, poly, invsqrt / sqrt) use IEEE-754 round-to-nearest-even (RNE) on the residual byte. Addition / subtraction use jam-sticky on lost bits, which gives better accuracy on repeated additions.
- Derived functions use a full 32-bit internal mantissa path, without mid-path rounding, for maximum accuracy when many multiplies and adds are required (Horner / Newton–Raphson). That is equivalent to a fused 32-bit multiply-add process, with the rounded IEEE-754 mantissa produced as the final result.
- Where no hardware multiply is available, software multiply uses a `32_24×8` unrolled algorithm. The dedicated square kernel is separate: five `16_8×8` products, matching the z80n / z180 square layout.
- Higher functions are written in C for maintainability. They draw on the intrinsic square root, square, polynomial evaluation, and the four arithmetic functions.
- Power and trigonometric accuracy and speed can be traded by changing polynomial coefficient tables and iteration counts. More coefficients give higher accuracy at the expense of performance. Cephes and Hi-Tech coefficient tables are the default. Alternative tables can be used without changing the evaluator code.
- Square root (through inverse square root) is seeded with the Quake magic-number method, then three Newton–Raphson iterations. Accuracy and speed can be traded by removing one or two iterations, for example for games.

---

## Products

| Library | CPU | Mantissa multiply |
|---------|-----|-------------------|
| `math32.lib` | Z80 | software `32_24×8` |
| `math32_z80n.lib` | ZX Spectrum Next (z80n) | hardware `mul de` |
| `math32_z180.lib` | Z180 | hardware `mlt` |
| `math32_ez80_z80.lib` | eZ80 (Z80 mode) | hardware `mlt` |
| `math32_r2ka.lib` / `math32_r4k.lib` / `math32_r6k.lib` | Rabbit | wide Rabbit multiply |
| `math32_kc160.lib` | KC160 | KC160 multiply helpers |
| `math32_8085.lib` | 8085 | stack-only software |
| `math32_8080.lib` | 8080 | stack-only software |
| `math32_gbz80.lib` | Game Boy (gbz80) | stack-only software |

**eZ80 note.** eZ80 Z80-mode has the same `mlt` encodings as Z180 (`ED 4C/5C/6C/7C`). `math32_ez80_z80.lib` is built from `newlibfiles_ez80_z80.lst`, which selects the Z180 mantissa helpers. Those helpers are gated `IF __CPU_Z180__ | __CPU_EZ80__ | __CPU_EZ80_Z80__` (`-mez80_z80` defines `__CPU_EZ80_Z80__`, not `__CPU_EZ80__`).

---

## IEEE-754 floating-point format

The z88dk floating-point format (compatible with Intel / IEEE) is:

```text
DEHL = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
       (s = sign, e = exponent, m = mantissa)
```

The four bytes are stored in memory in reverse order from the register picture above.

```text
s - 1 negative, 0 positive
e - 0–255, bias 127 (Intel 8087 / IEEE-754 binary32)
m - 23 bits, with implied 24th bit always 1 when e ≠ 0
```

With the hidden bit restored, the mantissa is 24 bits long and has a decimal value in the range 1.000 to 1.9999….

Examples:

```text
sign  exponent     mantissa
  0   01111110 (1) 10000....    1.5 * 2^(-1) =  0.75
  0   01111111 (1) 10000....    1.5 * 2^( 0) =  1.50
  1   10000000 (1) 10000....   -1.5 * 2^( 1) = -3.00
  0   10000110 (1) 01100100010..             = 178.25
  x   00000000     xxx... zero (sign positive or negative)
  x   11111111     000... infinity
  x   11111111     xxx... not a number
```

The package is loosely based on IEEE-754. It keeps the packed format. Product results pack with round-to-nearest-even on a residual byte. Add / sub use jam-sticky alignment. Denormal numbers are not supported. math32 treats any number with a zero exponent as signed zero, including a normalize result whose biased exponent is exactly 0. Quiet NaN is `0x7FFFFFFF` (payload is not propagated). `sqrt(-0)` returns `-0`. `invsqrt(-0)` returns `-Inf`.

```text
IEEE floating point format:  seeeeeee emmmmmmm mmmmmmmm mmmmmmmm

represents  e > 0           -> (-1)^s * 2^(e-127) * (0x800000 + m)/0x800000
            e = 0           -> signed zero (math32)
            e = 0xff & m=0  -> (-1)^s * INF
            e = 0xff & m≠0  -> NaN
```

IEEE-754 specifies round to nearest, ties to even. math32 uses that for **product** packing, and a cheaper sticky rule for **add / sub**:

```text
-------------------------------------------------------------------------
IEEE round to nearest, ties to even (product / residual pack):

After a 24- or 32-bit product (or expanded intermediate),
residual byte R is the bits below the kept 24-bit mantissa.
G = R.7 (guard), S = R[6:0] (sticky), B = mant LSB.

round_up = G && (S || B); then 24-bit mant++ (overflow → 1.0, exp++).

b g s  (b=lsbit g=guard s=sticky)   action
0 0 0  exact                        stay
0 0 1  -.001                        stay (truncate)
0 1 0  tie, even                    stay
0 1 1  +.001                        up
1 0 0  exact                        stay
1 0 1  -.001                        stay
1 1 0  tie, odd                     up
1 1 1  +.001                        up

Used on mul, sqr, div, poly, and invsqrt/sqrt pack paths.
Mid-low sticky inside truncated high-half multiplies is separate:
it only ORs product bits for the high half and is not a pack RNE step.
-------------------------------------------------------------------------

Digi jam-sticky (add / sub):

When aligning the smaller mantissa (or right-shifting a sum
overflow), any bits shifted out set the kept mant LSB (`OR 1`).
There is no separate guard/sticky RNE at pack. Fast and good for
long add chains (e.g. n-body energy); not full IEEE RNE on add.
-------------------------------------------------------------------------
```

### Expanded mantissa format

An expanded 32-bit internal mantissa is used for derived functions. This raises accuracy for Newton–Raphson iterations and Horner polynomial expansions. The same expanded form is used by the multiply and add intrinsic 32-bit mantissa helpers.

```text
unpacked: exponent in B, sign in C[7], mantissa in DEHL

BCDEHL = eeeeeeee s....... 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
```

---

## Calling convention

math32 uses the sccz80 standard register and stack calling convention, with the usual C parameter direction. For sccz80 the first (RHS) parameter is in **DEHL**, and the second (LHS) parameter is on the **stack**. For zsdcc all parameters are on the stack, right to left. Where several parameters are passed, they go on the stack for both compilers.

The intrinsic assembly functions assume the sccz80 convention. They are `__z88dk_fastcall` or `__z88dk_callee` by default, so they consume stack arguments and return in DEHL.

```text
LHS STACK - RHS DEHL -> RETURN DEHL

; add two sccz80 floats
;
; enter : stack = sccz80_float left, ret
;          DEHL = sccz80_float right
;
; exit  :  DEHL = sccz80_float(left+right)
;
; uses  : af, bc, de, hl, af', bc', de', hl'   (Z80-family)


; evaluation of a polynomial function
;
; float poly (float x, float d[], uint16_t n);
;
; enter : stack = uint16_t n, float d[], float x, ret
;
; exit  : dehl  = 32-bit product
;         carry reset
;
; uses  : af, bc, de, hl, af', bc', de', hl'   (Z80-family)
```

On 8080 / 8085 / gbz80 the same DEHL / stack contract applies, but the cores do not use the alternate set. Multi-arg sccz80 callee bridges that must not `pop af` a float word use `IF __CPU_INTEL__ | __CPU_GBZ80__` (AF-safe left-rotate).

---

## Digi roots, and what changed

Where not written for z88dk, functions were sourced from Digi International, Cephes, Hi-Tech C, SDCC, and public Newton–Raphson / Horner references. Early add / unpack / pack work descends from the Digi Rabbit IEEE-754 32-bit package.

Although some Digi algorithms remain visible in the intrinsic path, the cores have been rewritten to exploit z180 and z80n 8-bit multiply hardware, rather than the 16-bit multiply of Rabbit processors. The relationship is one of descent only — like West Side Story and Romeo and Juliet.

**Normalisation** is now a separate design on every CPU. The path is byte alignment first, then a residual bit loop, then pack into `DEHL`. Z80-family and 8080 / 8085 / gbz80 share that strategy with ISA-specific shifts.

**Addition / subtraction** still use a nybble / byte shift tree in Digi spirit. As add and subtract rely heavily on bit shifting across the mantissa, the functions establish a tree of byte and nybble shifting for performance. Nybble shifting is native on Rabbit, and the same plan works well on Z80 with little overhead. Lost bits use **jam-sticky**: any bit shifted out sets the kept mantissa LSB. Pack does not apply residual RNE on add / sub.

**Multiply** was rewritten around `16_8×8` terms. Z180 `mlt`, z80n `mul de`, and Rabbit / KC160 helpers accelerate the mantissa. Plain Z80 uses a `32_24×8` construction. The Digi Rabbit `32_16×16` path is not the current hot path.

---

## Function discussion

There are three grades of function in this library:

1. Assembly in the expanded floating-point domain, where sign, exponent, and mantissa are handled separately.
2. Assembly that uses those intrinsics, still in floating-point form.
3. C language higher functions.

The expanded domain is a useful tool. Complex functions can be written efficiently without managing every pack / unpack detail. A good example is `poly()`.

### Intrinsic arithmetic

```c
float add (float x, float y);
float sub (float x, float y);
float mul (float x, float y);
float div (float x, float y);
```

With these intrinsics (and the compact assembly square-root and polynomial functions) you can build efficient complex C functions.

#### Multiply and square

For Z80, `mulu_32h_24x24` uses three optimised `32_24×8` multiplies. That is the fastest path where no hardware multiply is available.

For z180 and z80n, `mulu_32h_24x24` uses eight `16_8×8` multiplies, the minimum term count. It is more natural for those CPUs to work in `16_8×8` than in Rabbit `32_16×16`. The multiply is not “correct” in the sense that every low term and every carry is kept. The lowest term is omitted because it does not affect the kept 32-bit high product. The low 16 bits of the full product are truncated, leaving 8 bits for mantissa rounding in the caller.

IEEE RNE on the residual byte is applied in `_fsmul` / `_fssqr` when packing the 24-bit mantissa.

`sqr()` is related to multiply, but ignores the sign and uses a dedicated `sqr_32h_24x24` kernel. All squaring used by square root, inverse square root, hypotenuse, and the transcendental C helpers goes through `_fssqr` / `sqr()` rather than a full `_fsmul`. That path uses five `16_8×8` products instead of a general 24×24 multiply (eight `16_8×8` terms on z180 / z80n, or the Z80 multi-pass `32_24×8` route). The five-term kernels need only the main register set.

For the 8×8-oriented CPUs the square uses the same high-32-of-48 algebraic expansion:

```text
abc * abc  (a,b,c = 24-bit mantissa bytes, a = msb)

  (a*a)<<32 + (2*a*b)<<24 + (b*b + 2*a*c)<<16 + (2*b*c)<<8
  ; (c*c)<<0 is not calculated — it only affects bits below the kept 32
```

| Build | `sqr_32h_24x24` 8×8 primitive |
|-------|-------------------------------|
| **z80** | `call l_mulu_de` |
| **z80n** | hardware `mul de` |
| **z180 / ez80** | hardware `mlt` |
| **8085 / 8080 / gbz80** | local `mulu_de` (same algorithm as `l_small_mulu_de`) |

Rabbit (r2ka) and KC160 also expose `m32_sqr_32h_24x24` for the same `_fssqr` entry, but implement the square through their wider multiply helpers rather than the five-term 8×8 expansion.

#### Wide multiply for Newton–Raphson

`mulu_32h_32x32` returns the high 32 bits of a 32×32 product for Newton–Raphson work that still needs a wide residual (notably `_fsinv`). General divide (`_fsdiv`) is restoring binary division and does not use this helper.

On Z80, `mulu_32h_32x32` uses four optimised `32_16×16` multiplies. On z180 / z80n the implementation truncates low-order carry work for speed: calculation starts at the 3rd byte of 8, and 11 `16_8×8` multiplies are required. Returning only bytes 4–7 leaves at most a small error in the least significant nibble of the 32-bit mantissa, which is discarded after rounding to 24-bit precision.

#### Divide and inverse

```c
float div (float x, float y);
float inv (float x);
```

| Op | Algorithm |
|----|-----------|
| `div` / `m32_fsdiv` | Restoring 24-bit mantissa divide, RNE on the guard |
| `inv` / `m32_fsinv` | Newton–Raphson with wide multiplies |

The z80-family, 8085, 8080, and gbz80 divide cores share the same control structure. The z80 core keeps rem and divisor across the main and alternate sets. The 8080 / 8085 / gbz80 cores keep rem in `DEHL`, the bit count in `B`, and the 3-byte divisor on a short stack frame.

For plain `1/n`, restoring `div` is the faster path on the measured CPUs. Explicit `inv(x)` calls the NR inverse. sccz80 does not rewrite IEEE `1.0f/x` into `inv`.

Inputs with `exp == 0` are ±0. Result underflow flushes to signed zero. There is no gradual underflow.

#### Square root and inverse square root

```c
float sqrt (float x);
float invsqrt (float x);
```

`invsqrt()` seeds Newton–Raphson with the Quake-class constant `0x5f375a86` (see [Lomont 2003](http://www.lomont.org/Math/Papers/2003/InvSqrt.pdf)), then three unrolled Newton–Raphson iterations on the expanded 32-bit helpers. `sqrt(x)` is `x * invsqrt(x)`. The IEEE `sqr()` intrinsic (24-bit `sqr_32h_24x24`) is a separate function for user code and is not a subroutine of those iterations.

Two NR iterations give about 5 or 6 significant digits. Three iterations (the default) approach 7 significant digits for this library. One iteration is often enough for 3D games and is substantially faster.

#### Special helpers

```c
float fabs (float x);
float frexp (float x, int *pw2);
float ldexp (float x, int pw2);
float div2 (float x);
float mul2 (float x);
float mul10u (float x);
```

sccz80 can emit `ldexp()` for power-of-two scales, so for example `x/2` becomes an exponent decrement rather than a full divide. `mul2()`, `div2()`, and `mul10u()` (`y = 10 * |x|`) are much faster than a full multiply. Combinations help: `div2(mul10u(mul10u(x)))` is substantially faster than `y = 50.0 * x` on any supported CPU.

#### Polynomial and hypotenuse

```c
float poly (const float x, const float d[], uint16_t n);
float hypot (float x, float y);
```

All higher functions use Horner evaluation through `poly()`, with a full 32-bit expanded mantissa path and a final IEEE pack. The 0th coefficient is stored first. See the library tables for `sin()`, `tan()`, `log()`, and `exp()`.

`hypot()` is provided as part of the standard maths set, and also shows how compactly complex routines can be written on top of the cores.

### C floating-point functions

The rest of the library is derived from Hi-Tech C, Cephes Math Library Release 2.2, and related IEEE sources. Hi-Tech is known for performance more than accuracy, which may relate to short coefficient tables. Alternative and extended coefficient matrices can be tested for accuracy and performance.

```c
/* Trigonometric */
float sin (float x);   float cos (float x);   float tan (float x);
float asin (float x);  float acos (float x);  float atan (float x);
float atan2 (float x, float y);

/* Hyperbolic */
float sinh (float x);  float cosh (float x);  float tanh (float x);
float asinh (float x); float acosh (float x); float atanh (float x);

/* Exp / log / power */
float exp (float x);   float exp2 (float x);  float exp10 (float x);
float log (float x);   float log2 (float x);  float log10 (float x);
float pow (float x, float y);

/* Nearest integer / remainder */
float ceil (float x);  float floor (float x);
float modf (float x, float *y);  float fmod (float x, float y);
```

---

## Directory layout

The library is laid out as shared assembly, CPU-specific cores, C sources, and compiler bridges.

| Path | Role |
|------|------|
| `asm/` | Shared **8080-compatible** assembly: coefficient tables, float constants, and cores identical on 8080 / 8085 / gbz80 (and on Z80 when the encoding matches). No Z80-only or 8085-only instructions. |
| `asm/z80/` | Z80-family intrinsic cores. Uses the alternate register set. Also holds CPU mantissa helpers (`f32_z80_*`, `f32_z80n_*`, `f32_z180_*`, `f32_r2ka_*`, `f32_kc160_*`). |
| `asm/8085/` | 8085 cores (extended opcodes, stack locals, no alternate registers). |
| `asm/8080/` | 8080 cores (original ISA, stack locals, `ld hl,sp+n`, cheap synthetics only). |
| `asm/gbz80/` | Game Boy cores. Same stack-only contract. Prefer `ld hl,sp+*`, `ld a,(hl+)`, CB shifts, and `jr`. Leading-one tests use `bit 7`. |
| `c/` | Higher-function C sources. |
| `c/z80/` | Precompiled Z80-family higher functions (SDCC). |
| `c/8085/`, `c/8080/`, `c/gbz80/` | Precompiled with **sccz80** (`make -C c 8085` / `8080` / `gbz80`). |
| `c/sdcc/`, `c/sccz80/` | Compiler bridges and float conversions. |
| `lm32/` | Standard-name aliases into math32 (`-lmath32` / `--math32`). |
| `newlibfiles_*.lst` | Module lists per product. |

One major operation per assembly file. Rebuild with `make -C libsrc/math/float/math32`, then install the `math32*.lib` products into `lib/clibs/`.

---

## Accuracy

Generally the intrinsic functions are accurate within 1–2 counts of the floating mantissa. In some ranges relative accuracy is much worse because of the intrinsic properties of floating-point math. Accuracy in counts of the mantissa is relative accuracy. Absolute accuracy is the absolute size of the error (for example 0.000001). Derivative functions, built from several basic functions, typically have larger error because those errors combine.

If a function depends on the difference of two close floating-point values, relative error generally becomes large even when absolute error stays small. Examples are logs of numbers near 1, and sine of numbers near π. Functions with steep slopes, such as exp of larger arguments, show large relative error because the relative error in the argument is magnified by the slope.

Add / sub jam-sticky is not full IEEE RNE. Results are typically within 1–2 ULP of a correctly rounded IEEE sum for ordinary cases. Long add-heavy chains can accumulate small differences versus pure RNE or versus math48.

Divide is restoring binary division (not NR). The pack step uses RNE on the residual bit. Inverse remains NR. Both target full IEEE 24-bit mantissa accuracy on ordinary finite (normal) inputs. Denormals are not supported.

Square root also relies on Newton–Raphson and is therefore an estimate. With the three iterations currently implemented, the estimate meets the IEEE 24-bit mantissa requirement. With one iteration the result is good for 3D graphics in games and not much else.

The remaining power and trigonometric functions rely on polynomial expansion. They are only as accurate as the algorithms and coefficients fed into that process. The default tables come from Hi-Tech C and Cephes.

`exp` / `exp2` / `exp10` clamp at `MAXLOG_*` / `MINLOG_*`: overflow returns `HUGE_POS_F32`, underflow returns `+0`.

`sin` and `cos` reduce by octants of π/4 in binary32. For `|x| >= 128` they first apply `fmod(x, 2π)` in single precision so the octant index cannot wrap. That keeps the result in `[-1, 1]`. It is not a correctly rounded reduction against true π; large-argument trigonometric values remain estimates.

---

## Benchmarks

Some [benchmarking](https://github.com/z88dk/z88dk/wiki/Classic--Maths-Libraries#benchmarks) has been completed. As expected, the z180 and z80n Spectrum Next results show substantial improvements over other floating-point libraries. On plain Z80 most of these benches are faster than the alternatives.

Careful use of the intrinsic functions can give a further improvement. For example, n-body can use `invsqrt()` and `sqr()`, and mandelbrot can use `sqr()` instead of a full multiply. See the **(opt)** rows below.

Classic `+test`, sccz80, TIMER-bounded region only (no `PRINTF`). Measured with `z88dk-ticks` and the matching CPU flag **before** the binary.

| Bench | Compile extras |
|-------|----------------|
| n-body | `-O2 -DSTATIC -DTIMER` |
| mandelbrot | `-O3 --opt-code-speed=inlineints -DSTATIC -DTIMER` |
| whetstone | `-O2 -DSTATIC -DTIMER` |

Library flags: `-lm` (genmath), `-lmath48@{ZCC_LIBCPU}`, `--math-bbc`, `--math-mbf32`, `--math32`.

**math32 (opt)** uses the intrinsic helpers as a guide for advanced code:

```c
#ifdef __MATH_MATH32
      inv_distance = invsqrt(sqr(dx) + sqr(dy) + sqr(dz));
#else
      inv_distance = 1.0/sqrt(dx * dx + dy * dy + dz * dz);
#endif
```

```c
#ifdef __MATH_MATH32
            for (i=0;i<iter && (Tr+Ti <= sqr(limit));++i)
            {
                Zi = 2.0*Zr*Zi + Ci;
                Zr = Tr - Ti + Cr;
                Tr = sqr(Zr);
                Ti = sqr(Zi);
            }
#else
            for (i=0;i<iter && (Tr+Ti <= limit*limit);++i)
            {
                Zi = 2.0*Zr*Zi + Ci;
                Zr = Tr - Ti + Cr;
                Tr = Zr * Zr;
                Ti = Zi * Zi;
            }
#endif
```

On plain Z80 and 8085 the n-body `invsqrt` / `sqr` rewrite is about a 10–13% TIMER win. Hardware-multiply builds (kc160 / z80n / z180 / eZ80) show larger relative gains. Most of the gain is from calling `invsqrt()` directly rather than `1.0/sqrt(...)`.

For mandelbrot, `sqr()` instead of a full multiply yields roughly 11–16% on kc160 / z80n / z180 / eZ80 / 8085. On plain Z80 the same rewrite helps less (~2% here) because the general multiply path is already a different 3×`32_24×8` construction.

Whetstone has no opt rewrite. KWIPS = `1000 / (ticks / 4e6)` at 4 MHz.

genmath has no Z180 or kc160 product (undocumented `ixh` / `ixl`). Those cells are blank.

### n-body — Z80 family (ticks)

| Library | z80 | z80n | z180 | ez80 | kc160 |
|---------|-----|------|------|------|-------|
| genmath | 3_660_196_258 | 3_651_307_458 | — | 1_013_771_310 | — |
| math48 | 2_379_690_672 | 2_370_841_872 | 2_091_459_593 | 666_739_415 | 656_023_478 |
| bbcmath | 1_643_590_720 | 1_634_741_920 | 1_399_252_452 | 491_344_563 | 429_332_350 |
| mbf32 | 1_835_079_611 | 1_826_230_811 | 1_663_652_473 | 522_036_603 | 457_635_342 |
| math32 | 797_522_480 | 478_764_090 | 448_716_652 | 129_603_332 | 153_562_673 |
| math32 (opt) | 719_364_405 | 398_658_288 | 378_976_548 | 110_770_844 | 135_923_452 |

### n-body — 8080 / gbz80 / 8085 (ticks)

| Library | 8080 | gbz80 | 8085 |
|---------|------|-------|------|
| mbf32 | 1_977_568_668 | 2_532_327_012 | 1_849_800_062 |
| math32 | 1_696_440_576 | 1_663_519_444 | 1_485_952_681 |
| math32 (opt) | 1_470_242_071 | 1_460_721_244 | 1_291_080_960 |

### mandelbrot — Z80 family (ticks)

| Library | z80 | z80n | z180 | ez80 | kc160 |
|---------|-----|------|------|------|-------|
| genmath | 3_596_708_088 | 3_596_708_088 | — | 1_096_891_356 | — |
| math48 | 3_266_218_225 | 3_266_218_225 | 2_883_529_545 | 915_300_242 | 905_375_630 |
| bbcmath | 3_002_926_692 | 3_002_926_692 | 2_566_695_334 | 974_172_744 | 813_033_907 |
| mbf32 | 1_798_158_288 | 1_798_158_288 | 1_641_336_382 | 522_151_491 | 459_272_316 |
| math32 | 1_030_978_885 | 743_299_493 | 685_695_345 | 203_176_898 | 237_765_028 |
| math32 (opt) | 1_006_280_717 | 638_651_951 | 583_354_883 | 172_234_961 | 225_014_815 |

### mandelbrot — 8080 / gbz80 / 8085 (ticks)

| Library | 8080 | gbz80 | 8085 |
|---------|------|-------|------|
| mbf32 | 1_918_663_977 | 2_486_836_444 | 1_805_825_914 |
| math32 | 2_190_129_878 | 2_219_968_340 | 1_947_071_129 |
| math32 (opt) | 1_795_730_302 | 1_939_789_300 | 1_616_570_709 |

### whetstone — Z80 family (KWIPS @ 4 MHz)

| Library | z80 | z80n | z180 | ez80 | kc160 |
|---------|-----|------|------|------|-------|
| genmath | 3.11 | 3.13 | — | 11.28 | — |
| math48 | 4.10 | 4.13 | 4.67 | 14.71 | 15.06 |
| bbcmath | 7.15 | 7.23 | 8.58 | 23.89 | 27.87 |
| mbf32 | 7.35 | 7.44 | 8.15 | 25.87 | 29.25 |
| math32 | 11.05 | 15.52 | 17.08 | 59.26 | 56.12 |

### whetstone — 8080 / gbz80 / 8085 (KWIPS @ 4 MHz)

| Library | 8080 | gbz80 | 8085 |
|---------|------|-------|------|
| mbf32 | 6.86 | 5.46 | 7.30 |
| math32 | 5.20 | 5.03 | 6.08 |

### How to read the tables

- On the Z80 family, math32 is the fastest library in these three benches. Hardware multiply on kc160 / z80n / z180 / eZ80 cuts mul-heavy work further. The opt rows show what `invsqrt` / `sqr` buy when you write for the library.
- On 8080 / gbz80 / 8085, math32 wins **n-body**. The other libraries stay ahead on **whetstone** and on base **mandelbrot**. The mandelbrot opt row recovers most of that gap with `sqr()`.
- kc160 and eZ80 T-state counts are not comparable one-for-one with plain Z80. Use them for library order on that model.
- Full recipes and archive RESULT blocks live under `support/benchmarks/`. Suite gate: `test/suites/math` (`test_math32*.bin`).

---

## Related

- Library tree: `libsrc/math/float/math32/`
- Half float: `libsrc/math/float/math16/`
- Classic maths overview: wiki *Classic Maths Libraries*
- Digi historical notes: `readme_digifloatmath.txt`

---

## Licence and provenance

math32 source is under the **Mozilla Public License, v. 2.0** (MPL-2.0). If a copy of the MPL was not distributed with this file, you can obtain one at <https://mozilla.org/MPL/2.0/>.

The Digi International Rabbit IEEE-754 32-bit material that seeded early cores carries the same MPL-2.0 notice. See `readme_digifloatmath.txt`.

Where not written for z88dk, functions were sourced from:

- Digi International Rabbit IEEE-754 32-bit library, copyright (C) 2015 Digi International Inc.
- Cephes Math Library Release 2.2, copyright (C) 1984, 1987, 1989 by Stephen L. Moshier
- Hi-Tech C 32-bit floating-point library, copyright (C) 1984–1987 HI-TECH SOFTWARE
- SDCC 32-bit floating-point library, copyright (C) 1991 by Pipeline Associates, Inc, and others
- Public references for Newton–Raphson and Horner evaluation (including the Quake inverse-square-root seed)
