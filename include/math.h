#ifndef __MATH_H__
#define __MATH_H__

/* $Id: math.h,v 1.5 2002-01-27 15:49:42 dom Exp $ */


extern double __LIB__ acos(double);  /* arc cosine */
extern double __LIB__ asin(double);  /* arc cosine */

extern double __LIB__ atan(double);  /* arc tangent */
extern double __LIB__ atan2(double,double); /* atan2(a,b) = arc tangent of a/b */
extern double __LIB__ cos(double);   /* cosine */
extern double __LIB__ cosh(double);  /* hyperbolic cosine */
extern double __LIB__ exp(double);   /* exponential */
extern double __LIB__ log(double);   /* natural logarithm */
extern double __LIB__ log10(double); /* log base 10 */
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


#endif /* _MATH_H */
