
#include "am9511_math.h"

float am9511_tanh (float x) __z88dk_fastcall
{
    float y;

    y = exp(x);
    x = 1.0/y;
    return (y - x)/(y + x);
}

