/*
 *      acos(x)
 */

#include <math/math_fix88.h>



fix16_t fix16_acosh(fix16_t x) __z88dk_fastcall
{
        return logk(
            mulk(x,FIX16_TWO) -
            divk(FIX16_ONE,(x+sqrtk(sqrk(x)-FIX16_ONE)))
        );
}