/*
 *	atanh(x)
 */

#include <math/math_fix16.h>


Accum fix16_tanh(Accum x) __z88dk_fastcall
{
    return divk(
        sinhk(x),
        coshk(x)
    );
}
