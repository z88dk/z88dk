/*
 * vecbench.c — dual-array numeric kernels, compiler comparison.
 *
 * Two hot loops that walk TWO arrays in lockstep:
 *     saxpy:  for (i) y[i] = a*x[i] + y[i];
 *     dot:    for (i) s   += x[i] * y[i];
 *
 * Unlike the single-array walk (ptrbench index_walk), this needs two live
 * element pointers at once — the register-pressure case for the index-register
 * co-design: one walking pointer in an index register (stepped `add iy,de`,
 * deref `(iy+d)`), the other in a gp pair. Without that, both addresses are
 * recomputed from the index each iteration.
 *
 * short elements + 16-bit-masked arithmetic, so the checksum matches on a
 * 16-bit target and a 32-bit host.
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define N     300
#define REPS  30
#define CHK   28042u        /* host-verified */

static short vx[N], vy[N];

static unsigned int dot(int n)
{
    unsigned int s = 0;
    int i;
    for (i = 0; i < n; i++)
        s = (s + (unsigned int)((unsigned int)(unsigned short)vx[i]
                              * (unsigned int)(unsigned short)vy[i])) & 0xffffu;
    return s;
}

static void saxpy(int n, int a)
{
    int i;
    for (i = 0; i < n; i++)
        vy[i] = (short)((a * vx[i] + vy[i]) & 0xffff);
}

static void vec_run(void)
{
    unsigned int chk = 0;
    int r, i;
    for (i = 0; i < N; i++) { vx[i] = (short)(i % 50); vy[i] = (short)((i * 7) % 40); }
    for (r = 0; r < REPS; r++) { saxpy(N, 3); chk = (chk + dot(N)) & 0xffffu; }
    Assert(chk == CHK, "dual-array saxpy+dot checksum (host-verified)");
}

int suite_vec(void)
{
    suite_setup("Dual-array Vector Tests");
    suite_add_test(vec_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_vec();
    exit(res);
}
