
#include "m32_math.h"

extern float m32_coeff_atan_a[];
extern float m32_coeff_atan_b[];

float m32_atanf (float f) __z88dk_fastcall
{
    int16_t recip;
    float val, val_squared;

    if((val = m32_fabsf(f)) == 0.0)
        return 0.0;
    if(recip = (val > 1.0))
        val = m32_invf(val);
    val_squared = m32_sqrf(val);
    val *= m32_polyf(val_squared, m32_coeff_atan_a, 5)/m32_polyf(val_squared, m32_coeff_atan_b, 4);
    if(recip)
        val = 1.570796326795 - val;
    return f < 0.0 ? -val : val;
}

