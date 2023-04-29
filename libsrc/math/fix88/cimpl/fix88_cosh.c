/*
 *	acos(x)
 */

#include <math/math_fix88.h>


fix88_t acosh(fix88_t x) __z88dk_fastcall
{
	return logfix88( 
        mulfix88(FIX88_TWO,x) -
        divfix88(FIX88_ONE, (x+sqrtfix88(sqrfix88(x)-FIX88_ONE)))
    );
}
