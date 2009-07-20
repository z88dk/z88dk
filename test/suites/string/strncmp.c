

#include "string_tests.h"



void strncmp_equal()
{
    Assert(strncmp("equal","equal",5) == 0, "Should be == 0");
}

void strncmp_equal_length()
{
    Assert(strncmp("equal","equalbar",5) == 0, "Should be == 0");
}


void strncmp_less()
{
    Assert(strncmp("equal","notequal",5) < 0, "Should be < 0");
}

void strncmp_greater()
{
    Assert(strncmp("equal","EQUAL",5) > 0, "Should be > 0");
}


int test_strncmp()
{
    suite_setup("Strncmp Tests");

    suite_add_test(strncmp_equal);
    suite_add_test(strncmp_equal_length);
    suite_add_test(strncmp_less);
    suite_add_test(strncmp_greater);

    return suite_run();
}
