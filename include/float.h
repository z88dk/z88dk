#ifndef __FLOAT_H__
#define __FLOAT_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <math.h>

/* Use compiler builtins for IEEE-754 float parameters when available
 * (__DBL_MANT_DIG__ defined), leaving classic 48-bit constants for sccz80/sdcc. */
#if defined(__DBL_MANT_DIG__)

#undef FLT_RADIX
#define FLT_RADIX       __FLT_RADIX__

#undef FLT_MANT_DIG
#undef DBL_MANT_DIG
#define FLT_MANT_DIG    __FLT_MANT_DIG__
#define DBL_MANT_DIG    __DBL_MANT_DIG__

#undef FLT_DIG
#undef DBL_DIG
#define FLT_DIG         __FLT_DIG__
#define DBL_DIG         __DBL_DIG__

#undef FLT_EPSILON
#undef DBL_EPSILON
#define FLT_EPSILON     __FLT_EPSILON__
#define DBL_EPSILON     __DBL_EPSILON__

#undef FLT_MAX
#undef DBL_MAX
#define FLT_MAX         __FLT_MAX__
#define DBL_MAX         __DBL_MAX__

#undef FLT_MIN
#undef DBL_MIN
#define FLT_MIN         __FLT_MIN__
#define DBL_MIN         __DBL_MIN__

#undef FLT_MIN_EXP
#undef DBL_MIN_EXP
#define FLT_MIN_EXP     __FLT_MIN_EXP__
#define DBL_MIN_EXP     __DBL_MIN_EXP__

#undef FLT_MIN_10_EXP
#undef DBL_MIN_10_EXP
#define FLT_MIN_10_EXP  __FLT_MIN_10_EXP__
#define DBL_MIN_10_EXP  __DBL_MIN_10_EXP__

#undef FLT_MAX_EXP
#undef DBL_MAX_EXP
#define FLT_MAX_EXP     __FLT_MAX_EXP__
#define DBL_MAX_EXP     __DBL_MAX_EXP__

#undef FLT_MAX_10_EXP
#undef DBL_MAX_10_EXP
#define FLT_MAX_10_EXP  __FLT_MAX_10_EXP__
#define DBL_MAX_10_EXP  __DBL_MAX_10_EXP__

/* long double: genmath leaves these undefined, so no #undef is needed. */
#if defined(__LDBL_MANT_DIG__)
#define LDBL_MANT_DIG   __LDBL_MANT_DIG__
#define LDBL_DIG        __LDBL_DIG__
#define LDBL_EPSILON    __LDBL_EPSILON__
#define LDBL_MAX        __LDBL_MAX__
#define LDBL_MIN        __LDBL_MIN__
#define LDBL_MIN_EXP    __LDBL_MIN_EXP__
#define LDBL_MIN_10_EXP __LDBL_MIN_10_EXP__
#define LDBL_MAX_EXP    __LDBL_MAX_EXP__
#define LDBL_MAX_10_EXP __LDBL_MAX_10_EXP__
#endif

#endif /* __DBL_MANT_DIG__ */


#endif
