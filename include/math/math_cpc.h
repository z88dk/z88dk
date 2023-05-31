#ifndef __MATH_ZXMATH_H
#define __MATH_ZXMATH_H

#include <sys/compiler.h>
#include <sys/types.h>
#include <limits.h>

#define FLT_ROUNDS 1
#define FLT_RADIX  2

#define FLT_MANT_DIG 31
#define DBL_MANT_DIG 31
#define FLT_DIG      7
#define DBL_DIG      7

#define FLT_EPSILON  0.000000001
#define DBL_EPSILON  0.000000001
#define MAXFLOAT     1.5e32
#define HUGE_VAL     1.0e32
#define INFINITY     1.7e32
#define FLT_MAX      1.5e32
#define DBL_MAX      1.5e32
#define FLT_MIN      1.0e-38
#define DBL_MIN      1.0e-38
#define FLT_MIN_EXP    -38
#define DBL_MIN_EXP    -38
#define FLT_MIN_10_EXP -38
#define DBL_MIN_10_EXP -38
#define FLT_MAX_EXP     32
#define DBL_MAX_EXP     32
#define FLT_MAX_10_EXP  31
#define DBL_MAX_10_EXP  31





/* Trigonmetric functions */
extern double_t __LIB__ cos(double_t);   /* cosine */
extern double_t __LIB__ tan(double_t);   /* tangent */
extern double_t __LIB__ sin(double_t);   /* sine */
extern double_t __LIB__ acos(double_t);  /* arc cosine */
extern double_t __LIB__ asin(double_t);  /* arc cosine */
extern double_t __LIB__ atan(double_t);  /* arc tangent */
extern double_t __LIB__ atan2(double_t,double_t) __smallc; /* atan2(a,b) = arc tangent of a/b */

/* Hyperbolic functions */
extern double_t __LIB__ cosh(double_t);  /* hyperbolic cosine */
extern double_t __LIB__ sinh(double_t);  /* hyperbolic sine */
extern double_t __LIB__ tanh(double_t);  /* hyperbolic tangent */
#define asinh(x) log(2.*fabs(x)+1./(sqrt(x*x+1.)+fabs(x)))
#define acosh(x) log(2.*x-1./(x+sqrt(x*x-1.)))
#define atanh(x) (log((1.+x)/(1.-x))*.5)

/* Power functions */
extern double_t __LIB__ pow(double_t,double_t) __smallc;   /* pow(x,y) = x**y */
extern double_t __LIB__ sqrt(double_t);  /* square root */
#define cbrt(x) ((x)==0.?0.:(x)>0.?pow(x,.33333333):-pow(-x,.33333333))
#define hypot(x,y) sqrt(x*x+y*y)

/* Exponential */
extern double_t __LIB__ exp(double_t);   /* exponential */
extern double_t __LIB__ log(double_t);   /* natural logarithm */
extern double_t __LIB__ log10(double_t); /* log base 10 */
#define log1p(x) log(1.+x)
#define log2(a) (log(a)/M_LN2)
#define exp2(x)  pow(2.,x)
#define expm1(x) (exp(x)-1.)

/* Nearest integer */
extern double_t __LIB__ floor(double_t) __smallc;
extern double_t __LIB__ ceil(double_t) __smallc;
#define trunc(a) (a>0.?floor(a):ceil(a))
#define round(a) (a>0.?floor(a+0.5):ceil(a-0.5))
#define rint(a) ceil(a)

/* Manipulation */
extern double_t __LIB__ ldexp(double_t x, int pw2) __smallc;
#define scalbn(x,pw2) ldexp(x,pw2)
extern double_t __LIB__ frexp(double_t x, int *pw2) __smallc;
#define copysign(a,b) (b<.0?-fabs(a):fabs(a))
#define signbit(x) (x != fabs(x))


/* General */
extern double_t __LIB__ fabs(double_t) __smallc;
extern double_t __LIB__ fmod(double_t,double_t) __smallc;
extern double_t __LIB__ fmax(double_t,double_t) __smallc;
extern double_t __LIB__ fmin(double_t,double_t) __smallc;
#define remainder(x,y) (x-(fabs(y)*round(x/fabs(y))))
#define fdim(a,b) (a>b?a-b:b-a)



/* Utility */
extern double_t __LIB__ halfpi();        /* pi / 2 */
extern double_t __LIB__ pi();            /* pi */

/* Helper functions */
extern double_t __LIB__ atof(char *) __smallc;
extern void __LIB__ ftoa(double_t, int, char *) __smallc;
extern void __LIB__ ftoe(double_t, int, char *) __smallc;

/* CPC Only function */
extern void __LIB__ deg();
extern void __LIB__ rad();

/* Classification */
#define isinf(x) 0
#define isnan(x) 0
#define isnormal(x) 1
#define isfinite(x) 1

#define FP_NORMAL   0
#define FP_ZERO     1
#define FP_NAN      2
#define FP_INFINITE 3
#define FP_SUBNORMAL 4
extern int __LIB__ fpclassify(double_t );



/* More (unoptimized) functions */

#define fma(x,y,z) (x*y+z)


#endif /* __MATH_ZXMATH_H */
