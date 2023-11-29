//-----------------------------------------------------------------------------
// types - common types and macros
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef uint8_t byte_t;
typedef uint16_t word_t;
typedef uint32_t dword_t;
typedef unsigned int uint_t;

// MIN, MAX, ABS, CLAMP
#undef	MIN
#define MIN(a, b)  		(((a) < (b)) ? (a) : (b))

#undef	MAX
#define MAX(a, b)  		(((a) > (b)) ? (a) : (b))

#undef	ABS
#define ABS(a)	   		(((a) < 0) ? -(a) : (a))

#undef	CLAMP
#define CLAMP(x, low, high)  \
						(((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

// number of elements of array
#define NUM_ELEMS(a)    (sizeof(a) / sizeof(a[0]))

#ifdef __cplusplus
}
#endif
