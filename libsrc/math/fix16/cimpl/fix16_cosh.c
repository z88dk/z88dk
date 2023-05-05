/*
 *	acos(x)
 */

#include <math/math_fix16.h>


Accum fix16_cosh(Accum x) __z88dk_fastcall
{
    return mulk(FIX16_HALF, expk(x) + expk(-x));
}
