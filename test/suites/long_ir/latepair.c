/* A rejected word DE-home pick restores the counter to BC, where a
 * call-split had meanwhile given seed a ranged BC home: the late home must be
 * demoted, or seed's load overwrites the counter and the loop never ends.
 * hist_pass() is that shape (it hung on z80 fp before the fix). */
#include "test.h"

#define NBINS 64
static unsigned int bins[NBINS];

static unsigned int hist_pass(unsigned int seed)
{
    int i;
    for (i = 0; i < 1000; i++) {
        seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
        bins[(seed >> 3) & (NBINS - 1)]++;
    }
    return seed;
}

static void test_latepair(void)
{
    unsigned int s = 0x0777u, t = 0x0777u, sum = 0;
    int i;
    for (i = 0; i < NBINS; i++) bins[i] = 0;
    s = hist_pass(s);
    for (i = 0; i < 1000; i++) t = (unsigned int)(t * 25173u + 13849u);
    assertEqual(s, t);
    for (i = 0; i < NBINS; i++) sum += bins[i];
    assertEqual(sum, 1000);
}

int main(int argc, char *argv[])
{
    suite_setup("latepair");
    suite_add_test(test_latepair);
    return suite_run();
}
