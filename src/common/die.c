//-----------------------------------------------------------------------------
// die - check results and die on error
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "die.h"
#include "xmalloc.h"
#include <assert.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

void die(const char *msg, ...) {
    va_list argptr;
    
	va_start(argptr, msg);
	vfprintf(stderr, msg, argptr);
	va_end(argptr);

    exit(EXIT_FAILURE);
}

