#ifndef __MATH_MATH16_H
#define __MATH_MATH16_H

#include <sys/compiler.h>
#include <sys/types.h>
#include <limits.h>


#define HUGE_POS_HF     (short)0x7BFF       /*  +6.5504E+4 */
#define TINY_POS_HF     (short)0x0400       /*  +6.1035E-5 */
#define HUGE_NEG_HF     (short)0xFBFF       /*  -6.5504E+4 */
#define TINY_NEG_HF     (short)0x8400       /*  -6.1035E-5 */

#define MAXL2_HF        (short)0x4BFF       /*  +15.99    */
#define MINL2_HF        (short)0xCB00       /*  -14.00    */
#define MAXLOG_HF       (short)0x498B       /*  +11.086   */
#define MINLOG_HF       (short)0xC8DA       /*  -9.700    */       
#define MAXL10_HF       (short)0x44D1       /*  +4.816    */
#define MINL10_HF       (short)0xC437       /*  -4.215    */

#define INFINITY_POS_HF (short)0x7C00
#define INFINITY_NEG_HF (short)0xFC00

#define PI          3.1415926536
#define TWO_PI      6.2831853071
#define HALF_PI     1.5707963268
#define QUART_PI    0.7853981634
#define iPI         0.3183098862
#define iTWO_PI     0.1591549431
#define TWO_O_PI    0.6366197724


// Non-ANSI macros
#define BADTAN          (half_t)1.560796327
#define EXPLARGE        (half_t)89.80081863
#define INF             (half_t)3.00e38
#define IPIby180        (half_t)57.29577951
#define LNof10          (half_t)2.302585093
#define LOG2            (half_t)0.30102999567
#define LOGE            (half_t)0.43429448190
#define PIby180         (half_t)0.0174532925
#define PIbyTWO         (half_t)1.570796326795
#define POW10INF        (half_t)38.0
#define SQR10           (half_t)3.162277660168
#define TWObyPI         (half_t)0.63661977

#define M_E        2.718282
#define M_INVLN2   1.442694  /* 1 / log(2) */
#define M_LOG2E    1.442694
#define M_IVLN10   0.434294  /* 1 / log(10) */
#define M_LOG10E   0.434294
#define M_LOG2_E   0.693146
#define M_LN2      0.693146
#define M_LN10     2.302585
#define M_PI       3.141592
#define M_TWOPI    6.283184
#define M_PI_2     1.570796
#define M_PI_4     0.785396
#define M_3PI_4    2.356194
#define M_SQRTPI   1.772454
#define M_1_PI     0.318310
#define M_2_PI     0.636620
#define M_1_SQRTPI 0.564190
#define M_2_SQRTPI 1.128379
#define M_SQRT2    1.414214
#define M_SQRT3    1.732051
#define M_SQRT1_2  0.707107


/* Power functions */
extern half_t __LIB__ sqrt(half_t a);

/* Nearest integer, absolute value, and remainder functions */
extern half_t __LIB__ ceil(half_t x);
extern half_t __LIB__ floor(half_t x);
#define trunc(a) (a>0.?floor(a):ceil(a))
#define round(a) (a>0.?floor(a+0.5):ceil(a-0.5))
#define rint(a) ceil(a)

/* Manipulation */
extern half_t __LIB__ frexp(half_t x, int *pw2) __smallc;
extern half_t __LIB__ ldexp(half_t x, int pw2) __smallc;
#define scalbn(x,pw2) ldexp(x,pw2)

/* Intrinsic functions */
extern half_t __LIB__ inv(half_t a);
extern half_t __LIB__ invsqrt(half_t a);

/* General */
extern half_t __LIB__ abs(half_t x);

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

