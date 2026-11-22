/*
 * charmulbench.c — char*char multiply, compiler comparison.
 *
 * Two hot loops that multiply BYTE operands directly, before any promotion
 * to int:
 *     u8dot: for (i) s += (unsigned int)ux[i] * uy[i];   (unsigned 8x8->16)
 *     s8dot: for (i) s += (int)sx[i] * sy[i];             (signed 8x8->16)
 *
 * This is the operand shape the 8x8 hardware multiply path in
 * build_muldiv_integer (ir_build.c) matches BEFORE promotion widens the
 * operands to int - kc160 (mul/muls hl, both signednesses), z180 (mlt hl,
 * unsigned only), z80n (mul de, unsigned only) all take it today. R800 has
 * its own unsigned-only 8x8 hardware multiply (mulub a,r) but no lowering
 * for it yet (see src/80cc/R800_TARGET_PLAN.md, "8x8 char multiply not
 * done") - this bench exists to give that work a real corpus number to
 * measure against, since none of the other 30 benches exercise a hot
 * char*char multiply.
 *
 * unsigned char values stay in 0..255; signed char values stay in -128..127,
 * so every product fits in int on both a 16-bit target and a 32-bit host -
 * no masking needed for the checksum to match.
 */

#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define N     64
#define REPS  40
#define CHK   41472u        /* host-verified (gcc -DHOST_VERIFY) */

static unsigned char ux[N], uy[N];
static signed char   sx[N], sy[N];

static unsigned int u8dot(int n)
{
    unsigned int s = 0;
    int i;
    for (i = 0; i < n; i++)
        s = (unsigned int)(s + (unsigned int)ux[i] * uy[i]) & 0xffffu;
    return s;
}

static unsigned int s8dot(int n)
{
    int s = 0;
    int i;
    for (i = 0; i < n; i++)
        s = (int)(s + (int)sx[i] * sy[i]);
    return (unsigned int)s & 0xffffu;
}

static unsigned int charmul_compute(void)
{
    unsigned int chk = 0;
    int r, i;
    for (i = 0; i < N; i++) {
        ux[i] = (unsigned char)(i * 5 + 3);
        uy[i] = (unsigned char)(i * 7 + 11);
        sx[i] = (signed char)(i * 3 - 90);
        sy[i] = (signed char)(i * 5 - 60);
    }
    for (r = 0; r < REPS; r++) {
        chk = (chk + u8dot(N)) & 0xffffu;
        chk = (chk + s8dot(N)) & 0xffffu;
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void charmul_run(void)
{
    unsigned int chk = charmul_compute();
    Assert(chk == CHK, "char*char multiply checksum (host-verified)");
}

int suite_charmul(void)
{
    suite_setup("Char*char Multiply Tests");
    suite_add_test(charmul_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_charmul();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", charmul_compute()); return 0; }
#endif
