

#include <stdio.h>
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
    { "%x", "e9" },
    { "%X", "E9" },
    { "%o", "351" },
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
    { "%x", "ff17" },
    { "%X", "FF17" },
    { "%o", "177427" },
    { "%B", "1111111100010111" },
    { "%10d", "      -233" },
    { "%10X", "      FF17" },
    { "%+B", "1111111100010111" }, // Undefined behaviour
    { "%+X", "FF17" }, // Undefined behaviour
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


int test_scanf()
{
    suite_setup("Sprintf Tests");

    suite_add_test(test_sprintf_s);
    suite_add_test(test_sprintf_int);
    suite_add_test(test_sprintf_int_negative);

    return suite_run();
}

int main(int argc, char *argv[])
{
    int  res = 0;

    res += test_scanf();

    return res;
}
