/*
 * COMMAND LINE DEFINES
 * 
 * -DSIZE=N
 * Investigate numbers 2..N-1 for primes.
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

#ifndef SIZE
#define SIZE 8000
#endif

#ifdef STATIC
   #undef  STATIC
   #define STATIC              static
#else
   #define STATIC
#endif

#ifdef PRINTF
   #define PRINTF2(a,b)        printf(a,b)
   #define PRINTF3(a,b,c)      printf(a,b,c)
#else
   #define PRINTF2(a,b)
   #define PRINTF3(a,b,c)
#endif

#ifdef TIMER
   #define TIMER_START()       __asm__("TIMER_START:")
   #define TIMER_STOP()        __asm__("TIMER_STOP:")
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif


#include <stdio.h>
#include <string.h>

#ifdef __Z88DK
   #include <intrinsic.h>
   #ifdef PRINTF
      #pragma output CLIB_OPT_PRINTF = 0x02
   #endif
#endif

unsigned char flags[SIZE];

main()
{
   STATIC unsigned int i, i_sq, k, count;

   // some compilers do not initialize properly

   memset(flags, 0, SIZE);

TIMER_START();

   count = SIZE - 2;
   
   i_sq = 4;
   for (i = 2; i_sq < SIZE; ++i)
   {
      if (!flags[i])
      {
         for (k = i_sq; k < SIZE; k += i)
         {
            count   -= !flags[k];
            flags[k] = 1;
         }
      }
      i_sq += i+i+1;  // (n+1)^2 = n^2 + 2n + 1
   }

TIMER_STOP();

   PRINTF3("\n%u primes found in [2,%u]:\n\n", count, SIZE-1);
   for (i = 2; i < SIZE; ++i)
      if (!flags[i]) PRINTF2("%u ", i);
}
