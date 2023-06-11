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
#if 0
    if( x > MAXL2_F32 )
    {
        return( HUGE_POS_F32 );
    }

    if( x < MINL2_F32 )
    {
        return(0.0);
    }
#endif

    if( x == 0.0 )
        return 1.0;

    return exp( x * M_LN2 );
}
