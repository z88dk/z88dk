

#include <stdio.h>
#include <string.h>
#include "test.h"

#pragma output CLIB_OPT_PRINTF=0x7fffffff

struct sprintf_test {
    char *pattern;
    char *result;
} stests[] = {
    { "%s", "HelloWorld" },
    { "%.3s", "Hel" },
    { "%20s",  "          HelloWorld" },
    { "%-20s", "HelloWorld          " },
    { NULL, NULL }
};

void test_sprintf_s()
{
    char    buf[100];
    struct sprintf_test *test = &stests[0];
    char   *teststr = "HelloWorld";

    while ( test->pattern != NULL ) {
       sprintf(buf,test->pattern, teststr);
       printf("Testing <%s> expect <%s> got <%s>\n",test->pattern, test->result,buf);
       Assert(strcmp(buf, test->result) == 0, "Result didn't match");
       ++test;
    }
}
struct sprintf_test dtests_positive[] = {
    { "%d", "233" },
    { "%u", "233" },
    { "%x", "e9" },
    { "%#x", "0xe9" },
    { "%X", "E9" },
    { "%#X", "0XE9" },
    { "%o", "351" },
    { "%#o", "0351" },
    { "%B", "11101001" },
    { "%10d", "       233" },
    { "%10X", "        E9" },
    { "%+B", "11101001" },   // Undefined behaviour
    { "%+X", "E9" },   // Undefined behaviour
    { "%-10d", "233       " },
    { "%+-10d", "+233      " },
    { "% -10d", " 233      " },
    { "%10.1d", "       233" },
    { NULL, 0 }
};
void test_sprintf_int()
{
    char    buf[100];
    struct sprintf_test *test = &dtests_positive[0];

    while ( test->pattern != NULL ) {
       sprintf(buf,test->pattern, 233);
       printf("Testing <%s> expect <%s> got <%s>\n",test->pattern, test->result,buf);
       Assert(strcmp(buf, test->result) == 0, "Result didn't match");
       ++test;
    }
}
struct sprintf_test dtests_negative[] = {
    { "%d", "-233" },
    { "%u", "65303" },
    { "%x", "ff17" },
    { "%X", "FF17" },
    { "%o", "177427" },
    { "%B", "1111111100010111" },
    { "%10d", "      -233" },
    { "%10X", "      FF17" },
    { "%+B", "1111111100010111" }, // Undefined behaviour
    { "%+X", "FF17" }, // Undefined behaviour
    { "%+u", "+65303" }, 
    { "%-10d", "-233      " },
    { "%+-10d", "-233      " },
    { "% -10d", "-233      " },
    { "%10.1d", "      -233" },
    { NULL, 0 }
};
void test_sprintf_int_negative()
{
    char    buf[100];
    struct sprintf_test *test = &dtests_negative[0];

    while ( test->pattern != NULL ) {
       sprintf(buf,test->pattern, -233);
       printf("Testing <%s> expect <%s> got <%s>\n",test->pattern, test->result,buf);
       Assert(strcmp(buf, test->result) == 0, "Result didn't match");
       ++test;
    }
}

struct sprintf_test ltests_positive[] = {
    { "%ld", "233000" },
    { "%lx", "38e28" },
    { "%lX", "38E28" },
    { "%lo", "707050" },
    { "%lB", "111000111000101000" },
    { "%10ld", "    233000" },
    { "%10lX", "     38E28" },
    { "%+lB", "111000111000101000" },   // Undefined behaviour
    { "%+lX", "38E28" },   // Undefined behaviour
    { "%-10ld", "233000    " },
    { "%+-10ld", "+233000   " },
    { "% -10ld", " 233000   " },
    { "%10.1ld", "    233000" },
    { NULL, 0 }
};
void test_sprintf_long_positive()
{
    char    buf[100];
    struct sprintf_test *test = &ltests_positive[0];

    while ( test->pattern != NULL ) {
       sprintf(buf,test->pattern, 233000L);
       printf("Testing <%s> expect <%s> got <%s>\n",test->pattern, test->result,buf);
       Assert(strcmp(buf, test->result) == 0, "Result didn't match");
       ++test;
    }
}
struct sprintf_test double_tests[] = {
    { "%f", "1.234500" },
    { "% f", "1.234500" }, // This is wrong, should have leading space
    { "%0f", "1.234500" },
    { "%e", "1.234500e0" },
    { "%.3f", "1.235" },
    { "%10.3f",  "     1.235" },
    { "%-10.3f", "1.235     " },
    { NULL, NULL }
};

void test_sprintf_double()
{
    char    buf[100];
    struct sprintf_test *test = &double_tests[0];

    while ( test->pattern != NULL ) {
       sprintf(buf,test->pattern, 1.2345);
       printf("Testing <%s> expect <%s> got <%s>\n",test->pattern, test->result,buf);
       Assert(strcmp(buf, test->result) == 0, "Result didn't match");
       ++test;
    }
}

void test_sprintf_precision_parameter()
{
    char buf[100];

    sprintf(buf,"%.*s", 2, "Hello");

    Assert(strcmp(buf,"He") == 0, "Precision parameter not picked up");
}

void test_sprintf_n()
{
    char buf[100];
    int  val, val2;

    sprintf(buf,"%n%s%n",&val, "Hello",&val2);

    Assert(val == 0, "First %n should be 0");
    Assert(val2 == 5, "Second %n should be 5");
}

int test_scanf()
{
    suite_setup("Sprintf Tests");

    suite_add_test(test_sprintf_s);
    suite_add_test(test_sprintf_int);
    suite_add_test(test_sprintf_int_negative);
    suite_add_test(test_sprintf_long_positive);
    suite_add_test(test_sprintf_double);
    suite_add_test(test_sprintf_precision_parameter);
    suite_add_test(test_sprintf_n);

    return suite_run();
}

int main(int argc, char *argv[])
{
    int  res = 0;

    res += test_scanf();

    return res;
}
