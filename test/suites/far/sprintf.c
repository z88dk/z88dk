

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "test.h"


#pragma output CLIB_OPT_PRINTF=0x7fffffff


struct sprintf_test {
    char *pattern;
    char *result;
} stests[] = {
    { "%S", "HelloWorld" },
    { "%.3S", "Hel" },
    { "%20S",  "          HelloWorld" },
    { "%-20S", "HelloWorld          " },
    { NULL, NULL }
};

void test_sprintf_near_string()
{
    char    buf[100];
    struct sprintf_test *test = &stests[0];
    char   *teststr = "HelloWorld";

    while ( test->pattern != NULL ) {
       sprintf(buf,test->pattern, (char *__far)teststr);
       printf("Testing <%s> expect <%s> got <%s>\n",test->pattern, test->result,buf);
       Assert(strcmp(buf, test->result) == 0, "Result didn't match");
       ++test;
    }
}


void test_sprintf_far_string()
{
    char    buf[100];
    struct sprintf_test *test = &stests[0];
    char   *__far teststr = strdupf("HelloWorld");

    while ( test->pattern != NULL ) {
       sprintf(buf,test->pattern, teststr);
       printf("Testing <%s> expect <%s> got <%s>\n",test->pattern, test->result,buf);
       Assert(strcmp(buf, test->result) == 0, "Result didn't match");
       ++test;
    }
}

void test_sprintff_s()
{
    char   *__far buf = malloc_far(100);
    struct sprintf_test *test = &stests[0];
    char   *__far teststr = strdupf("HelloWorld");

    while ( test->pattern != NULL ) {
       snprintff(buf,100,test->pattern, teststr);
       printf("Testing <%s> expect <%s> got <%s>\n",test->pattern, test->result,buf);
       Assert(strcmpf(buf, test->result) == 0, "Result didn't match");
       ++test;
    }
}



int test_sprintf()
{
    suite_setup("Sprintf (far) Tests");

    suite_add_test(test_sprintf_near_string);
    suite_add_test(test_sprintf_far_string);
    suite_add_test(test_sprintff_s);

    return suite_run();
}

