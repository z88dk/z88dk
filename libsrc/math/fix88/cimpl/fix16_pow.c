#include <math/math_fix88.h>


fix16_t fix16_pow(fix16_t x, fix16_t y) __z88dk_callee /* x to the power y */
{
	if (y == 0) return FIX16_ONE;
	if (y == FIX16_ONE ) return x;
	if (x <= 0) return 0;
	return expk(mulk(logk(x),y));
}

