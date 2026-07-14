/*
 * matrixbench.c — 2D stencil sweep, compiler comparison.
 *
 * A multiply-FREE nested-loop kernel (a matmul inner product would be
 * multiply-bound → l_mult dominates and the comparison flattens, cf. vecbench
 * dot). Instead this is a 5-point stencil over a 2D grid:
 *
 *     out[i][j] = in[i][j] + in[i-1][j] + in[i+1][j] + in[i][j-1] + in[i][j+1]
 *
 * The hot path is nested-loop ADDRESS COMPUTATION (row bases in[i*W], the four
 * neighbour offsets) plus loads/adds/store. W is a compile-time constant, so
 * `i*W` strength-reduces to shifts/adds (codegen, not a helper); the ideal
 * lowering keeps a stepped row pointer (induction-variable residency in a
 * nested loop). No multiply/divide/float on the hot path.
 *
 * Double-buffered by pointer swap; run for STEPS sweeps. Values are 16-bit
 * masked so the checksum is width-independent and host-verified.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define W     40
#define H     40
#define STEPS 16
#define CHK   36128u         /* host-verified (gcc -DHOST_VERIFY) */

static unsigned int gridA[H * W];
static unsigned int gridB[H * W];

static void stencil(const unsigned int *in, unsigned int *out)
{
    int i, j;
    for (i = 1; i < H - 1; i++) {
        for (j = 1; j < W - 1; j++) {
            unsigned int s = in[i * W + j]
                           + in[(i - 1) * W + j]
                           + in[(i + 1) * W + j]
                           + in[i * W + (j - 1)]
                           + in[i * W + (j + 1)];
            out[i * W + j] = s & 0xffffu;
        }
    }
}

static unsigned int matrix_compute(void)
{
    unsigned int chk = 0, seed = 0xA5A5u;
    unsigned int *cur = gridA, *nxt = gridB, *tmp;
    int i, s;

    for (i = 0; i < H * W; i++) {
        seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
        gridA[i] = seed & 0xffu;      /* small so early sweeps don't all saturate */
        gridB[i] = gridA[i];
    }

    for (s = 0; s < STEPS; s++) {
        stencil(cur, nxt);
        tmp = cur; cur = nxt; nxt = tmp;
    }

    for (i = 0; i < H * W; i++)
        chk = (unsigned int)((chk + cur[i]) & 0xffffu);
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void matrix_run(void)
{
    unsigned int chk = matrix_compute();
    Assert(chk == CHK, "2D stencil sweep checksum (host-verified)");
}

int suite_matrix(void)
{
    suite_setup("2D Stencil Tests");
    suite_add_test(matrix_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_matrix();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", matrix_compute()); return 0; }
#endif
