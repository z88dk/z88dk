/* Word (int) accumulator residency — ptrbench DE-home guard.
 *
 * A loop-carried int accumulator must total correctly when held in a
 * register (DE-home) across a pointer-stepped loop instead of a frame
 * slot. Values straddle the high byte (running total carries past
 * 0x00FF) so a stale home, a half-swapped DE (an `ex de,hl` gone
 * wrong), or a missed cross-BB carry shows up as a wrong total.
 *
 * Results are identical with the residency on (default) vs off
 * (IR_NO_WORD_RESIDENT) — these guard the codegen, not a value change.
 *
 * Split out of long_ir.c: that binary is at the MSX 64K ceiling, so the
 * suite lives in its own small binary (see the Makefile's wr.bin
 * target). Run the IR build directly, e.g.:
 *   zcc +test -compiler=80cc -Cc--use-ir -Cc-frameix \
 *       -I../../framework ../../framework/test.c word_resident.c -o wr.bin
 *   z88dk-ticks -w 30 -b msx wr.bin
 */

#include "test.h"

int wr_arr[8];
struct wrec { int a, b, c, d; };
struct wrec wr_recs[4];

static int wr_index_walk(int *a, int n)         /* 1 add/iter — index_walk shape */
{
    int i, sum;
    sum = 0;
    for (i = 0; i < n; i++) sum += a[i];
    return sum;
}

static int wr_ptr_walk(int *a, int n)           /* accumulator + *p++ */
{
    int sum = 0;
    int *p = a;
    while (n-- > 0) sum += *p++;
    return sum;
}

static int wr_field_sum(struct wrec *s, int n)  /* 4 adds/iter — struct shape */
{
    int i, sum;
    sum = 0;
    for (i = 0; i < n; i++) sum += s[i].a + s[i].b + s[i].c + s[i].d;
    return sum;
}

static int wr_nested(void)                      /* nested loop — region detection */
{
    int i, j, sum;
    sum = 0;
    for (i = 0; i < 4; i++)
        for (j = 0; j < 4; j++)
            sum += wr_arr[(i + j) & 7];
    return sum;
}

static int wr_cond_accum(int *a, int n)         /* conditional update — def-dom gate */
{
    int i, sum;
    sum = 0;
    for (i = 0; i < n; i++)
        if (a[i] & 1) sum += a[i];              /* sum not redefined every iter */
    return sum;
}

static int wr_signed_bound(int hi)              /* DE-clean SIGNED loop test in the
                                                   overflow regime: i-hi overflows
                                                   int16 at the first compare, so a
                                                   missing S^V correction reads the
                                                   wrong sign → 0 iterations. (Stride
                                                   chosen so i itself never wraps.) */
{
    int i, sum = 0;
    for (i = -30000; i < hi; i += 10000) sum += i;   /* sum += i: reduction → DE-home */
    return sum;
}

static void test_word_resident(void)
{
    int i;
    for (i = 0; i < 8; i++) wr_arr[i] = (i + 1) * 0x0123;   /* 0x123..0x918 */
    for (i = 0; i < 4; i++) {
        wr_recs[i].a = i + 1; wr_recs[i].b = 0x0100;
        wr_recs[i].c = 0x0010; wr_recs[i].d = 0x1000;
    }

    Assert(wr_index_walk(wr_arr, 8) == 0x28EC, "word resident: index walk");
    Assert(wr_ptr_walk(wr_arr, 8)   == 0x28EC, "word resident: ptr walk");
    Assert(wr_index_walk(wr_arr, 0) == 0,      "word resident: zero-trip");
    Assert(wr_field_sum(wr_recs, 4) == 0x444A, "word resident: field sum");
    Assert(wr_nested()              == 0x48C0, "word resident: nested");
    Assert(wr_cond_accum(wr_arr, 8) == 0x1230, "word resident: conditional accum");
    /* i=-30000,-20000,-10000,0 → sum -60000 → (int16) 0x15A0. First compare
       -30000<10000 has i-hi=-40000 (int16 overflow): guards the signed test's
       S^V correction (without it the compare's sign is wrong → 0 iterations). */
    Assert(wr_signed_bound(10000)   == 0x15A0, "word resident: signed bound overflow");
}

int suite_word_resident(void)
{
    suite_setup("word accumulator residency");
    suite_add_test(test_word_resident);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    res += suite_word_resident();
    exit(res);
}
