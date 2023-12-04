//-----------------------------------------------------------------------------
// string pool
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "strpool.h"
#include "uthash.h"
#include "xmalloc.h"

//-----------------------------------------------------------------------------
// string pool
//-----------------------------------------------------------------------------
typedef struct {
    char* str;
    UT_hash_handle hh;
} spool_t;

static spool_t* spool = NULL;

const char* spool_add(const char* str) {
    if (str == NULL) return NULL;		// special case

    spool_t* found;
    HASH_FIND_STR(spool, str, found);
    if (found) return found->str;		// found

    found = xnew(spool_t);
    found->str = xstrdup(str);

    HASH_ADD_STR(spool, str, found);

    return found->str;
}

const char* spool_add_n(const char* str, size_t n) {
    if (str == NULL) return NULL;		// special case

    char* copy = xstrndup(str, n);
    const char* ret = spool_add(copy);
    xfree(copy);
    return ret;
}
