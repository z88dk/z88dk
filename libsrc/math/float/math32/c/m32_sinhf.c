
#include "m32_math.h"

float m32_sinhf (float x) __z88dk_fastcall
{
    x = m32_expf(x);
    return m32_div2f( x - m32_invf(x) );
}

