/*
Z88DK Z80 Macro Assembler

Unit test library

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "dbg.h"
#include "testlib.h"
#include <assert.h>
#include <stdlib.h>

#ifdef _MSC_VER
#define snprintf _snprintf
#endif

/*-----------------------------------------------------------------------------
*   Global test state
*----------------------------------------------------------------------------*/
static int g_test_result = 0;		/* global test result */
static int g_nr_tests_run = 0;		/* count number of tests run */
static char *g_run_test = NULL;		/* name of test to run, NULL to run all */
static char *g_progname = NULL;		/* program name */

/*-----------------------------------------------------------------------------
*	Recurse to a new process to run one test, show error result on stderr
*	Return 0 if OK
*----------------------------------------------------------------------------*/
static int exec_test(int expect_result, char *test_name)
{
	char cmdline[FILENAME_MAX];
	int result;

	assert(g_progname);

	snprintf(cmdline, sizeof(cmdline), "%s %s", g_progname, test_name);
	warn("\n> Run %s\n\n", test_name);
	
	fflush(stdout);	fflush(stderr);
	result = system(cmdline);
	fflush(stdout);	fflush(stderr);

	warn("\n> Exit: %d\n", result ? 1 : 0);

	return !!result != !!expect_result;
}

/*-----------------------------------------------------------------------------
*   Setup to run all tests or the one given on the command line
*----------------------------------------------------------------------------*/
void init_tests(int argc, char *argv[])
{
	g_progname = argv[0];
	g_test_result = 0;
	g_nr_tests_run = 0;

	if (argc == 1) {
		g_run_test = NULL;
	}
	else if (argc == 2) {
		g_run_test = argv[1];
	}
	else {
		die("Usage: %s [test_name]\n", g_progname);
	}
}

/*-----------------------------------------------------------------------------
*	If g_run_test defined, run test in a subprocess
*	If g_run_test is NULL, run test callback only if test name matches
*	Set g_test_result to 1 if test did not return 0
*----------------------------------------------------------------------------*/
void run_test_(int expect_result, char *test_name, test_cb test_func)
{
	int result = 0;

	if (g_run_test == NULL) {	/* no command line arguments, run all tests */
		result = exec_test(expect_result, test_name);
		g_nr_tests_run++;
	}
	else if (strcmp(g_run_test, test_name) == 0) {	/* test name in command line, 
													   call test_func if test matches */
		result = test_func();
		g_nr_tests_run++;
	}
	else {
		;						/* test does not match, skipped */
	}

	if (result != 0) {
		g_test_result = 1;
	}
}

/*-----------------------------------------------------------------------------
*	Return test results, return 0 if all tests returned 0
*----------------------------------------------------------------------------*/
int test_result(void)
{
	if (g_nr_tests_run < 1) {
		warn("No tests found.\n");
	}
	
	if (g_test_result != 0) {
		warn("Tests failed.\n");
	}

	return g_test_result || g_nr_tests_run < 1;
}
