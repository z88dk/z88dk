include(__link__.m4)

#ifndef _ASSERT_H
#define _ASSERT_H

#include <stdio.h>
#include <stdlib.h>

#ifdef NDEBUG

   #define assert(exp)         ((void)0)

#else

   #define __assert_s(s)       #s
   #define assert(exp)         if (!(exp))  { fputs(__FILE__ " line " __assert_s(__LINE__) ": assert(" __assert_s(exp) ") failed\n", stderr); abort(); }

#endif

#endif
