
#include "math16.h"

half_t acosf16 (half_t x)
{
    union fl16 {
        half_t f;
        uint16_t l;
    };

    half_t y;

    /* Test for domain */
    if( fabsf16(x) > 1.0 )
    {
        union fl16 fl;
        fl.l = NAN_NEG_F16;
        return fl.f;
    }

    y = sqrtf16( 1.0 - (x*x) );
    return atanf16( y/x );
}

