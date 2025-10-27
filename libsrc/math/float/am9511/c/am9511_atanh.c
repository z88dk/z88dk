/*
 *	atanh(x)
 */

#include "am9511_math.h"

float am9511_atanh (float x) __z88dk_fastcall
{
    return ( log( div2((1.0 + x)/(1.0 - x))));
}
