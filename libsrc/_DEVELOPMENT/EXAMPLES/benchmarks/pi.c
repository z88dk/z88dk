
// Original
// https://crypto.stanford.edu/pbc/notes/pi/code.html

// Both sdcc and sccz80 are unable to pass structures by
// value so z88dk supplies function _ldiv_() to replace
// the standard library's ldiv().  The source code will
// have to be modified for other compilers.

// (sccz80) zcc +cpm -vn -clib=new pi.c -o pi
// (sdcc  ) zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 pi.c -o pi
//
// -DNOSTATIC
// Use local variables rather than statics.
//
// -DOPRINTF
// Do not use printf.

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
 
int main()
{
   static uint16_t r[2800 + 1];

#ifndef NOSTATIC
   static uint16_t i, k;
   static uint16_t b;
   static uint32_t d;
   static uint16_t c;
   static ldivu_t res;
#else
   uint16_t i, k;
   uint16_t b;
   uint32_t d;
   uint16_t c;
   ldivu_t res;
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
 
         _ldivu_(&res, d, (uint32_t)(b));
 
         r[i] = res.rem;
         d = res.quot;
 
         if (--i == 0) break;
 
         d *= (uint32_t)(i);
      }
 
      _ldivu_(&res, d, 10000UL);

#ifndef NOPRINTF
      printf("%.4d", c + (uint16_t)(res.quot));
#endif

      c = res.rem;
   }
 
#asm
ticks_end:
#endasm
 
   return 0;
}
