/*
 *	atanh(x)
 */

#include <math/math_fix16.h>


Accum atanh(Accum x) __z88dk_fastcall
{
	return logk( mulk(
          divk( (FIX16_ONE+x), (FIX16_ONE-x)),
          FIX16_HALF)
    );
}
