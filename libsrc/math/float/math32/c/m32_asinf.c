
#include "m32_math.h"

float m32_asinf (float x) __z88dk_fastcall
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
    /* atan2 keeps the correct quadrant when y is ±0 (x = ±1). */
    return m32_atan2f(x, y);
}

