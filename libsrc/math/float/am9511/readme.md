
## z88dk Am9511A IEEE Floating Point Package - `am9511`

This is the z88dk 32-bit IEEE-754 (mostly) standard Am9511A floating point maths package, designed to work with the SCCZ80 and ZSDCC compiler IEEE-754 (mostly) standard 32-bit floating point interfaces.

This library is designed expressly to support the AMD Am9511A (Intel 8231A) Arithmetic Processor Unit. The initial implementation is for the Am9511 APU Module, designed for the RC2014, with either z80 or 8085 CPU Module. Later expansion will support the DAI and other classic z80 and 8085 machines with the Am9511A APU.

*@feilipu, August 2020*

---

## Key Features

  *  All the intrinsic functions are written in z80 or 8085 assembly language.

  *  All the code is re-entrant.

  *  Register use is limited to the z80 main and alternate set. NO index registers were abused in the process.

  *  The APU instructions are used to full advantage to accelerate all floating point and long calculations.

  *  Format conversions between integer, long and float are done by the APU.

## Am9511 Floating Point Format

Automatic conversion from the Am9511A hardware floating point format and the IEEE-754 single precision floating point format is included. The Am9511A format is used only when loading and unloading the APU. All internal floating point uses IEEE-754 single precision.

The format for floating point values in the Am9511A is given below. The mantissa is expressed as a 24-bit (fractional) value; the exponent is expressed as an unbiased two's complement 7-bit value having the range of -64 to +63. The most significant bit is the sign of the mantissa (0 = Positive, 1 = negative), for a total of 32 bits. The binary point is assumed to be to the left of the most significant mantissa bit (bit 23). All floating point values must be normalised. Bit 23 must always be equal to 1, except for the value zero, which is represented by all zeros.

```
  dehl =  seeeeeeee 1mmmmmmm mmmmmmmm mmmmmmmm (s-sign, e-exponent, m-mantissa)
```
The range of values that can be expressed in this format is +/-(2.7x10^-20 to 9.2x10^18) and zero.

## IEEE-754 Floating Point Format

The z88dk single precision 32-bit floating point format (compatible with Intel / IEEE, etc.) is as follows:

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
    x   00000000     xxx... zero (sign positive or negative, mantissa not relevant)
    x   11111111     000... infinity  (sign positive or negative, mantissa zero)
    x   11111111     xxx... not a number (sign positive or negative, mantissa non zero)
```
This floating point package is loosely based on IEEE-754. We maintain the packed format, but we do not support denormal numbers or the round to even convention.

```
  IEEE floating point format: 	seeeeeee emmmmmmm mmmmmmmm mmmmmmmm

  represents  e>0             -> (-1)^s * 2^e * (0x800000 + m)/0x800000
              e=0             -> (-1)^s * 2^e * m/0x800000
              e=0xff & m=0    -> (-1)^s * INF
              e=0xff & m!=0   -> (-1)^s NAN
```
Where s is the sign, e is the exponent and m is bits 22-0 of the mantissa. The z88dk `am9511` library assumes any number with a zero exponent is positive or negative zero.

IEEE-754 assumes bit 23 of the mantissa is 1 except where the exponent is zero.

## Calling Convention

The z88dk am9511 library uses the sccz80 standard register and stack calling convention, but with the standard c parameter passing direction. For sccz80 the first or the right hand side parameter is passed in DEHL, and the second or LHS parameter is passed on the stack. For zsdcc all parameters are passed on the stack, from right to left. For both compilers, where multiple parameters are passed, they will be passed on the stack.

The intrinsic functions, written in assembly, assume the sccz80 calling convention, and are by default `__z88dk_fastcall` or `__z88dk_callee`, which means that they will consume values passed in the DEHL registers, or on the stack respectively, returning with the value in DEHL.

```
     LHS STACK - RHS DEHL -> RETURN DEHL

    ; add two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

