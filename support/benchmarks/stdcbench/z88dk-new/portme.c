/* A portme.c for z88dk newlib (+z80 -startup=0).

   startup 0 has no stdout. Messages go out of port 1. Run ticks
   with -iochar 1. main returns so z88dk-ticks can finish the run.

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

/* z80.h is wrapped in __Z80. This port is +z80. The C preprocessor
   does not always see that define, so the prototypes never appear. */
#ifndef __Z80
#define __Z80 1
#endif
#include <z80.h>

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

#define CON_PORT 1

#if defined(__Z180) || defined(__Z80N)
extern void bench_putc(unsigned char c) __z88dk_fastcall;
extern unsigned int bench_in2(unsigned int port) __z88dk_fastcall;
#endif

static void con_putc(unsigned char c)
{
#if defined(__Z180) || defined(__Z80N)
	bench_putc(c);
#else
	z80_outp(CON_PORT, c);
#endif
}

static void con_write(const char *s)
{
	while (*s)
		con_putc((unsigned char)*s++);
}

static void con_puts(const char *s)
{
	con_write(s);
	con_putc('\n');
}

static void con_putu(unsigned long n)
{
	char buf[12];
	char *p;

	p = buf + sizeof(buf);
	*--p = 0;
	do {
		*--p = (char)('0' + (unsigned)(n % 10ul));
		n /= 10ul;
	} while (n);
	while (*p)
		con_putc((unsigned char)*p++);
}

#ifdef STDCBENCH_IOTIMER

/* Guest buffer for ticks -mmtimer. The map name is _tickbuf. */
unsigned char tickbuf[8];

#define IOTIMER_PORT 2

static unsigned long tstates(void)
{
	unsigned long n;

#if defined(__Z180) || defined(__Z80N)
	bench_in2(IOTIMER_PORT);
#else
	z80_inp(IOTIMER_PORT);
#endif
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
	con_write("ERROR: ");
	con_puts(message);
}

int main(void)
{
	unsigned long score;

	con_putc('\n');
	con_puts(stdcbench_name_version_string);
	score = stdcbench();
#ifdef C90BASE
	con_write("stdcbench c90base score: ");
	con_putu(c90base_score);
	con_putc('\n');
#endif
#ifdef C90LIB
	con_write("stdcbench c90lib score: ");
	con_putu(c90lib_score);
	con_putc('\n');
#endif
	con_write("stdcbench final score: ");
	con_putu(score);
	con_putc('\n');
	return 0;
}
