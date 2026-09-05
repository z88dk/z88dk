/*
 *	acosh(x)
 */

#include "m32_math.h"

float m32_acoshf (float x) __z88dk_fastcall
{
    union float_long fl;

    if( x < 1.0 )
    {
        fl.l = (int32_t)NAN_NEG_F32;
        return fl.f;
    }
    return m32_logf(m32_mul2f(x) - 1.0/(x + m32_sqrtf(m32_sqrf(x) - 1.0)));
}
