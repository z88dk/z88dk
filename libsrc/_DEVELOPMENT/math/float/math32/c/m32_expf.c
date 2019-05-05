
#include <math.h>

float expf(float x) __z88dk_fastcall
{
    int16_t exp;
    uint8_t sign;

    if(x == 0.0)
        return 1.0;
    sign = x < 0.0;
    if(sign)
        x = -x;
    x *= 1.4426950409;        /* convert to log2 */
    exp = (uint16_t)floorf(x);
    x -= (float)exp;
    x = ldexpf(polyf(x, m32_coeff_exp, 9), exp);
    if(sign)
        return 1.0/x;
    return x;
}

