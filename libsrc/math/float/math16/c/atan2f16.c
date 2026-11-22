#include "math16.h"

half_t atan2f16 (half_t y, half_t x)
{
    half_t v, ax, ay;

    if( x != 0.0)
    {
        /* Locals, not nested fabs(): 8080/8085/gbz80 sccz80 stack offsets
         * around a live push of fabs(x) were wrong (2-byte half slots). */
        ax = fabsf16(x);
        ay = fabsf16(y);
        if(ax >= ay)
        {
            v = atanf16(y/x);
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
            v = -atanf16(x/y);
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

