/*
 * sortbench.c — sorting benchmark, compiler comparison.
 *
 * Two hand-written sorts over an int array, so the numbers measure the
 * COMPILER (no library sort code mixed in):
 *
 *   - qsort_rec: a recursive quicksort that compares through a FUNCTION
 *     POINTER. Probes what the array-walk benches never touch — the call
 *     ABI (prologue/epilogue, arg push + `add sp,N` cleanup, ix-frame setup
 *     per call), recursion depth, and a hot INDIRECT call (l_jpix / fnptr
 *     dispatch) in the partition inner loop.
 *   - ins_sort: insertion sort. Probes in-place element SHIFTS (mem↔mem
 *     moves) and a data-dependent inner loop — the classic O(n^2) swap kernel.
 *
 * Input is a 16-bit-masked LCG so the sequence, the sorted order and the
 * checksums are identical on a 16-bit target and a 32-bit host. Values are
 * held in [0,32767] (positive, so signed compares agree at both widths).
 * Data is re-shuffled every rep, so quicksort sees random (log-depth) input,
 * not an adversarial already-sorted case.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "test.h"

#define QN    100          /* quicksort array length */
#define IN    64           /* insertion-sort array length (O(n^2), smaller) */
#define QREPS 16
#define IREPS 24

#define QSUM  23215u        /* host-verified summed checksum (see sortbench notes) */
#define ISUM  43825u

static int qa[QN];
static int ia[IN];

/* 16-bit LCG: state masked to 16 bits so z80 (int==16) and host (int==32)
   produce the same stream. Value masked to 0..32767 (positive). */
static unsigned int lcg_state;
static int next_val(void)
{
    lcg_state = (unsigned int)((lcg_state * 181u + 17u) & 0xffffu);
    return (int)(lcg_state & 0x7fffu);
}

static int cmp_int(const void *a, const void *b)
{
    int x = *(const int *)a;
    int y = *(const int *)b;
    if (x < y) return -1;
    if (x > y) return 1;
    return 0;
}

/* Recursive quicksort (Lomuto partition) comparing via a function pointer. */
static void qsort_rec(int *v, int lo, int hi, int (*cmp)(const void *, const void *))
{
    int i, j, pivot, tmp;
    if (lo >= hi) return;
    pivot = v[hi];
    i = lo;
    for (j = lo; j < hi; j++) {
        if (cmp(&v[j], &pivot) < 0) {
            tmp = v[i]; v[i] = v[j]; v[j] = tmp;   /* swap */
            i++;
        }
    }
    tmp = v[i]; v[i] = v[hi]; v[hi] = tmp;         /* pivot into place */
    qsort_rec(v, lo, i - 1, cmp);
    qsort_rec(v, i + 1, hi, cmp);
}

static void ins_sort(int *v, int n)
{
    int i, j, key;
    for (i = 1; i < n; i++) {
        key = v[i];
        j = i - 1;
        while (j >= 0 && v[j] > key) {             /* shift larger elems up */
            v[j + 1] = v[j];
            j--;
        }
        v[j + 1] = key;
    }
}

static unsigned int checksum(const int *v, int n)
{
    unsigned int c = 0;
    int k;
    /* position-weighted so a mere permutation would not collide */
    for (k = 0; k < n; k++)
        c = (unsigned int)((c + (unsigned int)v[k] * (unsigned int)(k + 1)) & 0xffffu);
    return c;
}

static int is_sorted(const int *v, int n)
{
    int k;
    for (k = 1; k < n; k++)
        if (v[k - 1] > v[k]) return 0;
    return 1;
}

static void qsort_run(void)
{
    unsigned int chk = 0;
    int r, k, ok = 1;

    for (r = 0; r < QREPS; r++) {
        lcg_state = (unsigned int)(0xBEEFu + r);       /* fresh shuffle per rep */
        for (k = 0; k < QN; k++) qa[k] = next_val();
        qsort_rec(qa, 0, QN - 1, cmp_int);
        if (!is_sorted(qa, QN)) ok = 0;
        chk = (chk + checksum(qa, QN)) & 0xffffu;
    }
    Assert(ok == 1, "quicksort: array sorted every rep");
    Assert(chk == QSUM, "quicksort: summed checksum (host-verified)");
}

static void ins_run(void)
{
    unsigned int chk = 0;
    int r, k, ok = 1;

    for (r = 0; r < IREPS; r++) {
        lcg_state = (unsigned int)(0x1234u + r);
        for (k = 0; k < IN; k++) ia[k] = next_val();
        ins_sort(ia, IN);
        if (!is_sorted(ia, IN)) ok = 0;
        chk = (chk + checksum(ia, IN)) & 0xffffu;
    }
    Assert(ok == 1, "insertion sort: array sorted every rep");
    Assert(chk == ISUM, "insertion sort: summed checksum (host-verified)");
}

int suite_sort(void)
{
    suite_setup("Sort Tests");
    suite_add_test(qsort_run);
    suite_add_test(ins_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_sort();
    exit(res);
}
