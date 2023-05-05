/*
 *	atanh(x)
 */

#include <math/math_fix88.h>


Accum fix16_tanh(Accum x) __z88dk_fastcall
{
    return divk(
        sinhk(x),
        coshk(x)
    );
}
