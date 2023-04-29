
/*
 *      acos(x)
 *
 *      -1 < x < 1
 *
 *      Undefined results otherwise
 */

#include <math/math_fix88.h>


fix88_t fix88_acos(fix88_t x) __z88dk_fastcall
{
        return ( (FIX88_HALFPI)  - asinfix88(x) );
}
