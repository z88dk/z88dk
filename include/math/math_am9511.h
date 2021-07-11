#ifndef __MATH_AM9511_H
#define __MATH_AM9511_H

#include <sys/compiler.h>
#include <sys/types.h>
#include <limits.h>

#define FLT_ROUNDS          1
#define FLT_RADIX           2

#define FLT_MANT_DIG        23
#define DBL_MANT_DIG        23
#define FLT_DIG             7
#define DBL_DIG             7

#define HUGE_POS_F32        (+9.2e+18)
#define TINY_POS_F32        (+2.7e-20)
#define HUGE_NEG_F32        (-9.2e+18)
#define TINY_NEG_F32        (-2.7e-20)

#define MAXL2_F32           (+63.0)
#define MINL2_F32           (-64.0)
#define MAXLOG_F32          (+43.6657)
#define MINLOG_F32          (−45.0)
#define MAXL10_F32          (+18.9638)
#define MINL10_F32          (−19.5686)

#define HUGE_VAL_F32        (0x7F800000)
#define INFINITY_POS_F32    (0x7F800000)
#define INFINITY_NEG_F32    (0xFF800000)


/* Trigonometric functions */
extern double_t __LIB__ sin(double_t x);
extern double_t __LIB__ cos(double_t x);
extern double_t __LIB__ tan(double_t x);
extern double_t __LIB__ asin(double_t x);
extern double_t __LIB__ acos(double_t x);
extern double_t __LIB__ atan(double_t x);
extern double_t __LIB__ atan2(double_t y, double_t x) __smallc;

/* Hyperbolic functions */
extern double_t __LIB__ sinh(double_t x);
extern double_t __LIB__ cosh(double_t x);
extern double_t __LIB__ tanh(double_t x);
extern double_t __LIB__ asinh(double_t x);
extern double_t __LIB__ acosh(double_t x);
extern double_t __LIB__ atanh(double_t x);

/* Power functions */
extern double_t __LIB__ sqr(double_t a);
extern double_t __LIB__ sqrt(double_t a);
extern double_t __LIB__ pow(double_t x, double_t y) __smallc;

/* Exponential */
extern double_t __LIB__ exp(double_t x);
extern double_t __LIB__ exp2(double_t x);
extern double_t __LIB__ exp10(double_t x);
extern double_t __LIB__ log(double_t x);
extern double_t __LIB__ log2(double_t x);
extern double_t __LIB__ log10(double_t x);
#define log1p(x) log(1.+x)
#define expm1(x) (exp(x)-1.)

/* Nearest integer, absolute value, and remainder functions */
extern double_t __LIB__ ceil(double_t x);
extern double_t __LIB__ floor(double_t x);
extern double_t __LIB__ round(double_t x);
#define trunc(a) (a>0.?floor(a):ceil(a))
//#define round(a) (a>0.?floor(a+0.5):ceil(a-0.5))
#define rint(a) ceil(a)

/* Manipulation */
extern double_t __LIB__ div2(double_t x);
extern double_t __LIB__ mul2(double_t x);
extern double_t __LIB__ mul10u(double_t x);
extern double_t __LIB__ ldexp(double_t x, int pw2) __smallc;
#define scalbn(x,pw2) ldexp(x,pw2)
extern double_t __LIB__ modf(double_t x, double_t * y) __smallc;
extern double_t __LIB__ frexp(double_t x, int *pw2) __smallc;

/* General */
extern double_t __LIB__ fabs(double_t x);
extern double_t __LIB__ fmod(double_t x, double_t y) __smallc;
extern double_t __LIB__ hypot(double_t x, double_t y) __smallc;

/* Helper functions */
extern double_t __LIB__ atof(char *) __smallc;
extern void __LIB__ ftoa(double_t, int, char *) __smallc;
extern void __LIB__ ftoe(double_t, int, char *) __smallc;

extern double_t __LIB__ f32_fam9511(double_t x);
extern double_t __LIB__ fam9511_f32(double_t x);

/* Classification functions */
#define FP_NORMAL   0
#define FP_ZERO     1
#define FP_NAN      2
#define FP_INFINITE 3
#define FP_SUBNORMAL 4
extern int __LIB__ fpclassify(double_t x);
#define isinf(x) ( fpclassify(x) == FP_INFINITE )
#define isnan(x) ( fpclassify(x) == FP_NAN )
#define isnormal(x) 1
#define isfinite(x) ( fpclassify(x) == FP_NORMAL )

#endif

