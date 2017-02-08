/*
Z88DK Z80 Macro Assembler

Unit test for dbg.h

Based on Learn C the Hard Way book, by Zed. A. Shaw (http://c.learncodethehardway.org/book/)

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "minunit.h"
#include <assert.h>

int test_warn_die(void)
{
	warn("warning at %s:%d\n", __FILE__, __LINE__);
	die( "died at %s:%d\n",    __FILE__, __LINE__);
	warn("not reached\n");

	return MU_PASS;
}

int test_log(void)
{
	FILE *file;

	log_err(   "error at %s:%d", __FILE__, __LINE__);
	log_warn("warning at %s:%d", __FILE__, __LINE__);
	log_info(   "info at %s:%d", __FILE__, __LINE__);
	debug(     "debug at %s:%d", __FILE__, __LINE__);

	/* open non-existent file to test errno printing */
	file = fopen("x/y/z/hello.c", "r");
	mu_assert_ptr_null(file);

	log_err("open file failed at %s:%d", __FILE__, __LINE__);
	log_err("errno is now zero at %s:%d", __FILE__, __LINE__);

	return MU_PASS;
}

int test_check(void)
{
	check( 1, "check(true)  at %s:%d", __FILE__, __LINE__);
	check( 0, "check(false) at %s:%d", __FILE__, __LINE__);
	warn("not reached\n");
	return MU_FAIL;
error:
	warn("Error caught\n");
	return MU_PASS;
}

int test_check_int_die(void)
{
	int val1 = 0;
	int val2;

	val2 = check_int_die( val1++, == 0, "val1 ok");
	mu_assert_int(val1, ==, 1);
	mu_assert_int(val2, ==, 0);

	val2 = check_int_die( val1++, == 0, "val1 nok");
	warn("not reached\n");
	return MU_PASS;
}

int test_check_ptr_die(void)
{
	char *ptr1 = "hello";
	char *ptr2;

	ptr2 = check_ptr_die( ptr1, != NULL, "ptr1 ok");
	mu_assert_str(ptr1, ==, "hello");
	mu_assert_str(ptr2, ==, "hello");

	ptr2 = check_ptr_die( ptr1, == NULL, "ptr1 nok");
	warn("not reached\n");
	return MU_PASS;
}

int test_check_mem(void)
{
	void *memptr = "hello";

	check_mem( memptr );
	check_mem( NULL   );
	warn("not reached\n");
	return MU_FAIL;
error:
	warn("Error caught\n");
	return MU_PASS;
}

int test_check_mem_die(void)
{
	void *memptr1 = "hello";
	void *memptr2 = NULL;

	memptr2 = check_mem_die( memptr1 );
	mu_assert( memptr1 == memptr2, "pointers are aliases");

	check_mem_die( NULL );
	warn("not reached\n");
	return MU_PASS;
}

int test_check_node(void)
{
	void *memptr = "hello";

	check_node( memptr );
	check_node( NULL   );
	warn("not reached\n");
	return MU_FAIL;
error:
	warn("Error caught\n");
	return MU_PASS;
}

int test_check_node_die(void)
{
	void *memptr = "hello";

	check_node_die( memptr );
	check_node_die( NULL   );
	warn("not reached\n");
	return MU_PASS;
}

int test_check_debug(void)
{
	check_debug( 1, "check_debug(true)  at %s:%d", __FILE__, __LINE__);
	check_debug( 0, "check_debug(false) at %s:%d", __FILE__, __LINE__);
	warn("not reached\n");
	return MU_FAIL;
error:
	warn("Error caught\n");
	return MU_PASS;
}

int test_sentinel(void)
{
	sentinel("sentinel() at %s:%d", __FILE__, __LINE__);
	warn("not reached\n");
	return MU_FAIL;
error:
	warn("Error caught\n");
	return MU_PASS;
}

int test_sentinel_die(void)
{
	sentinel_die("sentinel() at %s:%d", __FILE__, __LINE__);
	warn("not reached\n");
	return MU_PASS;
}

int test_stack(void)
{
	int i, value;
	char *ptr;
	
	for (i = 0; i < 10; i++) {
		value = dbg_push_int(i);
		mu_assert_int(value, ==, i);
	}
	
	ptr = dbg_push_ptr("hello");
	mu_assert_str(ptr, ==, "hello");

	ptr = dbg_push_ptr("world");
	mu_assert_str(ptr, ==, "world");

	ptr = dbg_peek_ptr();
	mu_assert_str(ptr, ==, "world");

	ptr = dbg_pop_ptr();
	mu_assert_str(ptr, ==, "world");

	ptr = dbg_peek_ptr();
	mu_assert_str(ptr, ==, "hello");

	ptr = dbg_pop_ptr();
	mu_assert_str(ptr, ==, "hello");

	for (i = 9; i >= 0; i--) {
		value = dbg_peek_int();
		mu_assert_int(value, ==, i);

		value = dbg_pop_int();
		mu_assert_int(value, ==, i);
	}

	return MU_PASS;
}

int test_stack_overflow(void)
{
	while (1)
		dbg_push_int(1);

	warn("not reached\n");
	return MU_PASS;
}

int test_stack_underflow(void)
{
	dbg_pop_int();

	warn("not reached\n");
	return MU_PASS;
}

