/*
 *      asin(x)
 *
 *      -1 < x < 1
 *
 *      Undefined results otherwise
 *
 */

#include <math/math_fix88.h>



fix88_t fix88_asin(fix88_t x) __z88dk_fastcall
{
        return atanfix88( divfix88(x,(FIX88_ONE+sqrtfix88(FIX88_ONE-(sqrfix88(x))))));
}