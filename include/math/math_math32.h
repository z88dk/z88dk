#ifndef __MATH_MATH32_H
#define __MATH_MATH32_H

#include <sys/compiler.h>
#include <sys/types.h>
#include <limits.h>

#define FLT_ROUNDS          1
#define FLT_RADIX           2

#define FLT_MANT_DIG        23
#define DBL_MANT_DIG        23
#define FLT_DIG             7
#define DBL_DIG             7

#define HUGE_POS_F32        (+3.4028234664e+38)
#define TINY_POS_F32        (+1.1754943508e-38)
#define HUGE_NEG_F32        (-1.7014118346e+38)
#define TINY_NEG_F32        (-1.1754943508e-38)

#define MAXL2_F32           (+127.999999914)
#define MINL2_F32           (-126.0)
#define MAXLOG_F32          (+88.722839052)
#define MINLOG_F32          (−87.336544751)
#define MAXL10_F32          (+38.230809449)
#define MINL10_F32          (−37.929779454)

#define HUGE_VAL_F32        ((unsigned long)0x7F800000)
#define INFINITY_POS_F32    ((unsigned long)0x7F800000)
#define INFINITY_NEG_F32    ((unsigned long)0xFF800000)

#ifdef __SCCZ80

/* Trigonometric functions */
extern double_t __LIB__ sin(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ cos(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ tan(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ asin(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ acos(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ atan(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ atan2(double_t y,double_t x) __smallc;
extern double_t __LIB__ atan2_callee(double_t y,double_t x) __smallc __z88dk_callee;
#define atan2(a,b) atan2_callee(a,b)

/* Hyperbolic functions */
extern double_t __LIB__ sinh(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ cosh(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ tanh(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ asinh(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ acosh(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ atanh(double_t x) __smallc __z88dk_fastcall;

/* Power functions */
extern double_t __LIB__ inv(double_t a) __smallc __z88dk_fastcall;
extern double_t __LIB__ invsqrt(double_t a) __smallc __z88dk_fastcall;
extern double_t __LIB__ sqr(double_t a) __smallc __z88dk_fastcall;
extern double_t __LIB__ sqrt(double_t a) __smallc __z88dk_fastcall;
extern double_t __LIB__ pow(double_t x,double_t y) __smallc;
extern double_t __LIB__ pow_callee(double_t x,double_t y) __smallc __z88dk_callee;
#define pow(a,b) pow_callee(a,b)


/* Exponential */
extern double_t __LIB__ exp(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ exp2(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ exp10(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ log(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ log2(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ log10(double_t x) __smallc __z88dk_fastcall;
#define log1p(x) log(1.+x)
#define expm1(x) (exp(x)-1.)

/* Nearest integer, absolute value, and remainder functions */
extern double_t __LIB__ ceil(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ floor(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ round(double_t x) __smallc __z88dk_fastcall;
#define trunc(a) (a>0.?floor(a):ceil(a))
//#define round(a) (a>0.?floor(a+0.5):ceil(a-0.5))
#define rint(a) ceil(a)

/* Manipulation */
extern double_t __LIB__ div2(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ mul2(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ mul10u(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ ldexp(double_t x,int exp) __smallc;
extern double_t __LIB__ ldexp_callee(double_t x,int exp) __smallc __z88dk_callee;
#define ldexp(a,b) ldexp_callee(a,b)
#define scalbn(x,pw2) ldexp(x,pw2)
extern double_t __LIB__ modf(double_t value,double_t *iptr) __smallc;
extern double_t __LIB__ modf_callee(double_t value,double_t *iptr) __smallc __z88dk_callee;
#define modf(a,b) modf_callee(a,b)
extern double_t __LIB__ frexp(double_t value,int *exp) __smallc;
extern double_t __LIB__ frexp_callee(double_t value,int *exp) __smallc __z88dk_callee;
#define frexp(a,b) frexp_callee(a,b)

/* General */
extern double_t __LIB__ fabs(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ fmod(double_t x,double_t y) __smallc;
extern double_t __LIB__ fmod_callee(double_t x,double_t y) __smallc __z88dk_callee;
#define fmod(a,b) fmod_callee(a,b)

extern double_t __LIB__ hypot(double_t x,double_t y) __smallc;
extern double_t __LIB__ hypot_callee(double_t x,double_t y) __smallc __z88dk_callee;
#define hypot(a,b) hypot_callee(a,b)

/* Helper functions */
extern double_t __LIB__ atof(char *) __smallc __z88dk_fastcall;
extern void __LIB__ ftoa(double_t, int, char *) __smallc;
extern void __LIB__ ftoe(double_t, int, char *) __smallc;

extern double_t __LIB__ f32_fam9511(double_t x) __smallc __z88dk_fastcall;
extern double_t __LIB__ fam9511_f32(double_t x) __smallc __z88dk_fastcall;

#endif


#ifdef __SDCC

/* Trigonometric functions */
extern double_t sin(double_t x) __z88dk_fastcall;
extern double_t cos(double_t x) __z88dk_fastcall;
extern double_t tan(double_t x) __z88dk_fastcall;
extern double_t asin(double_t x) __z88dk_fastcall;
extern double_t acos(double_t x) __z88dk_fastcall;
extern double_t atan(double_t x) __z88dk_fastcall;
extern double_t atan2(double_t y,double_t x);
extern double_t atan2_callee(double_t y,double_t x) __z88dk_callee;
#define atan2(a,b) atan2_callee(a,b)

/* Hyperbolic functions */
extern double_t sinh(double_t x) __z88dk_fastcall;
extern double_t cosh(double_t x) __z88dk_fastcall;
extern double_t tanh(double_t x) __z88dk_fastcall;
extern double_t asinh(double_t x) __z88dk_fastcall;
extern double_t acosh(double_t x) __z88dk_fastcall;
extern double_t atanh(double_t x) __z88dk_fastcall;

/* Power functions */
extern double_t inv(double_t a) __z88dk_fastcall;
extern double_t invsqrt(double_t a) __z88dk_fastcall;
extern double_t sqr(double_t a) __z88dk_fastcall;
extern double_t sqrt(double_t a) __z88dk_fastcall;
extern double_t pow(double_t x,double_t y);
extern double_t pow_callee(double_t x,double_t y) __z88dk_callee;
#define pow(a,b) pow_callee(a,b)


/* Exponential */
extern double_t exp(double_t x) __z88dk_fastcall;
extern double_t exp2(double_t x) __z88dk_fastcall;
extern double_t exp10(double_t x) __z88dk_fastcall;
extern double_t log(double_t x) __z88dk_fastcall;
extern double_t log2(double_t x) __z88dk_fastcall;
extern double_t log10(double_t x) __z88dk_fastcall;
#define log1p(x) log(1.+x)
#define expm1(x) (exp(x)-1.)

/* Nearest integer, absolute value, and remainder functions */
extern double_t ceil(double_t x) __z88dk_fastcall;
extern double_t floor(double_t x) __z88dk_fastcall;
extern double_t round(double_t x) __z88dk_fastcall;
#define trunc(a) (a>0.?floor(a):ceil(a))
//#define round(a) (a>0.?floor(a+0.5):ceil(a-0.5))
#define rint(a) ceil(a)

/* Manipulation */
extern double_t div2(double_t x) __z88dk_fastcall;
extern double_t mul2(double_t x) __z88dk_fastcall;
extern double_t mul10u(double_t x) __z88dk_fastcall;
extern double_t ldexp(double_t x,int exp);
extern double_t ldexp_callee(double_t x,int exp) __z88dk_callee;
#define ldexp(a,b) ldexp_callee(a,b)
#define scalbn(x,pw2) ldexp(x,pw2)
extern double_t modf(double_t value,double_t *iptr);
extern double_t modf_callee(double_t value,double_t *iptr) __z88dk_callee;
#define modf(a,b) modf_callee(a,b)
extern double_t frexp(double_t value,int *exp);
extern double_t frexp_callee(double_t value,int *exp) __z88dk_callee;
#define frexp(a,b) frexp_callee(a,b)

/* General */
extern double_t fabs(double_t x) __z88dk_fastcall;
extern double_t fmod(double_t x,double_t y);
extern double_t fmod_callee(double_t x,double_t y) __z88dk_callee;
#define fmod(a,b) fmod_callee(a,b)

extern double_t hypot(double_t x,double_t y);
extern double_t hypot_callee(double_t x,double_t y) __z88dk_callee;
#define hypot(a,b) hypot_callee(a,b)

/* Helper functions */
extern double_t atof(char *);
extern void ftoa(double_t, int, char *);
extern void ftoe(double_t, int, char *);

extern double_t f32_fam9511(double_t x) __z88dk_fastcall;
extern double_t fam9511_f32(double_t x) __z88dk_fastcall;

#endif

/* Classification functions */
#define FP_NORMAL   0
#define FP_ZERO     1
#define FP_NAN      2
#define FP_INFINITE 3
#define FP_SUBNORMAL 4
extern int fpclassify(double_t x);
#define isinf(x) ( fpclassify(x) == FP_INFINITE )
#define isnan(x) ( fpclassify(x) == FP_NAN )
#define isnormal(x) 1
#define isfinite(x) ( fpclassify(x) == FP_NORMAL )

#endif

