
## z88dk IEEE Floating Point Package - `math16`

This is the z88dk 16-bit IEEE-754 standard math16 floating point maths package, designed to work with the SCCZ80 IEEE-754 16-bit interfaces.

Where not written by me, the functions were sourced from:

  * [float16 library](https://github.com/artyom-beilis/float16), copywrite (C) 2020 Artyom Beilis.
  * the Hi-Tech C floating point library, copyright (C) 1984-1987 HI-TECH SOFTWARE.
  * the Cephes Math Library Release 2.2, copyright (C) 1984, 1987, 1989 by Stephen L. Moshier.
  * various Wikipedia references, especially for Newton-Raphson and Horner's Method.
  
This library is designed for z80, z180, and z80n processors. Specifically, it is optimised for the z180 and [ZX Spectrum Next](https://www.specnext.com/) z80n as these processors have a hardware `16_8x8` multiply instruction that can substantially accelerate the floating point mantissa calculation.

This library is also designed to be as fast as possible on the z80 processor.

*@feilipu, May 2020*

---

## Key Features

  *  All the intrinsic functions are written in z80 assembly language.

  *  All the code is re-entrant.

  *  Register use is limited to the main and alternate set (including af'). NO index registers were abused in the process.

  *  Made for the Spectrum Next. The z80n `mul de` and the z180 `mlt nn` multiply instructions are used to full advantage to accelerate all floating point calculations.

  *  Mantissa calculations are done with 11-bits and 5-bits for rounding. Rounding is a simple method, but can be if required it can be expanded to the IEEE standard with a performance penalty.

  *  Derived functions are calculated with a 16-bit internal mantissa calculation path, without rounding, to provide the maximum accuracy when repeated multiplications and additions are required. This is equivalent to a fused multiply-add process.

  *  Higher functions are written in C, for maintainability, and draw upon the intrinsic functions including the square root, square, and polynomial evaluation, as well as the 4 standard arithmetic functions.

  *  Power and trigonometric functions' accuracy and speed can be traded by managing their polynomial series coefficient tables and algorithms. More coefficients and iterations provides higher accuracy at the expense of performance. A combination of the Cephes Math library, and the Hi-Tech C library coefficients are provided by default. Alternative coefficient tables can be implemented without impacting the code.

  *  The square root (through the inverse square root function) is seeded using the Quake magic number method, with two Newton-Raphson iterations for accuracy. Again, accuracy and speed can be traded depending on the application by removing one or two iterations, for example for game usage.

## IEEE-754 Floating Point Format

The z88dk floating point format (compatible with Intel/ IEEE, etc.) is as follows:

```
  hl = seeeeemm mmmmmmmm (s-sign, e-exponent, m-mantissa)
```
stored in memory with the 2 bytes reversed from shown above.

```
    s - 1 negative, 0 positive
    e - 0-15 indicating the exponent
    m - mantissa 10 bits, with implied 11th bit which is always 1
```
The mantissa, when the hidden bit is added in, is 11-bits long and has a value in the range of in decimal of 1.000 to 1.9999...

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
This floating point package is loosely based on IEEE-754. We maintain the packed format, but we do not support the round to even convention. 

z88dk math32 assumes any number with a zero exponent is positive or negative zero.
IEEE-754 assumes bit 11 of the mantissa is 1 except where the exponent is zero.


## IEEE Floating Point Expanded Mantissa Format

An expanded 24-bit internal mantissa is used to calculate derived functions. This is to provide increased accuracy for the Newton-Raphson iterations, and the Horner polynomial expansions.

This format is provided for both the multiply and add intrinsic internal 24-bit mantissa functions, from which other functions are derived.

```
  unpacked floating point format: exponent right justified in d, sign in d[7], mantissa in ehl

  dehl =  s00eeeeee 1mmmmmmm mmmmmmmm mmmmmmmm (s-sign, e-exponent, m-mantissa)

```

## Calling Convention

The z88dk math32 library uses the sccz80 standard register and stack calling convention, but with the standard c parameter passing direction. For sccz80 the first or the right hand side parameter is passed in DEHL, and the second or LHS parameter is passed on the stack. For zsdcc all parameters are passed on the stack, from right to left. For both compilers, where multiple parameters are passed, they will be passed on the stack.

The intrinsic functions, written in assembly, assume the sccz80 calling convention, and are by default `__z88dk_fastcall` or `__z88dk_callee`, which means that they will consume values passed on the stack, returning with the value in HL.

```
     LHS STACK - RHS DEHL -> RETURN DEHL

    ; add two sccz80 floats
    ;
    ; enter : stack = sccz80_half left, ret
    ;            HL = sccz80_half right
    ;
    ; exit  :    HL = sccz80_half(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'


    ; evaluation of a polynomial function
    ;
    ; float poly (half x, half d[], uint16_t n);
    ;
    ; enter : stack = uint16_t n, half d[], half x, ret
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'
```
## Directory Structure

The library is laid out in these directories.

### z80

Contains the assembly language implementation of the maths library.  This includes the maths functions expected by the C11 standard and various low level functions necessary to implement a complete float package accessible from assembly language.  These functions are the intrinsic `math16` functions.

### c

Contains the trigonometric, logarithmic, power and other functions implemented in C. Currently, compiled versions of these functions are prepared and saved in `c/asm` to be assembled and built as required.

### c/sdcc and c/sccz80

Contains the zsdcc and the sccz80 C compiler interface and is implemented using the assembly language interface in the z80 directory. Float conversion between the math16 IEEE-754 format and the format expected by zsdcc and sccz80 occurs here.

### lm32

Glue that connects the compilers and standard assembly interface to the `math16` library.  The purpose is to define aliases that connect the standard names to the math16 specific names.  These functions make up the complete z88dk `math16` maths library that is linked against on the compile line as `-lmath16`.

An alias is provided to simplify usage of the library. `--math16` provides all the required linkages and definitions, as a simple alternative to `-Cc-fp-mode=ieee -Cc-D__MATH_MATH16 -D__MATH_MATH16 -lmath16 -pragma-define:CLIB_16BIT_FLOAT=1`.

## Function Discussion

There are essentially three different grades of functions in this library. Those written in assembly code in the expanded floating point domain, where the sign, exponent, and mantissa are handled separately. Those written in assembly code, in the floating point domain but using intrinsic functions, where floating point numbers are passed as expanded 6 byte values. And those written in C language.

The expanded floating point domain is a useful tool for creating functions, as complex functions can be written quite efficiently without needing to manage details (which are best left for the intrinsic functions). For a good example of this see the `poly()` function.

## Licence

Copyright (c) 2020 Artyom Beilis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# TO BE COMPLETED

It supports:

- Basic operations "+", "-", "\*", "/"
- Conversion to/from integer
- Comparison operations

It uses IEEE 754 format. It supports full range of values including +/- inf, nan and subnormal values.
All operations work as expected with the respect of inf/nan values

Only simplest truncation rounding policy implemented, no round to nearest ties to evens provided.

What is expected in future:

- math functions: log/exp, trigonometry etc,
- formatting/parsing functions

## Z80 notes

- All functions are reentrant and relay on alternative set of registers AF', HL', DE', BC', so if your interrupt routines use shadow registers for fast context switching you can't use this library.

### FIX ME

- Some functions is IX for frame pointer, IY is not modified. <<< this XXX
