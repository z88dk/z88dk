
#include "am9511_math.h"

float am9511_sinhf (const float x) __z88dk_fastcall
{
    float y;

    y = am9511_exp(x);
    return am9511_div2( y - 1/y );
}

