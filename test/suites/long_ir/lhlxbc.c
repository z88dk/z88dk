/* [lhlx-bc] 8085 reload of a BC-homed word.
 *
 * The fill is `ld hl,N; add hl,sp; ld c,(hl); inc hl; ld b,(hl)` and the
 * first use copies it back with `ld hl,bc`. On the 8085 that becomes
 * `ld de,sp+N; ld hl,(de); ld bc,hl` when DE and F are dead after
 * the copy. The value must survive: a wrong walk reads the adjacent slot.
 *
 * keep (gate off) and 8080 (no LHLX) must return the same numbers.
 */
#include "test.h"

static unsigned g_sink;

static unsigned add_sink(unsigned x)
{
    g_sink += x;
    return x;
}

/* Two uses of p, with a call on the null arm only. That is the shape that
   homes p in BC and then copies it to HL for p[1]. */
static unsigned pick(unsigned *p)
{
    if (p[1] == 0)
        return add_sink(1);
    return add_sink(p[1]);
}

static unsigned both(unsigned *p)
{
    unsigned x = p[1];
    unsigned y = p[2];
    if (x == 0)
        return add_sink(y);
    return add_sink(x + y);
}

void test_lhlxbc(void)
{
    unsigned a[4];

    g_sink = 0;
    a[0] = 9;
    a[1] = 0;
    a[2] = 4;
    a[3] = 11;
    assertEqual(pick(a), 1u);
    a[1] = 7;
    assertEqual(pick(a), 7u);
    a[1] = 0;
    assertEqual(both(a), 4u);
    a[1] = 3;
    assertEqual(both(a), 7u);
    assertEqual(g_sink, 19u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("8085 LHLX reload into BC");
    suite_add_test(test_lhlxbc);
    return suite_run();
}
