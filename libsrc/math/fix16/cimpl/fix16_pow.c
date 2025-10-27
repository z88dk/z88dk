#include <math/math_fix16.h>


Accum fix16_pow(Accum x, Accum y) __z88dk_callee /* x to the power y */
{
	if (y == 0) return FIX16_ONE;
	if (y == FIX16_ONE ) return x;
	if (x <= 0) return 0;
	return expk(mulk(logk(x),y));
}

