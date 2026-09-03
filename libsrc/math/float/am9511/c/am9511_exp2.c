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

    if( x > MAXL2_F32 )
    {
        fl.l = (int32_t)INFINITY_POS_F32;
        return fl.f;
    }

    if( x < MINL2_F32 )
    {
        return 0.0;
    }

    if( x == 0.0 )
        return 1.0;

    return exp( x * M_LN2 );
}
