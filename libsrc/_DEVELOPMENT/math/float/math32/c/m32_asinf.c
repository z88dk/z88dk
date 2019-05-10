
#include <math.h>

float asinf (float x) __z88dk_fastcall
{
    float y;

    y = sqrtf(1 - sqrf(x));
    return atanf(x/y);
}

