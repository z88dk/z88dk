/*
 * <math/math_fix88.h> provides accessed a fixed point Q8.8 library
 *
 * Usage is similar to using regular floating points, however:
 * 
 * - multiplication and division should be performed using mulfix88() and divfix() functions.
 * - conversion to and from types should be performed using the provided macros
 */

#ifndef MATH_MATH_FIX88_H
#define MATH_MATH_FIX88_H

#include <stdint.h>

#ifdef __SCCZ80
#ifndef DISABLE_NATIVE_ACCUM
#define HAVE_NATIVE_ACCUM 1
#endif
#endif


#ifdef HAVE_NATIVE_ACCUM
typedef _Accum fix88_t;
#else
typedef int16_t fix88_t;
#endif




#ifdef HAVE_NATIVE_ACCUM
#define FIX88_FROM_INT(x)  ((fix88_t)x) 
#define FIX88_TO_INT(x) ( (int)(x) )
#define FIX88_TO_FLOAT(x) ((float) (x))
#define FIX88_FROM_FLOAT(x)  ((fix88_t)(x))
#define FIX88_TO_FLOAT16(x) ((_Float16) (x))
#define FIX88_FROM_FLOAT16(x)  ((fix88_t)(x))
#else
#define FIX88_FROM_INT(x) ( ((fix88_t)x) << 8)
#define FIX88_TO_INT(x) ( (x) >> 8)
#define FIX88_TO_FLOAT(x) ((float) ((x)*(1.0 / 256.0)))
#define FIX88_FROM_FLOAT(x) ((fix88_t)((x) / (1.0 / 256.0) + ((x) >= 0 ? 0.5 : -0.5)))
#define FIX88_TO_FLOAT16(x) ((_Float16) ((x)*(1.0f16 / 256.0f16)))
#define FIX88_FROM_FLOAT16(x) ((fix88_t)((x) / (1.0f16 / 256.0f16) + ((x) >= 0 ? 0.5f16 : -0.5f16)))
#endif


#define FIX88_ONE     FIX88_FROM_INT(1)
#define FIX88_TWO     FIX88_FROM_INT(2)
#define FIX88_HALF    FIX88_FROM_FLOAT(0.5)
#define FIX88_HALFPI  FIX88_FROM_FLOAT(3.14159265358979323846 / 2.0)  
#define FIX88_PI      FIX88_FROM_FLOAT(3.14159265358979323846)
#define FIX88_TWOPI   FIX88_FROM_FLOAT(3.14159265358979323846 * 2.0)  
#define FIX88_LN2     FIX88_FROM_FLOAT(0.69314718055994530942)
#define FIX88_INV_LN2 FIX88_FROM_FLOAT(1.4426950408889634074)
#define FIX88_E       FIX88_FROM_FLOAT(2.7182818284590452354)

/* Arithmetic functions */
#define addfix88(x,y) ((x) + (y))
#define subfix88(x,y) ((x) - (y))
extern fix88_t __LIB__ mulfix88(fix88_t x,fix88_t y) __smallc;
extern fix88_t __LIB__ mulfix88_callee(fix88_t x,fix88_t y) __smallc __z88dk_callee;
#define mulfix88(x,y) mulfix88_callee(x,y)

extern fix88_t __LIB__ divfix88(fix88_t x,fix88_t y) __smallc;
extern fix88_t __LIB__ divfix88_callee(fix88_t x,fix88_t y) __smallc __z88dk_callee;
#define divfix88(x,y) divfix88_callee(x,y)




/* Trigonmetric functions */
extern fix88_t __LIB__ cosfix88 (fix88_t x);
extern fix88_t __LIB__ cosfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define cosfix88(x) cosfix88_fastcall(x)
extern fix88_t __LIB__ sinfix88 (fix88_t x);
extern fix88_t __LIB__ sinfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define sinfix88(x) sinfix88_fastcall(x)
extern fix88_t __LIB__ tanfix88(fix88_t x);
extern fix88_t __LIB__ tanfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define tanfix88(x) tanfix88_fastcall(x)


