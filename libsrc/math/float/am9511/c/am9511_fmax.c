/*
 *  CPC Maths Routines
 *
 *  August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
 *
 */


#include "am9511_math.h"


float am9511_fmax_callee(float x,float y) __z88dk_callee
{
    if ( x > y )
        return x;
    return y;
}

float am9511_fmax(float x,float y)
{
    return am9511_fmax_callee(x,y);
}
