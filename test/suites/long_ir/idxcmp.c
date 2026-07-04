/* Index-half signed byte-wise compare: a signed `i < n` loop test where the
 * counter `i` is idx2-resident (an index register) and the bound `n` is an
 * ix-addressable memory operand (a param or slot) lowers, on CPUs with index
 * halves + fp mode, to `ld a,iyl; sub (ix+d); ld a,iyh; sbc a,(ix+d+1)` + the
 * S^V correction — instead of `push iy; pop hl; sbc hl,de`.
 *
 * This is the queen `safe()` shape (`for(i=0;i<col;i++) ... board[i] ...`).
 * The test must be built with -frameix to exercise the fp path; the assert
 * value is width-independent so it also validates the push/pop fallback on
 * non-index-half CPUs / sp-mode. Correctness traps: right ix offset, right
 * index-half register, and the signed correction (negative elements). */
#include "test.h"

static int arr[12];

/* An in-loop early return keeps the loop counter `i` as a genuine idx2
 * induction var and the `i < n` test in its simple signed form (a plain
 * counting loop is instead strength-reduced by IVSR/LFTR, dissolving the
 * shape) — this is exactly why queen's safe() hits the index-half path.
 * Returns the index of the first arr[i] < thr in [0,n), else -1. */
static int find_lt(int n, int thr)
{
    int i;
    for (i = 0; i < n; i++)
        if (arr[i] < thr)
            return i;
    return -1;
}

/* Count via an early-continue-free loop that still carries a running total in
 * a register across the `i < n` compare — guards that HL/DE survive the
 * A-only compare form (a corrupted sum would fail here). */
static int count_lt(int n, int thr)
{
    int i, c = 0;
    for (i = 0; i < n; i++) {
        if (arr[i] >= thr)
            continue;
        c++;
        if (c == 99) return -1;   /* in-loop exit → keeps the plain i<n shape */
    }
    return c;
}

static void test_idxcmp(void)
{
    int i;
    for (i = 0; i < 12; i++) arr[i] = (i * 7) - 40;   /* -40,-33,..,37 */
    /* arr = -40,-33,-26,-19,-12,-5,2,9,16,23,30,37. thr=0 → 6 negatives. */
    Assert(find_lt(12, 0) == 0,   "idxcmp: first negative at index 0");
    Assert(find_lt(12, -40) == -1, "idxcmp: none strictly < min → -1");
    Assert(count_lt(12, 0) == 6,  "idxcmp: signed i<n counter + arr[i]<0 count");
    Assert(count_lt(5, 0) == 5,   "idxcmp: partial bound count");
    Assert(count_lt(12, -40) == 0, "idxcmp: none < min");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Index-half signed compare");
    suite_add_test(test_idxcmp);
    return suite_run();
}
