/*
 * ORIGINAL
 * https://crypto.stanford.edu/pbc/notes/pi/code.html
 *
 * Both sdcc and sccz80 are unable to pass structures by
 * value so z88dk supplies function _ldiv_() to replace
 * the standard library's ldiv().  The source code will
 * have to be modified for other compilers.
 *
 * To verify correct output:
 *
 * (sccz80) zcc +cpm -vn -clib=new pi.c -o pi
 * (sdcc  ) zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 pi.c -o pi
 *
 * For size and timing purposes variations of:
 *
 * (sccz80) zcc +embedded -vn -clib=new pi.c -o pi -DNOPRINTF
 * (sdcc  ) zcc +embedded -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 pi.c -o pi -DNOPRINTF
 *
 * Approximately 2.5x speed-up can be had if the z88dk
 * libraries are built with the fast int math option enabled.
 *
 * COMMAND LINE DEFINES
 * 
 * -DNODIV
 * Define if ldiv() not supported and replace with / and %.
 *
 * -DNOSTAT
 * Use local variables rather than statics.
 *
 * -DNOPRINTF
 * Do not use printf.
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#ifdef NODIV
uint16_t dummy;
#endif

int main()
{
   static uint16_t r[2800 + 1];

#ifndef NOSTAT
   static uint16_t i, k;
   static uint16_t b;
   static uint32_t d;
   static uint16_t c;
#ifndef NODIV
   static ldivu_t res;
#endif
#else
   uint16_t i, k;
   uint16_t b;
   uint32_t d;
   uint16_t c;
#ifndef NODIV
   ldivu_t res;
#endif
#endif

#asm
ticks_start:
#endasm

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

#ifndef NODIV
         _ldivu_(&res, d, (uint32_t)(b));
 
         r[i] = res.rem;
         d = res.quot;
#else
         r[i] = d % (uint32_t)(b);
         d = d / (uint32_t)(b);
#endif

         if (--i == 0) break;
 
         d *= (uint32_t)(i);
      }

#ifndef NODIV
      _ldivu_(&res, d, 10000UL);

#ifndef NOPRINTF
      printf("%.4d", c + (uint16_t)(res.quot));
#endif
      c = res.rem;
#else
#ifndef NOPRINTF
      printf("%.4d", c + (uint16_t)(d / 10000UL));
      c = d % 10000UL;
#else
      dummy = d / 10000UL;
      c = d % 10000UL;
#endif
#endif
   }
 
#asm
ticks_end:
#endasm
 
   return 0;
}
