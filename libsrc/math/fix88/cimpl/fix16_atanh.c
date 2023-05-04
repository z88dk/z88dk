/*
 *	atanh(x)
 */

#include <math/math_fix88.h>


fix16_t atanh(fix16_t x) __z88dk_fastcall
{
	return logk( mulk(
          divk( (FIX16_ONE+x), (FIX16_ONE-x)),
          FIX16_HALF)
    );
}
