//-----------------------------------------------------------------------------
// die - check results and die on error
// Copyright (C) Paulo Custodio, 2011-2020
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

int check_retval(int retval, const char *file, const char *source_file, int line_nr)
{
	if (retval) {
		perror(file);
		exit(EXIT_FAILURE);
	}
	return retval;
}

int xglob(const char * pattern, int flags, 
	int(*errfunc)(const char *epath, int eerrno), glob_t * pglob)
{
	int ret = glob(pattern, flags, errfunc, pglob);
	if (ret != GLOB_NOMATCH && ret != 0)
		die("glob pattern '%s': %s\n",
			pattern,
			(ret == GLOB_ABORTED ? "filesystem problem" :
				ret == GLOB_NOSPACE ? "no dynamic memory" :
				"unknown problem"));
	return ret;
}
