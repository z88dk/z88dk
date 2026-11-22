/* c90lib_string module
   benchmarks string and character handling in the library

   (c) 2018 Philipp Klaus Krause

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include "stdcbench.h"

#ifdef C90LIB

extern void c90lib_lnlc(void);
extern void c90lib_peep(void);

#define SECONDS (STDCBENCH_CLOCKS_PER_SEC * 40ul)

unsigned long c90lib(void)
{
	unsigned long iterations = 0;
	stdcbench_clock_t stdcbench_start = stdcbench_clock();
	stdcbench_clock_t stdcbench_end;

	do
	{
		c90lib_lnlc();
		c90lib_peep();

		iterations++;
	}
	while((stdcbench_end = stdcbench_clock()) - stdcbench_start < SECONDS);

	return(iterations * (1000 * SECONDS / (stdcbench_end - stdcbench_start)) / 100);
}

#endif

