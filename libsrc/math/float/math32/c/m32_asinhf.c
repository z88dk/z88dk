/*
 *	asinh(x)
 */

#include "m32_math.h"

float m32_asinhf (float x) __z88dk_fastcall
{
    float a, r;

    a = m32_fabsf(x);
    r = m32_logf( m32_mul2f(a) + 1.0/(m32_sqrtf(m32_sqrf(a) + 1.0) + a));
    return x < 0.0 ? -r : r;
}
