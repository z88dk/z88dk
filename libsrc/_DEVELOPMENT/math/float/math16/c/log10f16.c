/*    Common logarithm
 *
 * SYNOPSIS:
 *
 * float x, y, log10f();
 *
 * y = log10f( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns logarithm to the base 10 of x.
 *
 * The argument is separated into its exponent and fractional
 * parts.  The logarithm of the fraction is approximated by
 *
 *     log(1+x) = x - 0.5 x**2 + x**3 P(x).
 *
 *
 * ACCURACY:
 *
 *                      Relative error:
 * arithmetic   domain     # trials      peak         rms
 *    IEEE      0.5, 2.0    100000      1.3e-7      3.4e-8
 *    IEEE      0, MAXNUMF  100000      1.3e-7      2.6e-8
 *
 * In the tests over the interval [0, MAXNUM], the logarithms
 * of the random arguments were uniformly distributed over
 * [-MAXL10_F, MAXL10_F].
 *
 * ERROR MESSAGES:
 *
 * log10f singularity:  x = 0; returns -HUGE_NEG_F16
 * log10f domain:       x < 0; returns -HUGE_NEG_F16
 * MAXL10_F16           0x44D1      /*  +4.816    */
 */

/*
Cephes Math Library Release 2.1:  December, 1988
Copyright 1984, 1987, 1988 by Stephen L. Moshier
Direct inquiries to 30 Frost Street, Cambridge, MA 02140
*/

#include "math16.h"

#define L102A       ((half_t) 3.0078125E-1)
#define L102B       ((half_t) 2.48745663981195213739E-4)
#define L10EA       ((half_t) 4.3359375E-1)
#define L10EB       ((half_t) 7.00731903251827651129E-4)

extern float f16_coeff_log[];

half_t log10f16 (half_t x)
{
    half_t y, z;
    int16_t e;

    /* Test for domain */
    if( x <= 0.0 )
        return HUGE_NEG_F16;

    /* separate mantissa from exponent */
    x = frexpf16( x, &e );

    /* logarithm using log(1+x) = x - .5x**2 + x**3 P(x) */

    if( x < M_SQRT1_2 )
    {
        --e;
        x = mul2f16(x) - 1.0; /*  2x - 1  */
    }
    else
    {
        x -= 1.0;
    }

    z = x*x;
    
    y = polyf16( x, f16_coeff_log, 9) * z;
    
    y -= div2f16(z); /* y - 0.5 x^2 */

    /* multiply log of fraction by log10(e)
     * and base 2 exponent by log10(2)
     */

    z = (x + y) * L10EB;  /* accumulate terms in order of size */
    z += y * L10EA;
    z += x * L10EA;
    x = (half_t)e;
    z += x * L102B;
    z += x * L102A;

    return( z );
}
