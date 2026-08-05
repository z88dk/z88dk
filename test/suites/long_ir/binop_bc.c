/* Word add/sub with a BC-resident operand (gen_add / gen_sub, ir_lower_ops).
 * When one operand already sits in BC, the lowerer subtracts/adds straight from
 * BC instead of staging it through DE:
 *   add hl,bc      — commutative, either operand may be the BC one;
 *   and a; sbc hl,bc — NOT commutative: only minuend-in-HL, subtrahend-in-BC;
 *   808x/gbz80     — the same byte-wise off C/B (sub c; sbc a,b), since those
 *                    emulate sbc hl,de.
 * Leaving DE untouched avoids spilling a DE-resident accumulator across the op.
 *
 * Pins CORRECTNESS of all three across the CPU matrix (z80 math48 sp/fp, plus
 * 8080/gbz80 for the byte-wise path). Self-verifying: va[i]=5i+2, vb[i]=2i+1. */
#include "test.h"

#define N 16
static int va[N], vb[N];

/* sbc hl,bc: s += a[i]-b[i]  (subtrahend b[i] can land in BC). */
static int diff(int n)
{
    int s = 0, i;
    for (i = 0; i < n; i++) s += va[i] - vb[i];
    return s;
}

/* repeated subtract from a running accumulator (DE) — DE must survive. */
static int rdiff(int n)
{
    int s = 1000, i;
    for (i = 0; i < n; i++) s -= va[i];
    return s;
}

/* add hl,bc: unsigned reduction (the walking-pointer base+idx add). */
static unsigned int asum(unsigned n)
{
    unsigned int s = 0, i;
    for (i = 0; i < n; i++) s = (s + (unsigned int)va[i]) & 0xffffu;
    return s;
}

static void test_binop_bc(void)
{
    int i;
    for (i = 0; i < N; i++) { va[i] = i * 5 + 2; vb[i] = i * 2 + 1; }

    /* sum((5i+2)-(2i+1)) = sum(3i+1). */
    assertEqual(diff(8),  92);         /* 8 + 3*28 */
    assertEqual(diff(16), 376);        /* 16 + 3*120 */
    assertEqual(diff(0),  0);          /* 0-trip */

    assertEqual(rdiff(5),  940);       /* 1000 - sum(5i+2, i=0..4) = 1000-60 */
    assertEqual(rdiff(0),  1000);      /* 0-trip, accumulator untouched */

    assertEqual(asum(8),  156u);       /* sum(5i+2, i=0..7) = 140+16 */
    assertEqual(asum(0),  0u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Word add/sub with a BC-resident operand");
    suite_add_test(test_binop_bc);
    return suite_run();
}
