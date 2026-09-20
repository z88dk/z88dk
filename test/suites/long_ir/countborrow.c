/* Keep a word countdown live across a loop body that borrows BC for a
 * multiply-by-constant. A nominal BC home is not enough to justify `dec bc`
 * after the body: the multiply's temporary seed value may have replaced it.
 * The initial seed makes the first LCG result 1, so the bad countdown exits
 * after one iteration instead of 1000. */
#include "test.h"

#define STREAM 1000
#define NBINS 64

static unsigned int bins[NBINS];

static unsigned int hist_pass(unsigned int seed)
{
    int i;
    for (i = 0; i < STREAM; i++) {
        seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
        bins[(seed >> 3) & (NBINS - 1)]++;
    }
    return seed;
}

static void test_countdown_survives_scratch_use(void)
{
    unsigned int i, total = 0;
    unsigned int seed = hist_pass(39496u);

    for (i = 0; i < NBINS; i++) total += bins[i];
    assertEqual(seed, 55008u);
    assertEqual(total, STREAM);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Loop countdown versus BC scratch use");
    suite_add_test(test_countdown_survives_scratch_use);
    return suite_run();
}
