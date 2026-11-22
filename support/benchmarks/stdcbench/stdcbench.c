/* (c) 2018 Philipp Klaus Krause

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include "stdcbench.h"

union stdcbench_buffer stdcbench_buffer;

unsigned long c90base_score;
unsigned long c90lib_score;

const char stdcbench_name_version_string[] = "stdcbench 0.8";

unsigned long stdcbench(void)
{
	unsigned long score = 0;

#ifdef C90BASE
	score += c90base_score = c90base();
#endif

#ifdef C90FLOAT
	score += c90float();
#endif

#ifdef C90DOUBLE
	score += c90double();
#endif

#ifdef C90LIB
	score += c90lib_score = c90lib();
#endif

	return(score);
}

