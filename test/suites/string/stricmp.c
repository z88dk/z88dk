




#include "string_tests.h"

#ifdef SCCZ80
static int (*func)();
#else
static int (*func)(char *x, char *y);
#endif

void stricmp_equal_lower()
{
    Assert(func("equal","equal") == 0, "Should be == 0");
}

void stricmp_equal_upper()
{
    Assert(func("EQUAL","EQUAL") == 0, "Should be == 0");
}

void stricmp_equal_mixed()
{
    Assert(func("EqUaL","eQuAl") == 0, "Should be == 0");
}

void stricmp_less()
{
    Assert(func("EQUAL","equam") < 0, "Should be < 0");
}

void stricmp_greater()
{
    Assert(func("equal","EQUAM") > 0, "Should be > 0");
}


int test_stricmp()
{
    suite_setup("Stricmp Tests");

    func = stricmp;

    suite_add_test(stricmp_equal_lower);
    suite_add_test(stricmp_equal_upper);
    suite_add_test(stricmp_equal_mixed);
    suite_add_test(stricmp_less);
    suite_add_test(stricmp_greater);

    return suite_run();
}

int test_strcasecmp()
{
    suite_setup("Strcasecmp Tests");

    func = strcasecmp;

    suite_add_test(stricmp_equal_lower);
    suite_add_test(stricmp_equal_upper);
    suite_add_test(stricmp_equal_mixed);
    suite_add_test(stricmp_less);
    suite_add_test(stricmp_greater);

    return suite_run();
}
