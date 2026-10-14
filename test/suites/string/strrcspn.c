

#include "string_tests.h"


void strrcspn_last_match()
{
    Assert(strrcspn("abXcdXz", "X") == 6, "Should include the last match");
    Assert(strrcspn("abXcdXz", "Q") == 0, "No match should return 0");
    Assert(strrcspn("abXcdXz", "") == 7, "Empty set should return strlen");
}


int test_strrcspn()
{
    suite_setup("Strrcspn Tests");
    suite_add_test(strrcspn_last_match);

    return suite_run();
}
