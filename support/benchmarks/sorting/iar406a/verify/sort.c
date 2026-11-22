/*
 * COMMAND LINE DEFINES
 * 
 * -DNUM=N
 * Set size of array to be sorted (>10).
 *
 * -DSTYLE=N
 * 0 = random, 1 = in order, 2 = reverse order, 3 = all same
 *
 * -DPRINTF
 * Enable printf.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points.
 *
 */

#ifdef PRINTF
   #define PRINTF1(a)          printf(a)
   #define PRINTF2(a,b)        printf(a,b)
#else
   #define PRINTF1(a)
   #define PRINTF2(a,b)
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

#ifdef __Z88DK
   #include <intrinsic.h>
#endif

#ifndef NUM
   #define NUM   5000
#endif

#ifndef STYLE
   #define STYLE 0
#endif

int i;
int numbers[NUM];

int g_rand(void);

int ascending_order(int *a, int *b)
{
   /* signed comparison is only good for |num| < 32768 */
   return *a - *b;
}

void perform_sort(void)
{
TIMER_START();

   qsort(numbers, NUM, sizeof(int), ascending_order);

TIMER_STOP();
}

int main(void)
{
   PRINTF1("\nFilling the array with numbers.\n\n");
   
   /* FILL ARRAY WITH NUMBERS */
   
   for (i = 0; i < NUM; ++i)
#if STYLE == 0
      numbers[i] = g_rand();
#else
#if STYLE == 1
      numbers[i] = i;
#else
#if STYLE == 2
      numbers[i] = NUM - i - 1;
#else
      numbers[i] = NUM/2;
#endif
#endif
#endif

   /* PRINT FIRST FEW NUMBERS TO DEMONSTRATE ALL IS GOOD */
   
   for (i = 0; i < 10; ++i)
      PRINTF2("%u, ", numbers[i]);
   
   /* SORT */
   
   PRINTF1("\n\nQSORT!!\n\n");
   perform_sort();

   /* VERIFY RESULT */
   
   for (i = 0; i < NUM; ++i)
   {
      PRINTF2("%u, ", numbers[i]);
      if ((i > 0) && (numbers[i] < numbers[i-1]))
      {
         PRINTF1("\n\nFAIL");
         break;
      }
   }
   
   PRINTF1("\n\n\n");
   
   return 0;
}

/*-------------------------------------------------------------------------
   rand.c - random number generator from SDCC under GPLv2
   
   Copyright (C) 2017, Philipp Klaus Krause, pkk@spth.de
   https://sourceforge.net/p/sdcc/code/HEAD/tree/trunk/sdcc/device/lib/rand.c
   
   Common random number generator to create the same random sequences
   for all compilers.
-------------------------------------------------------------------------*/

int g_rand(void)
{
   static unsigned long s = 0x80000001;
   unsigned long        t = s;
   
   t ^= t >> 10;
   t ^= t << 9;
   t ^= t >> 25;

   s = t;

   return(t & 0x7fff);
}
