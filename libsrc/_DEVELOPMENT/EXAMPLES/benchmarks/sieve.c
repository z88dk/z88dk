
/**********************************************************************
 ** Z88DK NOTES *******************************************************
 **********************************************************************

 New C library:
  
 (sccz80) zcc +cpm -vn -clib=new sieve.c -o sieve
 (sdcc  ) zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 sieve.c -o sieve
 
 Classic C library:
 
 (sccz80) zcc +cpm -vn sieve.c -o sieve -lndos

 **********************************************************************
 
 -DNOPRINTF
 No printing.

 -DNOSTAT
 Locals are not made static variables.

 **********************************************************************
*/

#include <stdio.h>
#include <string.h>

#ifndef SIZE
#define SIZE 8000
#endif

unsigned char flags[SIZE];

main()
{
#ifndef NOSTAT
   static unsigned int i, i_sq, k, count;
#else
   unsigned int i, i_sq, k, count;
#endif

   // some compilers do not initialize properly

   memset(flags, 0, SIZE);

#asm
ticks_begin:
#endasm

   count = SIZE - 2;
   
   i_sq = 4;
   for (i=2; i_sq<SIZE; ++i)
   {
      if (!flags[i])
      {
         for (k=i_sq; k<SIZE; k+=i)
         {
            count -= !flags[k];
            flags[k]=1;
         }
      }
      i_sq += i+i+1;  // (n+1)^2 = n^2 + 2n + 1
   }

#asm
ticks_end:
#endasm

#ifndef NOPRINTF

   printf("\n%u primes found in [2,%u]:\n\n", count, SIZE-1);
   for (i=2; i<SIZE; ++i)
      if (!flags[i]) printf("%u ", i);

#endif
}