extern fix88_t __LIB__ acosfix88 (fix88_t x);
extern fix88_t __LIB__ acosfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define acosfix88(x) acosfix88_fastcall(x)

extern fix88_t __LIB__ asinfix88 (fix88_t x);
extern fix88_t __LIB__ asinfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define asinfix88(x) asinfix88_fastcall(x)

extern fix88_t __LIB__ atanfix88(fix88_t x);
extern fix88_t __LIB__ atanfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define atanfix88(x) atanfix88_fastcall(x)


extern fix88_t __LIB__ acoshfix88 (fix88_t x);
extern fix88_t __LIB__ acoshfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define acoshfix88(x) acoshfix88_fastcall(x)

extern fix88_t __LIB__ asinhfix88 (fix88_t x);
extern fix88_t __LIB__ asinhfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define asinhfix88(x) asinhfix88_fastcall(x)

extern fix88_t __LIB__ atanhfix88(fix88_t x);
extern fix88_t __LIB__ atanhfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define atanhfix88(x) atanhfix88_fastcall(x)



/* Exponential, logarithmic and power functions */

extern fix88_t __LIB__ powfix88(fix88_t x,fix88_t y) __smallc;
extern fix88_t __LIB__ powfix88_callee(fix88_t x,fix88_t y) __smallc __z88dk_callee;
#define powfix88(x,y) powfix88_callee(x,y)


extern fix88_t __LIB__ pow2fix88 (fix88_t x);
extern fix88_t __LIB__ pow2fix88_fastcall (fix88_t x) __z88dk_fastcall;
#define pow2fix88(x) pow2fix88_fastcall(x)

extern fix88_t __LIB__ expfix88 (fix88_t x);
extern fix88_t __LIB__ expfix88_fastcall (fix88_t x) __z88dk_fastcall;
#define expfix88(x) expfix88_fastcall(x)


extern fix88_t __LIB__ logfix88 (fix88_t x);
extern fix88_t __LIB__ logfix88_fastcall (fix88_t x) __z88dk_fastcall;
#define logfix88(x) logfix88_fastcall(x)

extern fix88_t __LIB__ log2fix88 (fix88_t x);
extern fix88_t __LIB__ log2fix88_fastcall (fix88_t x) __z88dk_fastcall;
#define log2fix88(x) log2fix88_fastcall(x)

// Square a number
extern fix88_t __LIB__ sqrfix88(fix88_t x);
extern fix88_t __LIB__ sqrfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define sqrfix88(x) sqrfix88_fastcall(x)

extern fix88_t __LIB__ sqrtfix88(fix88_t x);
extern fix88_t __LIB__ sqrtfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define sqrtfix88(x) sqrtfix88_fastcall(x)

/* Nearest integer, absolute value, and remainder functions */
extern fix88_t __LIB__ fabsfix88 (fix88_t x) __z88dk_fastcall;
extern fix88_t __LIB__ fabsfix88_fastcall (fix88_t x);
#define fabsfix88(x) fabsfix88_fastcall(x)


extern fix88_t __LIB__ ceilfix88 (fix88_t x);
extern fix88_t __LIB__ ceilfix88_fastcall(fix88_t x) __z88dk_fastcall;
#define ceilfix88(x) ceilfix88_fastcall(x)

extern fix88_t __LIB__ floorfix88 (fix88_t x) __z88dk_fastcall;
extern fix88_t __LIB__ floorfix88_fastcall (fix88_t x);


#define truncfix88(a) (a>0?floorfix88(a):ceilfix88(a))
#define roundfix88(a) (a>0?floorfix88(a+0x80):ceilfix88(a-0x80))
#define rintfix88(a) ceilfix88(a)

/* Intrinsic functions */
extern fix88_t __LIB__ invfix88(fix88_t a);
extern fix88_t __LIB__ invfix88_fastcall(fix88_t a) __z88dk_fastcall;
#define invfix88(x) invfix88_fastcall(x)

#endif
