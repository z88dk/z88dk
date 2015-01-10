
#ifndef _ASSERT_H
#define _ASSERT_H

#include <stdio.h>
#include <stdlib.h>

#ifdef NDEBUG

   #define assert(x)           ((void)0)

#else

   #define assert(x)           if (x == 0)  { fputs(stderr, __FILE__ " line " #__LINE__ ": assert(" #exp ") failed\n"); abort(); }

#endif

#endif
