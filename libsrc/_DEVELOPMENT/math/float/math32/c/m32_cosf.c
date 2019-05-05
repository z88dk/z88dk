
#include <math.h>

float cosf(float f) __z88dk_fastcall
{
    /* cos is pi/2 out of phase with sin, so ... */

    return sinf(f + 1.570796326795);
}

