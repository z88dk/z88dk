
#include "m32_math.h"

float m32_atan2f (float y, float x)
{
    float v;

    if( x != 0.0)
    {
        if(m32_fabsf(x) >= m32_fabsf(y))
        {
            v = m32_atanf(y/x);
            if( x < 0.0)
            {
                if(y >= 0.0)
                    v += M_PI;
                else
                    v -= M_PI;
            }
        }
        else
        {
            v = -m32_atanf(x/y);
            if(y < 0.0)
                v -= M_PI_2;
            else
                v += M_PI_2;
        }
        return v;
    }
    else
    {
        if( y > 0.0)
        {
            return M_PI_2;
        }
        else if ( y < 0.0)
        {
            return -M_PI_2;
        }
    }
    return 0.0;
}

