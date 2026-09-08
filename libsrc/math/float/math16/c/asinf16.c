#include "math16.h"

half_t asinf16 (half_t x) __z88dk_fastcall
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
    /* atan2 keeps the correct quadrant when y is ±0 (x = ±1). */
    return atan2f16(x, y);
}

