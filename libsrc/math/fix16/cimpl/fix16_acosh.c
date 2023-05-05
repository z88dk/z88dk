/*
 *      acos(x)
 */

#include <math/math_fix16.h>



Accum fix16_acosh(Accum x) __z88dk_fastcall
{
        return logk(
            mulk(x,FIX16_TWO) -
            divk(FIX16_ONE,(x+sqrtk(sqrk(x)-FIX16_ONE)))
        );
}