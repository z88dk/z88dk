




#include "stdlib_tests.h"



void abs_negative()
{
    Assert(abs(-30000) == 30000, "Should be == 30000");
}

void abs_small_negative()
{
    Assert(abs(-456) == 456, "Should be == 456");
}

void abs_zero()
{
    Assert(abs(0) == 0, "Should be == 0");
}

void abs_small_positive()
{
    Assert(abs(133) == 133, "Should be == 133");
}

void abs_positive()
{
    Assert(abs(30000) == 30000, "Should be == 30000");
}


int test_abs()
{
    suite_setup("abs() Tests");

    suite_add_test(abs_negative);
    suite_add_test(abs_small_negative);
    suite_add_test(abs_zero);
    suite_add_test(abs_positive);
    suite_add_test(abs_small_positive);

    return suite_run();
}
