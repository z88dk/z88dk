/*
 *	asinh(x)
 */

#include "am9511_math.h"

float am9511_asinh (const float x) __z88dk_fastcall
{
	return am9511_log( am9511_mul2(am9511_fabs(x)) + 1 / ((am9511_sqrt(am9511_sqr(x) + 1.0) + am9511_fabs(x))));
}
