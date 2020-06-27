
#include "math16.h"

half_t cosf16 (half_t f)
{
    /* cos is pi/2 out of phase with sin, so ... */

    return sinf16( f + (half_t)M_PI_2 );
}

