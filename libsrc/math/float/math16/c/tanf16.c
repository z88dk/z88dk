
#include "math16.h"

half_t tanf16 (half_t x) 
{
    return sinf16(x)/cosf16(x);
}