```
## Directory Structure

The library is laid out in these directories.

### asm z80 / 8085

Contains the assembly language implementation of the maths library. This includes the maths functions expected by the C11 standard and various low level functions necessary to implement a complete float package accessible from assembly language. These functions are the intrinsic `am9511` functions. Where no differentiation between z80 and 8085 implementation is required (i.e. 8080 compatible) the functions are in the base directory. Otherwise the functions are provided in either z80 or 8085 specific directory, and are compiled according to the library requirements.

### c

Contains the remaining hyperbolic, logarithmic, power and other functions implemented in C. Currently, compiled versions of these functions are prepared and saved in `c/asm` to be assembled and built as required.

### c/sdcc and c/sccz80

Contains the zsdcc and the sccz80 C compiler interface and is implemented using the assembly language interface in the z80 directory. Calling convention conversion between the am9511 library and the format expected by the compilers occurs here.

### lam32

Glue that connects the compilers and standard assembly interface to the `am9511` library. The purpose is to define aliases that connect the standard names to the am9511 specific names. These functions make up the complete z88dk `am9511` maths library that is linked against on the compile line as `-lam9511`.

An alias is provided to simplify usage of the library. `--am9511` provides all the required linkages and definitions, as a simple alternative to `-Cc-fp-mode=ieee -Cc-D__MATH_AM9511 -D__MATH_AM9511 -lam9511 -pragma-define:CLIB_32BIT_FLOATS=1`.

For 8085 support using the classic library an alternative alias is provided to simplify usage of the library. `--math-am9511_8085` provides all the required linkages and definitions. This format aligns with common practice for classic maths library aliases.

## Function Discussion

There are essentially three different grades of functions in this library. The inherent long and floating point functions supported by the Am9511A. Those written in assembly code in the floating point domain to support the intrinsic functions. And those written in C language, and compiled in advance.

Using the Am9511A we can build complex functions quite efficiently without needing to manage details (which are best left for the intrinsic functions). For a good example of this see the `hypot()` function.

### Intrinsic Am9511A Functions

In addition to the standard arithmetic functions (add, subtract, multiply divide) the Am9511A supports a number of transcendental functions listed below.

```C
/* Trigonometric functions */
float sin (float x);
float cos (float x);
float tan (float x);
float asin (float x);
float acos (float x);
float atan (float x);

/* Exponential, logarithmic and power functions */
float exp (float x);
float log (float x);
float log10 (float x);
float pow (float x, float y);
```

#### Special Functions

For some functions it is easiest to work with IEEE floating point numbers in assembly. For these functions simple assembly code produces the result required effectively.

```C
float fabs (float x);
float ceil (float x);
float floor (float x);
float frexp (float x, int *pw2);
float ldexp (float x, int pw2);
```

The sccz80 compiler has been upgraded to issue `ldexp()` instructions where power of 2 multiplies (or divides) are required. This means that for example `x/2` is calculated as a decrement of the exponent byte rather than calculating a full divide, saving hundreds of cycles.


```C
float div2 (float x);
float mul2 (float x);
float mul10u (float x);
```
For sccz80, sdcc and in assembly there are `mul2()` and `div2()` functions available to handle simple power of two multiplication and division, as well as `ldexp()`. Also, a `mul10u()` function provides a fast `y = 10 * |x|` result. These functions are substantially faster than a full multiply equivalent, and combinations can be used to advantage. For example using `div2( mul10u( mul10u( x )))` is substantially faster than `y = 50.0 * x` on any CPU type.


#### _hypot()_

```C
float hypot (float x, float y);
```
The hypotenuse function `hypot()` is provided as it is part of the standard maths library. The main use is to further demonstrate how effectively (simply) complex routines can be written using the Am9511A APU.

### C Floating Point Functions

The rest of the maths library is derived from source code obtained from the Cephes Math Library Release 2.2, and from the GCC IEEE floating point library. Or derived from the standard Am9511A function by conversion.

```C
/* Trigonometric functions */
float atan2f (float x, float y);

/* Hyperbolic functions */
float sinh (float x);
float cosh (float x);
float tanh (float x);
float asinh (float x);
float acosh (float x);
float atanh (float x);

/* Exponential, logarithmic and power functions */
float exp2 (float x);
float exp10 (float x);
float log2 (float x);

/* Nearest integer, absolute value, and remainder functions */
float modf (float x, float *y);
float fmod (float x, float y);
```
### Accuracy

Generally the intrinsic functions are accurate within 1-2 counts of the floating mantissa. However, in certain ranges of certain functions the relative accuracy is much less do to the intrinsic properties of floating point math. Accuracy expressed in counts of the floating mantissa is relative accuracy - i.e. relative to the size of the number. Absolute accuracy is the absolute size of the error - e.g. .000001. The derivative functions, computed as combinations of the basic functions, typically have larger error because the errors of 2 or more basic functions are added together in some fashion.

If the value of the function depends on the value of the difference of 2 floating point numbers that are close to each other in value, the relative error generally becomes large, although the absolute error may remain well bounded. Examples are the logs of numbers near 1 and the sine of numbers near pi. For example, if the argument of the sine function is a floating point number is close to pi, say 5 counts of the mantissa away from pi and it is subtracted from pi the result will be a number with only 3 significant bits. The relative error in the sine result will be very large, but the absolute error will still be very small. Functions with steep slopes, such as the exponent of larger numbers will show a large relative error, since the relative error in the argument is magnified by the slope.

## Execution speed

Some benchmarking has been completed using the RC2014 APU Module and, as expected, the results show substantial improvements over other floating point libraries.

To compare to the [standardised benchmark results](https://github.com/z88dk/z88dk/wiki/Classic--Maths-Libraries#benchmarks) (Z80 @ 4MHz), the times below must be multiplied by 1.8432.

#### whetstone

Z88DK March 3, 2022<br>
zsdcc 4.2.0 / new c library

zsdcc / newlib / **math48 - 127 seconds**

`zcc +rc2014 -subtype=cpm -SO3 --max-allocs-per-node400000 -DPRINTOUT whetstone.c -o whetstone -lm -m -create-app`

zsdcc / newlib / **math32 - 82 seconds**

`zcc +rc2014 -subtype=cpm -SO3 --max-allocs-per-node400000 -DPRINTOUT whetstone.c -o whetstone --math32 -m -create-app`

zsdcc / newlib / **am9511 - 30 seconds**

`zcc +rc2014 -subtype=cpm -SO3 --max-allocs-per-node400000 -DPRINTOUT whetstone.c -o whetstone --am9511 -m -create-app`

**8085** / sccz80 / classic / **am9511 - 30 seconds**

`zcc +cpm -clib=8085 -O2 -DSTATIC -DPRINTOUT whetstone.c -o whetstone --math-am9511_8085 -lndos -create-app`


#### spectral-norm

Correct result<br>
1.274219991

Z88DK March 3, 2022<br>
zsdcc 4.2.0 / new c library

zsdcc / newlib / **math32 - 22 minutes 39 seconds**<br>
1.2742190

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 spectral-norm.c -o spectral-norm --math32 -create-app`

