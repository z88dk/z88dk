/* idx2 live-range reuse: the spare index register (IX, or IY in sp-mode) may
 * now host more than one vreg per function, as long as their live ranges
 * never overlap — previously a single boolean gave the whole function's idx2
 * slot to the first candidate that won it, regardless of whether a later
 * candidate's window ever actually conflicted with the winner's.
 *
 * span: a read-only invariant param `p` used only in an early, short loop,
 * and a stepping counter `c` used only in a later, disjoint loop. Their live
 * ranges never overlap, so both are eligible to share the slot.
 *
 * span_overlap: the same shape, but `p` is read again AFTER the counter's
 * loop, so its live range now genuinely spans across `c`'s — the correctness
 * boundary this test exists to guard. Sharing one physical register between
 * two vregs whose live ranges truly overlap corrupts one of them; wrong
 * output here means the overlap test regressed, not the allocation choice. */
#include "test.h"

static const unsigned char tab[16] = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
};

static unsigned int span(const unsigned char *t, unsigned int p, unsigned int n)
{
    unsigned int acc = 0, i, c;
    for (i = 0; i < 4; i++)
        acc = (unsigned int)((acc + t[p + i]) & 0xffffu);
    for (c = 0; c < n; c++)
        acc = (unsigned int)((acc + t[c & 7u]) & 0xffffu);
    return acc & 0xffffu;
}

static unsigned int span_overlap(const unsigned char *t, unsigned int p, unsigned int n)
{
    unsigned int acc = 0, i, c;
    for (i = 0; i < 4; i++)
        acc = (unsigned int)((acc + t[p + i]) & 0xffffu);
    for (c = 0; c < n; c++)
        acc = (unsigned int)((acc + t[c & 7u]) & 0xffffu);
    acc = (unsigned int)((acc + t[p]) & 0xffffu);
    return acc & 0xffffu;
}

static void test_idx2reuse(void)
{
    assertEqual(span(tab, 0u, 8u), 46u);
    assertEqual(span(tab, 2u, 20u), 100u);

    assertEqual(span_overlap(tab, 0u, 8u), 47u);
    assertEqual(span_overlap(tab, 2u, 20u), 103u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("idx2 live-range reuse");
    suite_add_test(test_idx2reuse);
    return suite_run();
}
