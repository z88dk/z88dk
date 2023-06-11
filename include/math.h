#ifndef __MATH_H__
#define __MATH_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <stdint.h>
#include <limits.h>
#include <float.h>

#define M_E        2.7182818
#define M_INVLN2   1.4426950  /* 1 / log(2) */
#define M_LOG2E    1.4426950
#define M_IVLN10   0.4342945  /* 1 / log(10) */
#define M_LOG10E   0.4342945
#define M_LOG2_E   0.6931472
#define M_LN2      0.6931472
#define M_LN10     2.3025851
#define M_PI       3.1415927
#define M_TWOPI    6.2831853
#define M_PI_2     1.5707963
#define M_PI_4     0.7853982
#define M_3PI_4    2.3561945
#define M_SQRTPI   1.7724539
#define M_1_PI     0.3183099
#define M_2_PI     0.6366198
#define M_4_PI     1.2732395
#define M_1_SQRTPI 0.5641896
#define M_2_SQRTPI 1.1283792
#define M_SQRT2    1.4142136
#define M_SQRT3    1.7320508
#define M_SQRT1_2  0.7071068

// math16 is an adjunct library so is always available
#include <math/math_math16.h>

#if __MATH_MATH32
#include <math/math_math32.h>
#elif __MATH_AM9511
#include <math/math_am9511.h>
#elif __MATH_MBF32
#include <math/math_mbf32.h>
#elif __MATH_DAI32
#include <math/math_dai32.h>
#elif __MATH_ZX
#include <math/math_zx.h>
#elif __MATH_CPC
#include <math/math_cpc.h>
#else
#include <math/math_genmath.h>
#endif

#endif /* __MATH_H__ */
