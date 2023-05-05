
/*
 *      acos(x)
 *
 *      -1 < x < 1
 *
 *      Undefined results otherwise
 */

#include <math/math_fix88.h>


Accum fix16_acos(Accum x) __z88dk_fastcall
{
        return ( (FIX16_HALFPI)  - asink(x) );
}
