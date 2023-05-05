/*
 *      asin(x)
 *
 *      -1 < x < 1
 *
 *      Undefined results otherwise
 *
 */

#include <math/math_fix16.h>
#include <stdlib.h>


Accum fix16_asin(Accum x) __z88dk_fastcall
{
    Accum  r = atank( divk(abs(x),(FIX16_ONE+sqrtk(FIX16_ONE-(sqrk(x))))));
    if ( x < 0 ) return -r;
    return r;
}