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
extern half_t __LIB__ f16_f16_f48(float x);
extern half_t __LIB__ f16_f16_f32(float x);
extern float  __LIB__ f16_f48_f16(half_t x);
extern float  __LIB__ f16_f32_f16(half_t x);

extern int16_t  __LIB__ f16_i16_f16(half_t x);
extern uint16_t __LIB__ f16_u16_f16(half_t x);
extern int32_t  __LIB__ f16_i32_f16(half_t x);
extern uint32_t __LIB__ f16_u32_f16(half_t x);

extern half_t __LIB__ f16_f16_i8(int8_t x);
extern half_t __LIB__ f16_f16_i16(int16_t x);
extern half_t __LIB__ f16_f16_i32(int32_t x);
extern half_t __LIB__ f16_f16_u8(uint8_t x);
extern half_t __LIB__ f16_f16_u16(uint16_t x);
extern half_t __LIB__ f16_f16_u32(uint32_t x);

/* Arithmetic functions */
extern half_t __LIB__ f16_add(half_t x,half_t y) __smallc;
extern half_t __LIB__ f16_sub(half_t x,half_t y) __smallc;
extern half_t __LIB__ f16_mul(half_t x,half_t y) __smallc;
extern half_t __LIB__ f16_div(half_t x,half_t y) __smallc;

extern half_t __LIB__ f16_fma(half_t x,half_t y,half_t z) __smallc;
extern half_t __LIB__ f16_hypot(half_t x,half_t y) __smallc;

/* Power functions */
extern half_t __LIB__ f16_sqrt(half_t x);
extern half_t __LIB__ f16_div2(half_t x);
extern half_t __LIB__ f16_mul2(half_t x);
extern half_t __LIB__ f16_mul10(half_t x);

/* Nearest integer, absolute value, and remainder functions */
extern half_t __LIB__ f16_ceil(half_t x);
extern half_t __LIB__ f16_floor(half_t x);
#define f16_trunc(a) (a>0.?f16_floor(a):f16_ceil(a))
#define f16_round(a) (a>0.?f16_floor(a+0.5):f16_ceil(a-0.5))
#define f16_rint(a) f16_ceil(a)

/* Manipulation */
extern half_t __LIB__ f16_frexp(half_t x, int *pw2) __smallc;
extern half_t __LIB__ f16_ldexp(half_t x, int pw2) __smallc;
#define scalbn(x,pw2) ldexp(x,pw2)

/* Intrinsic functions */
extern half_t __LIB__ f16_inv(half_t a);
extern half_t __LIB__ f16_invsqrt(half_t a);

/* General */
extern half_t __LIB__ f16_fabs(half_t x);
extern half_t __LIB__ f16_neg(half_t x);

/* Classification functions */
#define FP_NORMAL   0
#define FP_ZERO     1
#define FP_NAN      2
#define FP_INFINITE 3
#define FP_SUBNORMAL 4
extern int __LIB__ classify(half_t x);
#define isinf(x) ( classify(x) == FP_INFINITE )
#define isnan(x) ( classify(x) == FP_NAN )
#define isnormal(x) 1
#define isfinite(x) ( classify(x) == FP_NORMAL )

#endif

