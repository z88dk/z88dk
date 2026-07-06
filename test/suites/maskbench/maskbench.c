/*
 * maskbench.c — masked binary search, compiler comparison.
 *
 * A binary search whose key is masked per element: `v = tab[mid] & mask`. The
 * loop is the searchbench shape (general DE-home on `hi`) PLUS a width-2 bitwise
 * AND of two non-home operands (the indexed load and the mask param). That AND is
 * the case the byte-wise (ix+d) ALU fold targets: inside the DE-home region it is
 * lowered `ld a,l; and (ix+mask); ld a,h; and (ix+mask+1)` — reading both operands
 * in place through A, never staging one into DE, so `hi` survives in DE.
 *
 * mask = 0x7ff keeps the search identical to the plain version; the checksum is
 * host-verified and width-independent.
 */
#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define N       512
#define LOOKUPS 1000
#define REPS    6
#define CHK     60689u        /* host-verified */

static int tab[N];

static int bsearch_masked(int key, int mask)
{
    int lo = 0, hi = N - 1;
    while (lo <= hi) {
        int mid = (lo + hi) >> 1;
        int v = tab[mid] & mask;
        if (v == key) return mid;
        if (v < key) lo = mid + 1;
        else         hi = mid - 1;
    }
    return -1;
}

static void mask_run(void)
{
    unsigned int chk = 0, lcg;
    int r, q;
    for (r = 0; r < N; r++) tab[r] = r * 3;
    for (r = 0; r < REPS; r++) {
        lcg = (unsigned int)(0x51EDu + r);
        for (q = 0; q < LOOKUPS; q++) {
            int key;
            lcg = (unsigned int)((lcg * 181u + 17u) & 0xffffu);
            key = (int)(lcg & 0x7ffu);
            int idx = bsearch_masked(key, 0x7ff);
            if (idx >= 0) chk = (unsigned int)((chk + (unsigned int)(idx + 1)) & 0xffffu);
        }
    }
    Assert(chk == CHK, "masked binary search checksum (host-verified)");
}

int suite_mask(void)
{
    suite_setup("Masked Binary Search");
    suite_add_test(mask_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_mask();
    exit(res);
}
