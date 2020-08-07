/*
 *	acosh(x)
 */

#include "am9511_math.h"

float am9511_acosh (float x) __z88dk_fastcall
{
	return am9511_log(am9511_mul2(x) - 1 / (x + am9511_sqrt(am9511_sqr(x) - 1.0)));
}
