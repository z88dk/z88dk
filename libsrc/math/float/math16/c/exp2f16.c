/*    Base 2 exponential function
 *
 *
 * SYNOPSIS:
 *
 * float x, y, exp2f();
 *
 * y = exp2f( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns 2 raised to the x power.
 *
 * Range reduction is accomplished by separating the argument
 * into an integer k and fraction f such that
 *     x    k  f
 *    2  = 2  2.
 *
 * A polynomial approximates 2**x in the basic range [-0.5, 0.5].
 *
 * Approximation of f(x) = 2**x
 * with weight function g(x) = 2**x
 * on interval [ -0.5, 0.5 ]
 * with a polynomial of degree 5.
 * p(x)=((((1.3276472e-3*x+9.6755413e-3)*x+5.5507133e-2)*x+2.402212e-1)*x+6.9314697e-1)*x+1.0000001
 *
 * float f(float x)
 * {
 *    float u = 1.3276472e-3f;
 *    u = u * x + 9.6755413e-3f;
 *    u = u * x + 5.5507133e-2f;
 *    u = u * x + 2.402212e-1f;
 *    u = u * x + 6.9314697e-1f;
 *    return u * x + 1.000000f;
 * }
 *
 *
 * ACCURACY:
 *
 *                      Relative error:
 * arithmetic   domain     # trials      peak         rms
 *    IEEE     -127,+127    100000      1.7e-7      2.8e-8
 *
 *
 * See exp.c for comments on error amplification.
 *
 *
 * ERROR MESSAGES:
 *
 *   message         condition      value returned
 * exp underflow    x < -MAXL2_F16          0.0
 * exp overflow     x > MAXL2_F16        HUGE_POS_F16
 *
 * For IEEE arithmetic, MAXL2_F16 = 15.99.
 */


/*
Cephes Math Library Release 2.2:  June, 1992
Copyright 1984, 1987, 1988, 1992 by Stephen L. Moshier
Direct inquiries to 30 Frost Street, Cambridge, MA 02140
*/

#include "math16.h"

extern float f16_coeff_exp2[];

half_t exp2f16 (half_t x)
{
    half_t z;

    if( x > MAXL2_F16 )
        return HUGE_POS_F16;

    if( x < MINL2_F16 )
        return 0.0;

    if( x == 0.0 )
        return 1.0;

    /* separate into integer and fractional parts */
    z = floorf16( x + 0.5 );

    x -= z;

    /* rational approximation
     * exp2(x) = 1.0 +  xP(x)
     * scale by power of 2
     */

    return ldexpf16( polyf16( x, f16_coeff_exp2, 5 ), (int16_t)z );
}

