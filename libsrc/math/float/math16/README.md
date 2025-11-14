
## z88dk IEEE Floating Point Package - `math16`

This is the z88dk 16-bit IEEE-754 standard math16 half precision floating point maths package, designed to work with the SCCZ80 IEEE-754 half precision 16-bit interfaces.
  
This library is designed for z80, z180, and z80n processors. Specifically, it is optimised for the z180 and [ZX Spectrum Next](https://www.specnext.com/) z80n as these processors have a hardware `16_8x8` multiply instruction that can substantially accelerate the floating point mantissa calculation. This library is also designed to be as fast as possible on the z80 processor.

The specialised nature of 16-bit floating point implies that this is an adjunct or special purpose maths library. It can be used to accelerate the calculation of floating point, where the results are only needed to 3.5 significant digits. Applications can include video games, or neural networks, for example. Either the math48 (`-lm`) or the math32 (`--math32`) libraries must be used in conjunction with math16 (`--math16`) to provide stdio input and output capabilities.

*@feilipu, May 2020*

---

## Key Features

  *  All the intrinsic functions are written in z80 assembly language.

  *  All the code is re-entrant.

  *  Register use is limited to the main and alternate set (including af'). NO index registers were abused in the process.

  *  Made for the Spectrum Next. The z80n `mul de` and the z180 `mlt nn` multiply instructions are used to full advantage to accelerate all floating point calculations.

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
  unpacked floating point format: exponent right justified in d, sign in e[7],  mantissa in hl

  dehl = eeeeeeeee s....... 1mmmmmmm mmmmmmmm (e-exponent, s-sign, m-mantissa)

```

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
    ; uses  : af, bc, de, hl, af', bc', de', hl'
    
     RETURN HL <- LHS STACK - RHS STACK 

    ; subtract two sdcc half floats
    ;
    ; half f16_sub (half x, half y);
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret
    ;
    ; exit  :    HL = sdcc_half(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'
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
    ; uses  : af, bc, de, hl, af', bc', de', hl'

     RETURN HL <- LHS STACK - RHS STACK

    ; subtract two sdcc half floats
    ;
    ; half f16_sub (half x, half y);
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret
    ;
    ; exit  :    HL = sdcc_half(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'
```


## Directory Structure

The library is laid out in these directories.

### z80

Contains the assembly language implementation of the maths library.  This includes the maths functions expected by the IEEE-754 standard and various low level functions necessary to implement a float package accessible from assembly language.  These functions are the intrinsic `math16` functions.

### c

Contains the trigonometric, logarithmic, power and other functions implemented in C. Currently, compiled versions of these functions are prepared and saved in `c/asm` to be assembled and built as required.

### c/sdcc and c/sccz80

Contains the zsdcc and the sccz80 C compiler interface and is implemented using the assembly language interface in the z80 directory. Float conversion between the math16 IEEE-754 format and the format expected by zsdcc and sccz80 occurs here.

### lm16

Glue that connects the compilers and standard assembly interface to the `math16` library.  The purpose is to define aliases that connect the standard names to the math16 specific names.  These functions make up the complete z88dk math16 library that is linked against on the compile line as `-lmath16`.

An alias is provided to simplify usage of the library. `--math16` provides all the required linkages and definitions, as a simple command line alternative to `-lmath16 -Cc-D__MATH_MATH16 -D__MATH_MATH16`.

## Function Discussion

There are essentially two different grades of functions in this library. Those intrinsic functions written in assembly code in the expanded floating point domain, where the sign, exponent, and mantissa are handled separately. And derived functions, written in assembly code in the floating point domain but using intrinsic functions, where floating point numbers are passed as expanded 4 byte values using the internal `_f24` format.

### Derived Floating Point Functions

These functions are implemented in assembly language but they utilise the intrinsic assembly language functions to provide their returns. The use of the 16-bit mantissa expanded floating point format (`_f24`) functions to implement the derived functions means that their accuracy is maintained.

The expanded floating point format is a useful tool for creating functions, as complex functions can be written quite efficiently without needing to manage details (which are best left for the intrinsic functions). For a good example of this see the `invf16()`, `fmaf16()` and the `polyf16()` functions.

#### _div()_ and _inv()_

```C
half_t invf16 (half_t x);
half_t divf16 (half_t x, half_t y);
```
The divide function is implemented by first obtaining the inverse of the divisor, and then passing this result to the multiply instruction, so the intrinsic function is actually finding the inverse. This can be used to advantage where a function requires only an inverse, this can be returned saving the multiplication associated with the divide.

The Newton-Raphson method is used for finding the inverse, using full 16-bit expanded mantissa multiplies and adds for accuracy. Two N-R orthogonal iterations provide an accurate result for the IEEE-754 half float mantissa.

#### _sqrt()_ and _invsqrt()_

```C
half_t sqrtf16 (half_t x);
half_t invsqrtf16 (half_t x);
```
Recently, in the Quake video game, a novel method of seeding the Newton-Raphson iteration for the inverse square root was invented. This fancy process is covered in detail in [Lomont 2003](http://www.lomont.org/Math/Papers/2003/InvSqrt.pdf) and the suggested magic number `0x5f375a86`, better than was used by the original Quake game, was implemented.

Following this magic number seeding and traditional Newtwon-Raphson iterations an accurate inverse square root `invsqrtf16()` is produced. The square root `sqrtf16()` is then obtained by multiplying the number by its inverse square root.

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

## Licence

Copyright (c) 2020 Phillip Stevens

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

