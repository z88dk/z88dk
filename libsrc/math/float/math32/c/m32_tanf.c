
#include "m32_math.h"

float m32_tanf (float x) __z88dk_fastcall
{
    return m32_sinf(x)/m32_cosf(x);
}

