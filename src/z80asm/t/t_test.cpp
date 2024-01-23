//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "test.h"

void test_diag() {
	DIAG("hello world");
}

void test_ok() {
	OK(true);
}

void test_nok() {
	NOK(false);
}

void test_is_() {
	IS(2, 2);
}

void test_isnt_() {
	ISNT(2, 3);
}

void test_str_is_() {
	STR_IS("hello", "hello");
	STR_IS("hello\n", "hello\n");
	STR_IS("hello\n", "hello\r");
	STR_IS("hello\n", "hello\r\n");
}

void test_str_like_() {
	STR_LIKE(" 23\n", "^\\s*\\d+\\s*$");
}

void test_exec_() {
	RUN_OK("exec_test_1");
	RUN_NOK("exec_test_2");
	
	RUN_OK("exec_test_3");
	STR_IS(test_exec_out, "hello\n");
	STR_IS(test_exec_err, "");
	
	RUN_OK("exec_test_4");
	STR_IS(test_exec_out, "");
	STR_IS(test_exec_err, "hello\n");
}

int exec_test_1() {
	return EXIT_SUCCESS;
}

int exec_test_2() {
	return EXIT_FAILURE;
}

int exec_test_3() {
	cout << "hello" << endl;
	return EXIT_SUCCESS;
}

int exec_test_4() {
	cerr << "hello" << endl;
	return EXIT_SUCCESS;
}
