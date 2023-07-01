#ifndef __MATH_MATH16_H
#define __MATH_MATH16_H

#ifndef __CLANG

#include <sys/compiler.h>
#include <sys/types.h>
#include <limits.h>

#define HUGE_POS_F16            (+6.5504e+4)        /* 0x7BFF */
#define TINY_POS_F16            (+6.10352e-5)       /* 0x0400 */
#define HUGE_NEG_F16            (-6.5504e+4)        /* 0xFBFF */
#define TINY_NEG_F16            (-6.10352e-5)       /* 0x8400 */

#define MAXL2_F16               (+15.999)           /* 0x4BFF */
#define MINL2_F16               (-14.00)            /* 0xCB00 */
#define MAXLOG_F16              (+11.086)           /* 0x498B */
#define MINLOG_F16              (-9.700)            /* 0xC8DA */      
#define MAXL10_F16              (+4.816)            /* 0x44D1 */
#define MINL10_F16              (-4.215)            /* 0xC437 */

#define HUGE_VAL_F16            ((unsigned int)0x7C00)
#define INFINITY_POS_F16        ((unsigned int)0x7C00)
#define INFINITY_NEG_F16        ((unsigned int)0xFC00)
#define NAN_POS_F16             ((unsigned int)0x7FFF)
#define NAN_NEG_F16             ((unsigned int)0xFFFF)

/* Conversion functions */
#ifdef __SCCZ80
extern half_t __LIB__ f16_f48(float x) __z88dk_fastcall;
extern half_t __LIB__ f16_f32(float x) __z88dk_fastcall;

extern float  __LIB__ f48_f16(half_t x) __z88dk_fastcall;
extern float  __LIB__ f32_f16(half_t x) __z88dk_fastcall;

extern int16_t  __LIB__ i16_f16(half_t x) __z88dk_fastcall;
extern uint16_t __LIB__ u16_f16(half_t x) __z88dk_fastcall;
extern int32_t  __LIB__ i32_f16(half_t x) __z88dk_fastcall;
extern uint32_t __LIB__ u32_f16(half_t x) __z88dk_fastcall;

extern half_t __LIB__ f16_i8(int8_t x) __z88dk_fastcall;
extern half_t __LIB__ f16_i16(int16_t x) __z88dk_fastcall;
extern half_t __LIB__ f16_i32(int32_t x) __z88dk_fastcall;
extern half_t __LIB__ f16_u8(uint8_t x) __z88dk_fastcall;
extern half_t __LIB__ f16_u16(uint16_t x) __z88dk_fastcall;
extern half_t __LIB__ f16_u32(uint32_t x) __z88dk_fastcall;
#else
extern half_t f16_f48(double_t x);
extern half_t f16_f48_fastcall(double_t x) __z88dk_fastcall;
#define f16_f48(a) f16_f48_fastcall(a)


extern double_t f48_f16(half_t x);
extern double_t f48_f16_fastcall(half_t x) __z88dk_fastcall;
#define f48_f16(a) f48_f16_fastcall(a)



extern half_t f16_f32(float_t x);
extern half_t f16_f32_fastcall(float_t x) __z88dk_fastcall;
#define f16_f32(a) f16_f32_fastcall(a)


extern float_t f32_f16(half_t x);
extern float_t f32_f16_fastcall(half_t x) __z88dk_fastcall;
#define f32_f16(a) f32_f16_fastcall(a)

extern int16_t i16_f16(half_t x);
extern int16_t i16_f16_fastcall(half_t x) __z88dk_fastcall;
#define i16_f16(a) i16_f16_fastcall(a)


extern uint16_t u16_f16(half_t x);
extern uint16_t u16_f16_fastcall(half_t x) __z88dk_fastcall;
#define u16_f16(a) u16_f16_fastcall(a)


extern int32_t i32_f16(half_t x);
extern int32_t i32_f16_fastcall(half_t x) __z88dk_fastcall;
#define i32_f16(a) i32_f16_fastcall(a)


