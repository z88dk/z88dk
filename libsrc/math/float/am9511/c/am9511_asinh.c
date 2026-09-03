/*
 *	asinh(x)
 */

#include "am9511_math.h"

float am9511_asinh (float x) __z88dk_fastcall
{
    float a, r;

    a = fabs(x);
    r = log( mul2(a) + 1.0 / (sqrt(sqr(a) + 1.0) + a) );
    return x < 0.0 ? -r : r;
}
