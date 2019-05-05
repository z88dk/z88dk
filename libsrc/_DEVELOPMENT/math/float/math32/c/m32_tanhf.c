
#include <math.h>

float tanhf(float x) __z88dk_fastcall
{
    x = expf(x);
    return (x-1.0/x)/(x+1.0/x);
}

