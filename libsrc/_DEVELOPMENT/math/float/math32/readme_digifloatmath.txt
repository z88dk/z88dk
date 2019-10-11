Copyright (c) 2015 Digi International Inc.

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------
Rabbit Semiconductor Rabbit Floating Point Package (ZFPP)
-------------------------------------------------------------------------

            PROVIDED FOR HISTORICAL REFERENCE ONLY

feilipu, April 2019
-------------------------------------------------------------------------

Floating point format (compatible with Intel/ IEEE, etc.) is as follows:

    seeeeeee emmmmmmm mmmmmmmm mmmmmmmm (s-sign, e-exponent, m-mantissa)

stored in memory with the 4 bytes reversed from shown above.
s- 1 negative, 0- positive
e - 0-255 indicating the exponent
m- mantissa 23 bits with implied 24th bit which is always 1
exponent is biased by the amount bias set below

mantissa, when the hidden bit is added in, is 24 bits long
and has a value in the range of 1.000 to 1.9999...

to match Intel 8087 or IEEE format use bias of 127

examples of numbers:
  sign  exponent   mantissa
    0   01111110 (1) 10000....    1.5 * 2 ^ (-1) = 0.75
    0   01111111 (1) 10000....    1.5 * 2 ^ ( 0 )= 1.50
    1   10000000 (1) 10000....   -1.5 * 2 ^ ( 1 )= -3.00
    0   10000110 (1) 01100100010..         =178.25
    x   00000000     000....         zero (plus or minus)
    0   11111111 (1) 000... positive infinity
    1   11111111 (1) 000... negative infinity

Calling Sequences for floating point numbers

example X=Y*Z;
    ld    hl,(Y)   least part
    ld    de,(Y+2) most part
    push  de
    push  hl
    ld    hl,(Z)
    ld    de,(Z+2)
    call  F_mul
    ld    (X),hl
    ld    (X+2),de

example X=Y/Z;
    ld    hl,(Y)
    ld    de,(Y+2)
    push  de
    push  hl
    ld    hl,(Z)
    ld    de,(Z+2)
    call  F_div
    ld    (X),hl
    ld    (X+2),de

example X=Y+Z;
    ld    hl,(Y)
    ld    de,(Y+2)
    push  de
    push  hl
    ld    hl,(Z)
    ld    de,(Z+2)
    call  F_add
    ld    (X),hl
    ld    (X+2),de

example X=Y-Z;
    ld    hl,(Y)
    ld    de,(Y+2)
    push  de
    push  hl
    ld    hl,(Z)
    ld    de,(Z+2)
    call  F_sub
    ld    (X),hl
    ld    (X+2),de

example  X=-Z;
    ld    hl,(Z)
    ld    de,(Z+2)
     call  F_neg
    ld    (X),hl
    ld    (X+2),de

The Rabbit Semiconductor floating point package is loosely based on IEEE 754. We
maintain the packed format, but we do not support denormal numbers or
the round to even convention.  Both of these features could be added
in the future with some performance penalty.

IEEE floating point format: 	seeeeeee emmmmmmm mmmmmmmm mmmmmmmm

represents  e>0             -> (-1)^s * 2^e * (0x800000 + m)/0x800000
            e=0             -> (-1)^s * 2^e * m/0x800000
            e=0xff & m=0    -> (-1)^s * INF
            e=0xff & m!=0   -> (-1)^s NAN

Where s is the sign, e is the exponent and m is bits 22-0 of the
mantissa. ZFPP assumes any number with a zero exponent is zero.
IEEE/ZFPP assume bit 23 of the mantissa is 1 except where the exponent
is zero.

IEEE specifies rounding the result by a process of round to even.  IEEE
uses one guard bit and a sticky bit to round a result per the following
table

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
ZFPP rounds the number using a single sticky bit which is ored to
with the lsb of the result:
b s
0 0		exact
0 1		+.01
1 0		exact
1 1		-.01

-------------------------------------------------------------------------
Both results are free of bias with IEEE method having a slight edge with
rounding error.
-------------------------------------------------------------------------

******** Math Library Discussion *******

Functions included in math libraries

