/*
 * predbench.c — short-circuit predicates and branch layout.
 *
 * Control flow, not arithmetic. A chain like `(a<b && c>d) || (a==d && b!=c)` is
 * pure codegen with no library call in it: the compiler chooses how many
 * comparisons actually execute, whether a result is materialised as a 0/1 value
 * or consumed straight off the flags, whether the `&&` arms fall through or jump,
 * and whether a redundant compare folds into a preceding one.
 *
 *   chain     nested &&/|| where SHORT-CIRCUITING must skip work. A
 *             side-effecting probe counts evaluations, so a chain flattened into
 *             arithmetic is caught rather than silently accepted.
 *   sat       clamp/min/max: an if-chain whose branches assign the same
 *             variable, the classic branchless-vs-branchy decision.
 *   classify  a range ladder (the isalpha/isdigit shape), where each test can
 *             reuse the previous comparison's flags instead of reloading.
 *
 * Nothing here indexes or allocates anything wide, so the measurement is branch
 * layout and flag handling rather than addressing.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define STREAM 700
#define REPS   22
#define CHK    40895u        /* host-verified (gcc -DHOST_VERIFY) */

static unsigned int probes;          /* counts short-circuit evaluations */

/* Side-effecting operand: if the compiler wrongly evaluates both arms of a
   `&&`, `probes` diverges and the checksum catches it. */
static int probe(int v)
{
    probes = (unsigned int)((probes + 1u) & 0xffffu);
    return v;
}

static int chain(int a, int b, int c, int d)
{
    return (a < b && probe(c) > d) || (a == d && probe(b) != c);
}

/* Clamp to [0,255] then to a band — same variable assigned on both arms. */
static int sat(int v)
{
    if (v > 255) v = 255;
    if (v < 0)   v = 0;
    return (v < 64) ? 64 : (v > 192 ? 192 : v);
}

/* Range ladder: consecutive comparisons on the same value. */
static int classify(int c)
{
    if (c < 0)    return 0;
    if (c < 32)   return 1;
    if (c < 48)   return 2;
    if (c < 58)   return 3;
    if (c < 65)   return 4;
    if (c < 91)   return 5;
    if (c < 97)   return 6;
    if (c < 123)  return 7;
    return 8;
}

static unsigned int pred_compute(void)
{
    unsigned int chk = 0, seed = 0x7A5Cu;
    int r, i;

    probes = 0;
    for (r = 0; r < REPS; r++) {
        for (i = 0; i < STREAM; i++) {
            int a, b, c, d;
            seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
            a = (int)(seed & 255u) - 128;
            b = (int)((seed >> 3) & 255u) - 128;
            c = (int)((seed >> 6) & 255u) - 128;
            d = (int)((seed >> 9) & 255u) - 128;

            chk = (unsigned int)(chk + (unsigned int)chain(a, b, c, d));
            chk = (unsigned int)(chk + (unsigned int)sat(a * 3));
            chk = (unsigned int)(chk + (unsigned int)classify(b + 128));
            chk &= 0xffffu;
        }
    }
    /* Fold the short-circuit count in: a compiler that evaluates both arms of
       a && gets a different number here. */
    return (unsigned int)((chk + probes) & 0xffffu);
}

#ifndef HOST_VERIFY
static void pred_run(void)
{
    unsigned int chk = pred_compute();
    Assert(chk == CHK, "predicate / branch-layout checksum (host-verified)");
}

int suite_pred(void)
{
    suite_setup("Predicate / Branch Layout Tests");
    suite_add_test(pred_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_pred();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", pred_compute()); return 0; }
#endif
