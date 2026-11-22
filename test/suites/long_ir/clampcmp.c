/* Signed compares after a sign test: `if (v < 0) v = 0; if (v > K)` runs
 * unsigned, but only where v really is non-negative. The shapes that must stay
 * signed are checked against a reference computed in long.
 */
#include "test.h"

typedef unsigned char u8;
volatile u8 vsel;
volatile int vg;

static int clamp(int a, int b)                    /* the idiom */
{
    int v = a + b;
    int k = vsel ? 20 : 100;
    if (v < 0) v = 0;
    if (v > k) v = k;
    return v;
}
static long clamp_r(int a, int b)
{
    long v = (short)(a + b);
    long k = vsel ? 20 : 100;
    if (v < 0) v = 0;
    if (v > k) v = k;
    return v;
}

static int clamp_ge(int a, int b)                 /* positive form of the test */
{
    int v = a - b;
    if (v >= 0) { if (v > 50) v = 50; } else v = 0;
    return v;
}
static long clamp_ge_r(int a, int b)
{
    long v = (short)(a - b);
    if (v >= 0) { if (v > 50) v = 50; } else v = 0;
    return v;
}

static int neg_kept(int a, int b)                 /* the negative arm leaves v negative */
{
    int v = a + b;
    if (v < 0) vg++;
    if (v > 5) return 1;
    return 0;
}
static int neg_kept_r(int a, int b)
{
    long v = (short)(a + b);
    return v > 5;
}

static int rewrapped(int a, int b)                /* v can go negative after the test */
{
    int v = a;
    if (v < 0) v = 0;
    v = (int)((unsigned)v + (unsigned)b);
    if (v > 100) return 1;
    return 0;
}
static int rewrapped_r(int a, int b)
{
    long v = a;
    if (v < 0) v = 0;
    v = (short)(v + b);
    return v > 100;
}

static int stale(int a, int b)                    /* v changes between test and compare */
{
    int v = a;
    int neg = v < 0;
    v = (int)((unsigned)v + (unsigned)b);
    if (neg) v = 0;
    if (v > 7) return 1;
    return 0;
}
static int stale_r(int a, int b)
{
    long v = a;
    int neg = v < 0;
    v = (short)(v + b);
    if (neg) v = 0;
    return v > 7;
}

static int vals[] = { -32768, -30000, -1000, -101, -100, -1, 0, 1, 5, 6, 7, 8, 19, 20, 21,
                      50, 51, 99, 100, 101, 1000, 20000, 30000, 32767 };

static void check(void)
{
    int bad = 0, bg = 0, bn = 0, bw = 0, bs = 0;
    unsigned i, j, s;
    for (s = 0; s < 2; ++s) {
        vsel = (u8)s;
        for (i = 0; i < sizeof vals / sizeof vals[0]; ++i)
            for (j = 0; j < sizeof vals / sizeof vals[0]; ++j) {
                int a = vals[i], b = vals[j];
                if (clamp(a, b) != clamp_r(a, b)) ++bad;
                if (clamp_ge(a, b) != clamp_ge_r(a, b)) ++bg;
                if (neg_kept(a, b) != neg_kept_r(a, b)) ++bn;
                if (rewrapped(a, b) != rewrapped_r(a, b)) ++bw;
                if (stale(a, b) != stale_r(a, b)) ++bs;
            }
    }
    assertEqual(bad, 0);
    assertEqual(bg, 0);
    assertEqual(bn, 0);
    assertEqual(bw, 0);
    assertEqual(bs, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("signed compares after a sign test");
    suite_add_test(check);
    return suite_run();
}
