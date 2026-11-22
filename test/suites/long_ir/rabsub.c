/* Word subtract on the Rabbit 2000/3000. `sub hl,de` is native only on the
 * Rabbit 4000 and later; on r2ka/r3k z80asm turns it into a helper call, so
 * 80cc must emit `and a; sbc hl,de/bc` there. The Makefile checks the asm; this
 * file checks the values, for the DE form and the subtrahend-in-BC form.
 */
#include "test.h"

unsigned int udiff(unsigned int a, unsigned int b) { return a - b; }

int sdiff(int k, int n)
{
    int i, s = 0;
    for (i = 0; i < n; i++)
        s += k - i;
    return s;
}

static int run(void)
{
    int bad = 0;
    if (udiff(100, 58) != 42) bad++;
    if (udiff(3, 5) != 0xfffe) bad++;
    if (udiff(0x8000, 1) != 0x7fff) bad++;
    if (sdiff(10, 4) != 34) bad++;
    if (sdiff(0, 3) != -3) bad++;
    if (sdiff(-5, 2) != -11) bad++;
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("word subtract without sub hl,de on r2ka");
    suite_add_test(check);
    return suite_run();
}
