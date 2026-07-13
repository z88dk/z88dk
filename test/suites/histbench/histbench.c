/*
 * histbench.c — histogram / bucketed counting, compiler comparison.
 *
 * The `bins[sample & mask]++` idiom: stream values and increment an
 * array-indexed counter — the read-modify-write at a computed address that
 * underlies histograms, frequency tables, radix-sort counting passes, and
 * profiling counters. The hot path is a variable-index load, increment, store
 * back to the SAME computed address — distinct from the flat strided walks
 * (each element written once) and from the reductions (a register accumulator):
 * here the destination address is data-dependent every iteration.
 *
 * Values come from a deterministic LCG; the checksum folds the whole bin array,
 * 16-bit-masked, so it is width-independent and host-verified.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define NBINS 64
#define BMASK (NBINS - 1)
#define STREAM 1000
#define REPS  50
#define CHK   51928u         /* host-verified (gcc -DHOST_VERIFY) */

static unsigned int bins[NBINS];

static unsigned int hist_pass(unsigned int seed)
{
    int i;
    for (i = 0; i < STREAM; i++) {
        seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
        bins[(seed >> 3) & BMASK]++;                 /* the RMW at a computed index */
    }
    return seed;
}

static unsigned int hist_compute(void)
{
    unsigned int chk = 0, seed = 0x0777u;
    int r, i;
    for (r = 0; r < REPS; r++) {
        for (i = 0; i < NBINS; i++) bins[i] = 0;
        seed = hist_pass(seed);
        /* Fold the histogram (weighted) into the running checksum. */
        for (i = 0; i < NBINS; i++)
            chk = (unsigned int)((chk + bins[i] * (unsigned int)(i + 1)) & 0xffffu);
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void hist_run(void)
{
    unsigned int chk = hist_compute();
    Assert(chk == CHK, "histogram indexed-RMW checksum (host-verified)");
}

int suite_hist(void)
{
    suite_setup("Histogram Tests");
    suite_add_test(hist_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_hist();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", hist_compute()); return 0; }
#endif
