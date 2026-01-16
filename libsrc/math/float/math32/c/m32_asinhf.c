/*
 *	asinh(x)
 */

#include "m32_math.h"

float m32_asinhf (float x) __z88dk_fastcall
{
	return m32_logf( m32_mul2f(m32_fabsf(x)) + m32_invf((m32_sqrtf(m32_sqrf(x) + 1.0) + m32_fabsf(x))));
}
