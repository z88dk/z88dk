/*
 *	asin(x)
 */

#include <math/math_fix88.h>
#include <stdlib.h>


fix16_t fix16_asinh(fix16_t x) __z88dk_fastcall
{
    return logk(mulk(FIX16_TWO,abs(x)) + 
                    divk(FIX16_ONE, (sqrtk(sqrk(x)+FIX16_ONE)+abs(x)))
    );
}
