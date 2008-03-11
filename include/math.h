#ifndef __MATH_H__
#define __MATH_H__

/* $Id: math.h,v 1.10 2008-03-11 09:56:12 stefano Exp $ */


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

#ifndef _HAVE_ATOF_
#define _HAVE_ATOF_
extern double __LIB__ atof(char *);
#endif

/* Some additional CPC only routines now */
#if __CPC__ && __NATIVE_MATH__
#define _LIBRARY_POW10
extern double __LIB__ pow10(int x);         /* pow(10,x) - CPC only */
extern void __LIB__ deg();
extern void __LIB__ rad();
#endif


#ifndef _LIBRARY_POW10
#define pow10(x) pow(10.,x)
#endif


#endif /* _MATH_H */
