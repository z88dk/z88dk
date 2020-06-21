
#include    "math16.h"

extern float f16_coeff_sin_a[];
extern float f16_coeff_sin_b[];

half_t m32_sinf (half_t f)
{
    half_t    y, y_squared;
    int16_t    sect, e;

    if(f < 0.0)
    {
        f = -f;
        sect = 2;
    }
    else
        sect = 0;
    f *= .63661977237;
    if(f > 4.0)
        f -= mul2f16( mul2f16( floorf16( div2f16( div2f16(f) )) ));
    if(f > 2.0)
    {
        f -= 2.0;
        sect = 2 - sect;
    }
    y = f - (half_t)(e = (int16_t)f);
    sect = (e + sect) % 4;
    if(sect & 1)
        y = (half_t)1.0 - y;
    if(sect & 2)
        y = -y;
    y_squared = y*y;
    return y * polyf16(y_squared, f16_coeff_sin_a, 4) / polyf16(y_squared, f16_coeff_sin_b, 4);
}

