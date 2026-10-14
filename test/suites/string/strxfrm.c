

#include "string_tests.h"

#asm
PUBLIC __lc_char_ordinal
EXTERN l_ret
defc __lc_char_ordinal = l_ret
#endasm

static char buf[8];


void strxfrm_limits()
{
    memset(buf, 'Z', 8);
    Assert(strxfrm(buf, "hello", 1) == 5, "n == 1 should still return strlen");
    Assert(buf[0] == 0 && buf[1] == 'Z', "n == 1 should write only NUL");

    memset(buf, 'Z', 8);
    Assert(strxfrm(buf, "hello", 5) == 5, "Truncation should return strlen");
    Assert(buf[0] == 'h' && buf[1] == 'e' && buf[2] == 'l' && buf[3] == 'l', "Should keep n-1 chars");
    Assert(buf[4] == 0 && buf[5] == 'Z', "NUL must stay inside n");

    memset(buf, 'Z', 8);
    Assert(strxfrm(buf, "hello", 6) == 5, "Exact fit should return strlen");
    Assert(strcmp(buf, "hello") == 0, "Exact fit should copy the string");
    Assert(buf[6] == 'Z', "Exact fit wrote past n");

    memset(buf, 'Z', 8);
    Assert(strxfrm(buf, "", 1) == 0, "Empty source should return 0");
    Assert(buf[0] == 0 && buf[1] == 'Z', "Empty source should write one NUL");
}


int test_strxfrm()
{
    suite_setup("Strxfrm Tests");
    suite_add_test(strxfrm_limits);

    return suite_run();
}
