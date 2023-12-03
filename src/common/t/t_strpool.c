//-----------------------------------------------------------------------------
// string pool
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "unity.h"
#include "strpool.h"

void t_strpool_spool_add(void) {
#define NUM_STRINGS 10
#define STRING_SIZE	5
    struct {
        char source[STRING_SIZE];
        const char* pool;
    } strings[NUM_STRINGS];

    const char* pool;
    int i;

    // first run - create pool for all strings
    for (i = 0; i < NUM_STRINGS; i++) {
        sprintf(strings[i].source, "%d", i);		// number i

        pool = spool_add(strings[i].source);
        TEST_ASSERT_NOT_NULL(pool);
        TEST_ASSERT(pool != strings[i].source);
        TEST_ASSERT_EQUAL_STRING(strings[i].source, pool);

        strings[i].pool = pool;
    }

    // second run - check that pool did not move
    for (i = 0; i < NUM_STRINGS; i++) {
        pool = spool_add(strings[i].source);
        TEST_ASSERT_NOT_NULL(pool);
        TEST_ASSERT(pool != strings[i].source);
        TEST_ASSERT_EQUAL_STRING(strings[i].source, pool);
        TEST_ASSERT_EQUAL(strings[i].pool, pool);
    }

    // check NULL case
    pool = spool_add(NULL);
    TEST_ASSERT_NULL(pool);
}

void t_strpool_spool_add_n(void) {
    const char* p1 = spool_add_n("hello world", 5);
    TEST_ASSERT_EQUAL_STRING("hello", p1);

    const char* p2 = spool_add("hello");
    TEST_ASSERT_EQUAL_STRING("hello", p2);

    TEST_ASSERT(p1 == p2);
}
