
#include "am9511_math.h"

float am9511_sinhf (float x) __z88dk_fastcall
{
    x = exp(x);
    return div2( x - 1.0/x );
}

