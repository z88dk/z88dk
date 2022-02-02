/*
 *	asinh(x)
 */

#include "am9511_math.h"

float am9511_asinh (float x) __z88dk_fastcall
{
    return log( mul2( fabs(x)) + 1 / (( sqrt( sqr(x) + 1.0) + fabs(x))));
}
