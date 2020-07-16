#ifndef __MATH_MATH32_H
#define __MATH_MATH32_H

#include <sys/compiler.h>
#include <sys/types.h>
#include <limits.h>


#define HUGE_POS_F32    (float)+3.4028234664E+38
#define TINY_POS_F32    (float)+1.1754943508E−38
#define HUGE_NEG_F32    (float)-1.7014118346E+38
#define TINY_NEG_F32    (float)-1.1754943508E-38

#define MAXL2_F32       ((float)+127.999999914)
#define MINL2_F32       ((float)-126.0)
#define MAXLOG_F32      ((float)+88.722839052)
#define MINLOG_F32      ((float)−87.336544751)
#define MAXL10_F32      ((float)+38.230809449)
#define MINL10_F32      ((float)−37.929779454)

#define HUGE_VAL_F32        ((unsigned long)0x7F800000)
#define INFINITY_POS_F32    ((unsigned long)0x7F800000)
#define INFINITY_NEG_F32    ((unsigned long)0xFF800000)


/* Trigonometric functions */
extern double_t __LIB__ sin(double_t x);
extern double_t __LIB__ cos(double_t x);
extern double_t __LIB__ tan(double_t x);
extern double_t __LIB__ asin(double_t x);
extern double_t __LIB__ acos(double_t x);
extern double_t __LIB__ atan(double_t x);
extern double_t __LIB__ atan2(double_t x, double_t y) __smallc;

/* Hyperbolic functions */
extern double_t __LIB__ sinh(double_t x);
extern double_t __LIB__ cosh(double_t x);
extern double_t __LIB__ tanh(double_t x);
extern double_t __LIB__ asinh(double_t x);
extern double_t __LIB__ acosh(double_t x);
extern double_t __LIB__ atanh(double_t x);

/* Power functions */
extern double_t __LIB__ pow(double_t x, double_t y) __smallc;
extern double_t __LIB__ sqrt(double_t a);

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
extern double_t __LIB__ ldexp(double_t x, int pw2) __smallc;
#define scalbn(x,pw2) ldexp(x,pw2)
extern double_t __LIB__ modf(double_t x, double_t * y) __smallc;
extern double_t __LIB__ frexp(double_t x, int *pw2) __smallc;

/* Intrinsic functions */
extern double_t __LIB__ sqr(double_t a);
extern double_t __LIB__ inv(double_t a);
extern double_t __LIB__ invsqrt(double_t a);

/* General */
extern double_t __LIB__ fabs(double_t x);
extern double_t __LIB__ fmod(double_t x, double_t y) __smallc;
extern double_t __LIB__ hypot(double_t x, double_t y) __smallc;

/* Helper functions */
extern double_t __LIB__ atof(char *) __smallc;
extern void __LIB__ ftoa(double_t, int, char *) __smallc;
extern void __LIB__ ftoe(double_t, int, char *) __smallc;

extern double_t __LIB__ f32_fam9511(double_t x) __smallc;
extern double_t __LIB__ fam9511_f32(double_t x) __smallc;

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

