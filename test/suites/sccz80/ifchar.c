#include "test.h"
#include <stdio.h>
#include <stdlib.h>

/*
 * Char returns live in L. H is not part of the value (hand asm leaves it
 * dirty; carry may be set). if (fn()), !fn(), and == 0 must not test H.
 * Linked with ifchar_ret.asm for both sccz80 and 80cc.
 */

extern unsigned char char_ret_l0_hjunk(void);
extern unsigned char char_ret_l1_hjunk(void);

static unsigned char g0(void) { return 0; }
static unsigned char g1(void) { return 1; }

void test_if_char_return_ignores_h(void)
{
    int taken;

    taken = 0;
    if (char_ret_l0_hjunk())
        taken = 1;
    Assert(taken == 0, "if (L=0) must be false when H is dirty");

    taken = 0;
    if (char_ret_l1_hjunk())
        taken = 1;
    Assert(taken == 1, "if (L=1) must be true when H is dirty");

    taken = 0;
    if (char_ret_l0_hjunk() == 0)
        taken = 1;
    Assert(taken == 1, "L=0 == 0");

    taken = 0;
    if (!char_ret_l0_hjunk())
        taken = 1;
    Assert(taken == 1, "! (L=0) must be true when H is dirty");

    taken = 0;
    if (!char_ret_l1_hjunk())
        taken = 1;
    Assert(taken == 0, "! (L=1) must be false when H is dirty");
}

void test_if_char_c_return(void)
{
    int taken;

    taken = 0;
    if (g0())
        taken = 1;
    Assert(taken == 0, "if (c_fn returning 0)");

    taken = 0;
    if (g1())
        taken = 1;
    Assert(taken == 1, "if (c_fn returning 1)");
}

int suite_ifchar(void)
{
    suite_setup("Char if() Tests");
    suite_add_test(test_if_char_return_ignores_h);
    suite_add_test(test_if_char_c_return);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_ifchar();
    exit(res);
}
