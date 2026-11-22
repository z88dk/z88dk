/*
 * <math/math_fix16.h> provides accessed a fixed point Q8.8 library
 *
 * Usage is similar to _Float16:
 *
 * - With sdcc you have to use mulk() and divk() functions for arithmetic ops
 * - With sdcc use the type conversion macros
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
typedef _Accum Accum;
#else
typedef int16_t Accum;
#endif




#ifdef HAVE_NATIVE_ACCUM
#define FIX16_FROM_INT(x)  ((Accum)x) 
#define FIX16_TO_INT(x) ( (int)(x) )
#define FIX16_TO_FLOAT(x) ((float) (x))
#define FIX16_FROM_FLOAT(x)  ((Accum)(x))
#define FIX16_TO_FLOAT16(x) ((_Float16) (x))
#define FIX16_FROM_FLOAT16(x)  ((Accum)(x))
#define FIX16u_FROM_FLOAT16(x)  ((unsigned _Accum)(x))
#else
#define FIX16_FROM_INT(x) ( ((Accum)x) << 8)
#define FIX16_TO_INT(x) ( (x) >> 8)
#define FIX16_TO_FLOAT(x) ((float) ((x)*(1.0 / 256.0)))
#define FIX16_FROM_FLOAT(x) ((Accum)((x) / (1.0 / 256.0) + ((x) >= 0 ? 0.5 : -0.5)))
#define FIX16u_FROM_FLOAT(x) ((Accum)((x) / (1.0 / 256.0) + 0.5))
#define FIX16_TO_FLOAT16(x) ((_Float16) ((x)*(1.0f16 / 256.0f16)))
#define FIX16_FROM_FLOAT16(x) ((Accum)((x) / (1.0f16 / 256.0f16) + ((x) >= 0 ? 0.5f16 : -0.5f16)))
#define FIX16u_FROM_FLOAT16(x) ((Accum)((x) / (1.0f16 / 256.0f16) + 0.5f16))
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


extern Accum __LIB__ mulk(Accum x,Accum y) __smallc;
extern Accum __LIB__ mulk_callee(Accum x,Accum y) __smallc __z88dk_callee;
#define mulk(x,y) mulk_callee(x,y)

extern Accum __LIB__ divk(Accum x,Accum y) __smallc;
extern Accum __LIB__ divk_callee(Accum x,Accum y) __smallc __z88dk_callee;
#define divk(x,y) divk_callee(x,y)


#define adduk(x,y) ((x) + (y))
#define subuk(x,y) ((x) - (y))

extern Accum __LIB__ muluk(Accum x,Accum y) __smallc;
extern Accum __LIB__ muluk_callee(Accum x,Accum y) __smallc __z88dk_callee;
#define muulk(x,y) muluk_callee(x,y)

extern Accum __LIB__ divuk(Accum x,Accum y) __smallc;
extern Accum __LIB__ divuk_callee(Accum x,Accum y) __smallc __z88dk_callee;
#define divuk(x,y) divuk_callee(x,y)


/* Trigonmetric functions */
extern Accum __LIB__ cosk(Accum x);
extern Accum __LIB__ cosk_fastcall(Accum x) __z88dk_fastcall;
#define cosk(x) cosk_fastcall(x)
extern Accum __LIB__ sink(Accum x);
extern Accum __LIB__ sink_fastcall(Accum x) __z88dk_fastcall;
#define sink(x) sink_fastcall(x)
extern Accum __LIB__ tank(Accum x);
extern Accum __LIB__ tank_fastcall(Accum x) __z88dk_fastcall;
#define tank(x) tank_fastcall(x)


extern Accum __LIB__ coshk(Accum x);
extern Accum __LIB__ coshk_fastcall(Accum x) __z88dk_fastcall;
#define coshk(x) coshk_fastcall(x)
extern Accum __LIB__ sinhk(Accum x);
extern Accum __LIB__ sinhk_fastcall(Accum x) __z88dk_fastcall;
#define sinhk(x) sinhk_fastcall(x)
extern Accum __LIB__ tanhk(Accum x);
extern Accum __LIB__ tanhk_fastcall(Accum x) __z88dk_fastcall;
#define tanhk(x) tanhk_fastcall(x)



