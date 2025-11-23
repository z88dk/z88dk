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
 * with a polynomial of degree 7.
 * double f(double x)
 * {
 *   double u = 8.090484272600454e-2;
 *   u = u * x + 2.0380373931544082e-1;
 *   u = u * x + 5.3978993685198384e-1;
 *   u = u * x + 1.1712266435079228;
 *   u = u * x + 2.0346796696616236;
 *   u = u * x + 2.6509490353631601;
 *   u = u * x + 2.3025850931327687;
 *   return u * x + 9.9999999999984258e-1;
 * }
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
 * exp10 underflow    x < -MAXL10_F32     0.0
 * exp10 overflow     x >  MAXL10_F32   HUGE_POS_F
 *
 * IEEE single arithmetic: MAXL10_F32 = 38.230809449325611792.
 *
 */

/*
Cephes Math Library Release 2.2:  June, 1992
Copyright 1984, 1987, 1988, 1992 by Stephen L. Moshier
Direct inquiries to 30 Frost Street, Cambridge, MA 02140
*/


#include "m32_math.h"

#define LOG210      ((float)+3.32192809488736234787E+0)
#define LG102A      ((float)+3.00781250000000000000E-1)
#define LG102B      ((float)+2.48745663981195213739E-4)

extern float m32_coeff_exp10f[];

float m32_exp10f (float x) __z88dk_fastcall
{
    float z;

#if 0
    if( x > MAXL10_F32 )
    {
        return( HUGE_POS_F32 );
    }

    if( x < MINL10_F32 )
    {
        return(0.0);
    }
#endif
	if( x == 0.0 )
		return 1.0;

    /* Express 10**x = 10**g 2**n
     *   = 10**g 10**( n log10(2) )
     *   = 10**( g + n log10(2) )
     */
    z = m32_floorf( x * LOG210 + 0.5 );

    x -= z * LG102A;
    x -= z * LG102B;  

    return m32_ldexpf( m32_polyf(x, m32_coeff_exp10f, 7), (int16_t)z);
}
