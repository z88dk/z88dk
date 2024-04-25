#ifdef Z80

#include "string_tests.h"



void strcmpf_equal()
{
    Assert(strcmpf("equal","equal") == 0, "Should be == 0");
}

void strcmpf_less()
{
    Assert(strcmpf("equal","notequal") < 0, "Should be < 0");
}

void strcmpf_greater()
{
    Assert(strcmpf("equal","EQUAL") > 0, "Should be > 0");
}


int test_strcmpf()
{
    suite_setup("Strcmpf (far) Tests");

    suite_add_test(strcmpf_equal);
    suite_add_test(strcmpf_less);
    suite_add_test(strcmpf_greater);

    return suite_run();
}
#endif
