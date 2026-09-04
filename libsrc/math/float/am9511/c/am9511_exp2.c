/*	Base 2 exponential function
 *
 *
 * SYNOPSIS:
 *
 * float x, y, exp2f();
 *
 * y = exp2f( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns 2 raised to the x power.
 *
 */


#include "am9511_math.h"

float am9511_exp2 (float x) __z88dk_fastcall
{
    union float_long fl;

    /* MAXL2 is 63.  |x| < 32 (hi < 0x42) is in range.  |x| >= 128 overflows. */
    fl.f = x;
    {
        uint8_t hi = am9511_ieee_hi(fl);
        if( (hi & 0x7f) >= 0x43 )
        {
            if( hi & 0x80 )
                return 0.0;
            fl.l = (int32_t)INFINITY_POS_F32;
            return fl.f;
        }
        if( (hi & 0x7f) >= 0x42 )
        {
            if( x > MAXL2_F32 )
            {
                fl.l = (int32_t)INFINITY_POS_F32;
                return fl.f;
            }
            if( x < MINL2_F32 )
                return 0.0;
        }
    }

    if( x == 0.0 )
        return 1.0;

    return exp( x * M_LN2 );
}
