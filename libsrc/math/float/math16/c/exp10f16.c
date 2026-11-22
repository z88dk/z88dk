/*    Base 10 exponential function
 *      (Common antilogarithm)
 *
 * SYNOPSIS:
 *
 * float x, y, exp10f();
 *
 * y = exp10f( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns 10 raised to the x power.
 *
 * Range reduction is accomplished by expressing the argument
 * as 10**x = 2**n 10**f, with |f| < 0.5 log10(2).
 * A polynomial approximates 10**f.
 *
 * Approximation of f(x) = 10**x
 * with weight function g(x) = 10**x
 * on interval [ 0, 0.15051499783 ]
 * with a polynomial of degree 5.
 * p(x)=((((6.4075045e-1*x+1.1538467)*x+2.0360299)*x+2.6509022)*x+2.3025857)*x+1.
 *float f(float x)
 *{
 *    float u = 6.4075045e-1f;
 *    u = u * x + 1.1538467f;
 *    u = u * x + 2.0360299f;
 *    u = u * x + 2.6509022f;
 *    u = u * x + 2.3025857f;
 *    return u * x + 1.f;
 *}
 *
 * ACCURACY:
 *
 *                      Relative error:
 * arithmetic   domain     # trials      peak         rms
 *    IEEE      -38,+38     100000      9.8e-8      2.8e-8
 *
 *
 * See m32_expf.c for comments on error amplification.
 *
 * ERROR MESSAGES:
 *
 *   message         condition      value returned
 * exp10 underflow    x < -MAXL10_F16     0.0
 * exp10 overflow     x >  MAXL10_F16   HUGE_POS_F
 *
 * IEEE single arithmetic: MAXL10_F16 = +4.816
 *
 */

/*
Cephes Math Library Release 2.2:  June, 1992
Copyright 1984, 1987, 1988, 1992 by Stephen L. Moshier
Direct inquiries to 30 Frost Street, Cambridge, MA 02140
*/


#include "math16.h"

#define LOG210      ((half_t)+3.32192809488736234787E+0)
#define LG102A      ((half_t)+3.00781250000000000000E-1)
#define LG102B      ((half_t)+2.48745663981195213739E-4)

extern float f16_coeff_exp10[];

half_t exp10f16 (half_t x)
{
    half_t z;

    if( x > MAXL10_F16 )
        return HUGE_POS_F16;

    if( x < MINL10_F16 )
        return 0.0;

    if( x == 0.0 )
        return 1.0;

    /* Express 10**x = 10**g 2**n
     *   = 10**g 10**( n log10(2) )
     *   = 10**( g + n log10(2) )
     */
    z = floorf16( x * LOG210 + 0.5 );

    x -= z * LG102A;
    x -= z * LG102B;  

    return ldexpf16( polyf16( x, f16_coeff_exp10, 5 ), (int16_t)z );
}

