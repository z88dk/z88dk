//-----------------------------------------------------------------------------
// die - check results and die on error
// Copyright (C) Paulo Custodio, 2011-2022
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

void *check_alloc(void *p, const char *file, int line_num)
{
	if (!p)
		die("memory allocation error at %s:%d\n", file, line_num);
	return p;
}

int check_retval(int retval, const char *file, const char *source_file, int line_num)
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

#ifdef DEBUG
	printf("GLOB(%s)=", pattern);
	for (int i = 0; i < pglob->gl_pathc; i++) {
		char* found = pglob->gl_pathv[i];
		printf("%s ", found);
	}
	printf("\n");
#endif

	if (ret != GLOB_NOMATCH && ret != 0)
		die("glob pattern '%s': %s\n",
			pattern,
			(ret == GLOB_ABORTED ? "filesystem problem" :
				ret == GLOB_NOSPACE ? "no dynamic memory" :
				"unknown problem"));
	return ret;
}

//-----------------------------------------------------------------------------
// functions called from C++
//-----------------------------------------------------------------------------
void* must_malloc(size_t size) {
	return xmalloc(size);
}

void* must_calloc(size_t count, size_t size) {
	return xcalloc(count, size);
}

void* must_realloc(void* block, size_t size) {
	return xrealloc(block, size);
}

void must_free(void* block) {
	xfree(block);
}

char* must_strdup(const char* str) {
	return xstrdup(str);
}
