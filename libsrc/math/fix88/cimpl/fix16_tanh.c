/*
 *	atanh(x)
 */

#include <math/math_fix88.h>


fix16_t fix16_tanh(fix16_t x) __z88dk_fastcall
{
    return divk(
        sinhk(x),
        coshk(x)
    );
}