Basic floating point functions - these are computed from first principles

 F_sub, F_add, F_mul, F_div, F_neg - add, subtrace, multiply, divide, negate (in multifp.lib)
 deg(x) - degrees in x radians
 rad(x) - radians in x degrees

Derivative floating point functions (derived from combinations of basic functions)

 pow10(x)- 10 to the x power
 acsc(x) - arc cosecant of x
 asec(x) - arc secant of x
 acot(x) - arc cotangent of x

Basic floating point functions - these are computed from first principles

 pow2(x) - 2 to the power x
 log2(x) - logarithm of x base 2

 atan(x) - arc tangent
 sin(x) - sine
 sqrt(x) - square root
 ceil(x) - smallest integer greater than or equal to x
 fabs(x) - absolute value x
 floor(x) - largest integer less than or equal to x
 fmod(x,&n) - integer and fractional parts

Derivative floating point functions (derived from combinations of basic functions)

 acos(x) - arc cosine of x
 asin(x) - arc sine of x
 atan2(y,x) - arctan of y/x
 cos(x) - cosine of x
 tan(x)- tangent of x
 cosh(x) - hyperbolic cosine of x
 sinh(x) - hyperbolic sine of x
 tanh(x) - hyperbolic tangent of x
 exp(x) - e to the x power
 log(x) - logarithm of x base e
 log10(x) - logarithm of x base 10
 pow(x,y) - x to y power

Discussion of accuracy

 Generally the basic functions are accurate within 1-3 counts of the floating mantissa. However, in
 certain ranges of certain functions the relative accuracy is much less do to the intrinsic properties of
 floating point math. Accuracy expressed in counts of the floating mantissa is relative accuracy -
 i.e. relative to the size of the number. Absolute accuracy is the absolute size of the error - e.g.
 .00001. The derivative functions, computed as combinations of the basic functions, typically
 have larger error because the errors of 2 or more basic functions are added together in some fashion.

 If the value of the function depends on the value of the difference of 2 floating point numbers that are
 close to each other in value, the relative error generally becomes large, although the absolute error
 may remain well bounded. Examples are the logs of numbers near 1 and the sine of numbers near pi.
 For example, if the argument of the sine function is a floating point number is close to pi, say
 5 counts of the mantissa away from pi and it is subtracted from pi the result will be a number with
 only 3 significant bits. The relative error in the sine result will be very large, but the absolute
 error will still be very small. Functions with steep slopes, such as the exponent of larger numbers
 will show a large relative error, since the relative error in the argument is magnified by the slope.

Discussion of execution speed

 Floating add, subtract and multiply require approximately 350 clocks worst case on the Rabbit 2000
 microprocessor. Divide and square root require approximately 900 clocks. Sine and pow2, pow10 or exp
 require about 3200 clocks. Log, log2, log (base e), and atan need about 4000 clocks. Functions
 derived from these functions often require 5000 or more clocks.

Exceptions - range errors

 Certain values will result in an exception. If debugging is in process this will result in an error message.
 If the exception takes place in a program in the field the response is entry into the error log
 (planned) and a watchdog timeout. Exceptions occur for:

 1) Square root of a negative number
 2) argument of exponent type function too large (x>129.9).
 3) Log of a negative number.
 

