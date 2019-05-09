
#include <math.h>

float acosf (float x) __z88dk_fastcall
{
    float y;

    y = sqrtf(1 - sqrf(x));
    return atanf(y/x);
}

