#include "test.h"
#include <float.h>
#include <math.h>

void test_float_limits(void)
{
    Assert(FLT_MANT_DIG > 0, "FLT_MANT_DIG > 0");
    Assert(DBL_MANT_DIG > 0, "DBL_MANT_DIG > 0");
    Assert(FLT_RADIX == 2, "FLT_RADIX == 2");
    Assert(INFINITY > 0, "INFINITY > 0");
    Assert(HUGE_VAL > 0, "HUGE_VAL > 0");
}

int suite_float_limits(void)
{
    suite_setup("float limits Tests");
    suite_add_test(test_float_limits);
    return suite_run();
}

int main(void)
{
    return suite_float_limits();
}
