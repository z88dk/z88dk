/*
 *	atanh(x)
 */

#include <math/math_fix88.h>


fix88_t fix88_atanh(fix88_t x) __z88dk_fastcall
{
	return mulfix88(
        logfix88( 
            divfix88( (FIX88_ONE+x), (FIX88_ONE-x) )
        ),
        FIX88_HALF);
}
