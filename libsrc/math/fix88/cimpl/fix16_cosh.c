/*
 *	acos(x)
 */

#include <math/math_fix88.h>


Accum fix16_cosh(Accum x) __z88dk_fastcall
{
    return mulk(FIX16_HALF, expk(x) + expk(-x));
}
