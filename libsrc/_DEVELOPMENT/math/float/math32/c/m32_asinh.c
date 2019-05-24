/*
 *	asin(x)
 */

#include "m32_math.h"


float m32_asinh(float x) __z88dk_fastcall
{
	return m32_logf(2.*m32_fabsf(x)+1./(m32_sqrtf(x*x+1.)+m32_fabsf(x)));
}
