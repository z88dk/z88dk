#ifndef __MATH_MATH16_H
#define __MATH_MATH16_H

#include <sys/compiler.h>
#include <sys/types.h>
#include <limits.h>


#define HUGE_POS_F16    (_Float16)(short)0x7BFF       /*  +6.5504E+4 */
#define TINY_POS_F16    (_Float16)(short)0x0400       /*  +6.1035E-5 */
#define HUGE_NEG_F16    (_Float16)(short)0xFBFF       /*  -6.5504E+4 */
#define TINY_NEG_F16    (_Float16)(short)0x8400       /*  -6.1035E-5 */

#define MAXL2_F16       (_Float16)(short)0x4BFF       /*  +15.99    */
#define MINL2_F16       (_Float16)(short)0xCB00       /*  -14.00    */
#define MAXLOG_F16      (_Float16)(short)0x498B       /*  +11.086   */
#define MINLOG_F16      (_Float16)(short)0xC8DA       /*  -9.700    */       
#define MAXL10_F16      (_Float16)(short)0x44D1       /*  +4.816    */
#define MINL10_F16      (_Float16)(short)0xC437       /*  -4.215    */

#define HUGE_VAL_F16        (_Float16)(short)0x7C00
#define INFINITY_POS_F16    (_Float16)(short)0x7C00
#define INFINITY_NEG_F16    (_Float16)(short)0xFC00

/* Conversion functions */
extern half_t __LIB__ f16_f48(float x);
extern half_t __LIB__ f16_f32(float x);

extern float  __LIB__ f48_f16(half_t x);
extern float  __LIB__ f32_f16(half_t x);

extern int16_t  __LIB__ i16_f16(half_t x);
extern uint16_t __LIB__ u16_f16(half_t x);
extern int32_t  __LIB__ i32_f16(half_t x);
extern uint32_t __LIB__ u32_f16(half_t x);

extern half_t __LIB__ f16_i8(int8_t x);
extern half_t __LIB__ f16_i16(int16_t x);
extern half_t __LIB__ f16_i32(int32_t x);
extern half_t __LIB__ f16_u8(uint8_t x);
extern half_t __LIB__ f16_u16(uint16_t x);
extern half_t __LIB__ f16_u32(uint32_t x);

/* Arithmetic functions */
extern half_t __LIB__ addf16(half_t x,half_t y) __smallc;
extern half_t __LIB__ subf16(half_t x,half_t y) __smallc;
extern half_t __LIB__ mulf16(half_t x,half_t y) __smallc;
extern half_t __LIB__ divf16(half_t x,half_t y) __smallc;

extern half_t __LIB__ fmaf16(half_t x,half_t y,half_t z) __smallc;
extern half_t __LIB__ polyf16(half_t x,float d[],uint16_t n) __smallc;
extern half_t __LIB__ hypotf16(half_t x,half_t y) __smallc;

/* Power functions */
extern half_t __LIB__ sqrtf16(half_t x);
extern half_t __LIB__ div2f16(half_t x);
extern half_t __LIB__ mul2f16(half_t x);
extern half_t __LIB__ mul10f16(half_t x);

/* Nearest integer, absolute value, and remainder functions */
extern half_t __LIB__ ceilf16(half_t x);
extern half_t __LIB__ floorf16(half_t x);
#definetruncf16(a) (a>0.?f16_floor(a):f16_ceil(a))
#defineroundf16(a) (a>0.?f16_floor(a+0.5):f16_ceil(a-0.5))
#definerint(a)ceil(a)

/* Manipulation */
extern half_t __LIB__ frexpf16(half_t x, int *pw2) __smallc;
extern half_t __LIB__ ldexpf16(half_t x, int pw2) __smallc;
#define scalbnf16(x,pw2) ldexpf16(x,pw2)

/* Intrinsic functions */
extern half_t __LIB__ invf16(half_t a);
extern half_t __LIB__ invsqrtf16(half_t a);

/* General */
extern half_t __LIB__ fabsf16(half_t x);
extern half_t __LIB__ negf16(half_t x);

#endif