extern Accum __LIB__ acosk(Accum x);
extern Accum __LIB__ acosk_fastcall(Accum x) __z88dk_fastcall;
#define acosk(x) acosk_fastcall(x)

extern Accum __LIB__ asink(Accum x);
extern Accum __LIB__ asink_fastcall(Accum x) __z88dk_fastcall;
#define asink(x) asink_fastcall(x)

extern Accum __LIB__ atank(Accum x);
extern Accum __LIB__ atank_fastcall(Accum x) __z88dk_fastcall;
#define atank(x) atank_fastcall(x)


extern Accum __LIB__ acoshk(Accum x);
extern Accum __LIB__ acoshk_fastcall(Accum x) __z88dk_fastcall;
#define acoshk(x) acoshk_fastcall(x)

extern Accum __LIB__ asinhk(Accum x);
extern Accum __LIB__ asinhk_fastcall(Accum x) __z88dk_fastcall;
#define asinhk(x) asinhk_fastcall(x)

extern Accum __LIB__ atanhk(Accum x);
extern Accum __LIB__ atanhk_fastcall(Accum x) __z88dk_fastcall;
#define atanhk(x) atanhk_fastcall(x)



/* Exponential, logarithmic and power functions */

extern Accum __LIB__ powk(Accum x,Accum y) __smallc;
extern Accum __LIB__ powk_callee(Accum x,Accum y) __smallc __z88dk_callee;
#define powk(x,y) powk_callee(x,y)


extern Accum __LIB__ pow2k(Accum x);
extern Accum __LIB__ pow2k_fastcall (Accum x) __z88dk_fastcall;
#define pow2k(x) pow2k_fastcall(x)

extern Accum __LIB__ expk(Accum x);
extern Accum __LIB__ expk_fastcall (Accum x) __z88dk_fastcall;
#define expk(x) expk_fastcall(x)


extern Accum __LIB__ logk(Accum x);
extern Accum __LIB__ logk_fastcall (Accum x) __z88dk_fastcall;
#define logk(x) logk_fastcall(x)

extern Accum __LIB__ log2k(Accum x);
extern Accum __LIB__ log2k_fastcall (Accum x) __z88dk_fastcall;
#define log2k(x) log2k_fastcall(x)

// Square a number
extern Accum __LIB__ sqrk(Accum x);
extern Accum __LIB__ sqrk_fastcall(Accum x) __z88dk_fastcall;
#define sqrk(x) sqrk_fastcall(x)

extern Accum __LIB__ sqrtk(Accum x);
extern Accum __LIB__ sqrtk_fastcall(Accum x) __z88dk_fastcall;
#define sqrtk(x) sqrtk_fastcall(x)

/* Nearest integer, absolute value, and remainder functions */
extern Accum __LIB__ absk(Accum x) __z88dk_fastcall;
extern Accum __LIB__ absk_fastcall (Accum x);
#define absk(x) absk_fastcall(x)


extern Accum __LIB__ ceilk(Accum x);
extern Accum __LIB__ ceilk_fastcall(Accum x) __z88dk_fastcall;
#define ceilk(x) ceilk_fastcall(x)

extern Accum __LIB__ floork (Accum x) __z88dk_fastcall;
extern Accum __LIB__ floork_fastcall (Accum x);


#define trunck(a) (a>0?floork(a):ceilk(a))
#define roundk(a) (a>0?floork(a+0x80):ceilk(a-0x80))
#define rintk(a) ceilk(a)

/* Intrinsic functions */
extern Accum __LIB__ invk(Accum a);
extern Accum __LIB__ invk_fastcall(Accum a) __z88dk_fastcall;
#define invk(x) invk_fastcall(x)

#endif
