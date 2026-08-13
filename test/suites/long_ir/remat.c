/* Rematerialization correctness: a width-2 vreg defined ONCE by LD_IMM/LD_SYM
 * (a constant / static-array address) is rematerialized on a cache-miss load
 * instead of being spilled+reloaded. Two traps this guards:
 *
 *  1. A loop-carried counter incremented in place (`o++`, which after the opt
 *     passes lowers to a self-stepping op whose def is NOT in op->dst) must NOT
 *     be mis-tagged single-def and rematerialized to its initial constant.
 *     (This was a real bug: rle_encode returned 0 instead of the byte count
 *     because `o` was rematerialized as its init value 0.) The classic shape:
 *     walk a static array writing (index) pairs, return the final index.
 *
 *  2. A genuine constant address (static array base) walked across a loop must
 *     still produce correct element accesses when rematerialized.
 */
#include "test.h"

static unsigned char rsrc[24];
static unsigned char rdst[48];

/* Mirror of an RLE-ish encode: o is a loop-carried index, post-incremented
 * twice per run and RETURNED. If o is wrongly rematerialized to its init 0,
 * the return value collapses to 0. */
static unsigned int encode_pairs(unsigned int n)
{
    unsigned int i = 0, o = 0;
    while (i < n) {
        unsigned char v = rsrc[i];
        unsigned int run = 1;
        i++;
        while (i < n && rsrc[i] == v && run < 255) { run++; i++; }
        rdst[o++] = (unsigned char)run;
        rdst[o++] = v;
    }
    return o;
}

static void test_remat_counter(void)
{
    unsigned int o, k, chk = 0;
    /* 3 runs: 5×'A', 2×'B', 1×'C' → 6 output bytes, pairs (5,A)(2,B)(1,C). */
    for (k = 0; k < 5; k++) rsrc[k] = 'A';
    rsrc[5] = 'B'; rsrc[6] = 'B';
    rsrc[7] = 'C';
    o = encode_pairs(8);
    Assert(o == 6, "remat: loop-carried counter returned (not its init const)");
    for (k = 0; k < o; k++) chk = (chk + rdst[k]) & 0xffffu;
    /* 5+'A' + 2+'B' + 1+'C' = 5+65+2+66+1+67 = 206 */
    Assert(chk == 206, "remat: static-array base walk correct");
}

/* Two distinct static arrays whose bases are both rematerialized in one loop —
 * a copy-with-transform. Guards against a single base serving both. */
static void test_remat_two_bases(void)
{
    unsigned int i, sum = 0;
    for (i = 0; i < 24; i++) rsrc[i] = (unsigned char)(i + 1);
    for (i = 0; i < 24; i++) rdst[i] = (unsigned char)(rsrc[i] * 2u);
    for (i = 0; i < 24; i++) sum = (sum + rdst[i]) & 0xffffu;
    Assert(sum == 600, "remat: two static bases distinct (2*(1..24) sum)");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Rematerialization correctness");
    suite_add_test(test_remat_counter);
    suite_add_test(test_remat_two_bases);
    return suite_run();
}
