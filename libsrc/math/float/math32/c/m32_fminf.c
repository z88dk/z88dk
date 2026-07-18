/* 8085-friendly fmin — same approach as am9511_fmin.c */

#include "m32_math.h"

float m32_fminf(float x, float y) __z88dk_callee
{
    if (x < y)
        return x;
    return y;
}
