
#include "m32_math.h"

float m32_atan2f (float x, float y)
{
    float v;

    if( y != 0.0)
    {
        if(m32_fabsf(y) >= m32_fabsf(x))
        {
            v = m32_atanf(x/y);
            if( y < 0.0)
            {
                if(x >= 0.0)
                    v += PI;
                else
                    v -= PI;
            }
            return v;
        }
        v = -m32_atanf(y/x);
        if(y < 0.0)
            v -= HALF_PI;
        else
            v += HALF_PI;
        return v;
    }
    else
    {
        if( x > 0.0)
        {
            return HALF_PI;
        }
        else if ( x < 0.0)
        {
            return -HALF_PI;
        }
    }
    return 0.0;
}

