/*
Z88DK Z80 Macro Assembler

Unit tests. 

Based on Learn C the Hard Way book, by Zed. A. Shaw (http://c.learncodethehardway.org/book/)
*/

#include "minunit.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _MSC_VER
#define snprintf _snprintf
#endif

/*-----------------------------------------------------------------------------
*   Global test state
*----------------------------------------------------------------------------*/
static int   g_test_result  = 0;			/* global test result */
static int   g_nr_tests_run = 0;			/* count number of tests run */
static char *g_run_test = NULL;				/* name of test to run, NULL to run all */
static char *g_progname = NULL;				/* program name */
static char  g_out_filename[FILENAME_MAX];	/* output file */
static char  g_ans_filename[FILENAME_MAX];	/* benchmark file to compare output */

/*-----------------------------------------------------------------------------
*	Recurse to a new process to run one test
*----------------------------------------------------------------------------*/
static int exec_test(int exp_exit, char *test_name)
{
	char cmdline[FILENAME_MAX];
	int result;

	check(g_progname, "program name not defined");
	check(test_name,  "test name not defined");

	result = snprintf(cmdline, sizeof(cmdline), "%s %s", g_progname, test_name);
	check( result > 0 && result < (int)sizeof(cmdline), 
		   "not enough space to store command line, result=%d", result);
	
	fflush(stdout);	fflush(stderr);
	result = system(cmdline);

	return !!result != !!exp_exit;

error:
	return MU_FAIL;
}

/*-----------------------------------------------------------------------------
*	Build filename based on given file, less ext_size, with new extension
*----------------------------------------------------------------------------*/
static char *build_filename( char *dest, char *src_file, char *new_ext )
{
	char *p;
	
	check( strlen(src_file) + strlen(new_ext) < FILENAME_MAX,
		   "not enough space to build filename, dest_size=%d, src=%s, ext=%s",
		   FILENAME_MAX, src_file, new_ext );
	
	strcpy( dest, src_file );
	
	/* find '.', alpha* */
	p = dest + strlen(dest);
	while ( p > dest && isalnum(p[-1]) )
		p--;
	if ( p > dest && p[-1] == '.' )
		p--;
		
	strcpy( p, new_ext );
	
	return dest;
	
error:
	return NULL;
}

/*-----------------------------------------------------------------------------
*   Setup to run all tests or the one given on the command line
*----------------------------------------------------------------------------*/
void mu_init_(char *file, int argc, char *argv[])
{
	char *str_rc;
	int   int_rc;

	g_progname = argv[0];
	g_test_result = MU_PASS;
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

	/* prepare for mu_capture_stderr() tests */
	str_rc = build_filename( g_out_filename, file, ".out" );
	check( str_rc, "build .out file failed");
	if ( g_run_test == NULL ) {		/* run all tests, remove .out file first */
		int_rc = remove( g_out_filename );
		check( int_rc == 0 || errno == ENOENT, 
			   "remove file %s failed", g_out_filename );
	}

	str_rc = build_filename( g_ans_filename, file, ".ans" );
	check( str_rc, "build .ans file failed");

	return;

error:
	die("Cannot start %s\n", g_progname );
}

/*-----------------------------------------------------------------------------
*	If g_run_test defined, run test in a subprocess
*	If g_run_test is NULL, run test callback only if test name matches
*	Set g_test_result to MU_FAIL if test did not return MU_PASS
*----------------------------------------------------------------------------*/
int mu_run_test_(int exp_exit, char *test_name, test_cb_t test_func)
{
	FILE *out_file;

	int result = MU_PASS;

	if (g_run_test == NULL) {	/* no command line arguments, run all tests */
		if ( exec_test(exp_exit, test_name) )
			result = MU_FAIL;

		g_nr_tests_run++;
	}
	else if (strcmp(g_run_test, test_name) == 0) {	/* test name in command line, 
													   call test_func if test matches */

		/* append output, as multiple tests can use the same .out file */
		out_file = freopen(g_out_filename, "a", stderr);
		check(out_file, "error opening %s file as stderr", g_out_filename);

		fprintf(out_file, "\n---------- Test: %s ----------\n", test_name);

		result = test_func();
		g_nr_tests_run++;
	}
	else {
		;						/* test does not match, skipped */
	}

	if (result != MU_PASS) {
		g_test_result = MU_FAIL;
	}

	return result;
	
error:
	return MU_FAIL;
}

/*-----------------------------------------------------------------------------
*	If testing all, and .out file exists, compare with BMK file
*	Return MU_PASS if OK
*----------------------------------------------------------------------------*/
int mu_compare_ans(void)
{
	FILE *ans_file = NULL, *out_file = NULL;
	int result = MU_FAIL;
	char buffer1[1024], buffer2[1024];
	int  read1, read2;

	if ( g_run_test != NULL )
		return MU_PASS;					/* not running all tests, don't check .out file */

	out_file = fopen( g_out_filename, "r" );
	if ( out_file == NULL && errno == ENOENT )
		return MU_PASS;					/* no .out file created */
	check( out_file, "cannot open file %s", g_out_filename );

	ans_file = fopen( g_ans_filename, "r" );
	check( ans_file, "cannot open file %s", g_ans_filename );

	do {
		read1 = fread( buffer1, 1, sizeof(buffer1), out_file );
		check( read1 >= 0, "error reading from %s", g_out_filename );

		read2 = fread( buffer2, 1, sizeof(buffer2), ans_file );
		check( read2 >= 0, "error reading from %s", g_ans_filename );

		check( read1 == read2 && memcmp(buffer1, buffer2, read1) == 0,
			   "compare files %s %s failed", g_ans_filename, g_out_filename );
	} while ( read1 > 0 );

	result = MU_PASS;		/* fall through */
error:
	if ( out_file != NULL )
		check( fclose( out_file ) == 0, 
			   "close file %s failed", g_out_filename );

	if ( ans_file != NULL )
		check( fclose( ans_file ) == 0, 
			   "close file %s failed", g_ans_filename );

	return result;
}

/*-----------------------------------------------------------------------------
*	Return test results, return MU_PASS if all tests returned MU_PASS
*	If testing all, and .out file exists, compare with BMK file
*----------------------------------------------------------------------------*/
int mu_fini_(void)
{
	check( g_nr_tests_run > 0, "No tests run" );

	if ( g_test_result != MU_PASS ) 
		return MU_FAIL;
	else 
		return MU_PASS;

error:
	return MU_FAIL;
}
