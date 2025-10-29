/*-------------------------------------------------------------------------
   math.h: Floating point math function declarations

   Copyright (C) 2001, Jesus Calvino-Fraga, jesusc@ieee.org

   This library is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
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

#ifndef _INC_MATH32_C
#define _INC_MATH32_C

#include <stdint.h>
#include <math.h>

union float_long
{
    float f;
    int32_t l;
};

    /****************************************
     * Prototypes for ANSI C math functions *
     ****************************************/

/* Trigonometric functions */
float m32_sinf (float x) __z88dk_fastcall;
float m32_cosf (float x) __z88dk_fastcall;
float m32_tanf (float x) __z88dk_fastcall;
float m32_asinf (float x) __z88dk_fastcall;
float m32_acosf (float x) __z88dk_fastcall;
float m32_atanf (float x) __z88dk_fastcall;
float m32_atan2f (float y, float x);

/* Hyperbolic functions */
float m32_sinhf (float x) __z88dk_fastcall;
float m32_coshf (float x) __z88dk_fastcall;
float m32_tanhf (float x) __z88dk_fastcall;
float m32_asinhf (float x) __z88dk_fastcall;
float m32_acoshf (float x) __z88dk_fastcall;
float m32_atanhf (float x) __z88dk_fastcall;

/* Exponential, logarithmic and power functions */
float m32_expf (float x) __z88dk_fastcall;
float m32_exp2f (float x) __z88dk_fastcall;
float m32_exp10f (float x) __z88dk_fastcall;
float m32_logf (float x) __z88dk_fastcall;
float m32_log2f (float x) __z88dk_fastcall;
float m32_log10f (float x) __z88dk_fastcall;
float m32_powf (float x, float y);

/* Nearest integer, absolute value, and remainder functions */
float m32_ceilf (float x) __z88dk_fastcall;
float m32_fabsf (float x) __z88dk_fastcall;
float m32_floorf (float x) __z88dk_fastcall;
float m32_roundf (float x) __z88dk_fastcall;
float m32_fmodf (float x, float y);
float m32_modff (float x, float *y);

/* Intrinsic functions */
float m32_mul2f (float a) __z88dk_fastcall;
float m32_div2f (float a) __z88dk_fastcall;
float m32_sqrf (float a) __z88dk_fastcall;
float m32_invf (float a) __z88dk_fastcall;
float m32_sqrtf (float a) __z88dk_fastcall;
float m32_invsqrtf (float a) __z88dk_fastcall;
float m32_frexpf (float x, int16_t *pw2) __z88dk_callee;
float m32_ldexpf (float x, int16_t pw2) __z88dk_callee;
float m32_hypotf (float x, float y) __z88dk_callee;
float m32_polyf (const float x, const float d[], uint16_t n) __z88dk_callee;

#endif  /* _INC_MATH32_C */
