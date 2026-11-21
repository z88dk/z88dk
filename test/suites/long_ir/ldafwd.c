/* A global byte tested and then stepped in the next block: the second load is
 * dropped when A still holds the first, but not across a loop head or a store.
 */
#include "test.h"

static unsigned char sel;

static int up(void)
{
    if (sel == 3) return 0;
    ++sel;
    return 1;
}

static int down(void)
{
    if (!sel) return 0;
    --sel;
    return 1;
}

static void bump(void) { sel = (unsigned char)(sel + 1); }

static int until5(void)
{
    int n = 0;
    while (sel != 5) {
        bump();
        ++n;
    }
    return n;
}

static void check(void)
{
    sel = 0;
    assertEqual(down(), 0);
    assertEqual(up(), 1);
    assertEqual(up(), 1);
    assertEqual(up(), 1);
    assertEqual(up(), 0);
    assertEqual(sel, 3);
    assertEqual(down(), 1);
    assertEqual(sel, 2);
    sel = 1;
    assertEqual(until5(), 4);
    assertEqual(sel, 5);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("second load of a tested global byte");
    suite_add_test(check);
    return suite_run();
}
