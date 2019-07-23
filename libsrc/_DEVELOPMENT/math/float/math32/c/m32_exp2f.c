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

    return m32_ldexpf( m32_polyf(x, m32_coeff_exp2f, 5) * x + 1.0, n);
}
