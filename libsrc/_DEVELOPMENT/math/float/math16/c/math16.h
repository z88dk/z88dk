/*-------------------------------------------------------------------------
   math.h: half_ting point math function declarations

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

#ifndef _INC_MATH16_C
#define _INC_MATH16_C

#include <stdint.h>

#ifndef _FLOAT16_T
#define _FLOAT16_T
#ifndef __SCCZ80
typedef short _Float16;            /* IEEE-754 half float type */
#endif
typedef _Float16 half_t;
#endif

#define HUGE_POS_F16            (0x7BFF)        /*  +6.5504E+4 */
#define TINY_POS_F16            (0x0400)        /*  +6.1035E-5 */
#define HUGE_NEG_F16            (0xFBFF)        /*  -6.5504E+4 */
#define TINY_NEG_F16            (0x8400)        /*  -6.1035E-5 */

#define MAXL2_F16               (0x4BFF)        /*  +15.99    */
#define MINL2_F16               (0xCB00)        /*  -14.00    */
#define MAXLOG_F16              (0x498B)        /*  +11.086   */
#define MINLOG_F16              (0xC8DA)        /*  -9.700    */       
#define MAXL10_F16              (0x44D1)        /*  +4.816    */
#define MINL10_F16              (0xC437)        /*  -4.215    */

#define HUGE_VAL_F16            (0x7C00)
#define INFINITY_POS_F16        (0x7C00)
#define INFINITY_NEG_F16        (0xFC00)

#define HALF_PI                 ((half_t)1.5707963268)

    /****************************************
     * Prototypes for ANSI C math functions *
     ****************************************/
/* Arithmetic functions */
extern half_t __LIB__ fmaf16(half_t x,half_t y,half_t z) __smallc __z88dk_callee;
extern half_t __LIB__ polyf16(half_t x,float d[],uint16_t n) __smallc __z88dk_callee;

/* Power functions */
extern half_t __LIB__ sqrtf16(half_t x) __smallc __z88dk_fastcall;
extern half_t __LIB__ div2f16(half_t x) __smallc __z88dk_fastcall;
extern half_t __LIB__ mul2f16(half_t x) __smallc __z88dk_fastcall;
extern half_t __LIB__ mul10f16(half_t x) __smallc __z88dk_fastcall;

/* Trigonometric functions */
half_t __LIB__ sinf16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ cosf16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ tanf16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ asinf16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ acosf16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ atanf16 (half_t x) __smallc __z88dk_fastcall;

/* Exponential, logarithmic and power functions */
half_t __LIB__ expf16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ exp2f16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ exp10f16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ logf16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ log2f16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ log10f16 (half_t x) __smallc __z88dk_fastcall;
half_t __LIB__ powf16 (half_t x, half_t y) __smallc;

/* Nearest integer, absolute value, and remainder functions */
extern half_t __LIB__ ceilf16(half_t x) __smallc __z88dk_fastcall;
extern half_t __LIB__ floorf16(half_t x) __smallc __z88dk_fastcall;

/* Manipulation */
extern half_t __LIB__ frexpf16(half_t x, int8_t *pw2) __smallc __z88dk_callee;
extern half_t __LIB__ ldexpf16(half_t x, int16_t pw2) __smallc __z88dk_callee;

/* Intrinsic functions */
extern half_t __LIB__ invf16(half_t a) __smallc __z88dk_fastcall;
extern half_t __LIB__ invsqrtf16(half_t a) __smallc __z88dk_fastcall;

/* General */
extern half_t __LIB__ fabsf16(half_t x) __smallc __z88dk_fastcall;
extern half_t __LIB__ negf16(half_t x) __smallc __z88dk_fastcall;

#endif  /* _INC_MATH16_C */

