//-----------------------------------------------------------------------------
// die - check results and die on error
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include <stdlib.h>
#include <string.h>

// error message and exit program
extern void die(char *msg, ...);

// check alloc result, die if error
extern void *check_alloc(void *p, const char *file, int line_nr);
#define Check_alloc(type, p)	((type)(check_alloc((p), __FILE__, __LINE__)))

#define xmalloc(size)		Check_alloc(void*, malloc(size))
#define xcalloc(count,size)	Check_alloc(void*, calloc((count), (size)))
#define xrealloc(p,size)	Check_alloc(void*, realloc((p), (size)))
#define xfree(p)			(free(p), (p) = NULL)
#define xstrdup(s)			Check_alloc(char*, strdup(s))

#define xnew(type)			Check_alloc(type*, calloc(1, sizeof(type)))
