/* Ranged BC home for a reassigned PARAM (the call-split's read-only span).
 *
 * `lcg` is the shape that motivated it: a parameter multiplied by a multi-bit
 * constant, so the strength-reduced Horner chain reads the multiplicand 7-8
 * times in one write-free burst. That burst is a rich read-only span, so the
 * param earns BC over it and the chain becomes `add hl,bc` with no reloads.
 *
 * THE HAZARD this pins (it miscompiled first): the span is read-only, but the
 * param is REASSIGNED once per iteration OUTSIDE the span, and the loop body
 * also uses BC transiently as a deref base for the array store. The BC belief
 * must therefore NOT be carried across the loop BACK EDGE — every iteration
 * after the first would otherwise multiply a stale value. `bins` makes the
 * transient BC use real, and the checksum only matches if each iteration reads
 * the freshly-assigned seed.
 *
 * Self-verifying with explicit constants under 16-bit arithmetic; no printf
 * (it perturbs allocation and can mask exactly this bug).
 */
#include "test.h"

static unsigned int bins[8];

/* Reassigned param + a multi-bit constant multiply + an indexed RMW that wants
 * BC for the address — the histbench kernel in miniature. */
static unsigned int lcg(unsigned int seed, unsigned int n)
{
    unsigned int i;
    for (i = 0; i < n; i++) {
        seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
        bins[(seed >> 3) & 7u]++;                /* transient BC deref base */
    }
    return seed;
}

/* Same multiplicand-reuse burst with no loop: the span is the whole chain. */
static unsigned int scale(unsigned int x)
{
    return (unsigned int)(x * 25173u);
}

/* A param read many times but never reassigned — the plain read-only case. */
static unsigned int poly(unsigned int x)
{
    return (unsigned int)(x * 31u + x * 7u + x);
}

static void test_csparam(void)
{
    unsigned int i;
    for (i = 0; i < 8u; i++) bins[i] = 0;

    assertEqual(lcg(1u, 0u), 1u);                /* 0-trip: seed untouched */
    assertEqual(lcg(1u, 1u), 39022u);
    assertEqual(lcg(1u, 5u), 3882u);
    assertEqual(lcg(0x0777u, 50u), 20213u);

    assertEqual(scale(1u),   25173u);
    assertEqual(scale(3u),   9983u);
    assertEqual(scale(0u),   0u);

    assertEqual(poly(1u),    39u);
    assertEqual(poly(100u),  3900u);

    /* Fold the bins: wrong only if some iteration used a stale seed. */
    {
        unsigned int chk = 0;
        for (i = 0; i < 8u; i++)
            chk = (unsigned int)(chk + bins[i] * (unsigned int)(i + 1u));
        assertEqual(chk, 258u);
    }
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Ranged BC home for a reassigned param");
    suite_add_test(test_csparam);
    return suite_run();
}
