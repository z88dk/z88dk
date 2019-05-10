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

#define CHAR_BIT    8    /* bits in a char */
#define SCHAR_MAX   127
#define SCHAR_MIN  -128
#define UCHAR_MAX   0xff

#define INT_MIN     (-32767 - 1)
#define INT_MAX     32767
#define SHRT_MAX    INT_MAX
#define SHRT_MIN    INT_MIN
#define UINT_MAX    0xffff
#define UINT_MIN    0
#define USHRT_MAX   UINT_MAX
#define USHRT_MIN   UINT_MIN
#define LONG_MIN    (-2147483647L-1)
#define LONG_MAX    2147483647L
#define ULONG_MAX   0xffffffff
#define ULONG_MIN   0

#define LLONG_MIN   (-9223372036854775807LL-1)
#define LLONG_MAX   9223372036854775807LL
#define ULLONG_MAX  18446744073709551615ULL

#define HUGE_VALF   3.402823466e+38

#define PI          3.1415926536
#define TWO_PI      6.2831853071
#define HALF_PI     1.5707963268
#define QUART_PI    0.7853981634
#define iPI         0.3183098862
#define iTWO_PI     0.1591549431
#define TWO_O_PI    0.6366197724

// Non-ANSI macros
#define BADTAN          (float)1.560796327
#define EXPLARGE        (float)89.80081863
#define INF             (float)3.00e38
#define IPIby180        (float)57.29577951
#define LNof10          (float)2.302585093
#define LOG2            (float)0.30102999567
#define LOGE            (float)0.43429448190
#define PI              (float)3.14159265359
#define PIby180         (float)0.0174532925
#define PIbyTWO         (float)1.570796326795
#define POW10INF        (float)38.0
#define SQR10           (float)3.162277660168
#define TWObyPI         (float)0.63661977

union float_long
{
    float f;
    int32_t l;
};

    /****************************************
     * Prototypes for ANSI C math functions *
     ****************************************/

/* Trigonometric functions */
float sinf(float x) __z88dk_fastcall;
float cosf(float x) __z88dk_fastcall;
float tanf(float x) __z88dk_fastcall;
float asinf(float x) __z88dk_fastcall;
float acosf(float x) __z88dk_fastcall;
float atanf(float x) __z88dk_fastcall;
float atan2f(float x, float y) __z88dk_callee;

/* Hyperbolic functions */
float sinhf(float x) __z88dk_fastcall;
float coshf(float x) __z88dk_fastcall;
float tanhf(float x) __z88dk_fastcall;

/* Exponential, logarithmic and power functions */
float sqrtf(float a) __z88dk_fastcall;
float expf(float x) __z88dk_fastcall;
float logf(float x) __z88dk_fastcall;
float log10f(float x) __z88dk_fastcall;
float powf(float x, float y) __z88dk_callee;
float hypotf(float x, float y) __z88dk_callee;

/* Nearest integer, absolute value, and remainder functions */
float fabsf(float x) __z88dk_fastcall;
float frexpf(float x, int *pw2) __z88dk_callee;
float ldexpf(float x, int pw2) __z88dk_callee;
float ceilf(float x) __z88dk_fastcall;
float floorf(float x) __z88dk_fastcall;
float modff(float x, float * y) __z88dk_callee;
float fmodf(float x, float y) __z88dk_callee;

/* Intrinsic functions */
float sqrf(float a) __z88dk_fastcall;
float invf(float a) __z88dk_fastcall;
float invsqrtf(float a) __z88dk_fastcall;
float polyf(const float x, const float d[], uint16_t n) __z88dk_callee;

#endif  /* _INC_MATH */