extern uint32_t u32_f16(half_t x);
extern uint32_t u32_f16_fastcall(half_t x) __z88dk_fastcall;
#define u32_f16(a) u32_f16_fastcall(a)



extern half_t f16_i8(int8_t x);
extern half_t f16_i8_fastcall(int8_t x) __z88dk_fastcall;
#define f16_i8(a) f16_i8_fastcall(a)

extern half_t f16_i16(int16_t x);
extern half_t f16_i16_fastcall(int16_t x) __z88dk_fastcall;
#define f16_i16(a) f16_i16_fastcall(a)


extern half_t f16_i32(int32_t x);
extern half_t f16_i32_fastcall(int32_t x) __z88dk_fastcall;
#define f16_i32(a) f16_i32_fastcall(a)


extern half_t f16_u8(uint8_t x);
extern half_t f16_u8_fastcall(uint8_t x) __z88dk_fastcall;
#define f16_u8(a) f16_u8_fastcall(a)


extern half_t f16_u16(uint16_t x);
extern half_t f16_u16_fastcall(uint16_t x) __z88dk_fastcall;
#define f16_u16(a) f16_u16_fastcall(a)


extern half_t f16_u32(uint32_t x);
extern half_t f16_u32_fastcall(uint32_t x) __z88dk_fastcall;
#define f16_u32(a) f16_u32_fastcall(a)



#endif

/* Arithmetic functions */
extern half_t __LIB__ addf16(half_t x,half_t y) __smallc;
extern half_t __LIB__ subf16(half_t x,half_t y) __smallc;
extern half_t __LIB__ mulf16(half_t x,half_t y) __smallc;
extern half_t __LIB__ divf16(half_t x,half_t y) __smallc;

extern half_t __LIB__ fmaf16(half_t x,half_t y,half_t z) __smallc;
extern half_t __LIB__ polyf16(half_t x,float d[],uint16_t n) __smallc;
extern half_t __LIB__ hypotf16(half_t x,half_t y) __smallc;

/* Power functions */
extern half_t __LIB__ sqrtf16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ div2f16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ mul2f16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ mul10f16(half_t x) __z88dk_fastcall;

/* Trigonometric functions */
extern half_t __LIB__ acosf16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ asinf16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ atanf16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ atan2f16(half_t y,half_t x) __smallc;

extern half_t __LIB__ cosf16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ sinf16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ tanf16(half_t x) __z88dk_fastcall;

/* Exponential, logarithmic and power functions */
extern half_t __LIB__ expf16 (half_t x) __z88dk_fastcall;
extern half_t __LIB__ exp2f16 (half_t x) __z88dk_fastcall;
extern half_t __LIB__ exp10f16 (half_t x) __z88dk_fastcall;
extern half_t __LIB__ logf16 (half_t x) __z88dk_fastcall;
extern half_t __LIB__ log2f16 (half_t x) __z88dk_fastcall;
extern half_t __LIB__ log10f16 (half_t x) __z88dk_fastcall;
extern half_t __LIB__ powf16 (half_t x, half_t y) __smallc;

/* Nearest integer, absolute value, and remainder functions */
extern half_t __LIB__ ceilf16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ floorf16(half_t x) __z88dk_fastcall;
#define truncf16(a) (a>0.?floorf16(a):ceilf16(a))
#define roundf16(a) (a>0.?floorf16(a+0.5):ceilf16(a-0.5))
#define rintf16(a) ceilf16(a)

/* Manipulation */
extern half_t __LIB__ frexpf16(half_t x, int8_t *pw2) __smallc;
extern half_t __LIB__ ldexpf16(half_t x, int16_t pw2) __smallc;
#define scalbnf16(x,pw2) ldexpf16(x,pw2)

/* Intrinsic functions */
extern half_t __LIB__ invf16(half_t a) __z88dk_fastcall;
extern half_t __LIB__ invsqrtf16(half_t a) __z88dk_fastcall;

/* General */
extern half_t __LIB__ fabsf16(half_t x) __z88dk_fastcall;
extern half_t __LIB__ negf16(half_t x) __z88dk_fastcall;

#endif

#endif

