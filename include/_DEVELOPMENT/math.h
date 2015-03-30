
#ifndef _MATH_H
#define _MATH_H

// Math.h contains a complete listing of C11 functions for float and double
// types but the z80 math libraries will only implement a subset.


#ifdef __SDCC


///////////////////////////////////////////////////////////////
// SDCC
///////////////////////////////////////////////////////////////

// supports float type only
// double acts as synonym for float with warnings

typedef float float_t
typedef float double_t

#define FLT_EVAL_METHOD        1

#define HUGE_VAL
#define HUGE_VALF

#define INFINITY

#define MATH_ERRNO             1
#define MATH_ERREXCEPT         2
#define math_errhandling       1

// int signbit(real-floating x);

extern float         acosf(float x);
extern float         asinf(float x);
extern float         atanf(float x);
extern float         atan2f(float y, float x);

extern float         cosf(float x);
extern float         sinf(float x);
extern float         tanf(float x);

extern float         acoshf(float x);
extern float         asinhf(float x);
extern float         atanhf(float x);

extern float         coshf(float x);
extern float         sinhf(float x);
extern float         tanhf(float x);

extern float         expf(float x);
extern float         exp2f(float x);
extern float         expm1f(float x);
extern float         frexpf(float value, int *exp);
extern int           ilogbf(float x);
extern float         ldexpf(float x, int exp);

extern float         logf(float x);
extern float         log10f(float x);
extern float         log1pf(float x);
extern float         log2f(float x);
extern float         logbf(float x);

extern float         scalbnf(float x, int n);
extern float         scalblnf(float x, long int n);

extern float         fabsf(float x);
extern float         hypotf(float x, float y);

extern float         powf(float x, float y);
extern float         sqrtf(float x);
extern float         cbrtf(float x);

extern float         erff(float x);
extern float         erfcf(float x);
extern float         lgammaf(float x);
extern float         tgammaf(float x);

extern float         ceilf(float x);
extern float         floorf(float x);
extern float         nearbyintf(float x);
extern float         rintf(float x);
extern long          lrintf(float x);
extern long long     llrintf(float x);
extern float         roundf(float x);
extern long          lroundf(float x);
extern long long     llroundf(float x);
extern float         truncf(float x);

extern float         modff(float value, float *iptr);
extern float         fmodf(float x, float y);
extern float         remainderf(float x, float y);
extern float         remquof(float x, float y, int *quo);

extern float         copysignf(float x, float y);
extern float         nanf(const char *tagp);

extern float         nextafterf(float x, float y);
extern float         nexttowardf(float x, float y);

extern float         fdimf(float x, float y);

extern float         fmaxf(float x, float y);
extern float         fminf(float x, float y);

extern float         fmaf(float x, float y, float z);

// int isgreater(real-floating x, real-floating y);
// int isgreaterequal(real-floating x, real-floating y);
// int isless(real-floating x, real-floating y);
// int islessequal(real-floating x, real-floating y);
// int islessgreater(real-floating x, real-floating y);
// int isunordered(real-floating x, real-floating y);

#define acos         acosf
#define asin         asinf
#define atan         atanf
#define atan2        atan2f

#define cos          cosf
#define sin          sinf
#define tan          tanf

#define acosh        acoshf
#define asinh        asinhf
#define atanh        atanhf

#define cosh         coshf
#define sinh         sinhf
#define tanh         tanhf

#define exp          expf
#define exp2         exp2f
#define expm1        expm1f
#define frexp        frexpf
#define ilogb        ilogbf
#define ldexp        ldexpf

#define log          logf
#define log10        log10f
#define log1p        log1pf
#define log2         log2f
#define logb         logbf

#define scalbn       scalbnf
#define scalbln      scalblnf

#define fabs         fabsf
#define hypot        hypotf

#define pow          powf
#define sqrt         sqrtf
#define cbrt         cbrtf

#define erf          erff
#define erfc         erfcf
#define lgamma       lgammaf
#define tgamma       tgammaf

#define ceil         ceilf
#define floor        floorf
#define nearbyint    nearbyintf
#define rint         rintf
#define lrint        lrintf
#define llrint       llrintf
#define round        roundf
#define lround       lroundf
#define llround      llroundf
#define trunc        truncf

#define modf         modff
#define fmod         fmodf
#define remainder    remainderf
#define remquo       remquof

#define copysign     copysignf
#define nan          nanf

#define nextafter    nextafterf
#define nexttoward   nexttowardf

#define fdim         fdimf

#define fmax         fmaxf
#define fmin         fminf

#define fma          fmaf


#else


///////////////////////////////////////////////////////////////
// SCCZ80
///////////////////////////////////////////////////////////////

// supports double type only
// float acts as synonym for double without warnings

typedef double float_t
typedef double double_t

#define FLT_EVAL_METHOD        1

#define HUGE_VAL
#define HUGE_VALF

#define INFINITY

#define MATH_ERRNO             1
#define MATH_ERREXCEPT         2
#define math_errhandling       1

// int signbit(real-floating x);

