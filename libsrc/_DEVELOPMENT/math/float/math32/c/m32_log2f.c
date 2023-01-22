/*  Base 2 logarithm
 *
 * SYNOPSIS:
 *
 * float x, y, log2f();
 *
 * y = log2f( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns the base 2 logarithm of x.
 *
 * The argument is separated into its exponent and fractional
 * parts.  If the exponent is between -1 and +1, the base e
 * logarithm of the fraction is approximated by
 *
 *     log(1+x) = x - 0.5 x**2 + x**3 P(x)/Q(x).
 *
 * Otherwise, setting  z = 2(x-1)/x+1),
 *
 *     log(x) = z + z**3 P(z)/Q(z).
 *
 *
 * ACCURACY:
 *
 *                      Relative error:
 * arithmetic   domain     # trials      peak         rms
 *    IEEE      exp(+-88)   100000      1.1e-7      2.4e-8
 *    IEEE      0.5, 2.0    100000      1.1e-7      3.0e-8
 *
 * In the tests over the interval [exp(+-88)], the logarithms
 * of the random arguments were uniformly distributed.
 *
 * ERROR MESSAGES:
 *
 * log singularity:  x = 0; returns MINLOG_F32/log(2)
 * log domain:       x < 0; returns MINLOG_F32/log(2)
 */

/*
Cephes Math Library Release 2.2:  June, 1992
Copyright 1984, 1992 by Stephen L. Moshier
Direct inquiries to 30 Frost Street, Cambridge, MA 02140
*/

#include "m32_math.h"

#define SQRTHF      ((float) 0.70710678118654752440)
#define LOG2EA      ((float) 0.44269504088896340735992)

extern float m32_coeff_logf[];


float m32_log2f (float x) __z88dk_fastcall
{
    union fl32 {
        float f;
        uint32_t l;
    };

    float y, z;
    int16_t e;

    /* Test for domain */
    if( x <= 0.0 )
    {
        union fl32 fl;
        fl.l = NAN_NEG_F32;
        return fl.f;
    }

    /* separate mantissa from exponent */
    
    x = m32_frexpf( x, &e );

    /* logarithm using log(1+x) = x - .5x**2 + x**3 P(x)/Q(x) */

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

    /* Multiply log of fraction by log2(e)
     * and base 2 exponent by 1
     *
     * ***CAUTION***
     *
     * This sequence of operations is critical and it may
     * be horribly defeated by some compiler optimizers.
     */

    z = y * LOG2EA;
    z += x * LOG2EA;
    z += y;
    z += x;
    z += (float)e;

    return( z );
}
