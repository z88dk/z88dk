
#include "m32_math.h"

float m32_tanhf (const float x) __z88dk_fastcall
{
    float y;

    y = m32_expf(x);
    return (y - m32_invf(y))/(y + m32_invf(y));
}

