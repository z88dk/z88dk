/*
 * searchbench.c — binary-search benchmark, compiler comparison.
 *
 * Repeatedly bisects a sorted int array. The hot loop is `mid=(lo+hi)>>1;
 * compare; lo=mid+1 / hi=mid-1` — data-dependent, UNPREDICTABLE branches (the
 * search path depends on the key, so the direction flips arbitrarily) plus an
 * indexed load and a shift. That branch profile is the opposite of the flat
 * array-walk benches, which stride predictably; here the compiler's compare→
 * branch fusion and index codegen are what matter.
 *
 * Keys come from a 16-bit-masked LCG and the array holds a fixed arithmetic
 * progression, so the hit count and the checksum are identical on a 16-bit
 * target and a 32-bit host.
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define N       512        /* sorted table length */
#define LOOKUPS 1000        /* searches per rep */
#define REPS    6
#define HITS    1514u       /* host-verified total hits */
#define CHK     60689u      /* host-verified checksum */

static int table[N];        /* strictly increasing: table[i] = i*3 */

static int bsearch_idx(int key)
{
    int lo = 0, hi = N - 1;
    while (lo <= hi) {
        int mid = (lo + hi) >> 1;
        int v = table[mid];
        if (v == key) return mid;
        if (v < key) lo = mid + 1;
        else         hi = mid - 1;
    }
    return -1;
}

static void search_run(void)
{
    unsigned int hits = 0, chk = 0, lcg;
    int r, q, idx;

    for (r = 0; r < N; r++) table[r] = r * 3;   /* 0,3,6,… (sorted, distinct) */

    for (r = 0; r < REPS; r++) {
        lcg = (unsigned int)(0x51EDu + r);
        for (q = 0; q < LOOKUPS; q++) {
            int key;
            lcg = (unsigned int)((lcg * 181u + 17u) & 0xffffu);
            key = (int)(lcg & 0x7ffu);            /* 0..2047; table tops out at
                                                     1533, so ~1/4 keys hit. AND
                                                     mask (no per-lookup divide) */
            idx = bsearch_idx(key);
            if (idx >= 0) {
                hits++;
                chk = (unsigned int)((chk + (unsigned int)(idx + 1)) & 0xffffu);
            }
        }
    }
    Assert(hits == HITS, "binary search: total hits (host-verified)");
    Assert(chk == CHK,   "binary search: found-index checksum (host-verified)");
}

int suite_search(void)
{
    suite_setup("Binary Search Tests");
    suite_add_test(search_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_search();
    exit(res);
}
