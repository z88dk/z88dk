/*
 *	atanh(x)
 */

#include <math/math_fix88.h>


fix88_t fix88_tanh(fix88_t x) __z88dk_fastcall
{
    return divfix88(
        sinhfix88(x),
        coshfix88(x)
    );
}
