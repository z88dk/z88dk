#ifndef __MATH_H__
#define __MATH_H__

#include <sys/compiler.h>
#include <float.h>

/* $Id: math.h,v 1.16 2013-05-01 08:22:56 stefano Exp $ */


extern double __LIB__ acos(double);  /* arc cosine */
extern double __LIB__ asin(double);  /* arc cosine */
extern double __LIB__ atan(double);  /* arc tangent */
extern double __LIB__ atan2(double,double); /* atan2(a,b) = arc tangent of a/b */
extern double __LIB__ cos(double);   /* cosine */
extern double __LIB__ cosh(double);  /* hyperbolic cosine */
extern double __LIB__ exp(double);   /* exponential */
extern double __LIB__ log(double);   /* natural logarithm */
extern double __LIB__ log10(double); /* log base 10 */
extern double __LIB__ pi();          /* greek pi */
extern double __LIB__ pow(double,double);   /* pow(x,y) = x**y */
extern double __LIB__ sin(double);   /* sine */
extern double __LIB__ sinh(double);  /* hyperbolic sine */
extern double __LIB__ sqrt(double);  /* square root */
extern double __LIB__ tan(double);   /* tangent */
extern double __LIB__ tanh(double);  /* hyperbolic tangent */
#define log2(a) (log(a)/M_LN2)

#ifndef _HAVE_ATOF_
#define _HAVE_ATOF_
extern double __LIB__ atof(char *);
#endif

/* Some additional CPC only routines now */
#if __CPC__ && __NATIVE_MATH__
  extern double __LIB__ pow10(int x);         /* pow(10,x) - CPC only */
  extern void __LIB__ deg();
  extern void __LIB__ rad();
#else
  #define pow10(x) pow(10.,x)
  #define deg(x) (x*180./pi())
  #define rad(x) (x*pi()/180.)
#endif


/* More (unoptimized) functions */

#define cbrt(x) ((x)==0.?0.:(x)>0.?pow(x,.33333333):-pow(-x,.33333333))
#define ldexp(x,y) (pow(2.,(int)(y))*x)
#define hypot(x,y) sqrt(x*x+y*y)
#define asinh(x) log(2.*fabs(x)+1./(sqrt(x*x+1.)+fabs(x)))
#define acosh(x) log(2.*x-1./(x+sqrt(x*x-1.)))
#define atanh(x) (log((1.+x)/(1.-x))*.5)
#define log1p(x) log(1.+x)
#define exp2(x)  pow(2.,x)
#define expm1(x) (exp(x)-1.)

#define copysign(a,b) (b<.0?-fabs(a):fabs(a))
#define fdim(a,b) (a>b?a-b:b-a)
#define fma(x,y,z) (x*y+z)

//extern double __LIB__ frexp(double val, int *exp);	/* get mantissa and exponent */
//extern int __LIB__ ilogb(double val);					/* get exponent */
//extern int __LIB__ logb(double val);					/* get exponent */

#define infinity() INFINITY




#endif /* _MATH_H */
