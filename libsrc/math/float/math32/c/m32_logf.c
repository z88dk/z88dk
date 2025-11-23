/* Natural logarithm
 *
 * SYNOPSIS:
 *
 * float x, y, logf();
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
 * logf singularity:  x = 0; returns MINLOG_F32
 * logf domain:       x < 0; returns MINLOG_F32
 */

/*
 * Cephes Math Library Release 2.2:  June, 1992
 * Copyright 1984, 1987, 1988, 1992 by Stephen L. Moshier
 * Direct inquiries to 30 Frost Street, Cambridge, MA 02140
 */
 
#include "m32_math.h"

#define SQRTHF   ((float)  0.70710678118654752440)

extern float m32_coeff_logf[];

float m32_logf (float x) __z88dk_fastcall
{
    union fl32 {
        float f;
        uint32_t l;
    };

    float y, z;
    float floate;
    int16_t e;

    /* Test for domain */
    if( x <= 0.0 )
    {
        union fl32 fl;
        fl.l = NAN_NEG_F32;
        return fl.f;
    }

    x = m32_frexpf(x, &e);

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
 
    floate = (float)e;
    y += -2.12194440e-4 * floate;

    y -= m32_div2f(z); /* y - 0.5 x^2 */
    z = x + y;      /* ... + x  */
    z += 0.693359375 * floate;

    return( z );
}
