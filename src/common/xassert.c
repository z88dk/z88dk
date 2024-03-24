//-----------------------------------------------------------------------------
// assertion that is not removed in a release compile
// Copyright (C) Paulo Custodio, 2011-2024
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "xassert.h"
#include "xmalloc.h"
#include "dirname.h"
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

static char* g_progname = NULL;

static void xassert_free(void) {
    free(g_progname);
}

void xassert_init(char* progname) {
    static bool inited = false;
    if (!inited) {
        atexit(xassert_free);
        inited = true;
    }

    g_progname = xstrdup(zbasename(progname));
    remove_ext(g_progname);
}

int xassert_(const char* expr, const char* file, unsigned line_num) {
    if (g_progname && strlen(g_progname))
        fprintf(stderr, "%s: ", g_progname);
    fprintf(stderr, "Assertion failed: %s, file %s, line %d\n",
        expr, file, line_num);
    exit(EXIT_FAILURE);
    return 0; // not reached
}
