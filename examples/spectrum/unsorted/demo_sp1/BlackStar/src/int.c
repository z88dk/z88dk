#include <im2.h>
#include <intrinsic.h>
#include <stdlib.h>
#include <string.h>
#include <z80.h>
#include "int.h"

// timer

unsigned char tick;
unsigned char timer;

IM2_DEFINE_ISR_8080(isr)
{
   // update the clock
   ++tick;
}

void
wait(void)
{
   while (abs(tick - timer) < WFRAMES)
      intrinsic_halt();
   
   timer = tick;
}

void
setup_int(void)
{
   im2_init((void *)0xd000);
   memset((void *)0xd000, 0xd1, 257);
   
   z80_bpoke(0xd1d1, 0xc3);
   z80_wpoke(0xd1d2, (unsigned int)isr);
}
