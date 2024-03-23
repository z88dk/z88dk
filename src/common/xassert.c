//-----------------------------------------------------------------------------
// assertion that is not removed in a release compile
// Copyright (C) Paulo Custodio, 2011-2024
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "xassert.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char* g_progname = "";

// search last '/' or '\\'
static const char* basename(const char* filename) {
    const char* p = filename + strlen(filename) - 1;
    while (p > filename) {
        if (*p == '/' || *p == '\\')
            return p + 1;
        p--;
    }
    return filename;
}

void xassert_init(const char* progname) {
    g_progname = basename(progname);
}

int xassert_(const char* expr, const char* file, unsigned line_num) {
    if (g_progname && strlen(g_progname))
        fprintf(stderr, "%s: ", g_progname);
    fprintf(stderr, "Assertion failed: %s, file %s, line %d\n",
        expr, file, line_num);
    exit(EXIT_FAILURE);
    return 0; // not reached
}
