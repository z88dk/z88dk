/*
 * spectralnorm.c — spectral-norm (Computer Language Benchmarks Game),
 * adapted as a floating-point compiler-comparison bench.
 *
 * Approximates the largest singular value of the infinite matrix
 * A[i][j] = 1/((i+j)(i+j+1)/2 + i+1) by 10 rounds of power iteration on
 * A^T·A applied to a length-NUM vector, then sqrt(vBv/vv). The hot work is
 * double multiply-accumulate in the NUM×NUM inner loops (eval_A_times_u /
 * eval_At_times_u) plus a double divide per eval_A — a dense workout of the
 * software float ABI and codegen.
 *
 * NUM=16 (not the canonical 100) keeps the emulated-double workload inside
 * a sensible simulator budget while still exercising every float path. The
 * result is checked with a tolerance (approx_equal) because the exact bits
 * differ across float formats (math32 vs mbf32). Host-verified value below.
 *
 * Contributed originally by Sebastien Loisel.
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "test.h"

#define NUM 16

/* Absolute-tolerance compare — the exact low bits differ between the 48-bit
   and 32-bit (MBF) float libraries, so an == would be wrong. */
static int approx_equal(double a, double b, double eps)
{
    double d = a - b;
    if (d < 0.0) d = -d;
    return d < eps;
}

static double eval_A(int i, int j)
{
    return 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1);
}

static void eval_A_times_u(const double u[], double Au[])
{
    int i, j;
    for (i = 0; i < NUM; i++) {
        Au[i] = 0;
        for (j = 0; j < NUM; j++) Au[i] += eval_A(i, j) * u[j];
    }
}

static void eval_At_times_u(const double u[], double Au[])
{
    int i, j;
    for (i = 0; i < NUM; i++) {
        Au[i] = 0;
        for (j = 0; j < NUM; j++) Au[i] += eval_A(j, i) * u[j];
    }
}

static void eval_AtA_times_u(const double u[], double AtAu[])
{
    static double v[NUM];
    eval_A_times_u(u, v);
    eval_At_times_u(v, AtAu);
}

static void spectralnorm_run(void)
{
    static double u[NUM], v[NUM];
    double vBv, vv, r;
    int i;

    for (i = 0; i < NUM; i++) u[i] = 1;
    for (i = 0; i < 10; i++) {
        eval_AtA_times_u(u, v);
        eval_AtA_times_u(v, u);
    }
    vBv = vv = 0;
    for (i = 0; i < NUM; i++) { vBv += u[i] * v[i]; vv += v[i] * v[i]; }
    r = sqrt(vBv / vv);

    /* NUM=16 converges to 1.273525215 (host, IEEE double). */
    Assert(approx_equal(r, 1.273525215, 0.005), "spectral norm ~= 1.27353");
}

int suite_spectralnorm(void)
{
    suite_setup("Spectral-norm Tests");
    suite_add_test(spectralnorm_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_spectralnorm();
    exit(res);
}
