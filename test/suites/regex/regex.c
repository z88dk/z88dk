

#include "test.h"
#include <stdio.h>
#include <regexp.h>
#include <malloc.h>

struct regex_test {
    char *pattern;
    char *test;
    int   result;
} tests[] = {
   { "abracadabra$", "abracadabracadabra", 1 },
   { "aBrAcAdAbRa$", "AbRaCaDaBrA", 0 },
   { "aBrAc",        "ABRA2abra3abrac", 0},
   { "a...b",        "abababbb", 1},
   { "XXXXXX",       "..XXXXXX", 1},
   { "^abc", "xa", 0 },
   { "^a", "ax", 1 }, 
   { "\\^a", "a^a", 1 },
   { "a\\^", "a^a", 1 },
   { "a$", "aa$", 0 },
   { "a$", "aa", 1 },
   { "a\\$", "aa", 0 },
   { "a\\$", "a$", 1 },
   { ".*", "abcdef", 1 },
   { NULL, NULL, 0}
};

long heap;

void test_simple_regex()
{
    struct regex_test *test = &tests[0];
    regexp   *re;
    int       result;

    while ( test->pattern != NULL ) {
        re = regcomp(test->pattern);
        printf("Testing <%s> against <%s> expect %d\n",test->pattern, test->test, test->result);
        Assert(re != NULL, "We should have compiled the pattern");
        result = regexec(re, test->test);
        Assert(result == test->result, "Result didn't match");
        free(re);
        ++test;
    }

}


int suite_genmath()
{
    suite_setup("Regex Tests");

    suite_add_test(test_simple_regex);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    sbrk(50000, 10000);

    res += suite_genmath();

    exit(res);
}
