
#include "am9511_math.h"

float am9511_tanh (const float x) __z88dk_fastcall
{
    float y,z;

    y = am9511_exp(x);
    z = 1/y;
    
    return (y - z)/(y + z);
}

