/*
   Copyright (c) 2015 Digi International Inc.

   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/
/* START LIBRARY DESCRIPTION ***************************************************
math.lib

DESCRIPTION: Math functions for Rabbit

SUPPORT LIBRARIES: several
END DESCRIPTION ***************************************************************/

/*
******** Math Library Discussion *******

Functions included in math libaries

Basic floating point functions - these are computed from first principles

 F_sub, F_add, F_mul, F_div, F_neg - add, subtrace, multiply, divide, negate (in multifp.lib)
 deg(x) - degrees in x radians
 rad(x) - radians in x degrees

Derrivitive floating point functions (derrived from combinations of basic functions)

 pow10(x)- 10 to the x power
 acsc(x) - arc cosecant of x
 asec(x) - arc secant of x
 acot(x) - arc cotangent of x

Discussion of Accuracy

 Generally the basic functions are accurate within 1-3 counts of the floating mantissa. However, in
 certain ranges of certain functions the relative accuracy is much less do to the intrinsic properties of
 floating point math. Accuracy expressed in counts of the floating mantissa is relative acccuracy -
 i.e. relative to the size of the number. Absolute accuracy is the absolute size of the error - e.g.
 .00001. The derivative functions, computed as combinations of the basic functions, typically
 have larger error because the errors of 2 or more basic functions are added together in some fashion.

 If the value of the function depends on the value of the difference of 2 floating point numbers that are
 close to each other in value, the relative error generally becomes large, although the absolute error
 may remain well bounded. Examples are the logs of numbers near 1 and the sine of numbers near pi.
 For example, if the argument of the sine function is a floating point number is close to pi, say
 5 counts of the mantissa away from pi and it is subtracted from pi the result will be a number with
 only 3 significent bits. The relative error in the sine result will be very large, but the absolute
 error will still be very small. Functions with steep slopes, such as the exponent of larger numbers
 will show a large relative error, since the relative error in the argument is magnified by the slope.

Discussion of execution speed

 Floating add, subtract and multiply require approximately 350 clocks worst case on the Rabbit 2000
 microprocessor. Divide and square root require approximately 900 clocks. Sine and pow2, pow10 or exp
 require about 3200 clocks. Log, log2, log (base e), and atan need about 4000 clocks. Functions
 derrived from these functions often require 5000 or more clocks.

Exceptions - range errors

 Certain values will result in an exception. If debugging is in process this will result in an error message.
 If the exception takes place in a program in the field the response is entry into the error log
 (planned) and a watchdog timeout. Exceptions occur for:

 1) Square root of a negative number
 2) argument of exponent type function too large (x>129.9).
 3) Log of a negative number.



*/

/*** BeginHeader */
#include <math.h>
#ifndef __MATH_LIB
#define __MATH_LIB

/*** EndHeader */


/*** BeginHeader pow10 */

float pow10(float x);

/*** EndHeader   pow10 */



/* START FUNCTION DESCRIPTION ********************************************
pow10                        <MATH.LIB>

SYNTAX:       float pow10(float x);

PARAMETER1:   Floating point power to which 10 is to be raised.

KEYWORDS:     math

DESCRIPTION:  10 to the power of "x"
              Timing positive numbers  3000 clocks or 100 us at 30 MHz
              Timing negative numbers  3900 clocks or 130 us at 30 MHz

RETURN VALUE: See description.
END DESCRIPTION **********************************************************/

/*
   Method: 10^x  = 2^(log2(10)*x)
*/

__nodebug float pow10(float x){

 return pow2(3.321928094887*x);
}


/*** BeginHeader acot */

float acot(float x);

/*** EndHeader   acot */

/*
 * ACOT
 *
 * Purpose:
 *              Compute the arccotangent of real float value x
 *              The value x is assumed between -INF and +INF
 * Returns:
 *              angle   answer in radians 0 .. PI approx
 * Method:
 *              acot(x) = PI/2 + atan(-x)
 */

/* START FUNCTION DESCRIPTION ********************************************
acot                         <MATH.LIB>

SYNTAX:       float acot(float x);

PARAMETER1:   Floating point input for arccotangent computation.

KEYWORDS:     math

DESCRIPTION:  Computes the arccotangent of real float value x.  x is
              assumed between -INF and +INF.

RETURN VALUE: Arccotangent of the argument.
END DESCRIPTION **********************************************************/
__nodebug float acot(float x)
{
	float atan();

	return (PIbyTWO + atan(- x));
}

