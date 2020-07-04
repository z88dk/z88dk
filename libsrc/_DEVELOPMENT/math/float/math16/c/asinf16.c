
#include "math16.h"

half_t asinf16 (half_t x)
{
    half_t y;

    y = sqrtf16( 1.0 - (x*x) );
    return atanf16( x/y );
}

