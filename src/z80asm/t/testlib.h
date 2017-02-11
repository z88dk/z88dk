/*
Z88DK Z80 Macro Assembler

Unit test library

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

typedef int (*test_cb)(void);	/* return 0 if OK */

/* prepare to run test given in command line, or to run all tests if no arguments */
extern void init_tests(int argc, char *argv[]);

/* run test_name */
extern void run_test_(int expect_result, char *test_name, test_cb test_func);
#define     run_test(expect_result, func) run_test_(expect_result, #func, func)

/* return 0 if all tests returned 0 */
extern int test_result(void);

/* check results, fail test if wrong (return 1) */
#define check_int(result,eq,expect) \
				do { \
					int res = (int)result; \
					if ( ! (res eq (int)expect) ) { \
						warn("(%s(%d) %s) %s, failed %d %s %d\n", \
							 __FILE__, __LINE__, __FUNCTION__, \
							 #result, res, #eq, (int)expect); \
						return 1; \
					} \
				} while (0)

#define check_str(result,eq,expect) \
				do { \
					if ( ! (strcmp(result, expect) eq 0) ) { \
						warn("(%s(%d) %s) failed %s %s %s\n", \
							 __FILE__, __LINE__, __FUNCTION__, \
							 #result, #eq, #expect); \
						return 1; \
					} \
				} while (0)
