//-----------------------------------------------------------------------------
// die - check results and die on error
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "die.h"
#include <assert.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

//-----------------------------------------------------------------------------
// die
//-----------------------------------------------------------------------------
void die(char *msg, ...)
{
    va_list argptr;
    
	va_start(argptr, msg);
	vfprintf(stderr, msg, argptr);
	va_end(argptr);

    exit(EXIT_FAILURE);
}

void *check_alloc(void *p, const char *file, int line_nr)
{
	if (!p)
		die("memory allocation error at %s:%d\n", file, line_nr);
	return p;
}
