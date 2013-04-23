#ifndef __FLOAT_H__
#define __FLOAT_H__

#include <sys/compiler.h>


/*
 *	Some more floating point routines..I can't remember
 *	why these are separated out..
 *
 *	$Id: float.h,v 1.9 2013-04-23 15:59:07 stefano Exp $
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
#define M_E        2.718282
#define M_LOG2E    1.442693
#define M_LOG10E   0.434294
#define M_LN2      0.693146
#define M_LN10     2.302585
#define M_PI       3.141592
#define M_PI_2     1.570796
#define M_PI_4     0.785396
#define M_1_PI     0.318310
#define M_2_PI     0.636620
#define M_1_SQRTPI 0.564190
#define M_2_SQRTPI 1.128379
#define M_SQRT2    1.414214
#define M_SQRT_2   0.707107
//#endif


#endif

