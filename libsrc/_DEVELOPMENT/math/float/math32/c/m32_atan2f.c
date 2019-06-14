
#include "m32_math.h"

float m32_atan2f (float x, float y)
{
    float v;

    if(m32_fabsf(y) >= m32_fabsf(x)) {
        v = m32_atanf(x/y);
        if( y < 0.0)
            if(x >= 0.0)
                v += 3.14159265358979;
            else
                v -= 3.14159265358979;
        return v;
    }
    v = -m32_atanf(y/x);
    if(y < 0.0)
        v -= 1.57079632679489;
    else
        v += 1.57079632679489;
    return v;
}

