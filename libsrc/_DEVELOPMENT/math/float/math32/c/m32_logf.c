
#include "m32_math.h"

extern float m32_coeff_log[];

float m32_logf(float x) __z88dk_fastcall
{
    int exp;

    /* zero or -ve arguments are not defined */

    if(x <= 0.0)
        return 0.0;
    x = m32_frexpf(x, &exp) * 2.0 - 1.0;
    exp--;
    x = m32_poly(x, m32_coeff_log, 8);
    return x + 0.69314718055995 * exp;
}

