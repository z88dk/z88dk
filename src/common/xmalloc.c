//-----------------------------------------------------------------------------
// allocation of memory that dies on failure
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "xmalloc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char* g_progname = "";

void xmalloc_init(const char* progname) {
    g_progname = progname;
}

void* xmalloc_check_(void* p, const char* file, int line_num) {
    if (!p) {
        if (g_progname && strlen(g_progname))
            fprintf(stderr, "%s: ", g_progname);
        fprintf(stderr, "memory allocation error at %s:%d\n", file, line_num);
        exit(EXIT_FAILURE);
    }
    return p;
}

char* xmalloc_strndup_(const char* str, size_t n) {
    char* p = malloc(n + 1);
    if (!p)
        return NULL;
    else {
        strncpy(p, str, n);
        p[n] = '\0';
        return p;
    }
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