zsdcc / newlib / **am9511 - 6 min 20 seconds**<br>
1.2742140

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 spectral-norm.c -o spectral-norm --am9511 -create-app`

Z88DK August 16, 2020<br>
sccz80 / new c library

sccz80 / newlib / am9511 - 5 min 48 seconds<br>
sccz80 / newlib / **am9511 - 5 min 28 seconds** - `--opt-code-speed=inlineints`<br>
1.2742140

`zcc +rc2014 -subtype=cpm -clib=new --opt-code-speed=inlineints -DPRINTF spectral-norm.c -o spectral-norm --am9511 -create-app`

Z88DK January 21, 2022<br>
sccz80 / classic c library

**8085** / sccz80 / classic / **am9511 - 5 min 48 seconds**<br>
1.2742147

`zcc +cpm -clib=8085 -DSTATIC -DPRINTF -O2 spectral-norm.c -o spectral-norm --math-am9511_8085 -lndos -create-app`


#### fasta

Z88DK March 3, 2022<br>
zsdcc 4.2.0 / new c library

zsdcc / newlib / **math48 - 37 seconds**

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 --fsigned-char fasta.c -o fasta -lm -create-app`

zsdcc / newlib / **math32 - 38 seconds**

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 --fsigned-char fasta.c -o fasta --math32 -create-app`

zsdcc / newlib / **am9511 - 15 seconds**

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 --fsigned-char fasta.c -o fasta --am9511 -create-app`


#### n-body

Correct results<br>
-0.169075164<br>
-0.169087605

Z88DK March 3, 2022<br>
zsdcc 4.2.0 / new c library

zsdcc / newlib / **math48 - 308 seconds**<br>
-0.169075117<br>
-0.169158205

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 n-body.c -o n-body -lm -m -pragma-include:zpragma.inc -create-app`

zsdcc / newlib / **math32 - 113 seconds**<br>
-0.169075200<br>
-0.169086800

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 n-body.c -o n-body --math32 -m -pragma-include:zpragma.inc -create-app`

zsdcc / newlib / **am9511 - 76 seconds**<br>
-0.169075100<br>
-0.169080500

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 n-body.c -o n-body --am9511 -m -pragma-include:zpragma.inc -create-app`

 sccz80 / newlib / **am9511 - 70 seconds** - `--opt-code-speed=inlineints`<br>
-0.169075100<br>
-0.169080500

`zcc +rc2014 -subtype=cpm -clib=new --opt-code-speed=inlineints -DPRINTF n-body.c -o n-body --am9511 -m -pragma-include:zpragma.inc -create-app`

Z88DK January 21, 2022<br>
sccz80 / classic c library

**8085** / sccz80 / classic / **am9511 - 69 seconds**<br>
-0.169075100<br>
-0.169080500

`zcc +cpm -clib=8085 -DSTATIC -DPRINTF -O2 n-body.c -o n-body --math-am9511_8085 -lndos -create-app`


#### mandelbrot

Z88DK March 3, 2022<br>
zsdcc 4.2.0 / new c library

zsdcc / newlib / **math48 - 431 seconds**

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 mandelbrot.c -o mandelbrot -lm -m -pragma-include:zpragma.inc -create-app`

zsdcc / newlib / **math32 - 169 seconds**

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 mandelbrot.c -o mandelbrot --math32 -m -pragma-include:zpragma.inc -create-app`

zsdcc / newlib / **am9511 - 155 seconds**

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 mandelbrot.c -o mandelbrot --am9511 -m -pragma-include:zpragma.inc -create-app`

