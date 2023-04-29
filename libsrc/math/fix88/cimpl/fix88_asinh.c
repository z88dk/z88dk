/*
 *	asin(x)
 */

#include <math/math_fix88.h>
#include <stdlib.h>


fix88_t fix88_asinh(fix88_t x) __z88dk_fastcall
{
    return logfix88(mulfix88(FIX88_TWO,abs(x)) + 
                    divfix88(FIX88_ONE, (sqrtfix88(sqrfix88(x)+FIX88_ONE)+abs(x)))
    );
}
