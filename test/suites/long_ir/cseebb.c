/* An index chain computed before a branch is reused after it, but not when an
 * operand changes on the way, and not into a join reached from two blocks.
 */
#include "test.h"

typedef unsigned short u16;

static u16 tab[200];

static u16 idx(u16 r, u16 c) { return (u16)(((r - 6) * 5 + c) * 4 + (r - 6)); }

static int reuse(u16 r, u16 c, u16 key)
{
    u16 i = (u16)(((r - 6) * 5 + c) * 4 + (r - 6));

    if (tab[i] == key)
        return 0;
    tab[(u16)(((r - 6) * 5 + c) * 4 + (r - 6))] = key;
    return 1;
}

static int changed(u16 r, u16 c, u16 key)
{
    u16 i = (u16)(((r - 6) * 5 + c) * 4 + (r - 6));

    if (tab[i] == key)
        r = (u16)(r + 1);
    tab[(u16)(((r - 6) * 5 + c) * 4 + (r - 6))] = key + 1;
    return r;
}

static int join(u16 r, u16 c, u16 key, int f)
{
    u16 i = (u16)(((r - 6) * 5 + c) * 4 + (r - 6));

    if (f)
        key = (u16)(key + 2);
    if (tab[i] == key)
        return 0;
    tab[(u16)(((r - 6) * 5 + c) * 4 + (r - 6))] = key;
    return 1;
}

static u16 shortc(u16 a, u16 r, u16 c)
{
    u16 s = 0;

    if (a || tab[(u16)(((r - 6) * 5 + c) * 4 + (r - 6))] == 1)
        s = (u16)(((r - 6) * 5 + c) * 4 + (r - 6) + 7);
    return s;
}

static void check(void)
{
    int k;

    for (k = 0; k < 200; k++) tab[k] = 0;
    assertEqual(reuse(8, 3, 77), 1);
    assertEqual(tab[idx(8, 3)], 77);
    assertEqual(reuse(8, 3, 77), 0);
    tab[idx(9, 1)] = 5;
    assertEqual(changed(8, 3, 77), 9);
    assertEqual(tab[idx(9, 3)], 78);
    assertEqual(tab[idx(8, 3)], 77);
    tab[idx(7, 2)] = 5;
    assertEqual(changed(7, 2, 5), 8);
    assertEqual(tab[idx(8, 2)], 6);
    assertEqual(tab[idx(7, 2)], 5);
    for (k = 0; k < 200; k++) tab[k] = 0;
    assertEqual(join(8, 4, 10, 1), 1);
    assertEqual(tab[idx(8, 4)], 12);
    assertEqual(join(8, 4, 10, 1), 0);
    assertEqual(join(8, 4, 12, 0), 0);
    assertEqual(join(8, 4, 12, 1), 1);
    assertEqual(tab[idx(8, 4)], 14);
    for (k = 0; k < 200; k++) tab[k] = 0;
    assertEqual(shortc(1, 8, 3), idx(8, 3) + 7);
    assertEqual(shortc(0, 8, 3), 0);
    tab[idx(8, 3)] = 1;
    assertEqual(shortc(0, 8, 3), idx(8, 3) + 7);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("index chain shared across a branch");
    suite_add_test(check);
    return suite_run();
}
