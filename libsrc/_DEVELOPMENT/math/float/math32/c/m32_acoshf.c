/*
 *	acosh(x)
 */

#include "m32_math.h"

float m32_acoshf (float x) __z88dk_fastcall
{
	return m32_logf(m32_mul2f(x) - m32_invf(x + m32_sqrtf(m32_sqrf(x) - 1.0)));
}
