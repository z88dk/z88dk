//-----------------------------------------------------------------------------
// die - check results and die on error
// Copyright (C) Paulo Custodio, 2011-2022
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "fileutil.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#ifdef _WIN32
#include <direct.h>
#endif

#if defined(_WIN32) && !defined(_CYGWIN)
#include <unixem/glob.h>
#endif
#include <glob.h>
#include <dirent.h>

// error message and exit program
extern void die(char *msg, ...);

// assertion that is not removed in a release compile
#define xassert(f)			do { \
								if (!(f)) \
									die("assertion failed in %s:%d\n", __FILE__, __LINE__); \
							} while(0)

// check alloc result, die if error
extern void *check_alloc(void *p, const char *file, int line_num);
#define Check_alloc(type, p)	((type)(check_alloc((p), __FILE__, __LINE__)))

#define xmalloc(size)		Check_alloc(void*, malloc(size))
#define xcalloc(count,size)	Check_alloc(void*, calloc((count), (size)))
#define xrealloc(p,size)	Check_alloc(void*, realloc((p), (size)))
#define xfree(p)			(free(p), (p) = NULL)
#define xstrdup(s)			Check_alloc(char*, strdup(s))

#define xnew(type)			Check_alloc(type*, calloc(1, sizeof(type)))

// check OS retval
extern int check_retval(int retval, const char *file, const char *source_file, int line_num);
#define Check_retval(rv, file)	check_retval((rv), (file), __FILE__, __LINE__)

#define xremove(file)		Check_retval(remove(file), (file))

#ifdef _WIN32
#define xmkdir(dir)			Check_retval(_mkdir(path_os(dir)), (dir))
#define xrmdir(dir)			Check_retval(_rmdir(path_os(dir)), (dir))
#else
#define xmkdir(dir)			Check_retval(mkdir(path_os(dir), 0777), (dir))
#define xrmdir(dir)			Check_retval(rmdir(path_os(dir)), (dir))
#endif

int xglob(const char *pattern, int flags, int(*errfunc) (const char *epath, int eerrno),
	glob_t *pglob);
