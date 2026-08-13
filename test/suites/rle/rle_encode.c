/*
 * rle_encode.c — run-length encoding, compiler-comparison benchmark.
 *
 * Encodes a byte buffer into (count,value) pairs: an OUTER loop emits one
 * pair per run while an INNER loop counts the run of equal bytes. The hot
 * work is a strided byte walk with a byte compare, a nested run-counter, and
 * byte stores to the output — a foil for byte codegen and for the loop
 * register residency the counters/indices want (the inner run length plus the
 * i/o indices), the classic shape depth-weighted allocation targets.
 *
 * The input buffer, output size and checksum are host-verified. All arithmetic
 * is byte-wide or masked to 16 bits, so the result is identical on any int
 * width (16-bit target == 32-bit host).
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "test.h"

#define N     1024
#define REPS  64

static unsigned char inb[N];
static unsigned char outb[2 * N];      /* worst case: 2 output bytes per input byte */

/* Build pseudo-random runs (length 1..16, value 0..3) so the inner
   run-counter actually iterates. Byte arithmetic (mod 256) → width-independent. */
static void fill(void)
{
    unsigned int i = 0, j, runlen;
    unsigned char s = 0xA5, v;
    while (i < N) {
        s = (unsigned char)(s * 181u + 1u);
        runlen = (unsigned int)((s & 15) + 1);      /* 1..16 */
        v = (unsigned char)((s >> 4) & 3);          /* 0..3  */
        for (j = 0; j < runlen && i < N; j++) inb[i++] = v;
    }
}

/* RLE-encode inb[0..N) into outb as (count,value) pairs; count capped at 255.
   Returns the number of output bytes. */
static unsigned int rle_encode(void)
{
    unsigned int i = 0, o = 0, run;
    unsigned char v;
    while (i < N) {
        v = inb[i];
        run = 1;
        i++;
        while (i < N && inb[i] == v && run < 255) { run++; i++; }
        outb[o++] = (unsigned char)run;
        outb[o++] = v;
    }
    return o;
}

static void rle_run(void)
{
    unsigned int o = 0, chk = 0, r, k;

    fill();
    for (r = 0; r < REPS; r++) o = rle_encode();        /* amplify the hot loop */
    for (k = 0; k < o; k++) chk = (chk + outb[k]) & 0xffffu;

    Assert(o == 200,    "RLE output size = 100 runs (host-verified)");
    Assert(chk == 1174, "RLE output checksum (host-verified)");
}

int suite_rle(void)
{
    suite_setup("RLE encode Tests");
    suite_add_test(rle_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_rle();
    exit(res);
}
