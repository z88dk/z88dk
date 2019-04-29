#ifndef __MATH_H__
#define __MATH_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <float.h>

/* $Id: math.h,v 1.18 2016-07-16 22:00:08 dom Exp $ */


extern double_t __LIB__ acos(double_t);  /* arc cosine */
extern double_t __LIB__ asin(double_t);  /* arc cosine */
extern double_t __LIB__ atan(double_t);  /* arc tangent */
extern double_t __LIB__ atan2(double_t,double_t); /* atan2(a,b) = arc tangent of a/b */
extern double_t __LIB__ cos(double_t);   /* cosine */
extern double_t __LIB__ cosh(double_t);  /* hyperbolic cosine */
extern double_t __LIB__ exp(double_t);   /* exponential */
extern double_t __LIB__ log(double_t);   /* natural logarithm */
extern double_t __LIB__ log10(double_t); /* log base 10 */
extern double_t __LIB__ halfpi();        /* pi / 2 */
extern double_t __LIB__ pi();            /* pi */
extern double_t __LIB__ pow(double_t,double_t) __smallc;   /* pow(x,y) = x**y */
extern double_t __LIB__ sin(double_t);   /* sine */
extern double_t __LIB__ sinh(double_t);  /* hyperbolic sine */
extern double_t __LIB__ sqrt(double_t);  /* square root */
extern double_t __LIB__ tan(double_t);   /* tangent */
extern double_t __LIB__ tanh(double_t);  /* hyperbolic tangent */
extern double_t __LIB__ modf(double_t, double_t *) __smallc; /* Modulus */
#define log2(a) (log(a)/M_LN2)


/* Some additional CPC only routines now */
#if __CPC__ && __NATIVE_MATH__
  extern double_t __LIB__ pow10(int x);         /* pow(10,x) - CPC only */
  extern void __LIB__ deg();
  extern void __LIB__ rad();
#else
  #define pow10(x) pow(10.,x)
  #define deg(x) (x*180./M_PI)
  #define rad(x) (x*M_PI/180.)
#endif

extern double_t __LIB__ fmod(double_t,double_t) __smallc;
extern double_t __LIB__ amax(double_t,double_t) __smallc;
extern double_t __LIB__ fabs(double_t) __smallc;
extern double_t __LIB__ amin(double_t,double_t) __smallc;
extern double_t __LIB__ floor(double_t) __smallc;
extern double_t __LIB__ ceil(double_t) __smallc;



#define fmax(x,y) amax(x,y)
#define fmin(x,y) amix(x,y)

#define rint(a) ceil(a)

#define trunc(a) (a>0.?floor(a):ceil(a))
#define round(a) (a>0.?floor(a+0.5):ceil(a-0.5))

#define remainder(x,y) (x-(fabs(y)*round(x/fabs(y))))



/* Random numbers - not all libraries implement */
extern double_t __LIB__ fprand(void) __smallc; /* Generic only */
extern int __LIB__ fpseed(double_t) __smallc;    /* Seed random number */

extern double_t __LIB__ atof(char *) __smallc;


/*
 * Some support routines for floating point printf
 */
extern void __LIB__ ftoa(double_t, int, char *) __smallc;
extern void __LIB__ ftoe(double_t, int, char *) __smallc;





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
#define signbit(x) (x != fabs(x))
#define fdim(a,b) (a>b?a-b:b-a)
#define fma(x,y,z) (x*y+z)

//extern double_t __LIB__ frexp(double_t val, int *exp);	/* get mantissa and exponent */
//extern int __LIB__ ilogb(double_t val);					/* get exponent */
//extern int __LIB__ logb(double_t val);					/* get exponent */

#define infinity() INFINITY




#endif /* _MATH_H */
