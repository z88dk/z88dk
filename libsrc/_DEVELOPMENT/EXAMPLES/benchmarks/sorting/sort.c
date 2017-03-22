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

int ascending_order(int *a, int *b)
{
   /* signed comparison is only good for |num| < 32768 */
   
   return *a - *b;
}

int main(void)
{
   PRINTF1("\nFilling the array with numbers.\n\n");
   
   /* FILL ARRAY WITH NUMBERS */
   
   for (i = 0; i < NUM; ++i)
#if STYLE = 0
      numbers[i] = rand() & 0x7fff;
#else
#if STYLE = 1
      numbers[i] = i;
#else
#if STYLE = 2
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
   
TIMER_START();

   qsort(numbers, NUM, sizeof(int), ascending_order);

TIMER_STOP();

   /* VERIFY RESULT */
   
   for (i = 0; i < NUM; ++i)
      PRINTF2("%u, ", numbers[i]);
   PRINTF1("\n\n\n");
   
   return 0;
}
