/*
 *	asinh(x)
 */

#include "m32_math.h"

float m32_asinhf (const float x) __z88dk_fastcall
{
	return m32_logf(2.*m32_fabsf(x)+m32_invf((m32_sqrtf(m32_sqrf(x)+1.)+m32_fabsf(x))));
}
