/*
 *	atanh(x)
 */

#include "m32_math.h"

float m32_atanhf (float x) __z88dk_fastcall
{
    union float_long fl;

    if( x >= 1.0 || x <= -1.0 )
    {
        if( x == 1.0 )
        {
            fl.l = (int32_t)INFINITY_POS_F32;
            return fl.f;
        }
        if( x == -1.0 )
        {
            fl.l = (int32_t)INFINITY_NEG_F32;
            return fl.f;
        }
        fl.l = (int32_t)NAN_NEG_F32;
        return fl.f;
    }
    return m32_logf( m32_div2f((1.0 + x)/(1.0 - x)));
}
