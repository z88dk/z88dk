/* 8085-friendly fmax — same approach as am9511 */

#include "m32_math.h"

float m32_fmaxf(float x, float y) __z88dk_callee
{
    if (x > y)
        return x;
    return y;
}
