//-----------------------------------------------------------------------------
// allocation of memory that dies on failure
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "xmalloc.h"

void run_die_check_alloc(void)
{
    XMALLOC_CHECK(void*, run_die_check_alloc);
    XMALLOC_CHECK(void*, NULL);
}

void t_die_xmalloc(void)
{
    char* p = xmalloc(10);
    TEST_ASSERT_NOT_NULL(p);
    xfree(p);
    TEST_ASSERT_NULL(p);
}

/* Os error message in OSX instead of plain NULL return; cannot run this test
* void run_die_xmalloc(void)
{
    size_t size = 1024;
    char *p;
    while (true) {
        p = xmalloc(size);
        TEST_ASSERT_NOT_NULL(p);
        xfree(p);
        TEST_ASSERT_NULL(p);
        size *= 2;
    }
} */

void t_die_xcalloc(void)
{
    char* p = xcalloc(1, 5);
    TEST_ASSERT_NOT_NULL(p);
    TEST_ASSERT_EQUAL(0, memcmp(p, "\0\0\0\0\0", 5));
    xfree(p);
    TEST_ASSERT_NULL(p);
}

/* Os error message in OSX instead of plain NULL return; cannot run this test
* void run_die_xrealloc(void)
{
    size_t size = 1024;
    char *p = NULL;
    while (true) {
        p = xrealloc(p, size);
        TEST_ASSERT_NOT_NULL(p);
        size *= 2;
    }
} */

void t_die_xstrdup(void)
{
    char* p = xstrdup("hello");
    TEST_ASSERT_EQUAL_STRING("hello", p);
    xfree(p);
    TEST_ASSERT_NULL(p);
}

void t_die_xnew(void)
{
    long* p = xnew(long);
    TEST_ASSERT_EQUAL(0, *p);
    xfree(p);
    TEST_ASSERT_NULL(p);
}
