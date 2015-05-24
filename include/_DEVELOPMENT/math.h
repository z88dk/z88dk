
#ifndef _MATH_H
#define _MATH_H

// THE SELECTED FLOATING POINT PACKAGE MAY NOT SUPPORT ALL LISTED FUNCTIONS

// SCCZ80 ONLY AT THE MOMENT AND FUNCTION POINTERS NOT SUPPORTED YET

typedef double float_t;
typedef double double_t;

#define FLT_EVAL_METHOD        1

#define HUGE_VAL               1.701411835E+38
#define HUGE_VALF              1.701411835E+38

#define INFINITY               1.701411835E+38

#define MATH_ERRNO             1
#define MATH_ERREXCEPT         2
#define math_errhandling       1

extern double_t __LIB__ __FASTCALL__ acos(double_t x);
extern double_t __LIB__ __FASTCALL__ asin(double_t x);
extern double_t __LIB__ __FASTCALL__ atan(double_t x);
extern double_t __LIB__ __CALLEE__   atan2(double_t y, double_t x);

extern double_t __LIB__ __FASTCALL__ cos(double_t x);
extern double_t __LIB__ __FASTCALL__ sin(double_t x);
extern double_t __LIB__ __FASTCALL__ tan(double_t x);

extern double_t __LIB__ __FASTCALL__ acosh(double_t x);
extern double_t __LIB__ __FASTCALL__ asinh(double_t x);
extern double_t __LIB__ __FASTCALL__ atanh(double_t x);

extern double_t __LIB__ __FASTCALL__ cosh(double_t x);
extern double_t __LIB__ __FASTCALL__ sinh(double_t x);
extern double_t __LIB__ __FASTCALL__ tanh(double_t x);

extern double_t __LIB__ __FASTCALL__ exp(double_t x);
extern double_t __LIB__ __FASTCALL__ exp2(double_t x);
extern double_t __LIB__ __FASTCALL__ expm1(double_t x);
extern double_t __LIB__ __CALLEE__   frexp(double_t value, int *exp);
extern int      __LIB__ __FASTCALL__ ilogb(double_t x);
extern double_t __LIB__ __CALLEE__   ldexp(double_t x, int exp);

extern double_t __LIB__ __FASTCALL__ log(double_t x);
extern double_t __LIB__ __FASTCALL__ log10(double_t x);
extern double_t __LIB__ __FASTCALL__ log1p(double_t x);
extern double_t __LIB__ __FASTCALL__ log2(double_t x);
extern double_t __LIB__ __FASTCALL__ logb(double_t x);

extern double_t __LIB__ __CALLEE__   scalbn(double_t x, int n);
extern double_t __LIB__ __CALLEE__   scalbln(double_t x, int n);

extern double_t __LIB__ __FASTCALL__ fabs(double_t x);
extern double_t __LIB__ __CALLEE__   hypot(double_t x, double_t y);

extern double_t __LIB__ __CALLEE__   pow(double_t x, double_t y);
extern double_t __LIB__ __FASTCALL__ sqrt(double_t x);
extern double_t __LIB__ __FASTCALL__ cbrt(double_t x);

extern double_t __LIB__ __FASTCALL__ erf(double_t x);
extern double_t __LIB__ __FASTCALL__ erfc(double_t x);
extern double_t __LIB__ __FASTCALL__ lgamma(double_t x);
extern double_t __LIB__ __FASTCALL__ tgamma(double_t x);

extern double_t __LIB__ __FASTCALL__ ceil(double_t x);
extern double_t __LIB__ __FASTCALL__ floor(double_t x);
extern double_t __LIB__ __FASTCALL__ nearbyint(double_t x);
extern double_t __LIB__ __FASTCALL__ rint(double_t x);
extern long     __LIB__ __FASTCALL__ lrint(double_t x);
extern double_t __LIB__ __FASTCALL__ round(double_t x);
extern long     __LIB__ __FASTCALL__ lround(double_t x);
extern double_t __LIB__ __FASTCALL__ trunc(double_t x);

extern double_t __LIB__ __CALLEE__   modf(double_t value, double_t *iptr);
extern double_t __LIB__ __CALLEE__   fmod(double_t x, double_t y);
extern double_t __LIB__ __CALLEE__   remainder(double_t x, double_t y);
extern double_t __LIB__ __CALLEE__   remquo(double_t x, double_t y, int *quo);

extern double_t __LIB__ __CALLEE__   copysign(double_t x, double_t y);
extern double_t __LIB__ __FASTCALL__ nan(const char *tagp);

extern double_t __LIB__ __CALLEE__   nextafter(double_t x, double_t y);
extern double_t __LIB__ __CALLEE__   nexttoward(double_t x, double_t y);

extern double_t __LIB__ __CALLEE__   fdim(double_t x, double_t y);

extern double_t __LIB__ __CALLEE__   fmax(double_t x, double_t y);
extern double_t __LIB__ __CALLEE__   fmin(double_t x, double_t y);

extern double_t __LIB__ __CALLEE__   fma(double_t x, double_t y, double_t z);

extern int      __LIB__ __CALLEE__   isgreater(double_t x, double_t y);
extern int      __LIB__ __CALLEE__   isgreaterequal(double_t x, double_t y);
extern int      __LIB__ __CALLEE__   isless(double_t x, double_t y);
extern int      __LIB__ __CALLEE__   islessequal(double_t x, double_t y);
extern int      __LIB__ __CALLEE__   islessgreater(double_t x, double_t y);
extern int      __LIB__ __CALLEE__   isunordered(double_t x, double_t y);

// NO DISTINCTION BETWEEN FLOAT AND DOUBLE

#define acosf        acos
#define asinf        asin
#define atanf        atan
#define atan2f       atan2

#define cosf         cos
#define sinf         sin
#define tanf         tan

#define acoshf       acosh
#define asinhf       asinh
#define atanhf       atanh

#define coshf        cosh
#define sinhf        sinh
#define tanhf        tanh

#define expf         exp
#define exp2f        exp2
#define expm1f       expm1
#define frexpf       frexp
#define ilogbf       ilogb
#define ldexpf       ldexp

#define logf         log
#define log10f       log10
#define log1pf       log1p
#define log2f        log2
#define logbf        logb

#define scalbnf      scalbn
#define scalblnf     scalbln

#define fabsf        fabs
#define hypotf       hypot

#define powf         pow
#define sqrtf        sqrt
#define cbrtf        cbrt

#define erff         erf
#define erfcf        erfc
#define lgammaf      lgamma
#define tgammaf      tgamma

#define ceilf        ceil
#define floorf       floor
#define nearbyintf   nearbyint
#define rintf        rint
#define lrintf       lrint
#define llrintf      llrint
#define roundf       round
#define lroundf      lround
#define llroundf     llround
#define truncf       trunc

#define modff        modf
#define fmodf        fmod
#define remainderf   remainder
#define remquof      remquo

#define copysignf    copysign
#define nanf         nan

#define nextafterf   nextafter
#define nexttowardf  nexttoward

#define fdimf        fdim

#define fmaxf        fmax
#define fminf        fmin

#define fmaf         fma


#endif
