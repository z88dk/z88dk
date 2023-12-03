//-----------------------------------------------------------------------------
// allocation of memory that dies on failure
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include <stdlib.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

void xmalloc_init(const char* progname);
void* xmalloc_check_(void* p, const char* file, int line_num);
char* xmalloc_strndup_(const char* str, size_t n);

#define XMALLOC_CHECK(type, p)	((type)(xmalloc_check_((p), __FILE__, __LINE__)))

#define xmalloc(size)		XMALLOC_CHECK(void*, malloc(size))
#define xcalloc(count,size)	XMALLOC_CHECK(void*, calloc((count), (size)))
#define xrealloc(p,size)	XMALLOC_CHECK(void*, realloc((p), (size)))
#define xfree(p)			(free(p), (p) = NULL)
#define xstrdup(s)			XMALLOC_CHECK(char*, strdup(s))
#define xstrndup(s, n)		XMALLOC_CHECK(char*, xmalloc_strndup_((s), (n)))

#define xnew(type)			XMALLOC_CHECK(type*, calloc(1, sizeof(type)))

#ifdef __cplusplus
}
#endif
