/*
 *	acos(x)
 */

#include "m32_math.h"

float m32_acosh(float x) __z88dk_fastcall
{
	return m32_logf(2.*x-1./(x+m32_sqrtf(x*x-1.)));
}
