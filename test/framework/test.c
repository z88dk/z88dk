/*
 *  Test framework for z88dk library functions
 */

#include "test.h"

#include <setjmp.h>
#include <stdarg.h>
#include <stdio.h>

typedef struct {
    char     *name;
    char     *testnames[MAX_TESTS];
    void     *tests[MAX_TESTS];
    int       num_tests;
} Suite;


static Suite   suite;
static jmp_buf jmpbuf;
static char   *failed_message;
static char   *failed_file;
static int     failed_line;
static int     passed;
static int     failed;

void Assert_real(int result, char *file, int line, char *message)
{
    if ( result == 0 ) {
        failed_file = file;
        failed_line = line;
        failed_message = message;
        longjmp(jmpbuf, 1);
    }
}

int suite_run()
{
    int      i;
    void    (*func)();

    passed = failed = 0;

    printf("Starting suite %s (%d tests)\n",suite.name, suite.num_tests);

    for ( i = 0; i < suite.num_tests; i++ ) {
        if ( setjmp(jmpbuf) == 0 ) {
            printf("Running test %s..",suite.testnames[i]);
            func = suite.tests[i];
            func();
            printf("...passed\n");
            passed++;
        } else {
            printf("...failed %s:%d (%s)\n",failed_file, failed_line, failed_message);
            failed++;
        }
    }

    printf("%d run, %d passed, %d failed\n", suite.num_tests, passed, failed);

    return failed != 0;
}


void suite_setup(char *suitename)
{
    suite.name  = suitename;
    suite.num_tests = 0;
}


void suite_add_test_real(char *testname, void (*test)())
{
    int    i;
    
    i = suite.num_tests++;
    suite.testnames[i] = testname;
    suite.tests[i] = test;
}


