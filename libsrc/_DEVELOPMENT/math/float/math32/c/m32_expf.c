/*
 * Extracted from cephes-math
 *
 * Cephes is a C language library for special functions of mathematical physics
 * and related items of interest to scientists and engineers.
 * https://fossies.org/
 *
 */

#include "m32_math.h"

#define LOG2EF 1.44269504088896341
#define C1 0.693359375
#define C2 -2.12194440e-4

extern float m32_coeff_exp[];

float m32_expf(float x) __z88dk_fastcall
{
    int16_t n;

    /* Express e**x = e**g 2**n
     *   = e**g e**( n loge(2) )
     *   = e**( g + n loge(2) )
     */
    n = m32_floorf( LOG2EF * x + 0.5 );
    x -= (float)n * C1;
    x -= (float)n * C2;

    /* Theoretical peak relative error in [-0.5, +0.5] is 4.2e-9. */
    return m32_ldexpf(((m32_sqrf(x) * m32_polyf(x, m32_coeff_exp, 5)) + x + 1.0), n);
}
