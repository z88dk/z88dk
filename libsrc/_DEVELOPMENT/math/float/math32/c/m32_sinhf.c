
#include <math.h>

float sinhf (float x) __z88dk_fastcall
{
    x = expf(x);
    return 0.5*(x-1.0/x);
}

