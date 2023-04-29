/*
 *	atanh(x)
 */

#include <math/math_fix88.h>


fix88_t atanh(fix88_t x) __z88dk_fastcall
{
	return logfix88( mulfix88(
          divfix88( (FIX88_ONE+x), (FIX88_ONE-x)),
          FIX88_HALF)
    );
}
