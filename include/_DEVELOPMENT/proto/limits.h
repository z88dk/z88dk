include(__link__.m4)

#ifndef _LIMITS_H
#define _LIMITS_H

extern unsigned char   _MAX_OPEN[];
#define OPEN_MAX       ((unsigned int)_MAX_OPEN)

#define CHAR_BIT       8

#define SCHAR_MIN     -128
#define SCHAR_MAX      127
#define UCHAR_MAX      255U

#define SHRT_MIN      -32768
#define SHRT_MAX       32767
#define USHRT_MAX      65535U

#define INT_MIN       -32768
#define INT_MAX        32767
#define UINT_MAX       65535U

#define LONG_MIN      -2147483648L
#define LONG_MAX       2147483647L
#define ULONG_MAX      4294967295UL

#ifdef __CLANG

#define LLONG_MIN     -9223372036854775808LL
#define LLONG_MAX      9223372036854775807LL
#define ULLONG_MAX     18446744073709551615ULL

#endif

#ifdef __SDCC

#define LLONG_MIN     -9223372036854775808LL
#define LLONG_MAX      9223372036854775807LL
#define ULLONG_MAX     18446744073709551615ULL

#endif

#endif
