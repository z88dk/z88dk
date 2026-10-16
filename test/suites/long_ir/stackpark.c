/* A word temp read more than once is parked on the stack and read back with
 * pop/push until its last reader; nested temps unwind in order. */
#include "test.h"

static unsigned int scratch(unsigned int seed)
{
    int loc[16];
    unsigned int acc = 0;
    int i;

    for (i = 0; i < 16; i++)
        loc[i] = (int)((seed + (unsigned int)i * 37u) & 0x3fffu);
    for (i = 0; i < 16; i++) {
        int k = (int)((seed >> (i & 7)) & 15u);
        acc = (unsigned int)(acc + (unsigned int)loc[k]);
        loc[k] = (loc[k] + i) & 0x3fff;
    }
    return acc & 0xffffu;
}

static unsigned int tab[16];

static unsigned int through_ptr(unsigned int *t, unsigned int k, unsigned int i)
{
    unsigned int old = t[k & 15];
    t[k & 15] = (old + i) ^ (old >> 3);
    return old + t[(k + 1) & 15];
}

static unsigned int three_deep(unsigned int *a, unsigned int *b, unsigned int j, unsigned int s)
{
    unsigned int x = a[j & 7];
    unsigned int y = b[(j + s) & 7];
    a[j & 7] = (x + y) ^ (x >> 1);
    b[(j + s) & 7] = (y << 1) + a[j & 7];
    return x + y + a[(j + 1) & 7];
}

static unsigned int twice_then_store(unsigned int *p, unsigned int n)
{
    unsigned int *q = p + (n & 7);
    unsigned int r = *q + n;
    *q = r;
    return r + *q + (r >> 2);
}

static void test_stackpark(void)
{
    unsigned int i, r = 0;
    unsigned int a[8], b[8];

    assertEqual(scratch(0x1234), 0x3195);
    assertEqual(scratch(1), 0x0236);
    assertEqual(scratch(0xffff), 0x24d0);

    for (i = 0; i < 16; i++) tab[i] = i * 11;
    for (i = 0; i < 40; i++) r += through_ptr(tab, i * 5, i);
    assertEqual(r, 0x1f2d);
    assertEqual(tab[3], 0x0065);
    assertEqual(tab[9], 0x0094);

    for (i = 0; i < 8; i++) { a[i] = i * 3 + 1; b[i] = i * 5 + 2; }
    r = 0;
    for (i = 0; i < 30; i++) r += three_deep(a, b, i, i * 3);
    assertEqual(r, 0x73cf);
    assertEqual(a[2], 0xff47);
    assertEqual(b[5], 0x001b);

    for (i = 0; i < 8; i++) a[i] = i;
    r = 0;
    for (i = 0; i < 20; i++) r += twice_then_store(a, i * 7);
    assertEqual(r, 0x10c0);
    assertEqual(a[4], 0x0074);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("stack-parked temps with several readers");
    suite_add_test(test_stackpark);
    return suite_run();
}
