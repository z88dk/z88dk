/*    Base 10 exponential function
 *      (Common antilogarithm)
 *
 * SYNOPSIS:
 *
 * float x, y, exp10f();
 *
 * y = exp10f( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns 10 raised to the x power.
 *
 */


#include "am9511_math.h"

float am9511_exp10 (float x) __z88dk_fastcall
{
    union float_long fl;

    if( x > MAXL10_F32 )
    {
        fl.l = (int32_t)INFINITY_POS_F32;
        return fl.f;
    }

    if( x < MINL10_F32 )
    {
        return 0.0;
    }

    if( x == 0.0 )
        return 1.0;

    return exp( x * M_LN10 );
}
