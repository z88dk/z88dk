#ifndef __FLOAT_H__
#define __FLOAT_H__

#include <sys/compiler.h>


/*
 *	Some more floating point routines..I can't remember
 *	why these are separated out..
 *
 *	$Id: float.h,v 1.10 2013-04-29 16:51:26 stefano Exp $
 */



extern double __LIB__ fmod();
extern double __LIB__ amax(double,double);
extern double __LIB__ fabs(double);
extern double __LIB__ amin(double,double);
extern double __LIB__ floor(double);
extern double __LIB__ ceil(double);
extern double __LIB__ fprand(void); /* Generic only */
extern double __LIB__ __FASTCALL__ zfloat(int);
extern int __LIB__ fpseed(double);    /* Seed random number */

#define rint(a) ceil(a)

#define trunc(a) (a>0.?floor(a):ceil(a))
#define round(a) (a>0.?floor(a+0.5):ceil(a-0.5))

#define fmod(x,y) (x-(fabs(y)*trunc(x/fabs(y))))
#define remainder(x,y) (x-(fabs(y)*round(x/fabs(y))))

#ifndef _HAVE_ATOF_
#define _HAVE_ATOF_
extern double __LIB__ atof(char *);
#endif


/*
 * Some support routines for floating point printf
 */
extern void __LIB__ ftoa(double, int, char *);
extern void __LIB__ ftoe(double, int, char *);

/* 
 * Some constant nicked from /usr/include/math.h
 */


/* Constants (biased for the way z88dk works) */

//#ifdef _USE_MATH_DEFINES

#define MAXFLOAT   1.7e32		/* valid in all the FP implementations, 'genmath' can go further */
#define HUGE_VAL   1.7e32       /* as above */
#define INFINITY   9.999e37		/* will probably work fine only whith 'genmath' */

#ifdef FASTMATH

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

