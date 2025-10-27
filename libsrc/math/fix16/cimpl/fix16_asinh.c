/*
 *	asin(x)
 */

#include <math/math_fix16.h>
#include <stdlib.h>


Accum fix16_asinh(Accum x) __z88dk_fastcall
{
    return logk(mulk(FIX16_TWO,abs(x)) + 
                    divk(FIX16_ONE, (sqrtk(sqrk(x)+FIX16_ONE)+abs(x)))
    );
}