;-------------------------------------------------------------------------
; F_add - Rabbit floating point add
;-------------------------------------------------------------------------
; 1) first section: unpack from F_add: to sort:
;    one unpacked number in hldebc the other in hl'de'bc'
;    unpacked format: h==0; mantissa= lde, sign in b, exponent in c
;         in addition af' holds  b xor b' used to test if add or sub needed
;
; 2) second section: sort from sort to align, sets up smaller number in hldebc and larger in hl'de'bc'
;    This section sorts out the special cases:
;       to alignzero - if no alignment (right) shift needed
;           alignzero has properties: up to 23 normalize shifts needed if signs differ
;                                     not know which mantissa is larger for different signs until sub performed
;                                     no alignment shifts needed
;       to alignone  - if one alignment shift needed
;           alignone has properties: up to 23 normalize shifts needed if signs differ
;                                    mantissa aligned is always smaller than other mantissa
;                                    one alignment shift needed
;       to align     - 2 to 23 alignment shifts needed
;           numbers aligned 2-23 have properties: max of 1 normalize shift needed
;                                                 mantissa aligned always smaller
;                                                 2-23 alignment shifts needed
;       number too small to add, return larger number (to doadd1)
;
; 3) third section alignment - aligns smaller number mantissa with larger mantissa
;    This section does the right shift. Lost bits shifted off, are tested. Up to 8 lost bits
;    are used for the test. If any are non-zero a one is or'ed into remaining mantissa bit 0.
;      align 2-23 - worst case right shift by 7 with lost bits.
; 4) 4th section add or subtract
;
; 5) 5th section post normalize - worst case 7 left
;
; 6) 6th section pack up
;
;-------------------------------------------------------------------------
;
;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
; F_mul - Rabbit floating point multiply
;-------------------------------------------------------------------------
;
; since the f80 only has support for 16x16bit multiplies
; the multiplication of the mantissas needs to be broken
; into stages and accumulated at the end.
;
; abc * def
; assume worst overflow case: a=b=c=d=e=f=0xff (255)
;
; = (ab*2^8+c) * (de*2^8+f)
; = ab*de*2^16 + ab*f*2^8 + c*de*2^8 + c*f
;
; =    ff fe 00 01 00 00     (ab*de*2^16)
;    + 00 00 fe ff 01 00     (ab*f*2^8)
;    + 00 00 fe ff 01 00     (c*de*2^8)
;    + 00 00 00 00 fe 01     (f*c)
;   -----------------------
;      ff ff fe 00 00 01
;
; since there only a small number of cases where (f*c)
; changes things we will ignore that multiply.
;
; assume smallest case: abc=0x8000 def=0x8000
;
; =   40 00 00 00 00 00
;   + 00 00 00 00 00 00
;   + 00 00 00 00 00 00
;  -----------------------
;     40 00 00 00 00 00
;
; In this case a shift left is required to keep the number
; in the proper range for a ieee mantissa.
;
; the mul 16bit*16bit f80 multiply is signed so after each
; unsigned multiply with the chance of the sign bit in one
; of the operands set, we need to adjust the result back
; to an unsigned value
;
; -n = 2^16-n (convert from signed to unsigned)
;
; -m*-n = m*n = (2^16-n)*(2^16-m)
;             = 2^32 - 2^16*(m+n) + m*n
;             = -2^16(m+n) + m*n
;             = 2^16(m+n) + m*n   (if you bring to other side)
;
; -m*n  =-m*n = n*(2^16-m)
;             = 2^16*n-n*m
;
;         m*n = -2^16*n+m*n
;         m*n = 2^16*n+m*n (if you bring to other side)
;
; example: (using Rabbit Semiconductor algorithm)
;
;                  sign  exp   mantissa
;   0x3fa0624e   =  0    0x7f  0xa0624e
; * 0x4001eb85   =  0    0x80  0x81eb85
; -------------
;   0x4022ca2e   =  0    0x80  0xa2ca2e
;
;       0xa062    0xa062    0x81eb
; *     0x81eb  *   0x85  *   0x4e
; ------------  --------  --------
;   0x51649bf6  0x5352ea  0x27959a
;
;   0x51649bf6 00
; +     0x5342 ea
; +     0x2795 9a
; ---------------
;   0x516516dd XX
;
; shift result left by one
;
;   0xa2ca2dba
;
; 0 0x80 0xa2ca2d -> 0x4022ca2d
;
;-------------------------------------------------------------------------
;
;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
; F_div - floating point divide
;-------------------------------------------------------------------------
; r = x/y
;
; We calculate division of two floating point numbers by refining an
; estimate of the reciprocal of y using newton iterations.  Each iteration
; gives us just less than twice previous precision in binary bits (2n-2).
;
; 1/y can be calculated by:
; w[i+1] = w[i]*2 - w[i]*w[i]*y  where w[0] is approx 1/y
;
; The initial table lookup gets us 5 bits of precision.  The next iterations
; get 8, 14, and 26. At this point the number is rounded then multiplied
; by x using F_mul.
;-------------------------------------------------------------------------
;
;-------------------------------------------------------------------------


