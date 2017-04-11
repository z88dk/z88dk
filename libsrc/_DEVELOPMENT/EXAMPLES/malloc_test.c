// zcc +zx -vn -DPRINTF -DWALK -startup=4 -O3 -clib=new malloc_test.c -o malloc_test -create-app
// zcc +zx -vn -DPRINTF -DWALK -startup=4 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 malloc_test.c -o malloc_test -create-app

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stropts.h>
#include <intrinsic.h>
#include <malloc.h>

#ifdef WALK

void visit_heap_block(heap_info_t *hi)
{
   switch (hi->type)
   {
      case 0:
         printf("HEADER    ");
         break;
      case 1:
         printf("ALLOCATED ");
         break;
      default:
         printf("FREE      ");
         break;
   }
   
   printf("@ %05u size %04u bytes\n", (unsigned int)(hi->address), hi->size);
}

#pragma output CLIB_OPT_PRINTF = 0x202

#endif

#ifdef PRINTF
   #define PRINTF1(a)         printf(a)
   #define PRINTF2(a,b)       printf(a,b)
   #define PRINTF3(a,b,c)     printf(a,b,c)
   #define PRINTF4(a,b,c,d)   printf(a,b,c,d)
   #define IOCTL(a,b,c)       ioctl(a,b,c)
   #pragma output CLIB_OPT_PRINTF = 0x202
#else
   #define PRINTF1(a)
   #define PRINTF2(a,b)
   #define PRINTF3(a,b,c)
   #define PRINTF4(a,b,c,d)
   #define IOCTL(a,b,c)
#endif

#ifndef N
   #define N  20
#endif

void         *p[N];
unsigned int sz[N];
unsigned int errors, unables;

void main(void)
{
   static unsigned char vic;
   static unsigned int  i;
   
   IOCTL(1, IOCTL_OTERM_PAUSE, 0);
   
intrinsic_label(TIMER_START);

   for (i=0; i<5000; ++i)
   {
      vic = (unsigned char)((unsigned long)rand() * N / ((unsigned int)RAND_MAX + 1));
      
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
         {
            PRINTF2("Cannot allocate %u bytes\n", sz[vic]);
            unables++;
         }
      }
   }

intrinsic_label(TIMER_STOP);

   PRINTF4("\n\n%s (%u errors, %u unables)\n\n\n\n", errors ? "FAIL" : "PASS", errors, unables);
   
#ifdef WALK

   printf("Let's walk the heap.\n\n");
   heap_info(_malloc_heap, visit_heap_block);
   printf("\nEnd of heap.\n\n\n\n");

#endif
}
