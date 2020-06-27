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
 * with a polynomial of degree 9.
 * double f(double x)
 * {
 *   double u = 1.0150336705309648e-7;
 *   u = u * x + 1.3259405609345135e-6;
 *   u = u * x + 1.5252984838653427e-5;
 *   u = u * x + 1.540343494807179e-4;
 *   u = u * x + 1.3333557617604443e-3;
 *   u = u * x + 9.6181291920672461e-3;
 *   u = u * x + 5.5504108668685612e-2;
 *   u = u * x + 2.4022650695649653e-1;
 *   u = u * x + 6.9314718055987097e-1;
 *   return u * x + 1.0000000000000128;
 * }
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
        return (half_t)HUGE_POS_F16;

    if( x < MINL2_F16 )
        return (half_t)0.0;

    if( x == 0.0 )
        return (half_t)1.0;

    /* separate into integer and fractional parts */
    z = floorf16( x + (half_t)0.5 );

    x -= z;

    /* rational approximation
     * exp2(x) = 1.0 +  xP(x)
     * scale by power of 2
     */

    return ldexpf16( polyf16( x, f16_coeff_exp2, 9 ), (int16_t)z );
}

