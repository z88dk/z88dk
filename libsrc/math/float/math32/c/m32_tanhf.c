
#include "m32_math.h"

float m32_tanhf (float x) __z88dk_fastcall
{
    float y;

    y = m32_expf(x);
    x = 1.0/y;
    return  (y - x)/(y + x);
}

