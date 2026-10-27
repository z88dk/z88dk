/* A portme.c for z88dk +test.

   Output goes through printf. +test already provides that console.
   main returns so z88dk-ticks can finish the run.

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include <stdio.h>

#include "stdcbench.h"

#if defined(TIMER) && defined(C90BASE) && defined(C90LIB)
#error "TIMER times one module: -DSTDCBENCH_WHICH=1 or -DSTDCBENCH_WHICH=2"
#endif
#if defined(TIMER) && defined(STDCBENCH_IOTIMER)
#error "TIMER and STDCBENCH_IOTIMER are different clocks"
#endif

#if defined(__Z88DK) && defined(TIMER)
#include <intrinsic.h>
#endif

#ifdef STDCBENCH_IOTIMER
#include <stdlib.h>

/* Guest buffer for ticks -mmtimer. The map name is _tickbuf. */
unsigned char tickbuf[8];

#define IOTIMER_PORT 2

static unsigned long tstates(void)
{
	unsigned long n;

	inp(IOTIMER_PORT);
	n = (unsigned long)tickbuf[0]
	    | ((unsigned long)tickbuf[1] << 8)
	    | ((unsigned long)tickbuf[2] << 16)
	    | ((unsigned long)tickbuf[3] << 24);
	return n;
}

/* Free-running counter, same idea as the Rabbit RTC read. */
stdcbench_clock_t stdcbench_clock(void)
{
	return tstates() / 40ul;
}

#else

/* No on-chip timer. One iteration, so ticks can bound it with -start/-end.
   Odd calls open the iteration. Even calls close it. */
stdcbench_clock_t stdcbench_clock(void)
{
	static unsigned char phase;

	phase ^= 1;
	if (phase) {
#ifdef TIMER
		intrinsic_label(TIMER_START);
#endif
		return 0;
	}
#ifdef TIMER
	intrinsic_label(TIMER_STOP);
#endif
	return ~0ul;
}

#endif

void stdcbench_error(const char *message)
{
	printf("ERROR: %s\n", message);
}

int main(void)
{
	unsigned long score;

	printf("\n%s\n", stdcbench_name_version_string);
	score = stdcbench();
#ifdef C90BASE
	printf("stdcbench c90base score: %lu\n", c90base_score);
#endif
#ifdef C90LIB
	printf("stdcbench c90lib score: %lu\n", c90lib_score);
#endif
	printf("stdcbench final score: %lu\n", score);
	return 0;
}
