/*
 *  stdint.h - integer types
 *
 *	$Id: stdint.h,v 1.2 2016-04-25 10:19:17 dom Exp $
 */

#ifndef _STDINT_H
#define _STDINT_H

#include <sys/compiler.h>
#include <sys/types.h>

typedef signed char            int8_t;
typedef signed int             int16_t;
typedef signed long            int32_t;

typedef unsigned char          uint8_t;
typedef unsigned int           uint16_t;
typedef unsigned long          uint32_t;

typedef signed char            int_least8_t;
typedef signed int             int_least16_t;
typedef signed long            int_least32_t;

typedef unsigned char          uint_least8_t;
typedef unsigned int           uint_least16_t;
typedef unsigned long          uint_least32_t;

typedef signed int             int_fast8_t;
typedef signed int             int_fast16_t;
typedef signed long            int_fast32_t;

typedef unsigned int           uint_fast8_t;
typedef unsigned int           uint_fast16_t;
typedef unsigned long          uint_fast32_t;

#ifdef Z88DK_USES_SDCC

typedef long long              int64_t;
typedef unsigned long long     uint64_t;

typedef long long              int_least64_t;
typedef unsigned long long     uint_least64_t;

typedef long long              int_fast64_t;
typedef unsigned long long     uint_fast64_t;

#endif

#ifndef _INTPTR_T_DEFINED
#define _INTPTR_T_DEFINED
typedef int                    intptr_t;
#endif

typedef unsigned int           uintptr_t;

typedef long                   intmax_t;
typedef unsigned long          uintmax_t;

#define INT8_MIN              -128
#define INT16_MIN             -32768
#define INT32_MIN             -2147483648L

#define INT8_MAX               127
#define INT16_MAX              32767
#define INT32_MAX              2147483647L

#define UINT8_MAX              255U
#define UINT16_MAX             65535U
#define UINT32_MAX             4294967295UL

#define INT_LEAST8_MIN        -128
#define INT_LEAST16_MIN       -32768
#define INT_LEAST32_MIN       -2147483648L

#define INT_LEAST8_MAX         127
#define INT_LEAST16_MAX        32767
#define INT_LEAST32_MAX        2147483647L

#define UINT_LEAST8_MAX        255U
#define UINT_LEAST16_MAX       65535U
#define UINT_LEAST32_MAX       4294967295UL

#define INT_FAST8_MIN         -32768
#define INT_FAST16_MIN        -32768
#define INT_FAST32_MIN        -2147483648L

#define INT_FAST8_MAX          32767
#define INT_FAST16_MAX         32767
#define INT_FAST32_MAX         2147483647L

#define UINT_FAST8_MAX         65535U
#define UINT_FAST16_MAX        65535U
#define UINT_FAST32_MAX        4294967295UL

#define INTPTR_MIN            -32768
#define INTPTR_MAX             32767

#define UINTPTR_MAX            65535U

#define INTMAX_MIN            -2147483648L
#define INTMAX_MAX             2147483647L

#define UINTMAX_MAX            4294967295UL

#define PTRDIFF_MIN           -32768
#define PTRDIFF_MAX            32767

// SIG_ATOMIC_MIN
// SIG_ATOMIC_MAX

#define SIZE_MAX               65535U

#define WCHAR_MIN              0
#define WCHAR_MAX              255U

// WINT_MIN
// WINT_MAX

#define INT8_C(value)          value
#define INT16_C(value)         value
#define INT32_C(value)         value##L

#define UINT8_C(value)         value##U
#define UINT16_C(value)        value##U
#define UINT32_C(value)        value##UL

#define INTMAX_C(value)        value##L
#define UINTMAX_C(value)       value##UL

#endif


