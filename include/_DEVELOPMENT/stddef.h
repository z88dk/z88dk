
#ifndef _STDDEF_H
#define _STDDEF_H

#ifndef _STDIO_H

   typedef unsigned int size_t;
   #define NULL ((void*)(0))

#endif

typedef int ptrdiff_t;
typedef unsigned char max_align_t;
typedef char wchar_t;

#define offsetof(t,m) (&t.m - &t)

#endif
