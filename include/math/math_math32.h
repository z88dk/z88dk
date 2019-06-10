#ifndef __MATH_MATH32_H
#define __MATH_MATH32_H

#include <sys/compiler.h>
#include <sys/types.h>
#include <limits.h>



#define HUGE_VALF   3.402823466e+38

#define PI          3.1415926536
#define TWO_PI      6.2831853071
#define HALF_PI     1.5707963268
#define QUART_PI    0.7853981634
#define iPI         0.3183098862
#define iTWO_PI     0.1591549431
#define TWO_O_PI    0.6366197724


// Non-ANSI macros
#define BADTAN          (double_t)1.560796327
#define EXPLARGE        (double_t)89.80081863
#define INF             (double_t)3.00e38
#define IPIby180        (double_t)57.29577951
#define LNof10          (double_t)2.302585093
#define LOG2            (double_t)0.30102999567
#define LOGE            (double_t)0.43429448190
//#define PI              (double_t)3.14159265359
#define PIby180         (double_t)0.0174532925
#define PIbyTWO         (double_t)1.570796326795
#define POW10INF        (double_t)38.0
#define SQR10           (double_t)3.162277660168
#define TWObyPI         (double_t)0.63661977

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


/* Trigonometric functions */
extern double_t __LIB__ sin(double_t x);
extern double_t __LIB__ cos(double_t x);
extern double_t __LIB__ tan(double_t x);
extern double_t __LIB__ asin(double_t x);
extern double_t __LIB__ acos(double_t x);
extern double_t __LIB__ atan(double_t x);
extern double_t __LIB__ atan2(double_t x, double_t y);

/* Hyperbolic functions */
extern double_t __LIB__ sinh(double_t x);
extern double_t __LIB__ cosh(double_t x);
extern double_t __LIB__ tanh(double_t x);
extern double_t __LIB__ asinh(double_t x);
extern double_t __LIB__ acosh(double_t x);
extern double_t __LIB__ atanh(double_t x);

/* Power functions */
extern double_t __LIB__ pow(double_t x, double_t y) __smallc;
extern double_t __LIB__ hypot(double_t x, double_t y) __smallc;
extern double_t __LIB__ sqrt(double_t a);

/* Exponential */
extern double_t __LIB__ exp(double_t x);
extern double_t __LIB__ log(double_t x);
extern double_t __LIB__ log10(double_t x);
#define log1p(x) log(1.+x)
#define log2(a) (log(a)/M_LN2)
#define exp2(x)  pow(2.,x)
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

/* General */
extern double_t __LIB__ fabs(double_t x);
extern double_t __LIB__ fmod(double_t x, double_t y) __smallc;


/* Helper functions */
extern double_t __LIB__ atof(char *) __smallc;
extern void __LIB__ ftoa(double_t, int, char *) __smallc;
extern void __LIB__ ftoe(double_t, int, char *) __smallc;


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

