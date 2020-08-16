
## z88dk Am9511A IEEE Floating Point Package - `am9511`

This is the z88dk 32-bit IEEE-754 (mostly) standard Am9511A floating point maths package, designed to work with the SCCZ80 and ZSDCC IEEE-754 (mostly) standard 32-bit floating point interfaces.

This library is designed expressly to support the AMD Am9511A Arithmetic Processor Unit. The initial implementation is for the Am9511 APU Module, designed for the RC2014. Later expansion will support the DAI, and the YAZ180, and other classic machines with the Am9511A APU.

*@feilipu, August 2020*

---

## Key Features

  *  All the intrinsic functions are written in z80 (or upon selection 8080) assembly language.

  *  All the code is re-entrant.

  *  Register use is limited to the main set. NO index registers or alternate were abused in the process.

  *  Made for the Am9511A. The APU instructions are used to full advantage to accelerate all floating point calculations.

## IEEE-754 Floating Point Format

Automatic conversion from the inherent Am9511A floating point format and the IEEE-754 single precision floating point format is included.

The z88dk single precision 32-bit floating point format (compatible with Intel/ IEEE, etc.) is as follows:

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
This floating point package is loosely based on IEEE-754. We maintain the packed format, but we do not support denormal numbers or the round to even convention.  Both of these features could be added in the future with some performance penalty.

```
  IEEE floating point format: 	seeeeeee emmmmmmm mmmmmmmm mmmmmmmm

  represents  e>0             -> (-1)^s * 2^e * (0x800000 + m)/0x800000
              e=0             -> (-1)^s * 2^e * m/0x800000
              e=0xff & m=0    -> (-1)^s * INF
              e=0xff & m!=0   -> (-1)^s NAN
```
Where s is the sign, e is the exponent and m is bits 22-0 of the mantissa. z88dk am9511 assumes any number with a zero exponent is positive or negative zero.

IEEE-754 assumes bit 23 of the mantissa is 1 except where the exponent is zero.

## Am9511 Floating Point Format

The format for floating point values in the Am9511A is given below. The mantissa is expressed as a 24-bit (fractional) value; the exponent is expressed as an unbiased two's complement 7-bit value having the range of -64 to +63. The most significant bit is the sign of hte mantissa (0 = Positive, 1 = negative), for a total of 32 bits. The binary point is assumed to be to the left of the most significant mantissa bit (bit 23). All floating point values must be normalised. Bit 23 must alwas be equal to 1, execept for the value zero, which is represented by all zeros.

```

  dehl =  seeeeeeee 1mmmmmmm mmmmmmmm mmmmmmmm (s-sign, e-exponent, m-mantissa)

```
The range of values that can be expressed in this format is +/-(2.7x10^-20 to 9.2x10^18) and zero.

## Calling Convention

The z88dk am9511 library uses the sccz80 standard register and stack calling convention, but with the standard c parameter passing direction. For sccz80 the first or the right hand side parameter is passed in DEHL, and the second or LHS parameter is passed on the stack. For zsdcc all parameters are passed on the stack, from right to left. For both compilers, where multiple parameters are passed, they will be passed on the stack.

The intrinsic functions, written in assembly, assume the sccz80 calling convention, and are by default `__z88dk_fastcall` or `__z88dk_callee`, which means that they will consume values passed on the stack, returning with the value in DEHL.

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
    ; float poly (float x, float d[], uint16_t n);
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

Contains the assembly language implementation of the maths library.  This includes the maths functions expected by the C11 standard and various low level functions necessary to implement a complete float package accessible from assembly language.  These functions are the intrinsic `am9511` functions.

### c

Contains the remaining hyperbolic, logarithmic, power and other functions implemented in C. Currently, compiled versions of these functions are prepared and saved in `c/asm` to be assembled and built as required.

### c/sdcc and c/sccz80

Contains the zsdcc and the sccz80 C compiler interface and is implemented using the assembly language interface in the z80 directory. Calling convention conversion between the am9511 library and the format expected by the compilers occurs here.

### lam32

Glue that connects the compilers and standard assembly interface to the `am9511` library.  The purpose is to define aliases that connect the standard names to the am9511 specific names.  These functions make up the complete z88dk `am9511` maths library that is linked against on the compile line as `-lam9511`.

An alias is provided to simplify usage of the library. `--am9511` provides all the required linkages and definitions, as a simple alternative to `-Cc-fp-mode=ieee -Cc-D__MATH_AM9511 -D__MATH_AM9511 -lam9511 -pragma-define:CLIB_32BIT_FLOATS=1`.

