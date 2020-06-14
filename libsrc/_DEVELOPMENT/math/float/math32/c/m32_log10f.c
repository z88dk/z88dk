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
 * log10f singularity:  x = 0; returns -MAXL10
 * log10f domain:       x < 0; returns -MAXL10
 * MAXL10_F32 = 38.230809449325611792
 */

/*
Cephes Math Library Release 2.1:  December, 1988
Copyright 1984, 1987, 1988 by Stephen L. Moshier
Direct inquiries to 30 Frost Street, Cambridge, MA 02140
*/

#include "m32_math.h"

#define SQRTHF      ((float) 0.70710678118654752440)

#define L102A       ((float) 3.0078125E-1)
#define L102B       ((float) 2.48745663981195213739E-4)
#define L10EA       ((float) 4.3359375E-1)
#define L10EB       ((float) 7.00731903251827651129E-4)

extern float m32_coeff_logf[];

float m32_log10f (float x) __z88dk_fastcall
{
    float y, z;
    int16_t e;

    /* Test for domain */
    if( x <= 0.0 )
    {
        return( HUGE_NEG_F32 );
    }

    /* separate mantissa from exponent */

    x = m32_frexpf( x, &e );

    /* logarithm using log(1+x) = x - .5x**2 + x**3 P(x) */

    if( x < SQRTHF )
    {
        --e;
        x = m32_mul2f(x) - 1.0; /*  2x - 1  */
    }
    else
    {
        x -= 1.0;
    }

    z = m32_sqrf(x);
    
    y = m32_polyf(x, m32_coeff_logf, 9) * z;
    
    y -= m32_div2f(z); /* y - 0.5 x^2 */

    /* multiply log of fraction by log10(e)
     * and base 2 exponent by log10(2)
     */

    z = (x + y) * L10EB;  /* accumulate terms in order of size */
    z += y * L10EA;
    z += x * L10EA;
    x = (float)e;
    z += x * L102B;
    z += x * L102A;

    return( z );
}
