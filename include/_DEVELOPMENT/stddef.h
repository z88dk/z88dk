
#ifndef _STDDEF_H
#define _STDDEF_H

#ifndef _STDIO_H

   typedef unsigned int size_t;
   #define NULL ((void*)(0))

#endif

typedef int ptrdiff_t;
typedef unsigned char max_align_t;
typedef char wchar_t;

#ifdef __SDCC | __SDCC_IX | __SDCC_IY

   #define offsetof(t,m) __builtin_offsetof(t,m)

#else

   #define offsetof(t,m) (&t.m - &t)

#endif
#endif
