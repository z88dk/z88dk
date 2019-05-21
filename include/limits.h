#ifndef __LIMITS_H__
#define __LIMITS_H__ 

#define CHAR_BIT 8
#define SCHAR_MAX 127
#define SCHAR_MIN (-128)
#define UCHAR_MAX 255U
#define UCHAR_MIN 0

#ifdef __SDCC
#define CHAR_MAX UCHAR_MAX
#define CHAR_MIN UCHAR_MIN
#else
#define CHAR_MAX SCHAR_MAX
#define CHAR_MIN SCHAR_MIN
#endif

#define INT_MAX 32767
#define INT_MIN (-32768)
#define SHRT_MAX INT_MAX
#define SHRT_MIN INT_MIN
#define UINT_MAX 65535U
#define UINT_MIN 0
#define USHRT_MAX UINT_MAX
#define USHRT_MIN UINT_MIN
#define LONG_MAX 2147483647L
#define LONG_MIN (-2147483648L)
#define ULONG_MAX 4294967295LU
#define ULONG_MIN 0




#endif