/*** BeginHeader acsc */

float acsc(float x);

/*** EndHeader   acsc */

/*
 * ACSC
 *
 * Purpose:
 *              Compute the arccosecant of real float value x
 *              The value x is assumed between -INF and +INF
 * Returns:
 *              angle   answer in radians -PI/2 .. PI/2 approx
 * Method:
 *              acsc(x) = asec(x/sqrt(x*x-1));
 */

/* START FUNCTION DESCRIPTION ********************************************
acsc                         <MATH.LIB>

SYNTAX:       float acsc(float x);

PARAMETER1:   Floating point input for arccosecant computation.

KEYWORDS:     math

DESCRIPTION:  Computes the arccosecant of real float value x. x is assumed
              between -INF and +INF.

RETURN VALUE: The Arccosecant of the argument.
END DESCRIPTION **********************************************************/
__nodebug float acsc(float x)
{
	auto float y;
	static float sqrt(), asec();

	if ((y = x * x) < 1.0)
	{
		exception(-ERR_DOMAIN);
		return 0.0;
	}
	if (y == 1.0)
	{
		return ((x >= 0.0) ? PIbyTWO : - PIbyTWO);
	}
	return (asin(1.0 / x));
}

/*** BeginHeader asec */

float asec(float x);

/*** EndHeader   asec */

/*
 * ASEC
 *
 * Purpose:
 *              Compute the arcsecant of real float value x
 *              The value x is assumed between -INF and +INF
 * Returns:
 *              angle   answer in radians 0 .. PI approx
 *              0.0     errno = ERR_DOMAIN, on range error
 * Method:
 *              asec(x) = atan(sqrt(x*x - 1)) - (x >= 0 ? 0 : PI);
 */

/* START FUNCTION DESCRIPTION ********************************************
asec                         <MATH.LIB>

SYNTAX:       float asec(float x);

PARAMETER1:   Floating point input for arcsecant computation.

KEYWORDS:     math

DESCRIPTION:  Computes the arcsecant of real float value x. x is assumed
              between -INF and +INF.

RETURN VALUE: The Arcsecant of the argument.
END DESCRIPTION **********************************************************/
__nodebug float asec(float x)
{
	auto float y;
	static float atan(), sqrt();

	if ((y = x * x) < 1.0)
	{
		exception(-ERR_DOMAIN);
		return 0.0;
	}
	return (PIbyTWO - asin(1.0 / x));
}


/*** BeginHeader deg */

float deg(float x);

/*** EndHeader   deg */

/*
 * DEG
 *
 * Purpose:
 *              Changes float radians x to degrees
 * Returns:
 *              angle in degrees ( a float)
 * Method:
 *              angle = (180.0/PI)*x;
 */

/* START FUNCTION DESCRIPTION ********************************************
deg                          <MATH.LIB>

SYNTAX:       float deg(float x);

PARAMETER1:   Floating point input in radians.

KEYWORDS:     convert

DESCRIPTION:  Changes float radians x to degrees.

RETURN VALUE: Angle in degrees (a float).
END DESCRIPTION **********************************************************/
__nodebug float deg(float x)
{
	return (x * (IPIby180));
}


/*** BeginHeader poly */

float poly(float x, int n, const float c[]);

/*** EndHeader   poly */

/*
 * POLY
 *
 * Purpose:
 *              Compute polynomial value by Horner's method.
 *
 *      Horner's method for polynomial evaluation
 *
 * Example: Given p[2] = 3, p[1] = 4, p[0] = 6,
 *          then 3*(x**2) + 4*x + 6 = x( x(3) + 4) + 6 =
 *               x( x(p[2]) + p[1]) + p[0]
 *
 */

/* START FUNCTION DESCRIPTION ********************************************
poly                         <MATH.LIB>

SYNTAX:       float poly(float x, int n, const float c[]);

PARAMETER1:   Floating point variable for polynomial evaluation.

PARAMETER2:   Degree of polynomial (P(x) = 7.7*x^4 + 5*x^2 + 3.3, n = 4)

PARAMETER3:   Ascending array of coefficients ({3.3, 0, 5, 0, 7.7} for P(x))

KEYWORDS:     math

DESCRIPTION:  Computes polynomial value by Horner's method.

RETURN VALUE: See description.
END DESCRIPTION **********************************************************/
__nodebug float poly(float x, int n, const float p[])
{
	auto float value;

	value = p[n];
	while (n)
		value = x * value + p[ --n];
	return (value);
}



