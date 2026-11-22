
#include "am9511_math.h"

float am9511_atan2 (float y, float x) __stdc
{
    float v;

    if( x != 0.0)
    {
        if(fabs(x) >= fabs(y))
        {
            v = atan(y/x);
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
            v = -atan(x/y);
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