## Function Discussion

There are essentially two different grades of functions in this library. Those written in assembly code, in the floating point domain using intrinsic functions. And those written in C language.

The Am9511A can build complex functions quite efficiently without needing to manage details (which are best left for the intrinsic functions). For a good example of this see the `hypot()` function.

### Intrinsic Assembly Functions

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

The rest of the maths library is derived from source code obtained from the Cephes Math Library Release 2.2, and from the GCC IEEE floating point library.

If desired, alternative and extended coefficient matrices can be tested for accuracy and performance.

```c
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

### Execution speed

Some [benchmarking](https://github.com/z88dk/z88dk/wiki/Classic--Maths-Libraries#benchmarks) has been completed and, as expected, the results show substantial improvements over other floating point libraries.


#### whetstone

Z88DK August 16, 2020
zsdcc #11722 / new c library

whetstone math48
126 seconds

`zcc +rc2014 -subtype=cpm -SO3 --max-allocs-per-node400000 -DPRINTOUT whetstone.c -o whetstone -lm -m -create-app`

whetstone math32
92 seconds

`zcc +rc2014 -subtype=cpm -SO3 --max-allocs-per-node400000 -DPRINTOUT whetstone.c -o whetstone --math32 -m -create-app`

whetstone am9511
28 seconds

`zcc +rc2014 -subtype=cpm -SO3 --max-allocs-per-node400000 -DPRINTOUT whetstone.c -o whetstone --am9511 -m -create-app`

To compare to the standardised results (Z80 @ 4MHz), the times must be multiplied by 1.8432.

#### spectral-norm

Correct result
1.274219991

Z88DK August 15, 2020
zsdcc #11722 / new c library

spectral-norm math32
28 minutes 57 seconds
1.2742190

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 spectral-norm.c -o spectral-norm --math32 -create-app`

spectral-norm am9511
6 min 10 seconds - fast integer math
1.2742140

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 spectral-norm.c -o spectral-norm --am9511 -create-app`

Z88DK August 16, 2020
sccz80 / new c library

spectral-norm am9511
5 min 48 seconds - fast integer math
5 min 28 seconds - fast integer math & `--opt-code-speed=inlineints`
1.2742140

`zcc +rc2014 -subtype=cpm -clib=new --opt-code-speed=inlineints -DPRINTF spectral-norm.c -o spectral-norm --am9511 -create-app`

To compare to the standardised results (Z80 @ 4MHz), the times must be multiplied by 1.8432.


#### fasta


Z88DK August 13, 2020
zsdcc #11722 / new c library

fasta math48
30 seconds

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 --fsigned-char fasta.c -o fasta -lm -create-app`

fasta math32
37 seconds

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 --fsigned-char fasta.c -o fasta --math32 -create-app`

fasta am9511
14.5 seconds

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 --fsigned-char fasta.c -o fasta --am9511 -create-app`

To compare to the standardised results (Z80 @ 4MHz), the times must be multiplied by 1.8432.

#### n-body

Correct results
-0.169075164
-0.169087605

Z88DK August 16, 2020
zsdcc #11722 / new c library

n-body math48
308 seconds
-0.169075117
-0.169158205

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 n-body.c -o n-body -lm -m -pragma-include:zpragma.inc -create-app`


n-body math32
150 seconds
-0.169075200
-0.169086500

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 n-body.c -o n-body --math32 -m -pragma-include:zpragma.inc -create-app`


n-body am9511
77 seconds
-0.169075100
-0.169080500

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 n-body.c -o n-body --am9511 -m -pragma-include:zpragma.inc -create-app`

To compare to the standardised results (Z80 @ 4MHz), the times must be multiplied by 1.8432.


#### mandelbrot

Z88DK August 13, 2020
zsdcc #11722 / new c library

mandelbrot math48
432 seconds

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 mandelbrot.c -o mandelbrot -lm -m -pragma-include:zpragma.inc -create-app`

mandelbrot math32
225 seconds

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 mandelbrot.c -o mandelbrot --math32 -m -pragma-include:zpragma.inc -create-app`

mandelbrot am9511
162 seconds

`zcc +rc2014 -subtype=cpm -DPRINTF -SO3 --max-allocs-per-node400000 mandelbrot.c -o mandelbrot --am9511 -m -pragma-include:zpragma.inc -create-app`

To compare to the standardised results (Z80 @ 4MHz), the times must be multiplied by 1.8432.