/*** BeginHeader rad */

float rad(float x);

/*** EndHeader   rad */

/*
 * RAD
 *
 * Purpose:
 *              Changes float x degrees to radians
 * Returns:
 *              angle in radians (a float)
 * Method:
 *              angle = (PI/180.0)*x;
 */

/* START FUNCTION DESCRIPTION ********************************************
rad                          <MATH.LIB>

SYNTAX:       float rad(float x);

PARAMETER1:   Floating point input in degrees.

KEYWORDS:     convert

DESCRIPTION:  Convert degrees (360 for one rotation) to radians (2pi
              for a rotation).

RETURN VALUE: The radians equivalent to the passed in degree.
END DESCRIPTION **********************************************************/
__nodebug float rad(float x)
{
	return (x * (PIby180));
}



/*** BeginHeader _pow10 */
float _pow10(int exp);
/*** EndHeader   _pow10 */

/***************************************************************************\
	GENERAL UTILITY Convert Integer to Floating Exponent ( i.e. 10 ** i )

	   float _pow10 ( int exp )
\***************************************************************************/

const static float n10[][4] =
			 {
				 1e0, 1e-1, 1e-2, 1e-3,
				 1e0, 1e-4, 1e-8, 1e-12,
				 1e0, 1e-16, 1e-32, 0.0
			 };
const static float p10[][4] =
			 {
				 1e0, 1e1, 1e2, 1e3,
				 1e0, 1e4, 1e8, 1e12,
				 1e0, 1e16, 1e32, 0.0
			 };

/* START _FUNCTION DESCRIPTION ********************************************
_pow10                       <MATH.LIB>

SYNTAX:       float _pow10(int exp)

PARAMETER1:   integer exponent to which 10 is to be raised.

KEYWORDS:

DESCRIPTION:  Computes integral powers of 10.

RETURN VALUE: See description.
END DESCRIPTION **********************************************************/
__nodebug float _pow10(int exp)
{
	auto float prod;
	auto int i, sign;

	prod = 1.0;
	if (sign = (exp < 0))
		exp = - exp;
	for (i = 0; i < 3; i++)
	{
		if (sign)
			prod *= n10[i][exp & 3];
		else
			prod *= p10[i][exp & 3];
		if (! (exp >>= 2))
			break;
	}
	return (prod);
}

/*** BeginHeader lsqrt */

unsigned lsqrt(unsigned long x);

/*** EndHeader */

/* START FUNCTION DESCRIPTION ********************************************
lsqrt                        <MATH.LIB>

SYNTAX:       unsigned int lsqrt(unsigned long x);

PARAMETER1:   long int input for square root computation

KEYWORDS:     math

DESCRIPTION:  Computes the square root of x.  Note that the return value
              is an unsigned int.  The fractional portion of the result
              is truncated.

RETURN VALUE: Square root of x (fractional portion truncated)
END DESCRIPTION **********************************************************/

