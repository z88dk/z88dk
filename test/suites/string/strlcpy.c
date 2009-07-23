




#include "string_tests.h"



void strlcpy_fits()
{
    char   buf[20];

    Assert(strlcpy(buf, "Last", sizeof(buf)) == 4, "Should be == 4");
    Assert(strcmp(buf, "Last") == 0, "Incorrect contents");
}

void strlcpy_short()
{
    char   buf[2];

    Assert(strlcpy(buf, "Last", sizeof(buf)) == 4, "Should be == 4");
    Assert(strcmp(buf, "L") == 0, "Incorrect contents");
}






int test_strlcpy()
{
    suite_setup("Strlcpy Tests");

    suite_add_test(strlcpy_fits);
    suite_add_test(strlcpy_short);

    return suite_run();
}
