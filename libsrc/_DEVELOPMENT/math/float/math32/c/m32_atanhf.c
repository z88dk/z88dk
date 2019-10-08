/*
 *	atanh(x)
 */

#include "m32_math.h"

float m32_atanhf (float x) __z88dk_fastcall
{
	return (m32_logf( m32_div2f((1.0 + x)/(1.0 - x))));
}
