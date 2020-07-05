
#include "m32_math.h"

float m32_cosf (float f) __z88dk_fastcall
{
    /* cos is pi/2 out of phase with sin, so ... */

    return m32_sinf(f + M_PI_2);
}

