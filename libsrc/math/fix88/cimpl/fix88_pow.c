#include <math/math_fix88.h>


fix88_t fix88_pow(fix88_t x, fix88_t y) __z88dk_callee /* x to the power y */
{
	if (y == 0) return FIX88_ONE;
	if (y == FIX88_ONE ) return x;
	if (x <= 0) return 0;
	return expfix88(mulfix88(logfix88(x),y));
}

