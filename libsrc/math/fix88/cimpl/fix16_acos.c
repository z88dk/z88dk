
/*
 *      acos(x)
 *
 *      -1 < x < 1
 *
 *      Undefined results otherwise
 */

#include <math/math_fix88.h>


fix16_t fix16_acos(fix16_t x) __z88dk_fastcall
{
        return ( (FIX16_HALFPI)  - asink(x) );
}
