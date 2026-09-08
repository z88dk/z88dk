
## z88dk IEEE Floating Point Package - `math16`

This is the z88dk 16-bit IEEE-754 standard math16 half precision floating point maths package, designed to work with the SCCZ80 IEEE-754 half precision 16-bit interfaces.

`--math16` links `-lmath16@{ZCC_LIBCPU}`. Products:

| Product | Cores |
|---------|-------|
| `math16.lib` | `asm/z80/` |
| `math16_{ixiy,z80n,z180,ez80_z80,r2ka,r4k,r6k,kc160}.lib` | same `newlibfiles_z80.lst` (Z80-family) |
| `math16_8085.lib` | `asm/8085/` |
| `math16_8080.lib` | `asm/8080/` |
| `math16_gbz80.lib` | `asm/gbz80/` |

Shared specials and coeff tables live under `asm/`. 8080 / 8085 / gbz80 are stack-only (no `exx` / IX / IY). Packed half×half and `sqrf16` use an 11×11 product; f24 (poly / inv / hypot / fma / sqrt) uses 16×16. Plain z80 unrolls both in-file (`mulu_32_16x16_gen` / `mulu_32_16x16`). Other Z80-family products call `l_mulu_32_16x16` (z80n `mul de`, z180 / ez80 `mlt`, kc160 / rabbit integer HW).

The specialised nature of 16-bit floating point implies that this is an adjunct or special purpose maths library. It can be used to accelerate the calculation of floating point, where the results are only needed to 3.5 significant digits. Applications can include video games, or neural networks, for example. There is **no stdio / printf / scanf / dtoa requirement** on the math16 product itself; apps that need float print may pair another float library (e.g. math32) for I/O only.

*@feilipu, May 2020 / 8085 August 2026 / 8080 September 2026 / gbz80 September 2026*

---

