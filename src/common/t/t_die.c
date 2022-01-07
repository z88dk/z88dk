//-----------------------------------------------------------------------------
// die - check results and die on error
// Copyright (C) Paulo Custodio, 2011-2022
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "die.h"
#include "types.h"
#include <memory.h>

void run_die_die(void)
{
	die("hello %s %d!\n", "world", 42);
}

void run_die_xassert(void)
{
	xassert(1);
	xassert(0);
}

void run_die_check_alloc(void)
{
	Check_alloc(void*, run_die_check_alloc);
	Check_alloc(void*, NULL);
}

void t_die_xmalloc(void)
{
	char *p = xmalloc(10);
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
	char *p = xcalloc(1, 5);
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
	char *p = xstrdup("hello");
	TEST_ASSERT_EQUAL_STRING("hello", p);
	xfree(p);
	TEST_ASSERT_NULL(p);
}

void t_die_xnew(void)
{
	long *p = xnew(long);
	TEST_ASSERT_EQUAL(0, *p);
	xfree(p);
	TEST_ASSERT_NULL(p);
}
