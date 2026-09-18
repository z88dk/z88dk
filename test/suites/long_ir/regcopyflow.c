/* [regcopy-flow] The GBZ80 store restores HL from DE just before the loop
 * back-edge. The loop header immediately reloads HL, so the restore is dead.
 * The keep target proves that the same source runs with the rule disabled.
 * `flow2` reads its result before returning and must still work.
 */
#include "test.h"

unsigned int flow(unsigned int n)
{
    unsigned int chk = 0;
    unsigned int i;
    for (i = 0; i < n; i++)
        chk = (unsigned int)(chk + i * 3u);
    return chk;
}

unsigned int flow2(unsigned int n)
{
    unsigned int x = 0;
    do { x += n; n--; } while (n);
    return x;
}

static void test_regcopyflow(void)
{
    assertEqual(flow(0), 0);
    assertEqual(flow(10), 135);
    assertEqual(flow(100), 14850);
    assertEqual(flow2(1), 1);
    assertEqual(flow2(5), 15);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("regcopy flow across a loop back-edge");
    suite_add_test(test_regcopyflow);
    return suite_run();
}
