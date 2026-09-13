/* Tail merging / cross-jumping (IR_TAILMERGE, ir_lower.c filter_tail_merge):
 * a run of instructions ending at an UNCONDITIONAL terminator that appears
 * identically at two or more places is kept once, and every other copy becomes
 * a `jp` to a label on the survivor. This test pins the shapes it can get
 * wrong:
 *
 *  - many_exits    several `return`s with the SAME tail, so the epilogue is
 *                  duplicated and merged. The headline shape.
 *  - cond_tails    tails ending in a CONDITIONAL branch. Merging one would also
 *                  redirect its FALL-THROUGH path, which the two sites do not
 *                  share -- the one rule whose violation miscompiles. Each arm
 *                  falls through to a DIFFERENT value, so a merged conditional
 *                  tail returns the wrong answer rather than merely running
 *                  slower.
 *  - shared_jump   blocks that do the same shuffle and then jump to the SAME
 *                  label: the near-free case the pass exists for. The values
 *                  differ per arm so a wrong retarget is visible.
 *  - label_inside  a tail whose interior carries a branch TARGET. The run may
 *                  not be merged across it -- control can enter mid-run, and a
 *                  merged copy would lose that entry.
 *  - deep_tail     a long shared suffix (deepest-first clustering must take the
 *                  whole run, not a 4-instruction prefix of it).
 *
 * Self-verifying against explicit constants under identical 16-bit arithmetic,
 * so a miscompile fails an assert rather than matching a consistently-wrong
 * self-comparison. No printf (it perturbs allocation and can mask exactly this
 * class of bug -- see the enigma family).
 */
#include "test.h"

static unsigned int g_sink;
static void sink(unsigned int x) { g_sink = (unsigned int)(g_sink + x); }

/* Several returns sharing one epilogue: the repeated-teardown shape. Locals
 * force a real frame so the teardown is more than a bare `ret`. */
static unsigned int many_exits(unsigned int a, unsigned int b)
{
    unsigned int t[4];
    t[0] = (unsigned int)(a + 1u);
    t[1] = (unsigned int)(b + 2u);
    t[2] = (unsigned int)(a ^ b);
    t[3] = (unsigned int)(a * 3u);
    if (a == 0u) return (unsigned int)(t[0] + t[1]);
    if (b == 0u) return (unsigned int)(t[1] + t[2]);
    if (a == b)  return (unsigned int)(t[2] + t[3]);
    if (a > b)   return (unsigned int)(t[3] + t[0]);
    return (unsigned int)(t[0] + t[2]);
}

/* Tails ending in a CONDITIONAL branch, whose fall-through arms differ. If a
 * conditional tail is ever merged, one arm's fall-through lands in the other's
 * successor and these sums change. */
static unsigned int cond_tails(unsigned int n)
{
    unsigned int acc = 0, i;
    for (i = 0; i < n; i++) {
        if (i & 1u) {
            if (i > 4u) acc = (unsigned int)(acc + 100u);
            acc = (unsigned int)(acc + 3u);      /* fall-through A */
        } else {
            if (i > 4u) acc = (unsigned int)(acc + 100u);
            acc = (unsigned int)(acc + 7u);      /* fall-through B */
        }
    }
    return acc;
}

/* Same shuffle then the same target label: retarget the jump earlier. */
static unsigned int shared_jump(unsigned int x, unsigned int y)
{
    unsigned int r = 0;
    switch (x & 3u) {
        case 0: r = (unsigned int)(y + 1u); sink(r); break;
        case 1: r = (unsigned int)(y + 2u); sink(r); break;
        case 2: r = (unsigned int)(y + 3u); sink(r); break;
        default: r = (unsigned int)(y + 4u); sink(r); break;
    }
    return (unsigned int)(r * 2u);
}

/* A branch target sits INSIDE what would otherwise be a shared tail. */
static unsigned int label_inside(unsigned int n)
{
    unsigned int acc = 0, i = 0;
again:
    acc = (unsigned int)(acc + i);
    if (i < n) { i++; goto again; }
    acc = (unsigned int)(acc ^ 0x5a5au);
    sink(acc);
    return acc;
}

/* A long identical suffix on both arms. */
static unsigned int deep_tail(unsigned int x)
{
    unsigned int v;
    if (x & 1u) {
        v = (unsigned int)(x + 11u);
        v = (unsigned int)(v * 3u);
        v ^= 0x0f0fu;
        v = (unsigned int)(v + 7u);
        v = (unsigned int)(v << 1);
        v ^= 0x1234u;
        return (unsigned int)(v + 9u);
    }
    v = (unsigned int)(x + 6u);
    v = (unsigned int)(v * 3u);
    v ^= 0x0f0fu;
    v = (unsigned int)(v + 7u);
    v = (unsigned int)(v << 1);
    v ^= 0x1234u;
    return (unsigned int)(v + 9u);
}

static void test_tailmerge(void)
{
    g_sink = 0;

    assertEqual(many_exits(0, 0), 3u);
    assertEqual(many_exits(0, 5), 8u);
    assertEqual(many_exits(4, 0), 6u);
    assertEqual(many_exits(3, 3), 9u);
    assertEqual(many_exits(9, 2), 37u);
    assertEqual(many_exits(2, 9), 14u);

    assertEqual(cond_tails(0),  0u);
    assertEqual(cond_tails(1),  7u);
    assertEqual(cond_tails(2),  10u);
    assertEqual(cond_tails(6),  130u);
    assertEqual(cond_tails(9),  447u);

    assertEqual(shared_jump(0, 10), 22u);
    assertEqual(shared_jump(1, 10), 24u);
    assertEqual(shared_jump(2, 10), 26u);
    assertEqual(shared_jump(3, 10), 28u);

    assertEqual(label_inside(0), 23130u);
    assertEqual(label_inside(4), 23120u);

    assertEqual(deep_tail(0), 3205u);
    assertEqual(deep_tail(1), 3161u);
    assertEqual(deep_tail(8), 3189u);

    assertEqual(g_sink, 46300u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Tail merging (cross-jumping)");
    suite_add_test(test_tailmerge);
    return suite_run();
}
