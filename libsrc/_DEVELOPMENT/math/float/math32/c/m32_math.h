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

#ifndef _INC_MATH
#define _INC_MATH

#include <stdint.h>
#include <limits.h>

#define HUGE_POS_F32        (float)+3.4028234664E+38
#define TINY_POS_F32        (float)+1.1754943508E−38
#define HUGE_NEG_F32        (float)-1.7014118346E+38
#define TINY_NEG_F32        (float)-1.1754943508E-38

#define MAXL2_F32           (float)+127.999999914
#define MINL2_F32           (float)-126.0
#define MAXLOG_F32          (float)+88.722839052
#define MINLOG_F32          (float)−87.336544751
#define MAXL10_F32          (float)+38.230809449
#define MINL10_F32          (float)−37.929779454

#define HUGE_VAL_F32        ((unsigned long)0x7F800000)
#define INFINITY_POS_F32    ((unsigned long)0x7F800000)
#define INFINITY_NEG_F32    ((unsigned long)0xFF800000)

#define M_E                 2.718282
#define M_INVLN2            1.442694  /* 1 / log(2) */
#define M_LOG2E             1.442694
#define M_IVLN10            0.434294  /* 1 / log(10) */
#define M_LOG10E            0.434294
#define M_LOG2_E            0.693146
#define M_LN2               0.693146
#define M_LN10              2.302585093
#define M_PI                3.1415926536
#define M_TWOPI             6.2831853071
#define M_PI_2              1.5707963268
#define M_PI_4              0.7853981634
#define M_3PI_4             2.356194
#define M_SQRTPI            1.772454
#define M_1_PI              0.3183098862
#define M_2_PI              0.6366197724
#define M_4_PI              1.273240
#define M_1_SQRTPI          0.564190
#define M_2_SQRTPI          1.128379
#define M_SQRT2             1.414214
#define M_SQRT3             1.732051
#define M_SQRT1_2           0.707107

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
float m32_atan2f (float x, float y);

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

#endif  /* _INC_MATH */
