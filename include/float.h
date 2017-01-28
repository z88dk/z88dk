#ifndef __FLOAT_H__
#define __FLOAT_H__

#include <sys/compiler.h>
#include <sys/types.h>


/*
 *	Some more floating point routines..I can't remember
 *	why these are separated out..
 *
 *	$Id: float.h,v 1.13 2016-07-16 22:00:08 dom Exp $
 */



extern double_t __LIB__ fmod(double_t,double_t) __smallc;
extern double_t __LIB__ amax(double_t,double_t) __smallc;
extern double_t __LIB__ fabs(double_t) __smallc;
extern double_t __LIB__ amin(double_t,double_t) __smallc;
extern double_t __LIB__ floor(double_t) __smallc;
extern double_t __LIB__ ceil(double_t) __smallc;
extern double_t __LIB__ fprand(void) __smallc; /* Generic only */
extern double_t __LIB__  zfloat(int);
extern int __LIB__ fpseed(double_t) __smallc;    /* Seed random number */


#define fmax(x,y) amax(x,y)
#define fmin(x,y) amix(x,y)

#define rint(a) ceil(a)

#define trunc(a) (a>0.?floor(a):ceil(a))
#define round(a) (a>0.?floor(a+0.5):ceil(a-0.5))

//#define fmod(x,y) (x-(fabs(y)*trunc(x/fabs(y))))
#define remainder(x,y) (x-(fabs(y)*round(x/fabs(y))))

extern double_t __LIB__ atof(char *) __smallc;


/*
 * Some support routines for floating point printf
 */
extern void __LIB__ ftoa(double_t, int, char *) __smallc;
extern void __LIB__ ftoe(double_t, int, char *) __smallc;

/* 
 * Some constant nicked from /usr/include/math.h
 */

#define FLT_ROUNDS 1
#define FLT_RADIX 2

/*
 *  With 'FASTMATH' some constant is defined with a lower precision
 *  This saves code space and increases the speed for those very
 *  few specialized applications which use such values.
 * 
 *  Unless you know what you're doing you should set 'FASTMATH'
 *  with the simplified maths libraries (i.e. the ZX81/Spectrum ones)
 *  if you need the constants below.
 */

#ifdef FASTMATH

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

/* Simplified constants (a bit biased for the way z88dk works) */

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

#else

#define FLT_MANT_DIG 39
#define DBL_MANT_DIG 39
#define FLT_DIG      9
#define DBL_DIG      9

#define FLT_EPSILON  0.000000000001
#define DBL_EPSILON  0.000000000001
#define MAXFLOAT     9.995e37
#define HUGE_VAL     9.990e37
#define INFINITY     9.999e37
#define FLT_MAX      9.995e37
#define DBL_MAX      9.995e37
#define FLT_MIN      1.0e-38
#define DBL_MIN      1.0e-38
#define FLT_MIN_EXP    -38
#define DBL_MIN_EXP    -38
#define FLT_MIN_10_EXP -38
#define DBL_MIN_10_EXP -38
#define FLT_MAX_EXP     37
#define DBL_MAX_EXP     37
#define FLT_MAX_10_EXP  36
#define DBL_MAX_10_EXP  36

/* By default we use expressions to increase the precision, */
/* but the resulting code will be slower and bigger         */

#include <math.h>

#define M_E        exp(1.)
#define M_INVLN2   (1./(log(2.)))  /* 1 / log(2) */
#define M_LOG2E    (1./(log(2.)))
// #define M_IVLN10   (1./(log(10.)))  /* 1 / log(10) */
#define M_IVLN10   log10(exp(1.))
#define M_LOG10E   log10(exp(1.))
#define M_LOG2_E   log(2.)
#define M_LN2      log(2.)
#define M_LN10     log(10.)
#define M_PI       pi()
#define M_TWOPI    (pi()*2.)
#define M_PI_2     (pi()/2.)
#define M_PI_4     (pi()/4.)
#define M_3PI_4    ((pi()*3.)/4.)
#define M_SQRTPI   sqrt(pi())
#define M_1_PI     (1./(pi()))
#define M_2_PI     (2./(pi()))
#define M_1_SQRTPI (1./(sqrt(pi())))
#define M_2_SQRTPI (2./(sqrt(pi())))
#define M_SQRT2    sqrt(2.)
#define M_SQRT3    sqrt(3.)
#define M_SQRT1_2  sqrt(0.5)

#endif


//#endif


#endif

