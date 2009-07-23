

#include "string_tests.h"



void strrev_empty()
{
    char   buf[10];
    buf[0] = 0;

    Assert(strrev(buf) == buf, "Expected to get buf back");
    Assert(strcmp(buf,"") == 0, "Incorrect reversal");
}

void strrev_one()
{
    char   buf[10];

    strcpy(buf,"A");

    Assert(strrev(buf) == buf, "Expected to get buf back");
    Assert(strcmp(buf,"A") == 0, "Incorrect reversal");
}

void strrev_two()
{
    char   buf[10];

    strcpy(buf,"AB");

    Assert(strrev(buf) == buf, "Expected to get buf back");
    Assert(strcmp(buf,"BA") == 0, "Incorrect reversal");
}

void strrev_odd()
{
    char   buf[10];

    strcpy(buf,"ABCDEFG");

    Assert(strrev(buf) == buf, "Expected to get buf back");
    Assert(strcmp(buf,"GFEDCBA") == 0, "Incorrect reversal");
}

void strrev_even()
{
    char   buf[10];

    strcpy(buf,"ABCDEF");

    Assert(strrev(buf) == buf, "Expected to get buf back");
    Assert(strcmp(buf,"FEDCBA") == 0, "Incorrect reversal");
}


int test_strrev()
{
    suite_setup("strrev Tests");
    suite_add_test(strrev_empty);
    suite_add_test(strrev_one);
    suite_add_test(strrev_two);
    suite_add_test(strrev_odd);
    suite_add_test(strrev_even);

    return suite_run();
}
