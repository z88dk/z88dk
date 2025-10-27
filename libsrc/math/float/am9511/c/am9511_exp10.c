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
#if 0
    if( x > MAXL10_F32 )
    {
        return( HUGE_POS_F32 );
    }

    if( x < MINL10_F32 )
    {
        return(0.0);
    }
#endif

    if( x == 0.0 )
        return 1.0;

    return exp( x * M_LN10 );
}
