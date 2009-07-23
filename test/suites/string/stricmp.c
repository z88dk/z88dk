




#include "string_tests.h"



void stricmp_equal_lower()
{
    Assert(stricmp("equal","equal") == 0, "Should be == 0");
}

void stricmp_equal_upper()
{
    Assert(stricmp("EQUAL","EQUAL") == 0, "Should be == 0");
}

void stricmp_equal_mixed()
{
    Assert(stricmp("EqUaL","eQuAl") == 0, "Should be == 0");
}

void stricmp_less()
{
    Assert(stricmp("EQUAL","equam") < 0, "Should be < 0");
}

void stricmp_greater()
{
    Assert(stricmp("equal","EQUAM") > 0, "Should be > 0");
}


int test_stricmp()
{
    suite_setup("Stricmp Tests");

    suite_add_test(stricmp_equal_lower);
    suite_add_test(stricmp_equal_upper);
    suite_add_test(stricmp_equal_mixed);
    suite_add_test(stricmp_less);
    suite_add_test(stricmp_greater);

    return suite_run();
}
