

#include "string_tests.h"


static char buf[8];


void stpncpy_pads()
{
    char *p;

    memset(buf, 'Z', 8);
    p = stpncpy(buf, "ab", 4);

    Assert(p == buf + 2, "Should point at the first NUL");
    Assert(buf[0] == 'a' && buf[1] == 'b', "Should copy the source");
    Assert(buf[2] == 0 && buf[3] == 0, "Should pad with NUL inside n");
    Assert(buf[4] == 'Z', "Should not write past n");
}


void stpncpy_no_nul()
{
    char *p;

    memset(buf, 'Z', 8);
    p = stpncpy(buf, "abcd", 3);

    Assert(p == buf + 3, "Should point one past the copy");
    Assert(buf[0] == 'a' && buf[1] == 'b' && buf[2] == 'c', "Should copy n bytes");
    Assert(buf[3] == 'Z', "Wrote past n");
}


void stpncpy_empty_and_zero()
{
    char *p;

    memset(buf, 'Z', 8);
    p = stpncpy(buf, "", 1);
    Assert(p == buf, "Empty source should return dst");
    Assert(buf[0] == 0 && buf[1] == 'Z', "Should write one NUL");

    memset(buf, 'Z', 8);
    p = stpncpy(buf, "hi", 0);
    Assert(p == buf, "n == 0 should return dst");
    Assert(buf[0] == 'Z', "n == 0 should not write");
}


int test_stpncpy()
{
    suite_setup("Stpncpy Tests");
    suite_add_test(stpncpy_pads);
    suite_add_test(stpncpy_no_nul);
    suite_add_test(stpncpy_empty_and_zero);

    return suite_run();
}
