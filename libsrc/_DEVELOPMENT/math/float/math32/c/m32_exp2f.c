/*	Base 2 exponential function
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
 * exp underflow    x < -MAXL2        0.0
 * exp overflow     x > MAXL2         MAXNUMF
 *
 * For IEEE arithmetic, MAXL2 = 127.
 */


/*
Cephes Math Library Release 2.2:  June, 1992
Copyright 1984, 1987, 1988, 1992 by Stephen L. Moshier
Direct inquiries to 30 Frost Street, Cambridge, MA 02140
*/

#include "m32_math.h"

extern float m32_coeff_exp2f[];

float m32_exp2f (float x) __z88dk_fastcall
{
    float z;
    int16_t n;
#if 0
    if( x > MAXL2F )
    {
	    return( HUGE_POSF );
    }

    if( x < MINL2F )
    {
	    return(0.0);
    }
#endif
    /* separate into integer and fractional parts */
    z = m32_floorf(x);

    x -= z;

    n = (int16_t)z;
    
    if( x > 0.5 )
    {
	    ++n;
	    x -= 1.0;
    }

    /* rational approximation
     * exp2(x) = 1.0 +  xP(x)
     * scale by power of 2
     */

    return m32_ldexpf( m32_polyf(x, m32_coeff_exp2f, 9), n);
}
