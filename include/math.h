#ifndef __MATH_H__
#define __MATH_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <limits.h>
#include <float.h>

/* $Id: math.h,v 1.18 2016-07-16 22:00:08 dom Exp $ */

#ifdef __MATH_MATH32
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
