
#ifndef _STDDEF_H
#define _STDDEF_H

typedef int ptrdiff_t;

typedef unsigned int size_t;

typedef unsigned char max_align_t;

typedef unsigned char wchar_t;

#undef NULL
#define NULL ((void *)(0))

#ifdef __SDCC

   #define offsetof(t,m) __builtin_offsetof(t,m)

#endif

#endif
