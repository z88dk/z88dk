// zcc +zx -vn -startup=4 -O3 -clib=new malloc_test.c -o malloc_test -create-app -DPRINTF
// zcc +zx -vn -startup=4 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 malloc_test.c -o malloc_test -create-app -DPRINTF

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stropts.h>
#include <intrinsic.h>

#ifdef PRINTF
   #define PRINTF1(a)         printf(a)
   #define PRINTF2(a,b)       printf(a,b)
   #define PRINTF3(a,b,c)     printf(a,b,c)
   #define PRINTF4(a,b,c,d)   printf(a,b,c,d)
   #pragma output CLIB_OPT_PRINTF = 0x202
#else
   #define PRINTF(a)
   #define PRINTF2(a,b)
   #define PRINTF3(a,b,c)
   #define PRINTF4(a,b,c,d)
#endif

#ifndef N
   #define N  20
#endif

void         *p[N];
unsigned int sz[N];
unsigned int errors;

void main(void)
{
   static unsigned char vic;
   static unsigned int  i;
   
   ioctl(1, IOCTL_OTERM_PAUSE, 0);
   
intrinsic_label(TIMER_START);

   for (i=0; i<N*1000; ++i)
   {
      vic = (unsigned char)((long)rand() * N / RAND_MAX);
      
      if (p[vic])
      {
         PRINTF3("Slot %2u : free      %5u\n", vic, p[vic]);
         if (memrchr(p[vic], (unsigned char)p[vic], sz[vic]) != ((unsigned char *)p[vic] + sz[vic] - 1))
         {
            PRINTF1("\nERROR BLOCK CONTAMINATED\n\n");
            errors++;
         }

         free(p[vic]);
         p[vic] = 0;
      }
      else
      {
         if (p[vic] = malloc(sz[vic] = rand()/5 + 100))
         {
            memset(p[vic], (unsigned char)p[vic], sz[vic]);
            PRINTF4("Slot %2u : malloc at %5u %u bytes\n", vic, p[vic], sz[vic]);
         }
         else
            PRINTF2("Cannot allocate %u bytes\n", sz[vic]);
      }
   }

intrinsic_label(TIMER_STOP);

   PRINTF3("\n\n%s (%u errors)\n\n\n\n", errors ? "FAIL" : "PASS", errors);
}
