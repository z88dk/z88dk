/*
 * divbench.c — division, modulo and multiplication by constants.
 *
 * A constant divisor never needs the division helper. An unsigned power of two
 * is a shift and a mask; a SIGNED power of two is the same shift with a bias
 * added first, because C rounds the quotient toward zero; a small constant
 * multiplier is a chain of shifts and adds. What a compiler reduces here, and
 * what it hands to the runtime instead, is the whole measurement.
 *
 *   udiv  unsigned / and % by powers of two — shift and mask
 *   sdiv  signed / and % by powers of two — the round-toward-zero bias
 *   kmul  multiplication by small constants, powers of two and not
 *   kmix  a divide feeding a multiply, where the two reductions meet
 *
 * fixedbench multiplies by runtime values and crcbench shifts by one; nothing
 * else in the corpus divides at all.
 *
 * Values are kept small enough that no intermediate leaves the range of a 16-bit
 * int, so the checksum is identical on target and on the verifying host.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define STREAM 700
#define REPS   24
#define CHK    14023u          /* host-verified (gcc -DHOST_VERIFY) */

/* Unsigned powers of two: a shift for the quotient, a mask for the remainder. */
static unsigned int udiv(unsigned int v)
{
    unsigned int acc = 0;
    acc = (unsigned int)(acc + (v / 2u) + (v % 2u));
    acc = (unsigned int)(acc + (v / 8u) + (v % 8u));
    acc = (unsigned int)(acc + (v / 64u) + (v % 64u));
    acc = (unsigned int)(acc + (v / 256u) + (v % 256u));
    return acc & 0xffffu;
}

/* Signed powers of two: a plain arithmetic shift rounds toward minus infinity,
   so a negative dividend needs a bias added before it. */
static int sdiv(int v)
{
    int acc = 0;
    acc += (v / 2) + (v % 2);
    acc += (v / 8) + (v % 8);
    acc += (v / 64) + (v % 64);
    return acc;
}

/* Constant multipliers: 8 is a shift chain, 3 and 10 are shift-plus-add, 25 is
   where a compiler either builds a chain or gives up and calls the helper. */
static int kmul(int v)
{
    int acc = 0;
    acc += v * 2;
    acc += v * 3;
    acc += v * 8;
    acc += v * 10;
    acc += v * 25;
    return acc;
}

/* A divide feeding a multiply: the two reductions have to compose. */
static int kmix(int v)
{
    return ((v / 4) * 6) + ((v / 16) * 3);
}

static unsigned int div_compute(void)
{
    unsigned int chk = 0, seed = 0x6E13u;
    int r, i;

    for (r = 0; r < REPS; r++) {
        for (i = 0; i < STREAM; i++) {
            unsigned int u;
            int s;

            seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
            u = seed;
            /* Straddles zero on purpose: the signed bias only shows up on a
               negative dividend. Bounded so v*25 stays inside a 16-bit int. */
            s = (int)(seed & 1023u) - 512;

            chk = (unsigned int)(chk + udiv(u));
            chk = (unsigned int)(chk + (unsigned int)(sdiv(s) & 0xffff));
            chk = (unsigned int)(chk + (unsigned int)(kmul(s) & 0xffff));
            chk = (unsigned int)(chk + (unsigned int)(kmix(s) & 0xffff));
            chk &= 0xffffu;
        }
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void div_run(void)
{
    unsigned int chk = div_compute();
    Assert(chk == CHK, "constant divide/multiply checksum (host-verified)");
}

int suite_div(void)
{
    suite_setup("Constant Divide/Multiply Tests");
    suite_add_test(div_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_div();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", div_compute()); return 0; }
#endif
