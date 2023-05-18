/*
 *  CPC Maths Routines
 *
 *  August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
 *
 */


#include "am9511_math.h"


float am9511_fmin_callee(float x,float y) __z88dk_callee
{
    float i = x;
    float j = y;
    if ( i < j )
        return i;
    return j;
}

float am9511_fmin(float x,float y)
{
    return am9511_fmin_callee(x,y);
}
