
#include <math.h>

float atan2f (float x, float y) __z88dk_fastcall
{
    float v;

    if(fabsf(y) >= fabsf(x)) {
        v = atanf(x/y);
        if( y < 0.0)
            if(x >= 0.0)
                v += 3.14159265358979;
            else
                v -= 3.14159265358979;
        return v;
    }
    v = -atanf(y/x);
    if(y < 0.0)
        v -= 1.57079632679489;
    else
        v += 1.57079632679489;
    return v;
}

