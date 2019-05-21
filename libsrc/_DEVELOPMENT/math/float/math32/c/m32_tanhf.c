
#include "m32_math.h"

float m32_tanhf (float x) __z88dk_fastcall
{
    x = m32_expf(x);
    return (x-1.0/x)/(x+1.0/x);
}

