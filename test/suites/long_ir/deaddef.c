/* Per-BB dead-def elimination (ir_opt_dead_defs, --opt-disable=dead-def).
 * A def whose vreg is redefined later in the SAME basic block with no read in
 * between is removed: every later reader sees the second def, and the first def
 * already killed whatever preceded it.
 *
 * The producer is the short delegating function `int r = 0; r += f();` —
 * const-fold rewrites `0 + f()` into a direct define of r by the CALL (which is
 * what lets the frame disappear) and strands the `LD_IMM r <- 0`. ir_opt_dce
 * cannot reclaim it: it counts uses PER VREG and r is still read afterwards.
 *
 * THE HAZARD this pins (it shipped a miscompile once): a BB here may contain a
 * MID-BLOCK conditional branch, so "later in the same BB" does NOT mean "always
 * executes". If control leaves at the branch, a successor reads the FIRST def —
 * removing it is wrong. `stepped_loop` and `early_out` build exactly that shape
 * (a self-increment, then a conditional exit, then a redefinition); the first
 * version of the pass deleted the increment and long_ir/umaxd failed.
 *
 * Self-verifying with explicit constants; no printf.
 */
#include "test.h"

static unsigned int g_calls;
static unsigned int leaf(unsigned int x) { g_calls++; return (unsigned int)(x * 2u + 3u); }

/* The target shape: init is dead, the call defines the value. */
static unsigned int delegate(unsigned int a)
{
    unsigned int r = 0;
    r += leaf(a);
    return r;
}

/* Same, with the init genuinely used first (must NOT be removed). */
static unsigned int accumulate(unsigned int a)
{
    unsigned int r = 5u;
    r += leaf(a);                 /* reads r, so `r = 5` is live */
    return r;
}

/* Self-increment, conditional exit, then a redefinition later in the block:
 * the increment must survive, because the taken path leaves before the redef. */
static unsigned int stepped_loop(unsigned int n)
{
    unsigned int i = 0, acc = 0;
    while (i < n) {
        i++;                      /* def of i */
        if (i == 3u) return (unsigned int)(acc + i);   /* reads the increment */
        acc = (unsigned int)(acc + i);
        i = (unsigned int)(i + 0u);                    /* redef of i */
    }
    return acc;
}

/* A value defined, then a conditional escape, then redefined. */
static unsigned int early_out(unsigned int a)
{
    unsigned int v = (unsigned int)(a + 1u);
    if (a > 10u) return v;        /* the taken path reads the FIRST def */
    v = leaf(a);
    return v;
}

static void test_deaddef(void)
{
    g_calls = 0;
    assertEqual(delegate(4),   11u);      /* 4*2+3 */
    assertEqual(delegate(0),   3u);
    assertEqual(accumulate(4), 16u);      /* 5 + 11 */

    assertEqual(stepped_loop(0),  0u);
    assertEqual(stepped_loop(2),  3u);    /* 1 + 2 */
    assertEqual(stepped_loop(9),  6u);    /* returns acc+i at i==3: (1+2)+3 */

    assertEqual(early_out(20), 21u);      /* first def, via the early return */
    assertEqual(early_out(3),  9u);       /* 3*2+3, the redef */

    assertEqual(g_calls, 4u);   /* early_out(20) returns before calling */
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Per-BB dead-def elimination");
    suite_add_test(test_deaddef);
    return suite_run();
}
