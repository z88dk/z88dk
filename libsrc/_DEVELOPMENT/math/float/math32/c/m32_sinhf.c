
#include "m32_math.h"

float m32_sinhf (float x) __z88dk_fastcall
{
    x = m32_expf(x);
    return 0.5*(x-1.0/x);
}

