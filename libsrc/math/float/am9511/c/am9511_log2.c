/*  Base 2 logarithm
 *
 * SYNOPSIS:
 *
 * float x, y, log2();
 *
 * y = log2( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns the base 2 logarithm of x.
 *
 */


#include "am9511_math.h"

float am9511_log2 (float x) __z88dk_fastcall
{
    union fl32 {
        float f;
        uint32_t l;
    };

    /* Test for domain */
    if( x <= 0.0 )
    {
        union fl32 fl;
        fl.l = NAN_NEG_F32;
        return fl.f;
    }

    return( log( x ) * M_INVLN2 );
}
