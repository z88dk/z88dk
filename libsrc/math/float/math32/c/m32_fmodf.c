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

    if (y == 0.0)
        return 0.0;

    k = (long)(x / y); // Note: In some cases, d may be zero.
    d = x - (float)k * y;
    return d >= y ? d - y : d;
}
