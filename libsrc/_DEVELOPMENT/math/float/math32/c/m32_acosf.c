
#include "m32_math.h"

float m32_acosf (float x) __z88dk_fastcall
{
    union fl32 {
        float f;
        uint32_t l;
    };

    float y;

    /* Test for domain */
    if( fabs(x) > 1.0 )
    {
        union fl32 fl;
        fl.l = NAN_NEG_F32;
        return fl.f;
    }

    y = m32_sqrtf(1.0 - m32_sqrf(x));
    return m32_atanf(y/x);
}

