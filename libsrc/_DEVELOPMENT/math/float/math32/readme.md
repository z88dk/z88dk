
## z88dk IEEE Floating Point Package - `math32`

This is the z88dk 32-bit IEEE-754 (mostly) standard m32 floating point maths package, designed to work with the SCCZ80 and ZSDCC IEEE-754 (mostly) standard 32-bit interfaces.

Where not written by me, the functions were sourced from:

  * the Digi International Rabbit IEEE-754 32-bit library, copyright (C) 2015 Digi International Inc.
  * the Hi-Tech C 32-bit floating point library, copyright (C) 1984-1987 HI-TECH SOFTWARE.
  * the SDCC 32-bit floating point library, copyright (C) 1991 by Pipeline Associates, Inc, and others.
  * the Cephes Math Library Release 2.2, copyright (C) 1984, 1987, 1989 by Stephen L. Moshier.
  * various Wikipedia references, especially for Newton-Raphson and Horner's Method.

This library is designed for z180, and z80n processors. Specifically, it is optimised for the z180 and [ZX Spectrum Next](https://www.specnext.com/) z80n as these processors have a hardware `16_8x8` multiply instruction that can substantially accelerate floating point mantissa calculation.

This library is also designed to be as fast as possible on the z80 processor. For the z80 it is built on the same core `16_8x8` multiply model, using either an optimal unrolled shift+add algorithm or a faster 512 Byte table lookup algorithm.

*@feilipu, May 2019*

---

## Key Features

  *  All the intrinsic functions are written in z80 assembly language.

  *  All the code is re-entrant.

  *  Register use is limited to the main and alternate set (including af'). NO index registers were abused in the process.

  *  Made for the Spectrum Next. The z80n `mul de` and the z180 `mlt nn` multiply instructions are used to full advantage to accelerate all floating point calculations.

  *  The z80 multiply (without a hardware instruction) is implemented with an unrolled equivalent to the z80n `mul de`, which is designed to have no side effect other than resetting the flag register. An alternate fast table look-up z80 multiply is also implemented.

  *  Mantissa calculations are done with 24-bits and 8-bits for rounding. Rounding is a simple method, but can be if required it can be expanded to the IEEE standard with a performance penalty.

  *  Derived functions are calculated with a 32-bit internal mantissa calculation path, without rounding, to provide the maximum accuracy when repeated multiplications and additions are required. This is equivalent to a fused multiply-add process.

  *  Higher functions are written in C, for maintainability, and draw upon the intrinsic functions including the square root, square, and polynomial evaluation, as well as the 4 standard arithmetic functions.

  *  Power and trigonometric functions' accuracy and speed can be traded by managing their polynomial series coefficient tables and algorithms. More coefficients and iterations provides higher accuracy at the expense of performance. A combination of the Cephes Math library, and the Hi-Tech C library coefficients are provided by default. Alternative coefficient tables can be implemented without impacting the code.

  *  The square root (through the inverse square root function) is seeded using the Quake magic number method, with three Newton-Raphson iterations for accuracy. Again, accuracy and speed can be traded depending on the application by removing one or two iterations, for example for game usage.

## IEEE-754 Floating Point Format

The z88dk floating point format (compatible with Intel/ IEEE, etc.) is as follows:

```
  dehl = seeeeeee emmmmmmm mmmmmmmm mmmmmmmm (s-sign, e-exponent, m-mantissa)
```
stored in memory with the 4 bytes reversed from shown above.

```
    s - 1 negative, 0 positive
    e - 0-255 indicating the exponent
    m - mantissa 23 bits, with implied 24th bit which is always 1
```
The mantissa, when the hidden bit is added in, is 24-bits long and has a value in the range of in decimal of 1.000 to 1.9999...

To match the Intel 8087 or IEEE-754 32-bit format we use bias of 127.

Examples of numbers:

```
  sign  exponent     mantissa
    0   01111110 (1) 10000....    1.5 * 2 ^ (-1) =  0.75
    0   01111111 (1) 10000....    1.5 * 2 ^ ( 0 )=  1.50
    1   10000000 (1) 10000....   -1.5 * 2 ^ ( 1 )= -3.00
    0   10000110 (1) 01100100010..               =178.25
    x   00000000     000... zero (plus or minus)
    0   11111111 (1) 000... positive infinity
    1   11111111 (1) 000... negative infinity
```
This floating point package is loosely based on IEEE-754. We maintain the packed format, but we do not support denormal numbers or the round to even convention.  Both of these features could be added in the future with some performance penalty.

```
  IEEE floating point format: 	seeeeeee emmmmmmm mmmmmmmm mmmmmmmm

  represents  e>0             -> (-1)^s * 2^e * (0x800000 + m)/0x800000
              e=0             -> (-1)^s * 2^e * m/0x800000
              e=0xff & m=0    -> (-1)^s * INF
              e=0xff & m!=0   -> (-1)^s NAN
```
Where s is the sign, e is the exponent and m is bits 22-0 of the mantissa. z88dk m32 assumes any number with a zero exponent is zero.

IEEE assumes bit 23 of the mantissa is 1 except where the exponent is zero.

IEEE-754 specifies rounding the result by a process of round to even. z88dk m32 uses one guard bit and a sticky bit to round a result per the following tables.

Both results are free of bias with IEEE method having a slight edge with rounding error.

```
-------------------------------------------------------------------------
    IEEE round to nearest:

    b g s  (b=lsbit g=guard s=sticky)
    0 0 0  exact
    0 0 1  -.001
    0 1 0  -.01
    0 1 1  +.001
    1 0 0	exact
    1 0 1  -.001
    1 1 0  +.01
    1 1 1  +.001
-------------------------------------------------------------------------

-------------------------------------------------------------------------
    This z88dk m32 library rounds the number using a single sticky bit
    which uses the lsb[7] of the of the 32-bit result from any
    intrinsic calculation:

    b s  (b=lsb[7] s=sticky)
    0 0		exact
    0 1		+.01
    1 0		exact
    1 1		-.01
-------------------------------------------------------------------------
```


## IEEE Floating Point Expanded Mantissa Format

An expanded 32-bit internal mantissa is used to calculate derived functions. This is to provide increased accuracy for the Newton-Raphson iterations, and the Horner polynomial expansions.

This format is provided for both the multiply and add intrinsic internal 32-bit mantissa functions, from which other functions are derived.

```
  unpacked floating point format: exponent in b, sign in c[7], mantissa in dehl

  bcdehl =  eeeeeeee s....... 1mmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm (s-sign, e-exponent, m-mantissa)

```

## Calling Convention

The z88dk m32 library uses the sccz80 standard register and stack calling convention, but with the standard c parameter passing direction. For sccz80 the first or right hand side parameter is passed in DEHL, and the second or LHS parameter is passed on the stack. For zsdcc all parameters are passed on the stack, from right to left. For both compilers, where multiple parameters are passed, they will be passed on the stack.

The intrinsic functions, written in assembly, assume the sccz80 calling convention, and are by default `__z88dk_callee`, which means that they will consume values passed on the stack, returning with the value in DEHL.

```
     LHS STACK - RHS DEHL -> RETURN DEHL

    ; add two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'


    ; evaluation of a polynomial function
    ;
    ; float polyf (float x, float d[], uint16_t n);
    ;
    ; enter : stack = uint16_t n, float d[], float x, ret
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'
```
## Directory Structure

The library is laid out in these directories.

### z80

Contains the assembly language implementation of the maths library.  This includes the maths functions expected by the C11 standard and various low level functions necessary to implement a complete float package accessible from assembly language.  These functions are the intrinsic `math32` functions.

### c

Contains the trigonometric, logarithmic, power and other functions implemented in C. Currently, compiled versions of these functions are prepared and saved in `c/asm` to be assembled and built as required.

### c/sdcc and c/sccz80

Contains the zsdcc and the sccz80 C compiler interface and is implemented using the assembly language interface in the z80 directory. Float conversion between the math32 IEEE-754 format and the format expected by zsdcc and sccz80 occurs here.

### lm32

Glue that connects the compilers and standard assembly interface to the `math32` library.  The purpose is to define aliases that connect the standard names to the math32 specific names.  These functions make up the complete z88dk `math32` maths library that is linked against on the compile line (as in `-lmath32` or `-lmath32_fast`) or for the z180 and z80n (`-lmath32_z180` or `-lmath32_z80n`).

## Function Discussion

There are essentially three different grades of functions in this library. Those written in assembly code in the expanded floating point domain, where the sign, exponent, and mantissa are handled separately. Those written in assembly code, in the floating point domain but using intrinsic functions, where floating point numbers are passed as expanded 6 byte values. And those written in C language.

The expanded floating point domain is a useful tool for creating functions, as complex functions can be written quite efficiently without needing to manage details (which are best left for the intrinsic functions). For a good example of this see the `poly()` function.

### Intrinsic Assembly Functions

There are several assembly intrinsic functions.

```c
float __fsadd (float, float) __z88dk_callee;
float __fssub (float, float) __z88dk_callee;
float __fsmul (float, float) __z88dk_callee;
```
Using these intrinsic functions (and the compact assembly square root and polynomial functions) it is possible to build efficient C language complex functions.

Although some algorithms from the Digi International functions remain in these intrinsic functions, they have been rewritten to exploit the z180 and z80n 8-bit multiply hardware capabilities, rather than the 16-bit capabilities of Rabbit processors. Hence the relationship is only of descent, like "West Side Story" is derived from "Romeo and Juliet".

For the z80 CPU, with no hardware multiply, a replica of the z80n instruction `mul de` was created. Although the existing z88dk integer multiply routines could have been used, it is believed that since this routine is the heart of the entire library, it was worth optimising it for speed and to provide functional equivalence to the z80n hardware multiply instruction to simplify code maintenance.

The `z80_mulu_de` has zero argument detection, leading zero detection, and is unrolled. With the exception of preserving `hl`, for equivalency with z80n `mul de`, it should be the fastest `16_8x8` linear multiply possible on a z80.

In the search for performance, an alternate table driven `16_8x8` multiply function was created. This function uses a 512 Byte table containing the 16-bit square of 8-bit numbers, to substantially improve the multiply z80 performance. Alternate mantissa routines were written to suit this fast multiply function, and they are used where necessary.

To calculate the 24-bit mantissa a special `mulu_32h_24x24` function has been built using 8 multiplies, the minimum number of `16_8x8` multiply terms. It is much more natural for the z80 to work in `16_8x8` multiplies than the Rabbit's `32_16x16` multiply. It is not a "correct" multiply, in that all terms are calculated and carry forward is considered. The lowest term is not calculated, as it doesn't impact the 32-bit result. The lower 16-bits of the result are simply truncated, leaving a further 8-bits for mantissa rounding within the calling function. The resulting `mulu_32h_24x24` could be the fastest way to calculate an IEEE sized mantissa on a z80, z180, & z80n.

By providing a specific square function, all squaring (found in square root, trigonometric functions) can use the `_fssqr` or the equivalent C version. This means that the inverse `_fsinvsqrt` function uses `_fssqr` 5 multiplies in its `32h_24x24` mantissa calculation, in some situations, instead of 8 multiplies with the normal `_fsmul` function, and also avoids the need to use the alternate register set.

#### mulu_z80_de and zero detection

Zero detection is used in both the unrolled shift+add and the table driven `mulu_z80_de` options, and leading zero removal is implemented for the unrolled shift+add `mulu_z80_de` function. But one could question more generally about whether zero detection in the mantissa calculation is worth it or not?

A lot of "integer like" decimal or their binary equivalent numbers have "short" mantissas, when represented in floating point. If we call a 24-bit mantissa made up of three bytes "abc", then quite often the b and c bytes end up being zero. I think this is a common case. Handling these with zero detection will be a big win, making many `mulu_z80_de` multiplies very fast (because the result is zero).

Of course the other side of the argument is that integers should be handled by the integer library, and that calculating a 8 iteration polynomial estimation for `logf()` (for example) will never have zeros in it, so carrying zero detection overhead for short mantissa floats is just wasteful.

When benchmarking the library, using the spectral-norm example, it was found that for about 26% of `mulu_z80_de` function calls an early exit was achieved because of a zero multiplier or multiplicand. Specifically 4.94 million `zeroe` exits and 4.42 million `zerod` exits, from 34.6 million function entries. This one benchmark is not everything, but it does show the value of zero detection.

#### mulu_32h_32x32

The `mulu_32h_32x32` provides just the high order bytes from a 32-bit multiply calculation for the `_fsdiv` Newton-Raphson iteration. In this iteration calculation it is important to have access to the full 32-bits (rather than just 24-bits for normal mantissa calculations).

The implementation of the `mulu_32h_32x32` is not a "correct" multiplication as the lower order bytes are not included in the carry calculation, for efficiency reasons. The calculation begins at the 3rd byte (of 8), and this byte provides carry bits into the 4th byte. Further rounding from the third byte is applied to the 4th byte. There are 11 multiplications required for this function.

By calculating 3rd through to 7th bytes, but returning only byte 4 through 7, there is only maximally a small error in the least significant nibble of the 32-bit mantissa, which is discarded after rounding to 24-bit precision anyway. Doing this avoids calculating the 0th through 2nd bytes, which saves 5 `16_8x8` multiply operations, and the respective word push and pop baggage.

#### _fsadd and _fssub

These functions are closely related to the original Digi International functions.

As add and subtract rely heavily on bit shifting across the mantissa, these functions establish a tree of byte and nybble shifting, to provide the best performance. Nybble shifting is intrinsic to the Rabbit processor, but this nybble based algorithm also works effectively for the z80 processor with little overhead.

#### _fsmul and _fssqr

The multiply function is implemented with a `mulu_32h_24x24` mantissa calculation, that optimises (minimises) the number of `16_8x8` multiplies required, using either hardware instructions from the z180 and z80n, or the z80 equivalent function.

The mantissa multiplication is not a "correct" multiply, as not all carry bits are passed into the returned bytes. The low order mantissa term is not calculated and the low order bytes are simply truncated. The lower 8-bits of the 32-bit return can be used for rounding the 24-bit mantissa. This method minimises the number of `16_8x8` multiplies required to generate a correct 24-bit mantissa.

A simple rounding method is used, but a more sophisticated method IEEE compliant method could be applied as needed.

The square function is related to the multiply function, but is simplified by ignoring the sign bit, and reducing the number of `16_8x8` multiplies from 8 down to 5. A simplified mantissa calculation function is used for this purpose. As the square is used in the tangent, hypotenuse, and inverse square root calculation, having it available is a good optimisation.


### Derived Floating Point Functions

These functions are implemented in assembly language but they utilise the intrinsic assembly language functions to provide their returns. The use of the 32-bit mantissa expanded floating point format functions to implement the derived functions means that their accuracy is maintained.

```c
float __fssqr (float, float) __z88dk_fastcall;
float __fsinv (float, float) __z88dk_fastcall;
float __fsdiv (float, float) __z88dk_callee;

float sqrf(float a) __z88dk_fastcall;
float sqrtf(float a) __z88dk_fastcall;
float invsqrtf(float a) __z88dk_fastcall;

float fabsf(float x) __z88dk_fastcall;
float frexpf(float x, int *pw2) __z88dk_callee;
float ldexpf(float x, int pw2) __z88dk_callee;

float hypotf(float x, float y) __z88dk_callee;
float polyf(const float x, const float d[], uint16_t n) __z88dk_callee;
```
#### _fsdiv and _fsinv

The divide function is implemented by first obtaining the inverse of the divisor, and then passing this result to the multiply instruction, so the intrinsic function is actually finding the inverse. This can be used to advantage where a function requires only an inverse, this can be returned saving the multiplication associated with the divide.

The Newton-Raphson method is used for finding the inverse, using full 32-bit expanded mantissa multiplies and adds for accuracy. Three N-R orthogonal iterations provide an accurate result for the IEEE-754 mantissa, at the expense of some performance.

#### sqrtf() and invsqrt()

Recently, in the Quake video game, a novel method of seeding the Newton-Raphson iteration for the inverse square root was invented. This fancy process is covered in detail in [Lomont 2003](http://www.lomont.org/Math/Papers/2003/InvSqrt.pdf) and the suggested magic number `0x5f375a86`, better than was used by the original Quake game, was implemented.

Following this magic number seeding and traditional Newtwon-Raphson iterations, using the `sqrf()` function as appropriate, an accurate inverse square root `infsqrtf()` is produced. The square root `sqrtf()` is then obtained by multiplying the number by its inverse square root.

Two N-R iterations produce 5 or 6 significant digits of accuracy. Greater accuracy, approaching 7 significant digits for this library, has been obtained by increasing the Newton-Raphson iterations to 3 cycles at the expense of performance. Also, as in the original Quake game, 1 N-R iteration produces a good enough answer for most applications, and is substantially faster.

#### fabsf(), frexpf() and ldexpf()

For some functions it is easiest to work with IEEE floating point numbers in assembly. For these three functions simple assembly code produces the result required effectively.

The sccz80 compiler has been upgraded to issue `ldexpf()` instructions where power of 2 multiplies (or divides) are required. This means that for example `X/2` is calculated as a decrement of the exponent byte rather than calculating a full divide, saving hundreds of cycles. For other compilers there are `mul2f()` and `div2f` functions available to handle simple power of two issues.

#### polyf()

All of the higher functions are implemented based on Horner's Method for polynomial expansion. Therefore to evaluate these functions efficiently, an optimised `poly()` function has been developed, using full 32-bit expanded mantissa multiplies and adds for accuracy.

This function reads a table of coefficients stored in "ROM" and iterates the specified number of iterations to produce the result desired.

It is a general function. Any coefficient table can be used, as desired. The coefficients are provided in packed IEEE floating point format, with the coefficients stored in the correct order. The 0th coefficient is stored first in the table. For examples see in the library for `sinf()`, `tanf()`, `logf()` and `expf()`.

#### hypotf()

The hypotenuse function is provided as it is part of the standard maths library. The main use is to further demonstrate how effectively (simply) complex routines can be written using the compact floating point format.

### C Floating Point Functions

The rest of the maths library is derived from source code obtained from the Hi-Tech C Compiler floating point library, and from the GCC IEEE floating point library.

The Hi-Tech C Compiler floating point library is known for its performance, but not for its accuracy. This may be related to the limited number of coefficients used in the polynomial expansion used for calculating its results.

If desired, alternative and extended coefficient matrices can be tested for accuracy and performance.

```c
/* Trigonometric functions */
float sinf(float x) __z88dk_fastcall;
float cosf(float x) __z88dk_fastcall;
float tanf(float x) __z88dk_fastcall;
float asinf(float x) __z88dk_fastcall;
float acosf(float x) __z88dk_fastcall;
float atanf(float x) __z88dk_fastcall;
float atan2f(float x, float y);

/* Hyperbolic functions */
float sinhf(float x) __z88dk_fastcall;
float coshf(float x) __z88dk_fastcall;
float tanhf(float x) __z88dk_fastcall;

/* Exponential, logarithmic and power functions */
float expf(float x) __z88dk_fastcall;
float logf(float x) __z88dk_fastcall;
float log10f(float x) __z88dk_fastcall;
float powf(float x, float y);
float hypotf(float x, float y);

/* Nearest integer, absolute value, and remainder functions */
float ceilf(float x) __z88dk_fastcall;
float floorf(float x) __z88dk_fastcall;
float modff(float x, float * y);
float fmodf(float x, float y);
```
### Accuracy

Generally the intrinsic functions are accurate within 1-2 counts of the floating mantissa. However, in certain ranges of certain functions the relative accuracy is much less do to the intrinsic properties of floating point math. Accuracy expressed in counts of the floating mantissa is relative accuracy - i.e. relative to the size of the number. Absolute accuracy is the absolute size of the error - e.g. .000001. The derivative functions, computed as combinations of the basic functions, typically have larger error because the errors of 2 or more basic functions are added together in some fashion.

If the value of the function depends on the value of the difference of 2 floating point numbers that are close to each other in value, the relative error generally becomes large, although the absolute error may remain well bounded. Examples are the logs of numbers near 1 and the sine of numbers near pi. For example, if the argument of the sine function is a floating point number is close to pi, say 5 counts of the mantissa away from pi and it is subtracted from pi the result will be a number with only 3 significant bits. The relative error in the sine result will be very large, but the absolute error will still be very small. Functions with steep slopes, such as the exponent of larger numbers will show a large relative error, since the relative error in the argument is magnified by the slope.

The addition / subtraction process is "correct", and this result should be identical to m48 within the significant digits of IEEE-754.

The division process relies on N-R estimation. There is an analysis of the number iterations, based on the convergence of N-R estimation, required to derive sufficent significant bits for a correct IEEE 24-bit mantissa and I believe that using 3 iterations and the 32-bit internal mantissa calculation this outcome is achieved.

The square root calculation also relies on N-R and is therefore an estimate. With the 3 iterations currently implemented the estimate is also accurate to the requirement of the IEEE 24-bit mantissa. With 1 iteration the result is good for 3D graphics in games and not much else.

The rest of the derived power and trigonometric functions rely on the polynomial expansion process and will only be as accurate as the algorithms and coefficients that are fed into the process. I've used those algorithms and coefficients found in the Hi-Tech C library and the Cephes Math library. I guess they got them mostly right. Someone with a mathematical background might be interested to calculate better coefficients at some stage.

### Execution speed

Some [benchmarking](https://github.com/z88dk/z88dk/wiki/Classic--Maths-Libraries#benchmarks) has been completed and, as expected, the z180 and z80n "Spectrum NEXT" results show substantial improvements over other floating point libraries. For the z80 some benchmarks are faster than alternatives, but others are worse. More information on this will be added as experience grows.

Careful use of the intrinsic functions can result in significant performance improvement. For example, the n-body benchmark can be optimised by the use of intrinsic math32 functions of `invsqrt()` and `sqr()`, to produce a significant improvement. See `(opt)` results below.

```C
#ifdef __MATH_MATH32
      inv_distance = invsqrt(sqr(dx) + sqr(dy) + sqr(dz));
#else
      inv_distance = 1.0/sqrt(dx * dx + dy * dy + dz * dz);
#endif
```
And we get about a __25% improvement__ for the n-body benchmark.
Most of this gain is created by directly using the `invsqrt()` function. The optimisation effectively provides `y=invsqrt(x)`, instead of indirectly calculating `y=l_f32_inv(x*invsqrt(x))` in the normal situation.

Library          | Compiler | Value 1       | Value 2       | Ticks
-|-|-|-|-
correct values   | -->      | -0.169075164  | -0.169087605
math48           | sccz80   | -0.169075164  | -0.169087605  | 2_402_023_498
mbf32            | sccz80   | -0.169916810  | -0.169916810  | 1_939_334_701
bbcmath          | sccz80   | -0.169075164  | -0.169087604  | 1_655_789_776
math32           | sccz80   | -0.169075264  | -0.169086709  | _1_400_110_112_
math32 (opt)     | sccz80   | -0.169075264  | -0.169086709  | __1_040_434_814__
math32_fast      | sccz80   | -0.169075264  | -0.169086709  | _1_199_895_142_
math32_fast (opt)| sccz80   | -0.169075264  | -0.169086709  | __0_891_891_922__
math32_z180      | sccz80   | -0.169075264  | -0.169086709  | _0_562_947_777_
math32_z180 (opt)| sccz80   | -0.169075264  | -0.169086709  | __0_428_653_933__
math32_z80n      | sccz80   | -0.169075264  | -0.169086709  | _0_578_058_768_
math32_z80n (opt)| sccz80   | -0.169075264  | -0.169086709  | __0_442_608_201__


---
