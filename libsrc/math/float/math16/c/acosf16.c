#include "math16.h"

half_t acosf16 (half_t x) __z88dk_fastcall
{
    union float16_int fl;
    half_t y;

    /* Test for domain */
    if( fabsf16(x) > 1.0 )
    {
        fl.l = NAN_NEG_F16;
        return fl.f;
    }

    y = sqrtf16(1.0 - sqrf16(x));
    /* atan(y/x) loses the quadrant for x < 0 (acos(-1) became 0). */
    return atan2f16(y, x);
}

