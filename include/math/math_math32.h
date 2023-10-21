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
#define NAN_POS_F32         ((unsigned long)0x7FFFFFFF)
#define NAN_NEG_F32         ((unsigned long)0xFFFFFFFF)


// Note for clang the 

/* Trigonometric functions */
extern double_t __LIB__ sin(double_t x);
extern double_t __LIB__ cos(double_t x);
extern double_t __LIB__ tan(double_t x);
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ sin_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ cos_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ tan_fastcall(double_t x) __z88dk_fastcall;
#define sin(x) sin_fastcall(x)
#define cos(x) cos_fastcall(x)
#define tan(x) tan_fastcall(x)
#endif

extern double_t __LIB__ asin(double_t x);
extern double_t __LIB__ acos(double_t x);
extern double_t __LIB__ atan(double_t x);
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ asin_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ acos_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ atan_fastcall(double_t x) __z88dk_fastcall;
#define asin(x) asin_fastcall(x)
#define acos(x) acos_fastcall(x)
#define atan(x) atan_fastcall(x)
#endif

__ZPROTO2(double_t,,atan2,double_t,y,double_t,x)
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ atan2_callee(double_t y,double_t x) __smallc __z88dk_callee;
#define atan2(a,b) atan2_callee(a,b)
#endif

/* Hyperbolic functions */
extern double_t __LIB__ sinh(double_t x) ;
extern double_t __LIB__ cosh(double_t x) ;
extern double_t __LIB__ tanh(double_t x) ;
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ sinh_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ cosh_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ tanh_fastcall(double_t x) __z88dk_fastcall;
#define sinh(x) sinh_fastcall(x)
#define cosh(x) cosh_fastcall(x)
#define tanh(x) tanh_fastcall(x)
#endif

extern double_t __LIB__ asinh(double_t x) ;
extern double_t __LIB__ acosh(double_t x) ;
extern double_t __LIB__ atanh(double_t x) ;
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ asinh_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ acosh_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ atanh_fastcall(double_t x) __z88dk_fastcall;
#define asinh(x) asinh_fastcall(x)
#define acosh(x) acosh_fastcall(x)
#define atanh(x) atanh_fastcall(x)
#endif

/* Power functions */
extern double_t __LIB__ inv(double_t a) ;
extern double_t __LIB__ invsqrt(double_t a) ;
extern double_t __LIB__ sqr(double_t a) ;
extern double_t __LIB__ sqrt(double_t a) ;
__ZPROTO2(double_t,,pow,double_t,x,double_t,y)

#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ inv_fastcall(double_t a) __z88dk_fastcall;
extern double_t __LIB__ invsqrt_fastcall(double_t a) __z88dk_fastcall;
extern double_t __LIB__ sqr_fastcall(double_t a) __z88dk_fastcall;
extern double_t __LIB__ sqrt_fastcall(double_t a) __z88dk_fastcall;
#define inv(x)     inv_fastcall(x)
#define invsqrt(x) invsqrt_fastcall(x)
#define sqr(x)     sqr_fastcall(x)
#define sqrt(x)    sqrt_fastcall(x)

extern double_t __LIB__ pow_callee(double_t x,double_t y) __smallc __z88dk_callee;
#define pow(a,b) pow_callee(a,b)
#endif


/* Exponential */
extern double_t __LIB__ exp(double_t x) ;
extern double_t __LIB__ exp2(double_t x) ;
extern double_t __LIB__ exp10(double_t x) ;
extern double_t __LIB__ log(double_t x) ;
extern double_t __LIB__ log2(double_t x) ;
extern double_t __LIB__ log10(double_t x) ;

#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ exp_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ exp2_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ exp10_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ log_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ log2_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ log10_fastcall(double_t x) __z88dk_fastcall;
#define exp(x)   exp_fastcall(x)
#define exp2(x)  exp2_fastcall(x)
#define exp10(x) exp10_fastcall(x)
#define log(x)   log_fastcall(x)
#define log2(x)  log2_fastcall(x)
#define log10(x) log10_fastcall(x)
#endif

