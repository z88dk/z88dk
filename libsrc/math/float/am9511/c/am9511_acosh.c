/*
 *	acosh(x)
 */

#include "am9511_math.h"

float am9511_acosh (float x) __z88dk_fastcall
{
    return log( mul2(x) - 1 / (x + sqrt( sqr(x) - 1.0)));
}
