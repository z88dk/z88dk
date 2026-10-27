/* c90base module
   benchmarks basic functionality of C90 (excluding float, double, struct/union assignment, passing, returning and functionality not required for freestanding implementations)

   (c) 2018 Philipp Klaus Krause

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include "stdcbench.h"

#ifdef C90BASE
extern void c90base_compression(void);
extern void c90base_isort(void);
extern void c90base_immul(void);

#define SECONDS (STDCBENCH_CLOCKS_PER_SEC * 8ul)

unsigned long c90base(void)
{
	unsigned long iterations = 0;
	stdcbench_clock_t stdcbench_start = stdcbench_clock();
	stdcbench_clock_t stdcbench_end;

	do
	{
		c90base_compression();
		c90base_isort();
		c90base_immul();

		iterations++;
	}
	while((stdcbench_end = stdcbench_clock()) - stdcbench_start < SECONDS);

	return(iterations * (1000 * SECONDS / (stdcbench_end - stdcbench_start)) / 100);
}

#endif

