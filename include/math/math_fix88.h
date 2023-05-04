/*
 * <math/math_fix88.h> provides accessed a fixed point Q8.8 library
 *
 * Usage is similar to using regular floating points, however:
 * 
 * - multiplication and division should be performed using mulk() and divk() functions.
 * - conversion to and from types should be performed using the provided macros
 */

#ifndef MATH_MATH_FIX16_H
#define MATH_MATH_FIX16_H

#include <stdint.h>

#ifdef __SCCZ80
#ifndef DISABLE_NATIVE_ACCUM
#define HAVE_NATIVE_ACCUM 1
#endif
#endif


#ifdef HAVE_NATIVE_ACCUM
typedef _Accum fix16_t;
#else
typedef int16_t fix16_t;
#endif




#ifdef HAVE_NATIVE_ACCUM
#define FIX16_FROM_INT(x)  ((fix16_t)x) 
#define FIX16_TO_INT(x) ( (int)(x) )
#define FIX16_TO_FLOAT(x) ((float) (x))
#define FIX16_FROM_FLOAT(x)  ((fix16_t)(x))
#define FIX16_TO_FLOAT16(x) ((_Float16) (x))
#define FIX16_FROM_FLOAT16(x)  ((fix16_t)(x))
#else
#define FIX16_FROM_INT(x) ( ((fix16_t)x) << 8)
#define FIX16_TO_INT(x) ( (x) >> 8)
#define FIX16_TO_FLOAT(x) ((float) ((x)*(1.0 / 256.0)))
#define FIX16_FROM_FLOAT(x) ((fix16_t)((x) / (1.0 / 256.0) + ((x) >= 0 ? 0.5 : -0.5)))
#define FIX16_TO_FLOAT16(x) ((_Float16) ((x)*(1.0f16 / 256.0f16)))
#define FIX16_FROM_FLOAT16(x) ((fix16_t)((x) / (1.0f16 / 256.0f16) + ((x) >= 0 ? 0.5f16 : -0.5f16)))
#endif


#define FIX16_ONE     FIX16_FROM_INT(1)
#define FIX16_TWO     FIX16_FROM_INT(2)
#define FIX16_HALF    FIX16_FROM_FLOAT(0.5)
#define FIX16_HALFPI  FIX16_FROM_FLOAT(3.14159265358979323846 / 2.0)  
#define FIX16_PI      FIX16_FROM_FLOAT(3.14159265358979323846)
#define FIX16_TWOPI   FIX16_FROM_FLOAT(3.14159265358979323846 * 2.0)  
#define FIX16_LN2     FIX16_FROM_FLOAT(0.69314718055994530942)
#define FIX16_INV_LN2 FIX16_FROM_FLOAT(1.4426950408889634074)
#define FIX16_E       FIX16_FROM_FLOAT(2.7182818284590452354)

/* Arithmetic functions */
#define addk(x,y) ((x) + (y))
#define subk(x,y) ((x) - (y))


extern fix16_t __LIB__ mulk(fix16_t x,fix16_t y) __smallc;
extern fix16_t __LIB__ mulk_callee(fix16_t x,fix16_t y) __smallc __z88dk_callee;
#define mulk(x,y) mulk_callee(x,y)

extern fix16_t __LIB__ divk(fix16_t x,fix16_t y) __smallc;
extern fix16_t __LIB__ divk_callee(fix16_t x,fix16_t y) __smallc __z88dk_callee;
#define divk(x,y) divk_callee(x,y)


#define adduk(x,y) ((x) + (y))
#define subuk(x,y) ((x) - (y))

extern fix16_t __LIB__ muluk(fix16_t x,fix16_t y) __smallc;
extern fix16_t __LIB__ muluk_callee(fix16_t x,fix16_t y) __smallc __z88dk_callee;
#define muulk(x,y) muluk_callee(x,y)

extern fix16_t __LIB__ divuk(fix16_t x,fix16_t y) __smallc;
extern fix16_t __LIB__ divuk_callee(fix16_t x,fix16_t y) __smallc __z88dk_callee;
#define divuk(x,y) divuk_callee(x,y)


/* Trigonmetric functions */
extern fix16_t __LIB__ cosfix88 (fix16_t x);
extern fix16_t __LIB__ cosk_fastcall(fix16_t x) __z88dk_fastcall;
#define cosk(x) cosk_fastcall(x)
extern fix16_t __LIB__ sinfix88 (fix16_t x);
extern fix16_t __LIB__ sink_fastcall(fix16_t x) __z88dk_fastcall;
#define sink(x) sink_fastcall(x)
extern fix16_t __LIB__ tank(fix16_t x);
extern fix16_t __LIB__ tank_fastcall(fix16_t x) __z88dk_fastcall;
#define tank(x) tank_fastcall(x)


