/*
 *	asin(x)
 */

#include <math/math_fix16.h>
#include <stdlib.h>

Accum fix16_sinh(Accum x) __z88dk_fastcall
{
    return mulk(FIX16_HALF, expk(x) - expk(-x));
}