## Key Features

  *  All the intrinsic functions are written in assembly language.

  *  All the code is re-entrant.

  *  Z80 family: register use is limited to the main and alternate set (including af'). NO index registers were abused in the process.

 *  8085: no alternate register set; second f24 operand and temps on the **stack** only (`ld de,sp+*`, `ld hl,(de)`). Extended 8085 ops preferred. Library asm is not copt’d.

 *  8080 / gbz80: no alternate register set; second f24 operand on the stack. 8080: `ld hl,sp+n` clobbers C. gbz80: native `ld hl,sp+*` (signed; Z←0).

  *  Z80-family products assemble the same z80 cores (`-mz80n` / `-mz180` / `-mez80_z80` / …). Packed-half and f24 multiply on those CPUs call `l_mulu_32_16x16` (HW integer mul). The unrolled 11×11 / 16×16 body is plain z80 only.

  *  Mantissa calculations are done with 16-bits (11-bits plus 5-bits for rounding). Rounding is a simple method, but can be if required it can be expanded to the IEEE standard with a performance penalty.

  *  All functions are calculated with an 8-bit exponent and 16-bit internal mantissa calculation path, as this is a natural size for the z80, to provide the maximum accuracy when repeated multiplications and additions are required.

  *  Compiles natively with sccz80. Variables and constants with the type `half_t` can be used naturally in C expressions, including comparisons and arithmetic operations.


## IEEE-754 Half Precision Floating Point Format

The z88dk half precision floating point format (compatible with Intel / IEEE, etc.) is as follows:

```
  hl = seeeeemm mmmmmmmm (s-sign, e-exponent, m-mantissa)
```
stored in memory with the 2 bytes reversed from shown above.

```
    s - 1 bit, 1 negative, 0 positive
    e - 5 bits,indicating the exponent
    m - mantissa 10 bits, with implied 11th bit which is always 1
```
The mantissa, when the hidden bit is added in, is 11-bits long and has a value in the range of in decimal of 1.000 to 1.999...

To match IEEE-754 16-bit format we use bias of 15.

Examples of numbers:

```
  sign  exponent     mantissa
    0   01110    (1) 10000....    1.5 * 2 ^ (-1) =  0.75
    0   01111    (1) 10000....    1.5 * 2 ^ ( 0 )=  1.50
    1   10000    (1) 10000....   -1.5 * 2 ^ ( 1 )= -3.00
    0   10110    (1) 0110010010                  =178.3
    x   00000        xxx... zero (sign positive or negative, mantissa not relevant)
    x   11111        000... infinity  (sign positive or negative, mantissa zero)
    x   11111        xxx... not a number (sign positive or negative, mantissa non zero)
```
This half precision floating point package is loosely based on IEEE-754. We maintain the packed format, but we do not support the round to even convention. 

z88dk math16 assumes any number with a zero exponent is positive or negative zero.
IEEE-754 assumes bit 11 of the mantissa is 1 except where the exponent is zero. Sub-normal numbers are not supported.


## IEEE Floating Point Expanded Mantissa Format

An expanded 16-bit internal mantissa is used to calculate all functions. 16-bit calculations are natural for the z80, and this provides enhanced accuracy for repeated calculations required for derived functions. Specifically, this is to provide increased accuracy for the Newton-Raphson iterations, and the Horner polynomial expansions. The inverse function, divide function, fused multiply add function and the poly function are also implemented using the expanded 8-bit exponent and 16-bit mantissa internal path.

This format is provided for both the multiply and add intrinsic internal 16-bit mantissa functions, from which other functions are derived, and is referred to as `_f24` in the library.

```
  unpacked floating point format: exponent in d, sign in e[7], mantissa in hl

  d    = eeeeeeee     8-bit exponent, bias 127 (same scale as binary32)
  e    = s.......     sign in bit 7
  hl   = 1mmmmmmm mmmmmmmm   16-bit mantissa with explicit leading 1

  Conversion from packed half (bias 15):
    half_exp 0      -> f24 zero
    half_exp 1..30  -> d = half_exp + (127-15)   ; 113 .. 142  (finite)
    half_exp 31     -> d = 0xff, hl = 0 (Inf) or hl != 0 (NaN); sign in e[7]
  Overflow Inf from f24 arithmetic also uses d = 0xff (asm_f24_inf).

  Conversion back to half (asm_f16_f24):
    d < 113     -> ±0
    d 113..142  -> finite half_exp 1..30
    d >= 143 and d != 0xff -> ±Inf (overflow)
    d == 0xff   -> ±Inf if hl==0, else ±NaN
```

Pack underflow uses unsigned `jp C` after `sub 112` (not sign). `d=255` maps to 143 and is classified on the overflow arm.

IEEE specials are classified on overflow, operand-zero, and equal-exp 255 (packed exp 31) only. The finite add/mul path does not scan Inf/NaN. Packed Inf × a tiny finite (half exp sum − 15 < 31) may return a finite. `inc r` / `jp Z` tests f24 exp == 255 (8-bit `inc` sets Z, not C).

## Calling Convention

The z88dk math16 library uses the sccz80 standard register and stack calling convention, but with the standard c parameter passing direction. For sccz80 the first or the right hand side parameter is passed in `HL`, and the second or LHS parameter is passed on the stack. For zsdcc all parameters are passed on the stack, from right to left. For both compilers, where multiple parameters are passed, they will be passed on the stack.

The intrinsic functions `l_f16_`, written in assembly, assume the sccz80 calling convention, and are by default `__z88dk_fastcall` or `__z88dk_callee`, which means that they will consume values passed on the stack and/or `HL`, returning with the value in `HL`.

```
     RETURN HL <- LHS STACK - RHS HL REGISTERS 

    ; subtract two sccz80 half floats
    ;
    ; half l_f16_sub (half x, half y);
    ;
    ; enter : stack = sccz80_half left, ret
    ;            HL = sccz80_half right
    ;
    ; exit  :    HL = sccz80_half(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'   ; z80 family
    ;         af, bc, de, hl                      ; 8080 / 8085 / gbz80
    
     RETURN HL <- LHS STACK - RHS STACK 

    ; subtract two sdcc half floats
    ;
    ; half f16_sub (half x, half y);
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret
    ;
    ; exit  :    HL = sdcc_half(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'   ; z80 family
    ;         af, bc, de, hl                      ; 8080 / 8085 / gbz80 (no alternate set)
```

Normal functions `f16_`, assume the calling convention of sccz80 or sdcc depending on the selected compiler.

```
     RETURN HL <- LHS STACK - RHS STACK 

    ; subtract two sccz80 half floats
    ;
    ; half f16_sub (half x, half y);
    ;
    ; enter : stack = sccz80_half left, sccz80_half right, ret
    ;
    ; exit  :    HL = sccz80_half(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'   ; z80 family
    ;         af, bc, de, hl                      ; 8080 / 8085 / gbz80

     RETURN HL <- LHS STACK - RHS STACK

    ; subtract two sdcc half floats
    ;
    ; half f16_sub (half x, half y);
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret
    ;
    ; exit  :    HL = sdcc_half(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'   ; z80 family
    ;         af, bc, de, hl                      ; 8080 / 8085 / gbz80
```


## Directory Structure

The library is laid out in these directories.

### asm/

Shared portable pieces used by every CPU product: specials (`zero` / `inf` / `nan` / `neg` / `sigdig`) and polynomial coefficient tables (`coeff_f16_*`).

### asm/z80/

Z80-family cores (also assembled for z180 / z80n / r2ka / … where the same sources apply). Intrinsic half and f24 operations, expand/pack, poly, sqrt, compare, etc.

### asm/8085/

Intel 8085 cores only (`math16_8085.lib`). Same public entry names as the Z80 tree where the API matches; implementation is stack-based (no `exx` / IX / IY). See **CPU implementation strategies** below and `asm/8085/README`.

### asm/8080/

Intel 8080 cores only (`math16_8080.lib`). Stack-only like 8085; no 8085 extras (`rl de`, `sub hl,bc`, `ld de,sp+*`). `ld hl,sp+n` clobbers C.

### asm/gbz80/

Game Boy CPU cores only (`math16_gbz80.lib`). Stack-only; native `ld hl,sp+*` / `add sp,*` / CB shifts. No `ex de,hl` (56c); no `ex (sp),hl` (148c helper — open-code a DE-parked side-load). No S flag: leading-one tests use `bit 7,h`.

### c

Contains the trigonometric, logarithmic, power and other functions implemented in C. Compiled versions for the Z80 family are prepared and saved in `c/z80` to be assembled and built as required (Z80 codegen). 8085 / 8080 / gbz80 higher-level helpers are precompiled with **sccz80** into `c/8085`, `c/8080`, `c/gbz80` (`make -C c 8085` / `8080` / `gbz80`). Hand-written `cm16_sccz80_*.asm` bridges live in those dirs too.

### c/sdcc and c/sccz80

Contains the zsdcc and the sccz80 C compiler interface and is implemented using the assembly language interface in `asm/z80`, `asm/8085`, `asm/8080`, or `asm/gbz80`. Float conversion between the math16 IEEE-754 format and the format expected by zsdcc and sccz80 occurs here.

### lm16

Glue that connects the compilers and standard assembly interface to the `math16` library.  The purpose is to define aliases that connect the standard names to the math16 specific names.  These functions make up the complete z88dk math16 library that is linked against on the compile line as `-lmath16`.

An alias is provided to simplify usage of the library. `--math16` provides all the required linkages and definitions, as a simple command line alternative to `-lmath16 -Cc-D__MATH_MATH16 -D__MATH_MATH16`.

## CPU implementation strategies

Half and f24 **semantics** (bias, rounding sticky rules, specials at pack/expand) are shared. **Code paths are CPU-specific** — there is no single cross-CPU source for hot cores.

| Area | Shared strategy | Z80-family | 8085 / 8080 / gbz80 |
|------|-----------------|------------|---------------------|
| **Half×half mul** (`asm_f16_mul_callee`) / **`sqrf16`** | Packed field extract; 11-bit mants; integer product; place (`>>5` / `>>6`+inc exp); pack via `asm_f16_f24` | `ex af,af` for sign; `srl`/`bit`/`set`; Runer112 `mulu_32_16x16_gen` (plain z80) or `l_mulu_32_16x16` | Sign on stack; 11×11 helper (`f16_*_mulu_32_11x11`); logical EHL `>>` (8085/8080 open-code; gbz80 `srl`/`rr`) |
| **f24 mul** (poly / inv / hypot / fma / sqrt) | Left-aligned 16-bit mants; exp sum with bias 127; renorm + sticky | Alternate register set for second operand; `mulu_32_16x16` or `l_mulu_32_16x16` | Stack frame for second f24; 16×16 helper (`f16_*_mulu_32_16x16`) |
| **f24 div** (`asm_f16_div` / `asm_f24_div`) | Restoring 16×1-bit; prenorm if rem &lt; div; exp 0 → signed zero; specials via `asm_f24_zero` / `inf` / `nan` | rem `A:HL`, div `BC`, quot `DE`, count `B'` (`exx` + `djnz`); last rem≪ skipped | rem `A:HL`, div `BC`, quot `DE`. Stacked ret: push `div_pack`, 15× `div_bit`, `jp div_bit` (B is the divisor). 8085: `sub hl,bc` + `rl de`. 8080/gbz80: trial through A |
| **classify** (`asm_f16_classify`) | Packed half in `HL`; return 0 number / 1 zero / 2 nan / 3 inf | Shared `asm/asm_f16_classify.asm` (no f24 expand; AF only) | Same shared source |
| **Expand** (`asm_f24_f16`) | Half → f24 | `rr hl` / `rra` path (cheaper on Z80) | Field extract + `add hl,hl` ×5 + implicit bit (no cheap 16-bit `rr`) |
| **Pack** (`asm_f16_f24`) | f24 → half with low-bit rounding | `add hl,hl` for mant positioning | Same idea (`add hl,hl` ×3 + sign via A) |
| **Add / compare / …** | Same algorithms | `exx`, native CB shifts | Stack second operand. 8085: `sra hl` / `sub hl,bc`. 8080: through A. gbz80: `srl`/`rr`; no `ex de,hl` |

Deliberate non-goals: one shared mul body for all CPUs; forcing Z80 expand into the 8085/8080/gbz80 field form (or the reverse) — each form is the cheaper expand on that ISA.

## Function Discussion

There are essentially two different grades of functions in this library. Those intrinsic functions written in assembly code in the expanded floating point domain, where the sign, exponent, and mantissa are handled separately. And derived functions, written in assembly code in the floating point domain but using intrinsic functions, where floating point numbers are passed as expanded 4 byte values using the internal `_f24` format.

### Intrinsic Assembly Functions

```C
half_t addf16 (half_t x, half_t y);
half_t subf16 (half_t x, half_t y);
half_t mulf16 (half_t x, half_t y);
half_t sqrf16 (half_t x);          /* packed 11×11; result always + */
half_t divf16 (half_t x, half_t y);
```

#### _div()_

```C
half_t divf16 (half_t x, half_t y);
```

**`divf16` / `asm_f16_div`** is a **restoring** divider on the f24 path (z80, 8085, 8080, gbz80). Result exp 0 underflows to signed zero (no subnormals; same policy as half exp==0 → ±0).

Cores share the same label set (`div_body`, `div_bit_fail`, `div_quot_shift`, `div_normed`, `div_zero` / `div_inf` / `div_nan`, …). The f24 mantissa is 16 bits, so the divisor stays in `BC` for the whole loop. The z80 core puts the step count in `B'` (`djnz`) and does not shift rem after the last quot bit. 8085 / 8080 / gbz80: DE is free after prenorm, so 15 copies of `div_bit` and one `div_pack` are pushed and `div_bit` ends with `ret` (B is the divisor). Specials call shared `asm_f24_zero`, `asm_f24_inf`, and `asm_f24_nan`.

### Derived Floating Point Functions

These functions are implemented in assembly language but they utilise the intrinsic assembly language functions to provide their returns. The use of the 16-bit mantissa expanded floating point format (`_f24`) functions to implement the derived functions means that their accuracy is maintained.

The expanded floating point format is a useful tool for creating functions, as complex functions can be written quite efficiently without needing to manage details (which are best left for the intrinsic functions). For a good example of this see the `invf16()`, `fmaf16()` and the `polyf16()` functions.

#### _inv()_

```C
half_t invf16 (half_t x);
```

**`invf16` / `asm_f16_inv`** remains Newton–Raphson on the expanded mantissa. Prefer divide for general `/` and for plain `1/n` (restoring div is faster than NR inv). sccz80 does not rewrite half/IEEE literal `1.0/x` to inv — that is ordinary divide. Keep explicit `invf16` for reciprocal-as-primitive / NR-based helpers.

#### _sqrt()_ and _invsqrt()_

```C
half_t sqrtf16 (half_t x);
half_t invsqrtf16 (half_t x);
```
Recently, in the Quake video game, a novel method of seeding the Newton-Raphson iteration for the inverse square root was invented. This fancy process is covered in detail in [Lomont 2003](http://www.lomont.org/Math/Papers/2003/InvSqrt.pdf) and the suggested magic number `0x5f375a86`, better than was used by the original Quake game, was implemented.

Following this magic number seeding and traditional Newton-Raphson iterations an accurate inverse square root `invsqrtf16()` is produced. The square root `sqrtf16()` is then obtained by multiplying the number by its inverse square root.

Two N-R iterations produce 5 or 6 significant digits of accuracy. Also, as in the original Quake game, 1 N-R iteration produces a good enough answer for most applications, and is substantially faster.

#### _fabs()_, _frexp()_ and _ldexp()_ etc

```C
half_t fabsf16 (half_t x);
half_t negf16 (half_t x);
half_t ceilf16 (half_t x);
half_t floorf16 (half_t x);
half_t frexpf16 (half_t x, int *pw2);
half_t ldexpf16 (half_t x, int pw2);
```
For some functions it is easiest to work with IEEE half precision floating point numbers in assembly. For these three functions simple assembly code produces the result required effectively.

The sccz80 compiler has been upgraded to issue `ldexpf16()` instructions where power of 2 multiplies (or divides) are required. This means that for example `x/2` is calculated as a decrement of the exponent byte rather than calculating a full divide, saving hundreds of cycles.

#### Special Functions

```C
half_t div2f16 (half_t x);
half_t mul2f16 (half_t x);
half_t mul10f16 (half_t x);
```
For sccz80, sdcc and in assembly there are `mul2f16()` and `div2f16()` functions available to handle simple power of two multiplication and division, as well as `ldexpf16()`. Also, a `mul10f16()` function provides a fast `y = 10 * x` result. These functions are substantially faster than a full multiply equivalent, and combinations can be used to advantage. For example using `div2f16( mul10f16( mul10f16( x )))` is substantially faster than `y = 50.0 * x` on any CPU type.

#### _poly()_

All of the higher functions are implemented based on Horner's Method for polynomial expansion. Therefore to evaluate these functions efficiently, an optimised `polyf16()` function has been developed, using full 16-bit expanded mantissa `_f24` multiplies and adds.

This function reads a table of IEEE single precision coefficients stored in "ROM" and iterates the specified number of iterations to produce the result desired.

```c
half_t polyf16(const half_t x, const float_t d[], uint16_t n)
{
  float_t res = d[n];  /* where n is the maximum coefficient index. Same as the C index. */

  while(n)
    res = res * x + d[--n];
    return res;
}
```
I decided to use `_f32` float format for the coefficients (rather than the `_f16` half_t format), for a couple of reasons.

- Accuracy. The `poly()` function uses the `_f24` format (16-bit mantissa) internally for multiply-add. Using IEEE float coefficients (with 24-bit mantissa) provides the most accuracy that the function can consume.
- Performance. Converting the coefficients from `_f32` to `_f24` for calculations is faster than converting from `_f16` to `_f24`, even though more bytes are stored.
- Convenience. There are already tables of `_f32` coefficients proven for math32, so it is much easier to just reuse them.

It is a general function. Any coefficient table can be used, as desired. The coefficients are provided in packed IEEE single precision floating point format, with the coefficients stored in the correct order. The 0th coefficient is stored first in the table. For examples see in the library for `sinf16()`, `atanf16()`, `logf16()` and `expf16()`.

#### _hypot()_

```C
half_t hypotf16 (half_t x, half_t y);
```
The hypotenuse function `hypotf16()` is provided as it is part of the standard maths library. The main use is to further demonstrate how effectively (simply) complex routines can be written using the compact floating point format.

### C Floating Point Functions

The rest of the maths library is derived from source code obtained from the Hi-Tech C Compiler floating point library, the Cephes Math Library Release 2.2, and from the GCC IEEE floating point library. If desired, alternative and extended coefficient matrices can be tested for accuracy and performance.

C sources use `sqrf16(x)` for `x*x` and `1.0/x` (restoring `div`) for a reciprocal. `invsqrtf16` stays for inverse square root (`pow(x, -0.5)` included).

```c
/* Trigonometric functions */
half_t sinf16 (half_t x);
half_t cosf16 (half_t x);
half_t tanf16 (half_t x);
half_t asinf16 (half_t x);
half_t acosf16 (half_t x);
half_t atanf16 (half_t x);

/* Exponential, logarithmic and power functions */
half_t expf16 (half_t x);
half_t exp2f16 (half_t x);
half_t exp10f16 (half_t x);
half_t logf16 (half_t x);
half_t log2f16 (half_t x);
half_t log10f16 (half_t x);
half_t powf16 (half_t x, half_t y);
```

## TIMER (sccz80, Sep 9 2026)

Classic `+test` recipes in `support/benchmarks/*/z88dk-classic/`. Newlib `+z80 -clib=new`. Pure `--math16` (8085 TIMER also `-lmath32_8085` as a helper side-link). Map: `__code_fp_math32_size = $0000`.

| Bench | Clib | CPU | Bytes | Ticks |
|-------|------|-----|------:|------:|
| n-body N=1000, DT=1e-1 | classic | z80 | 4124 | 295,229,389 |
| n-body N=1000, DT=1e-1 | classic | 8085 | 4170 | 344,855,174 |
| n-body N=1000, DT=1e-1 | newlib | z80 | 3306 | 295,229,389 |
| mandelbrot w=h=60 | classic | z80 | 3091 | 788,675,466 |
| mandelbrot w=h=60 | classic | 8085 | 3301 | 955,053,921 |
| mandelbrot w=h=60 | newlib | z80 | 2260 | 788,675,466 |
| spectral-norm N=100 | classic | z80 | 3709 | 2,536,762,681 |
| spectral-norm N=100 | classic | 8085 | 3948 | 2,465,495,200 |

No published newlib spectral math16 row. Full RESULT blocks: those `readme.txt` files.

## Licence

Copyright (c) 2020 Phillip Stevens

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
