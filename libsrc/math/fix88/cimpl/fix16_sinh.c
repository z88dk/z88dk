/*
 *	asin(x)
 */

#include <math/math_fix88.h>
#include <stdlib.h>

fix16_t fix16_sinh(fix16_t x) __z88dk_fastcall
{
    return mulk(FIX16_HALF, expk(x) - expk(-x));
}
