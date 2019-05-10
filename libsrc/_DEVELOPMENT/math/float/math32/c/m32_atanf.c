
#include <math.h>

float atanf (float f) __z88dk_fastcall
{
    int16_t recip;
    float val, val_squared;

    if((val = fabsf(f)) == 0.0)
        return 0.0;
    if(recip = (val > 1.0))
        val = 1.0/val;
    val_squared = sqrf(val);
    val *= polyf(val_squared, m32_coeff_atan_a, 5)/polyf(val_squared, m32_coeff_atan_b, 4);
    if(recip)
        val = 1.570796326795 - val;
    return f < 0.0 ? -val : val;
}

