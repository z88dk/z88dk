#ifndef __FLOAT_H__
#define __FLOAT_H__

/*
 *	Some more floating point routines..I can't remember
 *	why these are separated out..
 *
 *	$Id: float.h,v 1.7 2003-08-22 21:14:40 dom Exp $
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


# define M_E		2.7182818284590452354	/* e */
# define M_LOG2E	1.4426950408889634074	/* log_2 e */
# define M_LOG10E	0.43429448190325182765	/* log_10 e */
# define M_LN2		0.69314718055994530942	/* log_e 2 */
# define M_LN10		2.30258509299404568402	/* log_e 10 */
# define M_PI		3.14159265358979323846	/* pi */
# define M_PI_2		1.57079632679489661923	/* pi/2 */
# define M_PI_4		0.78539816339744830962	/* pi/4 */
# define M_1_PI		0.31830988618379067154	/* 1/pi */
# define M_2_PI		0.63661977236758134308	/* 2/pi */
# define M_2_SQRTPI	1.12837916709551257390	/* 2/sqrt(pi) */
# define M_SQRT2	1.41421356237309504880	/* sqrt(2) */
# define M_SQRT1_2	0.70710678118654752440	/* 1/sqrt(2) */


#endif