extern double __LIB__ acos(double x);
extern double __LIB__ asin(double x);
extern double __LIB__ atan(double x);
extern double __LIB__ atan2(double y, double x);

extern double __LIB__ cos(double x);
extern double __LIB__ sin(double x);
extern double __LIB__ tan(double x);

extern double __LIB__ acosh(double x);
extern double __LIB__ asinh(double x);
extern double __LIB__ atanh(double x);

extern double __LIB__ cosh(double x);
extern double __LIB__ sinh(double x);
extern double __LIB__ tanh(double x);

extern double __LIB__ exp(double x);
extern double __LIB__ exp2(double x);
extern double __LIB__ expm1(double x);
extern double __LIB__ frexp(double value, int *exp);
extern int    __LIB__ ilogb(double x);
extern double __LIB__ ldexp(double x, int exp);

extern double __LIB__ log(double x);
extern double __LIB__ log10(double x);
extern double __LIB__ log1p(double x);
extern double __LIB__ log2(double x);
extern double __LIB__ logb(double x);

extern double __LIB__ scalbn(double x, int n);
extern double __LIB__ scalbln(double x, long int n);

extern double __LIB__ fabs(double x);
extern double __LIB__ hypot(double x, double y);

extern double __LIB__ pow(double x, double y);
extern double __LIB__ sqrt(double x);
extern double __LIB__ cbrt(double x);

extern double __LIB__ erf(double x);
extern double __LIB__ erfc(double x);
extern double __LIB__ lgamma(double x);
extern double __LIB__ tgamma(double x);

extern double __LIB__ ceil(double x);
extern double __LIB__ floor(double x);
extern double __LIB__ nearbyint(double x);
extern double __LIB__ rint(double x);
extern long   __LIB__ lrint(double x);
extern double __LIB__ round(double x);
extern long   __LIB__ lround(double x);
extern double __LIB__ trunc(double x);

extern double __LIB__ modf(double value, double *iptr);
extern double __LIB__ fmod(double x, double y);
extern double __LIB__ remainder(double x, double y);
extern double __LIB__ remquo(double x, double y, int *quo);

extern double __LIB__ copysign(double x, double y);
extern double __LIB__ __FASTCALL__ nan(const char *tagp);

extern double __LIB__ nextafter(double x, double y);
extern double __LIB__ nexttoward(double x, double y);

extern double __LIB__ fdim(double x, double y);

extern double __LIB__ fmax(double x, double y);
extern double __LIB__ fmin(double x, double y);

extern double __LIB__ fma(double x, double y, double z);

// int isgreater(real-floating x, real-floating y);
// int isgreaterequal(real-floating x, real-floating y);
// int isless(real-floating x, real-floating y);
// int islessequal(real-floating x, real-floating y);
// int islessgreater(real-floating x, real-floating y);
// int isunordered(real-floating x, real-floating y);

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

// SCCZ80 CALLEE LINKAGE

// int signbit(real-floating x);

extern double __LIB__ __CALLEE__ acos_callee(double x);
extern double __LIB__ __CALLEE__ asin_callee(double x);
extern double __LIB__ __CALLEE__ atan_callee(double x);
extern double __LIB__ __CALLEE__ atan2_callee(double y, double x);

extern double __LIB__ __CALLEE__ cos_callee(double x);
extern double __LIB__ __CALLEE__ sin_callee(double x);
extern double __LIB__ __CALLEE__ tan_callee(double x);

extern double __LIB__ __CALLEE__ acosh_callee(double x);
extern double __LIB__ __CALLEE__ asinh_callee(double x);
extern double __LIB__ __CALLEE__ atanh_callee(double x);

extern double __LIB__ __CALLEE__ cosh_callee(double x);
extern double __LIB__ __CALLEE__ sinh_callee(double x);
extern double __LIB__ __CALLEE__ tanh_callee(double x);

extern double __LIB__ __CALLEE__ exp_callee(double x);
extern double __LIB__ __CALLEE__ exp2_callee(double x);
extern double __LIB__ __CALLEE__ expm1_callee(double x);
extern double __LIB__ __CALLEE__ frexp_callee(double value, int *exp);
extern int    __LIB__ __CALLEE__ ilogb_callee(double x);
extern double __LIB__ __CALLEE__ ldexp_callee(double x, int exp);

extern double __LIB__ __CALLEE__ log_callee(double x);
extern double __LIB__ __CALLEE__ log10_callee(double x);
extern double __LIB__ __CALLEE__ log1p_callee(double x);
extern double __LIB__ __CALLEE__ log2_callee(double x);
extern double __LIB__ __CALLEE__ logb_callee(double x);

extern double __LIB__ __CALLEE__ scalbn_callee(double x, int n);
extern double __LIB__ __CALLEE__ scalbln_callee(double x, long int n);

extern double __LIB__ __CALLEE__ fabs_callee(double x);
extern double __LIB__ __CALLEE__ hypot_callee(double x, double y);

