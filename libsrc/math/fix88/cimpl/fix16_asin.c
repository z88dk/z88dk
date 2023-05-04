/*
 *      asin(x)
 *
 *      -1 < x < 1
 *
 *      Undefined results otherwise
 *
 */

#include <math/math_fix88.h>
#include <stdlib.h>


fix16_t fix16_asin(fix16_t x) __z88dk_fastcall
{
    fix16_t  r = atank( divk(abs(x),(FIX16_ONE+sqrtk(FIX16_ONE-(sqrk(x))))));
    if ( x < 0 ) return -r;
    return r;
}