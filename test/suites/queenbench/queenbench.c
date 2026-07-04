/*
 * queenbench.c — N-queens backtracking benchmark, compiler comparison.
 *
 * Counts the placements of N non-attacking queens on an N*N board by
 * column-recursive backtracking. Unlike the array-walk benches this is a
 * DEEP, IRREGULAR recursion (N frames) with data-dependent branching and no
 * loop the strength-reducer can touch: it probes the call ABI (per-node
 * prologue/epilogue, arg push, ix-frame setup), recursion, and the
 * unpredictable branches of the conflict test — call/branch behaviour the
 * flat kernels never exercise.
 *
 * All arithmetic is small-int and width-independent, so the solution count is
 * identical on a 16-bit target and a 32-bit host.
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define NQ    8            /* 8-queens has 92 solutions (host-verified); the
                              full backtrack search is ~38M ticks on z80 */
#define REPS  1
#define NSOL  92

static int board[NQ];      /* board[c] = row of the queen in column c */
static unsigned int solutions;

/* Can a queen sit at (col, row) without attacking any already placed? */
static int safe(int col, int row)
{
    int i, d;
    for (i = 0; i < col; i++) {
        int ri = board[i];
        if (ri == row) return 0;               /* same row */
        d = ri - row;
        if (d < 0) d = -d;                      /* |row diff| */
        if (d == col - i) return 0;             /* same diagonal */
    }
    return 1;
}

static void place(int col)
{
    int row;
    if (col == NQ) { solutions++; return; }
    for (row = 0; row < NQ; row++)
        if (safe(col, row)) {
            board[col] = row;
            place(col + 1);
        }
}

static void queen_run(void)
{
    unsigned int total = 0;
    int r;
    for (r = 0; r < REPS; r++) {
        solutions = 0;
        place(0);
        total += solutions;
    }
    Assert(solutions == NSOL, "N-queens solution count (host-verified)");
    Assert(total == (unsigned int)(NSOL * REPS), "N-queens total over reps");
}

int suite_queen(void)
{
    suite_setup("N-Queens Tests");
    suite_add_test(queen_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_queen();
    exit(res);
}
