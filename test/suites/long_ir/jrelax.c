/* Branch relaxation (jp -> jr): the backend rewrites an in-range CFG branch to
 * the 2-byte relative form using an UPPER-BOUND size model over the rendered
 * function (ir_lower.c, filter_relax_branches). This test pins the shapes that
 * relaxation can get wrong:
 *
 *  - cond_mix    every conditional form that has a `jr` (nz/z/nc/c), taken and
 *                not-taken, so a swapped condition or a mis-parsed target shows
 *                up as a wrong sum. `po/pe/p/m` have NO jr form and must never
 *                be converted.
 *  - long_span   a forward branch over a body far larger than the +127 range.
 *                It must STAY `jp`. If the size bound is ever under-estimated
 *                the assembler refuses the build ("integer range") — so this
 *                function is a build-time canary as much as a runtime one.
 *  - nested      nested loops: the hot back edge and the in-loop UNCONDITIONAL
 *                jump (which relaxation deliberately leaves as `jp`, since it is
 *                taken every iteration), plus loop-depth attribution.
 *  - ji_shape    `jp cc,L / jp M / L:` — copt's #JI inverts this and needs BOTH
 *                jumps to still be `jp`, so the pass skips that window. Pins
 *                that the inversion still produces the right control flow.
 *
 * Self-verifying with explicit constants computed under identical 16-bit
 * arithmetic, so a miscompile fails an assert rather than matching a
 * consistently-wrong self-comparison. No printf (it would perturb allocation and
 * can mask exactly this class of bug — see the enigma family).
 */
#include "test.h"

static unsigned int g_sink;
static void sink(unsigned int x) { g_sink += x; }

/* Straight-line filler with real data dependencies, so the optimiser cannot
 * delete it and the emitted span genuinely exceeds the jr range. */
#define CHURN(v) do {                     \
        (v) = (unsigned int)((v) * 3u + 1u);   \
        (v) ^= (unsigned int)((v) >> 3);       \
        (v) = (unsigned int)((v) + 0x1234u);   \
        (v) = (unsigned int)(((v) << 1) | ((v) >> 15)); \
    } while (0)

/* Every jr-able condition, both directions, inside a loop. */
static unsigned int cond_mix(unsigned int n)
{
    unsigned int i, acc = 0;
    for (i = 0; i < n; i++) {
        if (i == 3u)            acc += 11u;      /* z  */
        if (i != 5u)            acc += 2u;       /* nz */
        if (i < 4u)             acc += 7u;       /* c  */
        if (i >= 6u)            acc += 5u;       /* nc */
        acc = (unsigned int)(acc + (i << 1));
    }
    return acc;
}

/* Forward branch over a body much longer than 127 bytes: must remain `jp`. */
static unsigned int long_span(unsigned int x)
{
    unsigned int v = x;
    if (x & 1u) {
        CHURN(v); CHURN(v); CHURN(v); CHURN(v);
        CHURN(v); CHURN(v); CHURN(v); CHURN(v);
        CHURN(v); CHURN(v); CHURN(v); CHURN(v);
        CHURN(v); CHURN(v); CHURN(v); CHURN(v);
        CHURN(v); CHURN(v); CHURN(v); CHURN(v);
        v = (unsigned int)(v + 1u);
    } else {
        v = (unsigned int)(v ^ 0xa5a5u);
    }
    return v;
}

/* Nested loops: back edges at two depths plus an in-loop unconditional jump
 * (the if/else join), which relaxation must leave alone. */
static unsigned int nested(unsigned int n)
{
    unsigned int i, j, acc = 0;
    for (i = 0; i < n; i++) {
        for (j = 0; j < 4u; j++) {
            if (((i + j) & 1u) != 0u)
                acc = (unsigned int)(acc + (i * 3u));
            else
                acc = (unsigned int)(acc ^ (j + 1u));   /* else-arm join = jp */
        }
        sink(acc);
    }
    return acc;
}

/* `jp cc,L / jp M / L:` — the copt #JI inversion window. */
static unsigned int ji_shape(unsigned int x)
{
    unsigned int r;
    if (x > 100u)
        r = 1u;
    else
        r = 2u;
    if (x == 7u)
        r = (unsigned int)(r + 40u);
    return r;
}

static void test_jrelax(void)
{
    g_sink = 0;

    assertEqual(cond_mix(0),  0u);
    assertEqual(cond_mix(1),  9u);
    assertEqual(cond_mix(7),  98u);
    assertEqual(cond_mix(12), 223u);

    assertEqual(long_span(0), 0xa5a5u);
    assertEqual(long_span(1), 52148u);
    assertEqual(long_span(2), 0xa5a7u);
    assertEqual(long_span(9), 25211u);

    assertEqual(nested(0), 0u);
    assertEqual(nested(1), 2u);
    assertEqual(nested(6), 106u);

    assertEqual(ji_shape(7),   42u);
    assertEqual(ji_shape(101), 1u);
    assertEqual(ji_shape(3),   2u);

    assertEqual(g_sink, 282u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Branch relaxation (jp->jr)");
    suite_add_test(test_jrelax);
    return suite_run();
}
