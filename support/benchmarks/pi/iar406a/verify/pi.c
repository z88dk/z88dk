/*
 * ORIGINAL
 * https://crypto.stanford.edu/pbc/notes/pi/code.html
 *
 * COMMAND LINE DEFINES
 * 
 * -DSTATIC
 * Use static variables instead of locals.
 *
 * -DPRINTF
 * Enable printf.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points.
 *
 */

#ifdef __Z88DK
   #include <intrinsic.h>
   #ifdef PRINTF
      #pragma output CLIB_OPT_PRINTF = 0x01
   #endif
#endif

#ifdef STATIC
   #undef  STATIC
   #define STATIC              static
#else
   #define STATIC
#endif

#ifdef PRINTF
   #undef  PRINTF
   #define PRINTF(a,b)         printf(a,b)
#else
   STATIC  int dummy;
   #define PRINTF(a,b)         (dummy=b)
#endif

#ifdef TIMER
   #define TIMER_START()       intrinsic_label(TIMER_START)
   #define TIMER_STOP()        intrinsic_label(TIMER_STOP)
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif


#include <stdio.h>
#include <stdlib.h>

typedef unsigned int  uint16_t;
typedef unsigned long uint32_t;

int main()
{
   static uint16_t r[2800 + 1];

   STATIC uint16_t i, k;
   STATIC uint16_t b;
   STATIC uint32_t d;
   STATIC uint16_t c;

TIMER_START();

   c = 0;
 
   for (i = 0; i < 2800; ++i)
      r[i] = 2000;
 
   for (k = 2800; k > 0; k -= 14)
   {
      d = 0;
      i = k;
 
      while (1) 
      {
         d += (uint32_t)(r[i]) * 10000UL;
         b = i * 2 - 1;

         r[i] = d % (uint32_t)(b);
         d /= (uint32_t)(b);

         if (--i == 0) break;
 
         d *= (uint32_t)(i);
      }

      PRINTF("%.4d", c + (uint16_t)(d / 10000UL));
      c = d % 10000UL;
   }

TIMER_STOP();

   return 0;
}
