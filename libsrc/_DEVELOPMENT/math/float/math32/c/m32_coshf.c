
#include <math.h>

float coshf (const float x) __z88dk_fastcall
{
    float y;

    y = expf(x);
    return 0.5*(y+1.0/y);
}
