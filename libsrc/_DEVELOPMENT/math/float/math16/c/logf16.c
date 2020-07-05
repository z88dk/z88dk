/* Natural logarithm
 *
 * SYNOPSIS:
 *
 * half_t x, y, logf();
 *
 * y = logf( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns the base e (2.718...) logarithm of x.
 *
 * The argument is separated into its exponent and fractional
 * parts.  If the exponent is between -1 and +1, the logarithm
 * of the fraction is approximated by
 *
 *     log(1+x) = x - 0.5 x**2 + x**3 P(x)
 *
 *
 * ACCURACY:
 *
 *                      Relative error:
 * arithmetic   domain     # trials      peak         rms
 *    IEEE      0.5, 2.0    100000       7.6e-8     2.7e-8
 *    IEEE      1, MAXNUMF  100000                  2.6e-8
 *
 * In the tests over the interval [1, MAXNUM], the logarithms
 * of the random arguments were uniformly distributed over
 * [0, MAXLOG_F].
 *
 * ERROR MESSAGES:
 *
 * logf singularity:  x = 0; returns HUGE_NEG_F16
 * logf domain:       x < 0; returns HUGE_NEG_F16
 * MAXLOG_F16         0x498B     /*  +11.086   */
 */

/*
 * Cephes Math Library Release 2.2:  June, 1992
 * Copyright 1984, 1987, 1988, 1992 by Stephen L. Moshier
 * Direct inquiries to 30 Frost Street, Cambridge, MA 02140
 */
 
#include "math16.h"

half_t __LIB__ logf16 (half_t x) __smallc __z88dk_fastcall;

half_t logf16 (half_t x)
{
    half_t y, z, halfe;
    int16_t e;

    /* Test for domain */
    if( x <= 0.0 )
        return HUGE_NEG_F16;

    /* separate mantissa from exponent */
    x = frexpf16(x, &e);

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

    y = polyf16(x, f16_coeff_log, 9) * z;
 
    halfe = (half_t)e;
    y +=  halfe * -2.12194440e-4;

    y -= div2f16(z); /* y - 0.5 x^2 */
    z = x + y;      /* ... + x  */
    z += halfe * 0.693359375;

    return( z );
}