extern fix16_t __LIB__ acosfix88 (fix16_t x);
extern fix16_t __LIB__ acosk_fastcall(fix16_t x) __z88dk_fastcall;
#define acosk(x) acosk_fastcall(x)

extern fix16_t __LIB__ asinfix88 (fix16_t x);
extern fix16_t __LIB__ asink_fastcall(fix16_t x) __z88dk_fastcall;
#define asink(x) asink_fastcall(x)

extern fix16_t __LIB__ atank(fix16_t x);
extern fix16_t __LIB__ atank_fastcall(fix16_t x) __z88dk_fastcall;
#define atank(x) atank_fastcall(x)


extern fix16_t __LIB__ acoshfix88 (fix16_t x);
extern fix16_t __LIB__ acoshk_fastcall(fix16_t x) __z88dk_fastcall;
#define acoshk(x) acoshk_fastcall(x)

extern fix16_t __LIB__ asinhfix88 (fix16_t x);
extern fix16_t __LIB__ asinhk_fastcall(fix16_t x) __z88dk_fastcall;
#define asinhk(x) asinhk_fastcall(x)

extern fix16_t __LIB__ atanhk(fix16_t x);
extern fix16_t __LIB__ atanhk_fastcall(fix16_t x) __z88dk_fastcall;
#define atanhk(x) atanhk_fastcall(x)



/* Exponential, logarithmic and power functions */

extern fix16_t __LIB__ powk(fix16_t x,fix16_t y) __smallc;
extern fix16_t __LIB__ powk_callee(fix16_t x,fix16_t y) __smallc __z88dk_callee;
#define powk(x,y) powk_callee(x,y)


extern fix16_t __LIB__ pow2fix88 (fix16_t x);
extern fix16_t __LIB__ pow2k_fastcall (fix16_t x) __z88dk_fastcall;
#define pow2k(x) pow2k_fastcall(x)

extern fix16_t __LIB__ expfix88 (fix16_t x);
extern fix16_t __LIB__ expk_fastcall (fix16_t x) __z88dk_fastcall;
#define expk(x) expk_fastcall(x)


extern fix16_t __LIB__ logfix88 (fix16_t x);
extern fix16_t __LIB__ logk_fastcall (fix16_t x) __z88dk_fastcall;
#define logk(x) logk_fastcall(x)

extern fix16_t __LIB__ log2fix88 (fix16_t x);
extern fix16_t __LIB__ log2k_fastcall (fix16_t x) __z88dk_fastcall;
#define log2k(x) log2k_fastcall(x)

// Square a number
extern fix16_t __LIB__ sqrk(fix16_t x);
extern fix16_t __LIB__ sqrk_fastcall(fix16_t x) __z88dk_fastcall;
#define sqrk(x) sqrk_fastcall(x)

extern fix16_t __LIB__ sqrtk(fix16_t x);
extern fix16_t __LIB__ sqrtk_fastcall(fix16_t x) __z88dk_fastcall;
#define sqrtk(x) sqrtk_fastcall(x)

/* Nearest integer, absolute value, and remainder functions */
extern fix16_t __LIB__ fabsfix88 (fix16_t x) __z88dk_fastcall;
extern fix16_t __LIB__ fabsk_fastcall (fix16_t x);
#define fabsk(x) fabsk_fastcall(x)


extern fix16_t __LIB__ ceilfix88 (fix16_t x);
extern fix16_t __LIB__ ceilk_fastcall(fix16_t x) __z88dk_fastcall;
#define ceilk(x) ceilk_fastcall(x)

extern fix16_t __LIB__ floorfix88 (fix16_t x) __z88dk_fastcall;
extern fix16_t __LIB__ floork_fastcall (fix16_t x);


#define trunck(a) (a>0?floork(a):ceilk(a))
#define roundk(a) (a>0?floork(a+0x80):ceilk(a-0x80))
#define rintk(a) ceilk(a)

/* Intrinsic functions */
extern fix16_t __LIB__ invk(fix16_t a);
extern fix16_t __LIB__ invk_fastcall(fix16_t a) __z88dk_fastcall;
#define invk(x) invk_fastcall(x)

#endif
