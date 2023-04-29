/*
 *	acos(x)
 */

#include <math/math_fix88.h>


fix88_t fix88_cosh(fix88_t x) __z88dk_fastcall
{
    return mulfix88(FIX88_HALF, expfix88(x) + expfix88(-x));
}
