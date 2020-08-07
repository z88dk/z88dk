
#include "am9511_math.h"

float am9511_atan2 (float x, float y)
{
    float v;

    if( y != 0.0)
    {
        if(am9511_fabs(y) >= am9511_fabs(x))
        {
            v = am9511_atan(x/y);
            if( y < 0.0)
            {
                if(x >= 0.0)
                    v += M_PI;
                else
                    v -= M_PI;
            }
            return v;
        }
        v = -am9511_atan(y/x);
        if(y < 0.0)
            v -= M_PI_2;
        else
            v += M_PI_2;
        return v;
    }
    else
    {
        if( x > 0.0)
        {
            return M_PI_2;
        }
        else if ( x < 0.0)
        {
            return -M_PI_2;
        }
    }
    return 0.0;
}

