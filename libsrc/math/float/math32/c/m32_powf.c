/*-------------------------------------------------------------------------
   powf.c - Computes x**y where x and y are 32-bit floats.
            WARNING: less that 6 digits accuracy.

   Copyright (C) 2001, 2002, Jesus Calvino-Fraga, jesusc@ieee.org

   This library is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this library; see the file COPYING. If not, write to the
   Free Software Foundation, 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.

   As a special exception, if you link this library with other files,
   some of which are compiled with SDCC, to produce an executable,
   this library does not by itself cause the resulting executable to
   be covered by the GNU General Public License. This exception does
   not however invalidate any other reasons why the executable file
   might be covered by the GNU General Public License.
-------------------------------------------------------------------------*/

/* Version 1.0 - Initial release */

#include "m32_math.h"

float m32_powf (float x, float y)
{
    if(y == 0.0) return 1.0;

    if(x <= 0.0) return 0.0;

    if(y == 1.0) return x;
    if(y == -1.0) return m32_invf(x);

    if(y == 0.5) return m32_sqrtf(x);
    if(y == -0.5) return m32_invsqrtf(x);

    if(y == 2.0) return m32_sqrf(x);
    if(y == -2.0) return m32_invf(m32_sqrf(x));

    /* Integer powers via multiply (avoids log/exp; needed on 8085 while
     * log/exp poly path is still being hardened). */
    {
        int16_t yi = (int16_t)y;
        if ((float)yi == y && yi >= -16 && yi <= 16 && yi != 0) {
            float r = 1.0;
            int16_t n = yi;
            if (n < 0) n = -n;
            while (n--)
                r *= x;
            if (yi < 0)
                return m32_invf(r);
            return r;
        }
    }

    return m32_expf( m32_logf(x) * y);
}
