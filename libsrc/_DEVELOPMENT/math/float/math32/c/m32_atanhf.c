/*
 *	atanh(x)
 */

#include "m32_math.h"

float m32_atanh(float x) __z88dk_fastcall
{
	return (m32_logf((1.+x)/(1.-x))*.5);
}
