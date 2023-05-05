
/*
 *      acos(x)
 *
 *      -1 < x < 1
 *
 *      Undefined results otherwise
 */

#include <math/math_fix16.h>


Accum fix16_acos(Accum x) __z88dk_fastcall
{
        return ( (FIX16_HALFPI)  - asink(x) );
}
