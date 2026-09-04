/*
   Copyright (c) 2015 Digi International Inc.

   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

#include "m32_math.h"

float m32_fmodf (float x, float y)
{
    long k;
    float d;

    if (y == 0.0) {
        /* match m32_fsconst_pnan (0x7fffffff) */
        union float_long fl;
        fl.l = 0x7fffffff;
        return fl.f;
    }

    k = (long)(x / y); /* trunc toward 0; d can land just below 0 or at y */
    d = x - (float)k * y;
    if (y > 0.0) {
        if (d < 0.0) d += y;
        if (d >= y) d -= y;
    } else {
        if (d > 0.0) d += y;
        if (d <= y) d -= y;
    }
    return d;
}