extern double __LIB__ __CALLEE__ pow_callee(double x, double y);
extern double __LIB__ __CALLEE__ sqrt_callee(double x);
extern double __LIB__ __CALLEE__ cbrt_callee(double x);

extern double __LIB__ __CALLEE__ erf_callee(double x);
extern double __LIB__ __CALLEE__ erfc_callee(double x);
extern double __LIB__ __CALLEE__ lgamma_callee(double x);
extern double __LIB__ __CALLEE__ tgamma_callee(double x);

extern double __LIB__ __CALLEE__ ceil_callee(double x);
extern double __LIB__ __CALLEE__ floor_callee(double x);
extern double __LIB__ __CALLEE__ nearbyint_callee(double x);
extern double __LIB__ __CALLEE__ rint_callee(double x);
extern long   __LIB__ __CALLEE__ lrint_callee(double x);
extern double __LIB__ __CALLEE__ round_callee(double x);
extern long   __LIB__ __CALLEE__ lround_callee(double x);
extern double __LIB__ __CALLEE__ trunc_callee(double x);

extern double __LIB__ __CALLEE__ modf_callee(double value, double *iptr);
extern double __LIB__ __CALLEE__ fmod_callee(double x, double y);
extern double __LIB__ __CALLEE__ remainder_callee(double x, double y);
extern double __LIB__ __CALLEE__ remquo_callee(double x, double y, int *quo);

extern double __LIB__ __CALLEE__ copysign_callee(double x, double y);

extern double __LIB__ __CALLEE__ nextafter_callee(double x, double y);
extern double __LIB__ __CALLEE__ nexttoward_callee(double x, double y);

extern double __LIB__ __CALLEE__ fdim_callee(double x, double y);

extern double __LIB__ __CALLEE__ fmax_callee(double x, double y);
extern double __LIB__ __CALLEE__ fmin_callee(double x, double y);

extern double __LIB__ __CALLEE__ fma_callee(double x, double y, double z);

// int isgreater(real-floating x, real-floating y);
// int isgreaterequal(real-floating x, real-floating y);
// int isless(real-floating x, real-floating y);
// int islessequal(real-floating x, real-floating y);
// int islessgreater(real-floating x, real-floating y);
// int isunordered(real-floating x, real-floating y);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define acos(a)           acos_callee(a)
#define asin(a)           asin_callee(a)
#define atan(a)           atan_callee(a)
#define atan2(a,b)        atan2_callee(a,b)

#define cos(a)            cos_callee(a)
#define sin(a)            sin_callee(a)
#define tan(a)            tan_callee(a)

#define acosh(a)          acosh_callee(a)
#define asinh(a)          asinh_callee(a)
#define atanh(a)          atanh_callee(a)

#define cosh(a)           cosh_callee(a)
#define sinh(a)           sinh_callee(a)
#define tanh(a)           tanh_callee(a)

#define exp(a)            exp_callee(a)
#define exp2(a)           exp2_callee(a)
#define expm1(a)          expm1_callee(a)
#define frexp(a,b)        frexp_callee(a,b)
#define ilogb(a)          ilogb_callee(a)
#define ldexp(a,b)        ldexp_callee(a,b)

#define log(a)            log_callee(a)
#define log10(a)          log10_callee(a)
#define log1p(a)          log1p_callee(a)
#define log2(a)           log2_callee(a)
#define logb(a)           logb_callee(a)

#define scalbn(a,b)       scalbn_callee(a,b)
#define scalbln(a,b)      scalbln_callee(a,b)

#define fabs(a)           fabs_callee(a)
#define hypot(a,b)        hypot_callee(a,b)

#define pow(a,b)          pow_callee(a,b)
#define sqrt(a)           sqrt_callee(a)
#define cbrt(a)           cbrt_callee(a)

#define erf(a)            erf_callee(a)
#define erfc(a)           erfc_callee(a)
#define lgamma(a)         lgamma_callee(a)
#define tgamma(a)         tgamma_callee(a)

#define ceil(a)           ceil_callee(a)
#define floor(a)          floor_callee(a)
#define nearbyint(a)      nearbyint_callee(a)
#define rint(a)           rint_callee(a)
#define lrint(a)          lrint_callee(a)
#define llrint(a)         llrint_callee(a)
#define round(a)          round_callee(a)
#define lround(a)         lround_callee(a)
#define llround(a)        llround_callee(a)
#define trunc(a)          trunc_callee(a)

#define modf(a,b)         modf_callee(a,b)
#define fmod(a,b)         fmod_callee(a,b)
#define remainder(a,b)    remainder_callee(a,b)
#define remquo(a,b,c)     remquo_callee(a,b,c)

#define copysign(a,b)     copysign_callee(a,b)

#define nextafter(a,b)    nextafter_callee(a,b)
#define nexttoward(a,b)   nexttoward_callee(a,b)

#define fdim(a,b)         fdim_callee(a,b)

#define fmax(a,b)         fmax_callee(a,b)
#define fmin(a,b)         fmin_callee(a,b)

#define fma(a,b,c)        fma_callee(a,b,c)


#endif

#endif
