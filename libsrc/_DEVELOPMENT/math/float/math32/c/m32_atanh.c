/*
 *	atanh(x)
 */

#include "m32_math.h"

float m32_atanh(float x)
{
	return (m32_logf((1.+x)/(1.-x))*.5);
}
