

#include "string_tests.h"


/* The Intel loop used to increment the first byte instead of the pointer. */
void strnlen_leaves_string()
{
    char buf[8];

    strcpy(buf, "abc");

    Assert(strnlen(buf, 2) == 2, "Should stop at maxlen");
    Assert(strcmp(buf, "abc") == 0, "strnlen wrote the string");
    Assert(strnlen(buf, 10) == 3, "Should be the string length");
    Assert(strnlen("", 5) == 0, "Empty string should be 0");
    Assert(strnlen("abc", 0) == 0, "maxlen 0 should be 0");
}


int test_strnlen()
{
    suite_setup("Strnlen Tests");
    suite_add_test(strnlen_leaves_string);

    return suite_run();
}
