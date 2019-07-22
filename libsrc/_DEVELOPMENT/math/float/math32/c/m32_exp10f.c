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
 *
 * ACCURACY:
 *
 *                      Relative error:
 * arithmetic   domain     # trials      peak         rms
 *    IEEE      -38,+38     100000      9.8e-8      2.8e-8
 *
 * ERROR MESSAGES:
 *
 *   message         condition      value returned
 * exp10 underflow    x < -MAXL10F        0.0
 * exp10 overflow     x > MAXL10F       MAXNUM
 *
 * IEEE single arithmetic: MAXL10F = 38.230809449325611792.
 *
 */

/*
Cephes Math Library Release 2.2:  June, 1992
Copyright 1984, 1987, 1988, 1992 by Stephen L. Moshier
Direct inquiries to 30 Frost Street, Cambridge, MA 02140
*/


#include "m32_math.h"

#define MAXL10F  38.230809449325611792
#define MAXLOGF  88.02969187150841
#define MINLOGF -88.7228391116729996
#define LOG2EF    1.44269504088896341

#define LOG210    3.32192809488736234787e0
#define LG102A    3.00781250000000000000E-1
#define LG102B    2.48745663981195213739E-4

extern float m32_coeff_exp10f[];

float m32_exp10f (float x) __z88dk_fastcall
{
    float z;

    if( x > MAXL10F )
    {
        return( INF );
    }

    if( x < -MAXL10F )    /* Would like to use MINLOG but can't */
    {
        return(0.0);
    }

    /* The following is necessary because range reduction blows up: */
    if( x == 0 )
        return(1.0);

    /* Express 10**x = 10**g 2**n
     *   = 10**g 10**( n log10(2) )
     *   = 10**( g + n log10(2) )
     */
    z = m32_floorf( x * LOG210 + 0.5 );
    x -= z * LG102A;
    x -= z * LG102B;

    /* rational approximation for exponential
     * of the fractional part:
     * 10**x - 1  =  2x P(x**2)/( Q(x**2) - P(x**2) )
     * multiply by power of 2 
     */
    return m32_ldexpf( m32_polyf(x, m32_coeff_exp10f, 5) * x + 1.0, (int16_t)z );
}
