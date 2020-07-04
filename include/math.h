#ifndef __MATH_H__
#define __MATH_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <stdint.h>
#include <limits.h>
#include <float.h>

#define M_E        2.718282
#define M_INVLN2   1.442694  /* 1 / log(2) */
#define M_LOG2E    1.442694
#define M_IVLN10   0.434294  /* 1 / log(10) */
#define M_LOG10E   0.434294
#define M_LOG2_E   0.693146
#define M_LN2      0.693146
#define M_LN10     2.302585
#define M_PI       3.141592
#define M_TWOPI    6.283184
#define M_PI_2     1.570796
#define M_PI_4     0.785396
#define M_3PI_4    2.356194
#define M_SQRTPI   1.772454
#define M_1_PI     0.318310
#define M_2_PI     0.636620
#define M_4_PI     1.273240
#define M_1_SQRTPI 0.564190
#define M_2_SQRTPI 1.128379
#define M_SQRT2    1.414214
#define M_SQRT3    1.732051
#define M_SQRT1_2  0.707107

// math16 is an adjunct library so is always available
#include <math/math_math16.h>

#if __MATH_MATH32
#include <math/math_math32.h>
#elif __MATH_MBF32
#include <math/math_mbf32.h>
#elif __MATH_ZX
#include <math/math_zx.h>
#elif __MATH_CPC
#include <math/math_cpc.h>
#else
#include <math/math_genmath.h>
#endif


#endif /* _MATH_H */
