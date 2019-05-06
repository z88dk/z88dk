
#include <math.h>

float acosf (float x) __z88dk_fastcall
{
    float y;

    y = sqrtf(1 - x*x);
    return atanf(y/x);
}

