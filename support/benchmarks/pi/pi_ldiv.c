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

#ifdef __Z88DK
   #define LDIV(res,num,den)   _ldiv_(&res,num,den)
#else
   #define LDIV(res,num,den)   (res=ldiv(num,den))
#endif

#ifdef TIMER
   #define TIMER_START()       intrinsic_label(TIMER_START)
   #define TIMER_STOP()        intrinsic_label(TIMER_STOP)
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif


#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int main()
{
   static uint16_t r[2800 + 1];

   STATIC uint16_t i, k;
   STATIC uint16_t b;
   STATIC uint32_t d;
   STATIC uint16_t c;
   
   STATIC ldiv_t res;

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
         d += (uint32_t)(r[i]) * 10000L;
         b = i * 2 - 1;

         LDIV(res, d, (uint32_t)(b));
 
         r[i] = res.rem;
         d = res.quot;

         if (--i == 0) break;
 
         d *= (uint32_t)(i);
      }

      LDIV(res, d, 10000L);

      PRINTF("%.4d", c + (uint16_t)(res.quot));
      c = res.rem;
   }
 
TIMER_STOP();
 
   return 0;
}
