#ifdef __TESTTARGET__
#ifdef __Z80

#include "far_tests.h"

static int (*func)(const char *__far x,const  char *__far y) __smallc;

static void stricmp_equal_lower()
{
    Assert(func("equal","equal") == 0, "Should be == 0");
}

static void stricmp_equal_upper()
{
    Assert(func("EQUAL","EQUAL") == 0, "Should be == 0");
}

static void stricmp_equal_mixed()
{
    Assert(func("EqUaL","eQuAl") == 0, "Should be == 0");
}

static void stricmp_less()
{
    Assert(func("EQUAL","equam") < 0, "Should be < 0");
}

static void stricmp_greater()
{
    Assert(func("equam","EQUAL") > 0, "Should be > 0");
}

int test_strcasecmpf()
{
    suite_setup("Strcasecmpf (far) Tests");

    func = strcasecmpf;

    suite_add_test(stricmp_equal_lower);
    suite_add_test(stricmp_equal_upper);
    suite_add_test(stricmp_equal_mixed);
    suite_add_test(stricmp_less);
    suite_add_test(stricmp_greater);

    return suite_run();
}
#endif
#endif