__nodebug unsigned lsqrt(unsigned long x) {
	static char buffer[8];
	auto char lastBuf[8];
	static int count;

	memcpy(lastBuf,buffer,sizeof(buffer));
	*(unsigned long *)buffer = x;
	*((unsigned long *)buffer+1) = 0;
	count = 16;
#asm xmemok
	ld		de,0
.doAgain:
	ld		hl,.jumpback
	push	hl
	jp		.shiftBy2

.jumpback:
	ex		de,hl					; shift root by one bit
	add	hl,hl
	ex		de,hl

	ld		l,e					;	bc = de * 2 + 1
	ld		h,d
	add	hl,hl
	inc	hl
	ld		c,l
	ld		b,h

	ld		hl,(buffer+4)
	xor	a						;	carry bit clear
	sbc	hl,bc					;	subtract least sig. word
	push	hl
	ld		hl,(buffer+6)
	ld		bc,0
	bit	7,d
	jr		z,.__noCarryOver
	inc	bc
.__noCarryOver:
	sbc	hl,bc					;	subtract most sig. word
	jp		c,.__noSubtract
									;	commit the subtraction
	ld		(buffer+6),hl
	pop	hl
	ld		(buffer+4),hl

	inc	de						;	increment root

	jr		.contLoop
.__noSubtract:
	pop	hl
.contLoop:
	ld		hl,count
	dec	(hl)
	jp		nz,.doAgain

	ld		l,e
	ld		h,d
	jr		.funcEnd

.shiftBy2:
	ld		hl,(buffer)			;	shift buffer by two bits
	add	hl,hl
	rl		c
	add	hl,hl
	rla
	ld		(buffer),hl
	ld		hl,(buffer+2)
	rr		c
	adc	hl,hl
	rl		c
	rra
	adc	hl,hl
	rla
	ld		(buffer+2),hl
	ld		hl,(buffer+4)
	rr		c
	adc	hl,hl
	rl		c
	rra
	adc	hl,hl
	rla
	ld		(buffer+4),hl
	ld		hl,(buffer+6)
	rr		c
	adc	hl,hl
	rl		c
	rra
	adc	hl,hl
	rla
	ld		(buffer+6),hl

	pop	hl
	jp		(hl)

.funcEnd:
#endasm
}

/*** BeginHeader srandf, randf, _ran_value */
void srandf(unsigned long);
float randf(void);
extern unsigned long _ran_value;
/*** EndHeader */

unsigned long _ran_value = 0x83654321;

/* START FUNCTION DESCRIPTION ********************************************
srandf                         <MATH.LIB>

SYNTAX:			void srandf(unsigned long seed)

KEYWORDS:		math, random

DESCRIPTION:	Sets the seed value for the randf() function.  The seed must
					be an odd number.

SEE ALSO:		randf, randg, randb

RETURN VALUE:	none
END DESCRIPTION **********************************************************/

__nodebug
void srandf(unsigned long seed)
{
	_ran_value = seed;
}

/* START FUNCTION DESCRIPTION ********************************************
randf                         <MATH.LIB>

SYNTAX:			float randf(void);

KEYWORDS:		math, random

DESCRIPTION:	Returns a uniformly distributed random number in the
					range 0.0 <= v < 1.0.  Uses the algorithm

							randf = (5 * randf) modulo (2^32)

					A default seed value is set on startup, but can be changed
					with the srandf() function.  This function is not task reentrant.

SEE ALSO:		randg, randb, srandf

RETURN VALUE:	a uniformly distributed random number 0.0 <= v < 1.0
END DESCRIPTION **********************************************************/

__nodebug
float randf()
{
	auto float value;

// algorithm - r[n+1]=r[n]*5 mod 2^32 then take bits starting at bit 28 for mantissa
#asm
	ld 	de,(_ran_value+2) ; most
	ld 	hl,(_ran_value)   ; least
	set 	0,l   				; make sure odd, in case bad seed
	add 	hl,hl
	rl 	de
	add 	hl,hl
	rl 	de
; 2 shifts left
	ld 	bc,(_ran_value) 	; least
	add 	hl,bc 				; add leasts
	ex 	de,hl
	ld 	bc,(_ran_value+2) ; most
	adc 	hl,bc  				; most
	ld 	(_ran_value+2),hl ; most
	ld 	(_ran_value),de   ; least
; shift 4 right to get mantissa
	rr 	hl
	rr 	de
	rr 	hl
	rr 	de
	rr 	hl
	rr 	de
	rr 	hl
	rr 	de
	ld 	c,l
	ld 	b,0
	call 	Bg_Bf  				; float integer in cde
; move binary point 24 right
	ld 	a,b
	sub 	0ch
	ld 	b,a
	ld 	(sp+@SP+value),bcde
#endasm
	return value;
}

/*** BeginHeader randb */
float randb(void);
/*** EndHeader */

/* START FUNCTION DESCRIPTION ********************************************
randb                         <MATH.LIB>

SYNTAX:			float randb(void);

KEYWORDS:		math, random

DESCRIPTION:	Returns a uniformly distributed random number in the
					range -1.0 <= v < 1.0.  See randf() for more information
					about the algorithm used  This function is not task reentrant.

SEE ALSO:		randf, randg, srandf

RETURN VALUE:	a uniformly distributed random number -1.0 <= v < 1.0
END DESCRIPTION **********************************************************/

