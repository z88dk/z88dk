
## z88dk IEEE Floating Point Package - `math16`

This is the z88dk 16-bit IEEE-754 standard math16 half precision floating point maths package, designed to work with the SCCZ80 IEEE-754 half precision 16-bit interfaces.
  
This library is designed for z80, z180, and z80n processors. Specifically, it is optimised for the z180 and [ZX Spectrum Next](https://www.specnext.com/) z80n as these processors have a hardware `16_8x8` multiply instruction that can substantially accelerate the floating point mantissa calculation. This library is also designed to be as fast as possible on the z80 processor.

The specialised nature of 16-bit floating point implies that this is an adjunct or special purpose library. It can be used to accelerate the calculation of floating point, where the results are only needed to 3.5 significant digits. Applications can include video games, or neural networks, for example.

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

The z88dk half precision floating point format (compatible with Intel/ IEEE, etc.) is as follows:

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

An expanded 16-bit internal mantissa is used to calculate all functions. 16-bit mantissa calculations are natural for the z80, and this provides enhanced accuracy for repeated calculations required for derived functions. Specifically, this is to provide increased accuracy for the Newton-Raphson iterations, and the Horner polynomial expansions. The inverse function, divide function, fused multiply add function and the poly function are also implemented using the expanded 8-bit exponent and 16-bit mantissa internal path.

This format is provided for both the multiply and add intrinsic internal 16-bit mantissa functions, from which other functions are derived, and is referred to as `f24` in the library.

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

### c/sdcc and c/sccz80

Contains the zsdcc and the sccz80 C compiler interface and is implemented using the assembly language interface in the z80 directory. Float conversion between the math16 IEEE-754 format and the format expected by zsdcc and sccz80 occurs here.

### lm16

Glue that connects the compilers and standard assembly interface to the `math16` library.  The purpose is to define aliases that connect the standard names to the math16 specific names.  These functions make up the complete z88dk `math16` maths library that is linked against on the compile line as `-lmath16`.

An alias is provided to simplify usage of the library. `--math16` provides all the required linkages and definitions, as a simple command line alternative to `-lmath16 -Cc-D__MATH_MATH16 -D__MATH_MATH16 -pragma-define:CLIB_16BIT_FLOAT=1`.

## Function Discussion

There are essentially two different grades of functions in this library. Those intrinsic functions written in assembly code in the expanded floating point domain, where the sign, exponent, and mantissa are handled separately. And those written in assembly code, in the floating point domain but using intrinsic functions, where floating point numbers are passed as expanded 4 byte values using the internal `f24` format.

The expanded floating point format is a useful tool for creating functions, as complex functions can be written quite efficiently without needing to manage details (which are best left for the intrinsic functions). For a good example of this see the `inv()`, `fma()` and the `poly()` functions.

For the `poly()` function, I decided to use `_f32` float format for the coefficients (rather than `_f16` half format), for a couple of reasons.

```c
half_t polyf16(const half_t x, const float_t d[], uint16_t n)
{
  float_t res = d[n];  /* where n is the maximum coefficient index. Same as the C index. */

  while(n)
    res = res * x + d[--n];
    return res;
}
```

- Accuracy. The `poly()` function uses the `_f24` format (16-bit mantissa) internally for multiply-add. Using IEEE float coefficients (with 24-bit mantissa) provides the most accuracy that the function can consume.
- Performance. Converting the coefficients from `_f32` to `_f24` for calculations is faster than converting from `_f16` to `_f24`, even though more bytes are stored.
- Convenience. There are already tables of `_f32` coefficients proven for math32, so it is much easier to just reuse them.

## Licence

Copyright (c) 2020 Phillip Stevens

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

