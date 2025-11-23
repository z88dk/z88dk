
#include "m32_math.h"

float m32_tanhf (float x) __z88dk_fastcall
{
    float y;

    y = m32_expf(x);
    x = m32_invf(y);
    return  (y - x)/(y + x);
}