#define log1p(x) log(1.+x)
#define expm1(x) (exp(x)-1.)

/* Nearest integer, absolute value, and remainder functions */
extern double_t __LIB__ ceil(double_t x) ;
extern double_t __LIB__ floor(double_t x) ;
extern double_t __LIB__ round(double_t x) ;
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ ceil_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ floor_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ round_fastcall(double_t x) __z88dk_fastcall;
#define ceil(x)  ceil_fastcall(x)
#define floor(x) floor_fastcall(x)
#define round(x) round_fastcall(x)
#endif

extern double_t __LIB__ fmin(double_t z,double_t y);
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ fmin_callee(double_t z,double_t y) __z88dk_callee;
#define fmin(x,y) fmin_callee(x,y)
#endif

extern double_t __LIB__ fmax(double_t z,double_t y);
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ fmax_callee(double_t z,double_t y) __z88dk_callee;
#define fmax(x,y) fmax_callee(x,y)
#endif

#define remainder(x,y) (x-(fabs(y)*round(x/fabs(y))))
#define trunc(a) (a>0.?floor(a):ceil(a))
//#define round(a) (a>0.?floor(a+0.5):ceil(a-0.5))
#define rint(a) ceil(a)

/* Manipulation */
extern double_t __LIB__ div2(double_t x) __z88dk_fastcall;
extern double_t __LIB__ mul2(double_t x) __z88dk_fastcall;
extern double_t __LIB__ mul10u(double_t x) __z88dk_fastcall;
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ div2_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ mul2_fastcall(double_t x) __z88dk_fastcall;
extern double_t __LIB__ mul10u_fastcall(double_t x) __z88dk_fastcall;
#define div2(x)    div2_fastcall(x)
#define mul2(x)    mul2_fastcall(x)
#define mul10u(x)  mul10u_fastcall(x)
#endif


__ZPROTO2(double_t,,ldexp,double_t,x,int,exp)
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ ldexp_callee(double_t x,int exp) __smallc __z88dk_callee;
#define ldexp(a,b) ldexp_callee(a,b)
#endif
#define scalbn(x,pw2) ldexp(x,pw2)

__ZPROTO2(double_t,,modf,double_t,value,double_t *,iptr)
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ modf_callee(double_t value,double_t *iptr) __smallc __z88dk_callee;
#define modf(a,b) modf_callee(a,b)
#endif
__ZPROTO2(double_t,,frexp,double_t,value,int *,exp)
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ frexp_callee(double_t value,int *exp) __smallc __z88dk_callee;
#define frexp(a,b) frexp_callee(a,b)
#endif

/* General */
extern double_t __LIB__ fabs(double_t x);
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ fabs_fastcall(double_t x) __z88dk_fastcall;
#define fabs(x) fabs_fastcall(x)
#endif

__ZPROTO2(double_t,,fmod,double_t,x,double_t,y)
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ fmod_callee(double_t x,double_t y) __smallc __z88dk_callee;
#define fmod(a,b) fmod_callee(a,b)
#endif

__ZPROTO2(double_t,,hypot,double_t,x,double_t,y)
#ifndef __STDC_ABI_ONLY
extern double_t __LIB__ hypot_callee(double_t x,double_t y) __smallc __z88dk_callee;
#define hypot(a,b) hypot_callee(a,b)
#endif

/* Helper functions */
extern double_t __LIB__ atof(char *);
__ZPROTO3(void,,ftoa,double_t,d,int,l,char *,b)
__ZPROTO3(void,,ftoe,double_t,d,int,l,char *,b)




/* Classification functions */
#define FP_NORMAL   0
#define FP_ZERO     1
#define FP_NAN      2
#define FP_INFINITE 3
#define FP_SUBNORMAL 4
extern int __LIB__  fpclassify(double_t x);
#define isinf(x) ( fpclassify(x) == FP_INFINITE )
#define isnan(x) ( fpclassify(x) == FP_NAN )
#define isnormal(x) 1
#define isfinite(x) ( fpclassify(x) == FP_NORMAL )

#endif

