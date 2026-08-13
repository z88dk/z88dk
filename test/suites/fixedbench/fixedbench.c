/*
 * fixedbench.c — Q8.8 fixed-point DSP, compiler comparison.
 *
 * A first-order IIR filter `y = (a*x + b*y_prev) >> 8` plus a fixed-point dot
 * product, both in Q8.8. The hot op is a 16x16->32 multiply followed by a
 * >>8 narrowing — the fixed-point idiom of embedded audio/control/graphics code
 * on a CPU with no FPU. Unlike vecbench (plain int dot) the multiply feeds a
 * shift-narrow, so it exercises the compiler's 16x16->32 `l_mult` path and the
 * 32-bit >>8 extract together.
 *
 * All state is kept 16-bit (the Q8.8 values) with 32-bit (long) multiply
 * intermediates — long is 32-bit on target and host alike, so the checksum is
 * width-independent and host-verified.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define N     64
#define REPS  120
#define CHK   24664u          /* host-verified (gcc -DHOST_VERIFY) */

static unsigned int sig[N];        /* Q8.8 input samples */
static unsigned int coef[N];       /* Q8.8 coefficients */

/* Q8.8 multiply: (a*b) >> 8, kept to 16 bits. long intermediate = 32-bit. */
static unsigned int qmul(unsigned int a, unsigned int b)
{
    unsigned long p = (unsigned long)a * (unsigned long)b;
    return (unsigned int)((p >> 8) & 0xffffu);
}

static unsigned int iir(void)
{
    unsigned int y = 0, acc = 0;
    int i;
    for (i = 0; i < N; i++) {
        /* y = 0.75*x + 0.25*y_prev in Q8.8 (0.75 = 192, 0.25 = 64). */
        y = (unsigned int)((qmul(192u, sig[i]) + qmul(64u, y)) & 0xffffu);
        acc = (unsigned int)((acc + y) & 0xffffu);
    }
    return acc;
}

static unsigned int fxdot(void)
{
    unsigned int acc = 0;
    int i;
    for (i = 0; i < N; i++)
        acc = (unsigned int)((acc + qmul(sig[i], coef[i])) & 0xffffu);
    return acc;
}

static unsigned int fixed_compute(void)
{
    unsigned int chk = 0, seed = 0xBEEFu;
    int r, i;
    for (i = 0; i < N; i++) {
        seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
        sig[i]  = seed & 0x0fffu;                 /* Q8.8 ~ 0..15.99 */
        coef[i] = (unsigned int)((seed >> 4) & 0x01ffu);
    }
    for (r = 0; r < REPS; r++) {
        chk = (unsigned int)((chk + iir()) & 0xffffu);
        chk = (unsigned int)((chk + fxdot()) & 0xffffu);
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void fixed_run(void)
{
    unsigned int chk = fixed_compute();
    Assert(chk == CHK, "Q8.8 fixed-point DSP checksum (host-verified)");
}

int suite_fixed(void)
{
    suite_setup("Fixed-Point DSP Tests");
    suite_add_test(fixed_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_fixed();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", fixed_compute()); return 0; }
#endif
