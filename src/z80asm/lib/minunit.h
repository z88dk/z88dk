/*
Z88DK Z80 Macro Assembler

Unit tests. 

Based on Learn C the Hard Way book, by Zed. A. Shaw (http://c.learncodethehardway.org/book/)
*/

#pragma once

#undef NDEBUG

#include "dbg.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*-----------------------------------------------------------------------------
*   Constants for test results, 0 is TRUE to match process exit codes
*----------------------------------------------------------------------------*/
#define MU_PASS		0
#define MU_FAIL		1

/*-----------------------------------------------------------------------------
*   Type for test functions. 
*	Each test function is run in a separate sub-process.
*----------------------------------------------------------------------------*/
typedef int (*test_cb_t)(void);	/* return MU_PASS if OK, MU_FAIL if FAILED */

/*-----------------------------------------------------------------------------
*   Unit test API
*----------------------------------------------------------------------------*/

/* prepare to run test given in command line, or to run all tests if no arguments */
#define     mu_init(argc, argv) mu_init_(__FILE__, argc, argv)
extern void mu_init_(char *file, int argc, char *argv[]);

/* finish main(), return MU_PASS on no error, include error: label for error catching */
#define mu_fini() \
			do { \
				int rc = mu_compare_ans(); \
				check( rc == MU_PASS, "DIFFERENT OUTPUT" ); \
				rc = mu_fini_(); \
				check( rc == MU_PASS, "TESTS FAILED" ); \
				return MU_PASS; \
			} while (0); \
			error: \
				return MU_FAIL
extern int mu_fini_(void);
extern int mu_compare_ans(void);

/* run test_name in a subprocess */
#define    mu_run_test(exp_exit, func) \
				do { \
					if ( mu_run_test_(exp_exit, #func, func) != MU_PASS ) { \
						log_err("Test %s FAILED", #func ); \
						return MU_FAIL; \
					} \
				} while (0)
extern int mu_run_test_(int exp_exit, char *test_name, test_cb_t test_func);

/* check, fail test if false */
#define mu_assert(test, message, ...) \
				do { \
					if ( ! (test) ) { \
					log_err(message, ##__VA_ARGS__); \
						return MU_FAIL; \
					} \
				} while (0)

/* compare two ints and strings */
#define __mu_str__(a) #a
#define mu_assert_int(a, cmp_op, b)	\
			mu_assert((a) cmp_op (b), \
					  "test %s %s %s failed, %s = %d, %s = %d", \
					  __mu_str__(a), __mu_str__(cmp_op), __mu_str__(b), \
					  __mu_str__(a), (int)(a), __mu_str__(b), (int)(b) ) 

#define mu_assert_str(a, cmp_op, b)	\
			mu_assert(strcmp((a), (b)) cmp_op 0, \
					  "test %s %s %s failed, %s = %d, %s = %d", \
					  __mu_str__(a), __mu_str__(cmp_op), __mu_str__(b), \
					  __mu_str__(a), (int)(a), __mu_str__(b), (int)(b) ) 

#define mu_assert_ptr(p) \
			mu_assert( (p) != NULL, \
					  "test %s != NULL failed", \
					  __mu_str__(p) )

#define mu_assert_ptr_null(p) \
			mu_assert( (p) == NULL, \
					  "test %s == NULL failed", \
					  __mu_str__(p) )
