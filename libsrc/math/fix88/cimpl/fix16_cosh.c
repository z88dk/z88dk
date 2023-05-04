/*
 *	acos(x)
 */

#include <math/math_fix88.h>


fix16_t fix16_cosh(fix16_t x) __z88dk_fastcall
{
    return mulk(FIX16_HALF, expk(x) + expk(-x));
}
