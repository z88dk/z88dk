/*
Unit test for xmalloc.c

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/t/Attic/test_xmalloc.c,v 1.2 2014-07-06 03:06:15 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "testlib.h"
#include <assert.h>

int test_no_allocation(void)
{
	xmalloc_init();
	return 0;
}

int test_no_leak(void)
{
	char *p1 = xmalloc(1);
	check_int(p1, !=, NULL);

	xfree(p1);
	check_int(p1, ==, NULL);

	xfree(p1);
	check_int(p1, ==, NULL);

	return 0;
}

int test_alloc_failed(void)
{
	while (1)
		xmalloc(0x08000000);
	return 0;
}

int test_unmatched_block(void)
{
	char p1[10], *p2 = p1;
	xfree(p2);
	return 0;
}

int test_buffer_underflow(void)
{
	char *p1 = xmalloc(1);
	p1[-1] = 0;
	xfree(p1);
	return 0;
}

int test_buffer_overflow(void)
{
	char *p1 = xmalloc(1);
	p1[1] = 0;
	xfree(p1);
	return 0;
}

int test_xmalloc(void)
{
	char *p0, *p1, *p2;
	
	p0 = xmalloc(0);
	check_int(p0, !=, NULL);

	p1 = xmalloc(1);
	check_int(p1, !=, NULL);

	p2 = xmalloc(2);
	check_int(p2, !=, NULL);

	p1[0] = p2[0] = p2[1] = 0;

	check_int( memcmp(p0-4, "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA",      8), ==, 0 );
	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA",    9), ==, 0 );
	check_int( memcmp(p2-4, "\xAA\xAA\xAA\xAA\0\0\xAA\xAA\xAA\xAA", 10), ==, 0 );

	return 0;
}

int test_xcalloc(void)
{
	char *p1 = xcalloc(5, 1);
	check_int(p1, !=, NULL);

	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\0\0\0\0\xAA\xAA\xAA\xAA", 13), ==, 0 );

	return 0;
}

int test_xnew(void)
{
	char *p1, *p2;
	
	p1 = xnew(char);
	check_int(p1, !=, NULL);

	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9), ==, 0 );

	p2 = xnew_n(char, 5);
	check_int(p2, !=, NULL);

	check_int( memcmp(p2-4, "\xAA\xAA\xAA\xAA\0\0\0\0\0\xAA\xAA\xAA\xAA", 13), ==, 0 );

	return 0;
}

int test_xrealloc(void)
{
	char *p1, *p2;

	p1 = xrealloc(NULL, 2);	
	check_int(p1, !=, NULL);

	p1[0] = 1; p1[1] = 2;

	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\1\2\xAA\xAA\xAA\xAA", 10), ==, 0 );

	/* shrink */
	p1 = xrealloc(p1, 1);
	check_int(p1, !=, NULL);

	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\1\xAA\xAA\xAA\xAA", 9), ==, 0 );

	p1 = xrealloc(p1, 0);
	check_int(p1, !=, NULL);

	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA", 8), ==, 0 );

	/* grow */
	p1 = xrealloc(p1, 1);
	check_int(p1, !=, NULL);

	p1[0] = 1;

	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\1\xAA\xAA\xAA\xAA", 9), ==, 0 );

	p1 = xrealloc(p1, 2);
	check_int(p1, !=, NULL);

	p1[1] = 2;

	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\1\2\xAA\xAA\xAA\xAA", 10), ==, 0 );

	/* keep sequence of free when reallocating */
	p2 = xmalloc(1999);
	check_int(p2, !=, NULL);

	p1 = xrealloc(p1, 3);
	check_int(p1, !=, NULL);

	p1[2] = 3;

	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\1\2\3\xAA\xAA\xAA\xAA", 11), ==, 0 );

	return 0;
}

int test_xstrdup(void)
{
	char *p1 = xstrdup("hello");
	check_int(p1, !=, NULL);

	check_int( memcmp(p1-4, "\xAA\xAA\xAA\xAAhello\0\xAA\xAA\xAA\xAA", 14), ==, 0 );
	check_str( p1, ==, "hello" );
	
	return 0;
}

int test_xmallocf(void)
{
	char *p1, *p2;
	
	p1 = xmallocf(1);
	check_int(p1, !=, NULL);

	p2 = xmallocf(2);
	check_int(p2, !=, NULL);

	xfreef(p2);
	check_int(p2, !=, NULL);

	return 0;
}

int test_warn(void)
{
	warn("This is a warning at %s(%d)\n", __FILE__, __LINE__);
	return 0;
}

int test_die(void)
{
	die("This is a death at %s(%d)\n", __FILE__, __LINE__);
	warn("Not reached at %s(%d)\n", __FILE__, __LINE__);
	return 0;
}

void message_at_exit(void)
{
	warn("Message at exit at %s(%d)\n", __FILE__, __LINE__);
}

int test_xatexit(void)
{
	warn("start\n");
	xatexit(message_at_exit);
	xatexit(message_at_exit);
	warn("end\n");
	return 0;
}

int test_xatexit_failed(void)
{
	xatexit(NULL);
	warn("Not reached at %s(%d)\n", __FILE__, __LINE__);
	return 0;
}

int test_sentinel(void)
{
	sentinel_die("not reached");
	warn("Not reached at %s(%d)\n", __FILE__, __LINE__);
	return 0;
}

int test_log(void)
{
	FILE *fp;

	log_err(   "error at %s(%d)", __FILE__, __LINE__);
	log_warn("warning at %s(%d)", __FILE__, __LINE__);
	log_info(   "info at %s(%d)", __FILE__, __LINE__);

	/* open non-existent file */
	fp = fopen("x/y/z/hello.c", "r");
	check_int(fp, ==, NULL);
	log_err("open file failed at %s(%d)", __FILE__, __LINE__);

	return 0;
}

int main(int argc, char *argv[])
{
	init_tests(argc, argv);
	run_test(0, test_no_allocation);
	run_test(0, test_no_leak);
	run_test(1, test_alloc_failed);
	run_test(1, test_unmatched_block);
	run_test(1, test_buffer_underflow);
	run_test(1, test_buffer_overflow);
	run_test(0, test_xmalloc);
	run_test(0, test_xcalloc);
	run_test(0, test_xnew);
	run_test(0, test_xrealloc);
	run_test(0, test_xstrdup);
	run_test(0, test_xmallocf);
	run_test(0, test_warn);
	run_test(1, test_die);
	run_test(0, test_xatexit);
	run_test(1, test_xatexit_failed);
	run_test(1, test_sentinel);
	run_test(0, test_log);
	return test_result();
}
