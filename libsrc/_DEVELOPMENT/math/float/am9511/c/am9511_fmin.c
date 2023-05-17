/*
 *  CPC Maths Routines
 *
 *  August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
 *
 */


#include "am9511_math.h"


float fmin(float x,float y) __stdc
{
    if ( x < y )
        return x;
    return y;
}
