#include "test.h"
#include <stdbool.h>

void test_stdbool_definitions(void)
{
    bool b_true = true;
    bool b_false = false;

    Assert(b_true == 1, "true is 1");
    Assert(b_false == 0, "false is 0");
    Assert(sizeof(bool) >= 1, "sizeof(bool) >= 1");
    Assert(__bool_true_false_are_defined == 1, "__bool_true_false_are_defined is 1");
}

int suite_stdbool(void)
{
    suite_setup("stdbool Tests");
    suite_add_test(test_stdbool_definitions);
    return suite_run();
}

int main(void)
{
    return suite_stdbool();
}
