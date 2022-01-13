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

#ifndef _INC_AM9511_C
#define _INC_AM9511_C

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

#ifdef __SDCC

/* Trigonometric functions */
float sin (float x) __z88dk_fastcall;
float cos (float x) __z88dk_fastcall;
float tan (float x) __z88dk_fastcall;
float asin (float x) __z88dk_fastcall;
float acos (float x) __z88dk_fastcall;
float atan (float x) __z88dk_fastcall;

float am9511_atan2 (float y, float x);

/* Hyperbolic functions */
float am9511_sinh (float x) __z88dk_fastcall;
float am9511_cosh (float x) __z88dk_fastcall;
float am9511_tanh (float x) __z88dk_fastcall;
float am9511_asinh (float x) __z88dk_fastcall;
float am9511_acosh (float x) __z88dk_fastcall;
float am9511_atanh (float x) __z88dk_fastcall;

/* Exponential, logarithmic and power functions */
float log (float x) __z88dk_fastcall;
float log10 (float x) __z88dk_fastcall;
float exp (float x) __z88dk_fastcall;
float pow (float x, float y) __z88dk_callee;

float am9511_log2 (float x) __z88dk_fastcall;
float am9511_exp2 (float x) __z88dk_fastcall;
float am9511_exp10 (float x) __z88dk_fastcall;

/* Nearest integer, absolute value, and remainder functions */
float ceil (float x) __z88dk_fastcall;
float fabs (float x) __z88dk_fastcall;
float floor (float x) __z88dk_fastcall;

float am9511_round (float x) __z88dk_fastcall;
float am9511_fmod (float x, float y);
float am9511_modf (float x, float *y);

/* Intrinsic functions */
float mul2 (float a) __z88dk_fastcall;
float div2 (float a) __z88dk_fastcall;
float sqr (float a) __z88dk_fastcall;
float sqrt (float a) __z88dk_fastcall;
float frexp (float x, int16_t *pw2) __z88dk_callee;
float ldexp (float x, int16_t pw2) __z88dk_callee;
float hypot (float x, float y) __z88dk_callee;

#endif

#ifdef __SCCZ80

/* Trigonometric functions */
float sin (float x) __smallc __z88dk_fastcall;
float cos (float x) __smallc __z88dk_fastcall;
float tan (float x) __smallc __z88dk_fastcall;
float asin (float x) __smallc __z88dk_fastcall;
float acos (float x) __smallc __z88dk_fastcall;
float atan (float x) __smallc __z88dk_fastcall;

float am9511_atan2 (float y, float x) __smallc;

/* Hyperbolic functions */
float am9511_sinh (float x) __smallc __z88dk_fastcall;
float am9511_cosh (float x) __smallc __z88dk_fastcall;
float am9511_tanh (float x) __smallc __z88dk_fastcall;
float am9511_asinh (float x) __smallc __z88dk_fastcall;
float am9511_acosh (float x) __smallc __z88dk_fastcall;
float am9511_atanh (float x) __smallc __z88dk_fastcall;

/* Exponential, logarithmic and power functions */
float log (float x) __smallc __z88dk_fastcall;
float log10 (float x) __smallc __z88dk_fastcall;
float exp (float x) __smallc __z88dk_fastcall;
float pow (float x, float y) __smallc __z88dk_callee;

float am9511_log2 (float x) __smallc __z88dk_fastcall;
float am9511_exp2 (float x) __smallc __z88dk_fastcall;
float am9511_exp10 (float x) __smallc __z88dk_fastcall;

/* Nearest integer, absolute value, and remainder functions */
float ceil (float x) __smallc __z88dk_fastcall;
float fabs (float x) __smallc __z88dk_fastcall;
float floor (float x) __smallc __z88dk_fastcall;

float am9511_round (float x) __smallc __z88dk_fastcall;
float am9511_fmod (float x, float y) __smallc;
float am9511_modf (float x, float *y) __smallc;

/* Intrinsic functions */
float mul2 (float a) __smallc __z88dk_fastcall;
float div2 (float a) __smallc __z88dk_fastcall;
float sqr (float a) __smallc __z88dk_fastcall;
float sqrt (float a) __smallc __z88dk_fastcall;
float frexp (float x, int16_t *pw2) __smallc __z88dk_callee;
float ldexp (float x, int16_t pw2) __smallc __z88dk_callee;
float hypot (float x, float y) __smallc __z88dk_callee;

#endif

#endif  /* _INC_AM9511_C */
