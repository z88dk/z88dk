
#include "m32_math.h"

float m32_coshf (const float x)
{
    float y;

    y = m32_expf(x);
    return 0.5*(y+1.0/y);
}