__nodebug
float randb(){   // uniformly distributed -1. to +1. call randf() and add sign
auto float value;

#asm
   call 	randf  				; get random number in bcde
   ld 	hl,(_ran_value+2) ; get current number most part
   ld 	a,h
   rla
   rla
   rla
   and 	80h
   or 	b
   ld 	b,a  					; put a sign on randomly
   ld 	(sp+@sp+value),bcde
#endasm
   return value;
}


/*** BeginHeader randg */
float randg(void);
/*** EndHeader */

/* START FUNCTION DESCRIPTION ********************************************
randg                         <MATH.LIB>

SYNTAX:			float randg(void);

KEYWORDS:		math, random

DESCRIPTION:	Returns a gaussian-distributed random number in the
					range -16.0 <= v < 16.0 with a standard deviation of
					approximately 2.6.  The distribution is made by adding
					16 random numbers (see randf()).  This function is not
					task reentrant.

SEE ALSO:		randf, randb, srandf

RETURN VALUE:	a uniformly distributed random number -1.0 <= v < 1.0
END DESCRIPTION **********************************************************/

__nodebug
float randg(){
// adds together 16 uniformly distributed numbers between -1 and +1
// to create an approximately gaussian distribution
auto float value;

#asm
	exx
	ld 	hl,0
	ld 	de,0 					; zero sum
	ld 	a,16  				; count
	exx
.loop:
	ld 	de,(_ran_value+2)	; most
	ld		hl,(_ran_value)  	; least
	set 	0,l   				; make sure odd, in case bad seed
	add 	hl,hl
	rl 	de
	add 	hl,hl
	rl 	de
; 2 shifts left
	ld 	bc,(_ran_value) 	; least
	add 	hl,bc ; add leasts
	ex 	de,hl
	ld 	bc,(_ran_value+2)	; most
	adc 	hl,bc  				; most
	ld 	(_ran_value+2),hl	; most
	ld 	(_ran_value),de  	; least
; shift 4 right to get mantissa
	rr 	hl
	rr 	de
	rr 	hl
	rr 	de
	rr 	hl
	rr 	de
	rr 	hl
	rr 	de
	rr 	h  					; get bit to use for sign
	ld 	h,0
	ld 	b,h
	ld 	c,l  					; move to bc
	jr 	nc,.mpos 				; check for negate mantissa
; negate mantissa
	or 	a  					; clc
	ld 	hl,0
	sbc 	hl,de  				; neg least
	ex 	de,hl
	ld 	hl,0
	sbc 	hl,bc  				; most
	ld 	bc,hl
.mpos:     						; now have mantissa in bcde signed number
; add to sum in alternate regs
	ld 	bc',de
	exx
	ex 	de,hl
	add 	hl,bc 				; add leasts
	ex 	de,hl
	exx
	ld 	bc',bc 				; mosts
	exx
	adc 	hl,bc 				; mosts
	exx
	dec 	a
	jr 	nz,.loop
; now have 16 added in alt hlde
	exx
	ld 	b,h
	ld 	c,l
	call 	Bl_Bf  				; float the number
	ld 	a,b
	and 	80h
	ld 	l,a
	ld 	a,b
	sub 	0ch
	and 	a,7fh
	or 	l
	ld 	b,a
	ld 	(sp+@SP+value),bcde
#endasm
	return value;
}


/*** BeginHeader intel, intel16 */
// Endian swapping routines.  Put in math.lib since they are useful for
// things other than just tcp/ip.
__root unsigned long intel( unsigned long );
__root unsigned short intel16( unsigned short );
#ifndef ntohs
// This works because function is its own inverse
#define ntohs intel16
#define htons intel16
#define ntohl intel
#define htonl intel
#endif
/*** EndHeader */

#asm __nodebug
;
; unsigned long intel(unsigned long)
; returns the intel byte order dword converted from network byte order
;

intel::
	ex		de,hl
	ld		e,b
	ld		d,c
	ld		b,l
	ld		c,h
	ret

;
; unsigned intel16(unsigned)
; returns the intel byte order word converted from network byte order
;

intel16::
	ld		a,l
	ld		l,h
	ld		h,a
	ret
#endasm


