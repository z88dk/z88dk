
#include "m32_math.h"

float m32_acosf (float x) __z88dk_fastcall
{
    union float_long fl;
    float y;

    /* Test for domain */
    if( m32_fabsf(x) > 1.0 )
    {
        fl.l = (int32_t)NAN_NEG_F32;
        return fl.f;
    }

    y = m32_sqrtf(1.0 - m32_sqrf(x));
    /* atan(y/x) loses the quadrant for x < 0 (acos(-1) became 0). */
    return m32_atan2f(y, x);
}