void message_at_exit(void)
{
	warn("Message at exit at %s:%d\n", __FILE__, __LINE__);
}

int test_xatexit(void)
{
	int value;

	warn("start at %s:%d\n", __FILE__, __LINE__);

	value = xatexit(message_at_exit);
	mu_assert_int(value, ==, 0);

	value = xatexit(message_at_exit);
	mu_assert_int(value, ==, 0);

	value = xatexit(message_at_exit);
	mu_assert_int(value, ==, 0);

	warn("end at %s:%d\n", __FILE__, __LINE__);
	return MU_PASS;
}

int test_xatexit_die(void)
{
	int value;

	warn("start at %s:%d\n", __FILE__, __LINE__);

	value = xatexit(NULL);
	mu_assert_int(value, !=, 0);

	warn("Not reached at %s:%d\n", __FILE__, __LINE__);
	return MU_PASS;
}

int test_xfopen(void)
{
	FILE *file;
	char str[256];
	int i;

	warn("Read %s\n", __FILE__);
	file = xfopen(__FILE__, "r");
	for (i = 1; i < 8; i++)
	{
		fgets(str, sizeof(str), file);
		warn("Line %d: %s", i, str);
	}
	xfclose(file);

	return MU_PASS;
}

#define FILE_NOT_FOUND	__FILE__ ".not.found"
#define TEMP_FILE		"test_dbg.tmp"

int test_xfopen_die(void)
{
	FILE *file;

	warn("Read %s\n", FILE_NOT_FOUND);
	file = xfopen(FILE_NOT_FOUND, "r");
	assert(file);		/* not reached */
	
	return MU_PASS;
}

int test_xfclose_die(void)
{
	FILE *file;

	warn("Open %s and close twice\n", __FILE__);
	file = xfopen(__FILE__, "r");
	xfclose(file);
	xfclose(file);

	return MU_PASS;
}

int test_xfputs(void)
{
	char str[256];
	FILE *file;
	char *p;

	file = xfopen(TEMP_FILE, "w");
	xfputs("hello world\n", file);
	xfclose(file);

	file = xfopen(TEMP_FILE, "r");
	
	p = fgets(str, sizeof(str), file);
	mu_assert_ptr(p);
	mu_assert(p == str, "fgets failed");
	mu_assert_str(str, == , "hello world\n");

	p = fgets(str, sizeof(str), file);
	mu_assert_ptr_null(p);

	xfclose(file);
	xremove(TEMP_FILE);

	return MU_PASS;
}

int test_xfputs_die(void)
{
	FILE *file;

	warn("Read from wrong handle\n");
	file = xfopen(__FILE__, "r");
	xfputs("hello world\n", file);

	return MU_PASS;
}

int test_xremove(void)
{
	FILE *file;

	file = xfopen(TEMP_FILE, "w");
	xfputs("hello world\n", file);
	xfclose(file);

	xremove(TEMP_FILE);

	file = fopen(TEMP_FILE, "r");
	mu_assert_ptr_null(file);

	return MU_PASS;
}

int test_xremove_die(void)
{
	FILE *file;

	warn("Remove non-existing file\n");

	file = xfopen(TEMP_FILE, "w");
	xfputs("hello world\n", file);
	xfclose(file);

	xremove(TEMP_FILE);

	file = fopen(TEMP_FILE, "r");
	mu_assert_ptr_null(file);

	xremove(TEMP_FILE);

	return MU_PASS;
}

int test_xsystem(void)
{
	xsystem("true");
	return MU_PASS;
}

int test_xsystem_die(void)
{
	xsystem("false");
	warn("not reached\n");
	return MU_PASS;
}


int main(int argc, char *argv[])
{
	mu_init(argc, argv);
    mu_run_test(MU_FAIL, test_warn_die);
    mu_run_test(MU_PASS, test_log);
    mu_run_test(MU_PASS, test_check);
    mu_run_test(MU_FAIL, test_check_int_die);
    mu_run_test(MU_FAIL, test_check_ptr_die);
    mu_run_test(MU_PASS, test_check_mem);
    mu_run_test(MU_FAIL, test_check_mem_die);
    mu_run_test(MU_PASS, test_check_node);
    mu_run_test(MU_FAIL, test_check_node_die);
    mu_run_test(MU_PASS, test_check_debug);
    mu_run_test(MU_PASS, test_sentinel);
    mu_run_test(MU_FAIL, test_sentinel_die);
	mu_run_test(MU_PASS, test_stack);
	mu_run_test(MU_FAIL, test_stack_overflow);
	mu_run_test(MU_FAIL, test_stack_underflow);
	mu_run_test(MU_PASS, test_xatexit);
	mu_run_test(MU_FAIL, test_xatexit_die);
	mu_run_test(MU_PASS, test_xfopen);
	mu_run_test(MU_FAIL, test_xfopen_die);
	mu_run_test(MU_FAIL, test_xfclose_die);
	mu_run_test(MU_PASS, test_xfputs);
	mu_run_test(MU_FAIL, test_xfputs_die);
	mu_run_test(MU_PASS, test_xremove);
	mu_run_test(MU_FAIL, test_xremove_die);
	mu_run_test(MU_PASS, test_xsystem);
	mu_run_test(MU_FAIL, test_xsystem_die);
	mu_fini();
}
