
#include "m32_math.h"

//  Approximation of f(x) = atan(x)
//  with weight function g(x) = atan(x)
//  on interval [ 0, 1 ]
//  with a polynomial of degree 7.
//
//  float f(float x)
//  {
//    float u = +5.3387679e-2f;
//    u = u * x + -2.2568632e-1f;
//    u = u * x + +3.2087456e-1f;
//    u = u * x + -3.4700353e-2f;
//    u = u * x + -3.2812673e-1f;
//    u = u * x + -3.5815786e-4f;
//    u = u * x + +1.0000081f;
//    return u * x + 4.2012834e-19f;
//  }

extern float m32_coeff_atan[];

float m32_atanf (float f) __z88dk_fastcall
{
    uint8_t recip;
    float val;

    if((val = m32_fabsf(f)) == 0.0)
        return 0.0;
    if(recip = (val > 1.0))
        val = m32_invf(val);
    val = m32_polyf(val, m32_coeff_atan, 7);
    if(recip)
        val = M_PI_2 - val;
    return f < 0.0 ? -val : val;
}

