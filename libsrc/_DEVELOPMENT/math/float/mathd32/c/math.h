/*
   Copyright (c) 2015 Digi International Inc.

   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

/*
	C90 - 7.5 Mathematics
*/

#ifndef __MATH_H
#define __MATH_H

	#define HUGE_VAL    		(float)3.00e38

	// Support functions used as a basis for other functions in math.h
	double pow2(double x);
	double log2(double x);

	// Non-ANSI macros used by Dynamic C
	#define BADTAN          (float)1.560796327
	#define EXPLARGE        (float)89.80081863
	#define INF             (float)3.00e38
	#define IPIby180        (float)57.29577951
	#define LNof10          (float)2.302585093
	#define LOG2            (float)0.30102999567
	#define LOGE            (float)0.43429448190
	#define PI              (float)3.14159265359
	#define PIby180         (float)0.0174532925
	#define PIbyTWO         (float)1.570796326795
	#define POW10INF        (float)38.0
	#define SQR10           (float)3.162277660168
	#define TWObyPI         (float)0.63661977

	// C90 - 7.5.2 Trigonometric functions
	double acos(double x);
	double asin(double x);
	double atan(double x);
	double atan2(double y, double x);
	double cos(double x);
	double sin(double x);
	double tan(double x);

	// C90 - 7.5.3 Hyperbolic functions
	double cosh(double x);
	double sinh(double x);
	double tanh(double x);

	// C90 - 7.5.4 Exponential and logarithmic functions
	double exp(double x);
	double frexp(double value, int *exp);
	double ldexp(double x, int exp);
	double log(double x);
	double log10(double x);
	double modf(double value, double *iptr);

	// C90 - 7.5.5 Power functions
	double pow(double x, double y);
	double sqrt(double x);

	// C90 - 7.5.6 Nearest integer, absolute value, and remainder functions
	double ceil(double x);
	double fabs(double x);
	double floor(double x);
	double fmod(double x, double y);

	// C99 - float equivalents to all C90 functions in math.lib
	float acosf(float x);
	float asinf(float x);
	float atanf(float x);
	float atan2f(float y, float x);
	float cosf(float x);
	float sinf(float x);
	float tanf(float x);
	float coshf(float x);
	float sinhf(float x);
	float tanhf(float x);
	float expf(float x);
	float frexpf(float value, int *exp);
	float ldexpf(float x, int exp);
	float logf(float x);
	float log10f(float x);
	float modff(float value, float *iptr);
	float powf(float x, float y);
	float sqrtf(float x);
	float ceilf(float x);
	float fabsf(float x);
	float floorf(float x);
	float fmodf(float x, float y);

	// Note that Dynamic C does not support the "long double" type, so there
	// is no need to declare long double versions of each function.

	#use "math.c"

#endif