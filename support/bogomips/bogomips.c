/*
 *                Standalone BogoMips program
 *
 * Based on code Linux kernel code in init/main.c and
 * include/linux/delay.h
 *
 * For more information on interpreting the results, see the BogoMIPS
 * Mini-HOWTO document.
 *
 * version: 1.3 
 *  author: Jeff Tranter (Jeff_Tranter@Mitel.COM)
 *
 * djm 20/3/2000
 * Made a little bit more relevent for 8 bit machines in the printing
 * stage...should be right!
 */

#include <stdio.h>
#include <time.h>

#ifdef CLASSIC_BOGOMIPS
/* the original code from the Linux kernel */
static __inline__ void delay(int loops)
{
  __asm__(".align 2,0x90\n1:\tdecl %0\n\tjns 1b": :"a" (loops):"ax");
}
#endif

#ifdef QNX_BOGOMIPS
/* version for QNX C compiler */
void delay(int loops);
#pragma aux delay = \
     "l1:"       \
     "dec eax"   \
     "jns l1"    \
     parm nomemory [eax] modify exact nomemory [eax];
#endif

#ifdef PORTABLE_BOGOMIPS
/* portable version */
static void delay(long loops)
{
  long i;
  for (i = loops; i != 0 ; i--) 
    ;
}
#endif

/*
 * This is a chronic cheat! The code is completely different and runs
 * many times quicker..<ahem>
 *
 * We could just forget it really!
 */

#ifdef Z80_DELAY
static void delay(long loops)
{
#asm
.del_loop
	call	l_declong
	ld	a,h
	or	l
	or	e
	or	d
	jp	nz,del_loop
#endasm
}
#endif


int
main(void)
{
  unsigned long loops_per_sec = 1;
  unsigned long ticks;
  unsigned long bogo;
  unsigned long sub;
  
  printf("Calibrating delay loop.. ");
  fflush(stdout);
  
  while ((loops_per_sec <<= 1)) {
    ticks = clock();
    delay(loops_per_sec);
    ticks = clock() - ticks;
    if (ticks >= CLOCKS_PER_SEC) {
      loops_per_sec = (loops_per_sec / ticks) * CLOCKS_PER_SEC;
      bogo = loops_per_sec/500000L;
      sub = loops_per_sec/5000L;
      sub %=100;
      printf("ok - %lu.%s%lu BogoMips\n",
			bogo,
			(sub<10)?"0":"",
			sub
		);
      printf("loops_per_sec=%lu\n",loops_per_sec);
      return 0;
    }
  }
  printf("failed\n");
  return -1;
}
