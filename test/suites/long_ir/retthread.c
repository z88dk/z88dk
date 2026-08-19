/* Branch-to-return (`jp [cc,]L` -> `ret [cc]`): a branch whose target block is a
 * bare `ret` becomes the return itself, and the label is dropped (ir_lower.c,
 * emit_dropping_dead_bb_labels pass 0c/2). Shapes pinned here:
 *
 *  - store_if_new / skip_*  the one-armed `if` — the shape that converts, once
 *                   per condition. po/pe/p/m have no portable `ret cc` (gbz80
 *                   has no P/V flag); the CPU variants of this suite are the
 *                   build-time canary for that.
 *  - cc_*           the same conditions as early returns, where the `ret` is
 *                   already the fall-through and nothing may change.
 *  - two_arm        if/else join: the then-arm's unconditional `jp` -> `ret`.
 *  - ji_shape       `jp cc,L / jp M / L:` — copt's #JI inversion is cheaper, so
 *                   the pass vetoes both members.
 *  - scan           early return from a pointer walk: BC-homed pointer live on
 *                   the conditional ret's not-taken path. Breaks if instr_effects
 *                   calls a conditional `ret` a function boundary.
 *  - framed         return block is `ld sp,ix / pop ix / ret` — no rewrite.
 *
 * Explicit constants, no printf (it perturbs allocation and can mask this class
 * of bug — see the enigma family).
 */
#include "test.h"

static unsigned char g_b;
static unsigned int  g_calls;
static unsigned char g_hit;

/* One-armed if, void function: `jp z,L_ret` -> `ret z`. */
static void store_if_new(unsigned char a)
{
    if (a != g_b)
        g_b = a;
}

/* Early-return form: the `ret` is already the fall-through — nothing to do. */
static void cc_z(unsigned int x)  { if (x == 3u) return; g_calls = (unsigned int)(g_calls + 1u); }
static void cc_nz(unsigned int x) { if (x != 3u) return; g_calls = (unsigned int)(g_calls + 2u); }
static void cc_c(unsigned int x)  { if (x < 3u)  return; g_calls = (unsigned int)(g_calls + 4u); }
static void cc_nc(unsigned int x) { if (x >= 3u) return; g_calls = (unsigned int)(g_calls + 8u); }

/* Same conditions as one-armed ifs: the return block is now the branch target,
 * which is what becomes `ret cc`. Same semantics, so a swapped condition shows
 * up as a wrong sum either way. */
static void skip_z(unsigned int x)  { if (x != 3u) g_calls = (unsigned int)(g_calls + 64u); }
static void skip_nz(unsigned int x) { if (x == 3u) g_calls = (unsigned int)(g_calls + 128u); }
static void skip_c(unsigned int x)  { if (x >= 3u) g_calls = (unsigned int)(g_calls + 256u); }
static void skip_nc(unsigned int x) { if (x < 3u)  g_calls = (unsigned int)(g_calls + 512u); }

/* if/else join: the then-arm ends in an unconditional jump to the return. */
static void two_arm(unsigned int x)
{
    if ((x & 1u) != 0u)
        g_calls = (unsigned int)(g_calls + 16u);
    else
        g_calls = (unsigned int)(g_calls + 32u);
}

/* copt's #JI window: conditional jump then unconditional. Neither may convert. */
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

/* Early return from a pointer walk: BC live across the not-taken path. */
static void scan(const unsigned char *p, unsigned char k)
{
    g_hit = 0;
    while (*p) {
        if (*p == k) {
            g_hit = 1;
            return;
        }
        p++;
    }
}

/* The local array forces a frame, so the return block is a teardown, not a
 * bare `ret`, and the rewrite must not fire. */
static unsigned int framed(unsigned int n)
{
    unsigned char buf[6];
    unsigned int i, acc = 0;
    for (i = 0; i < 6u; i++)
        buf[i] = (unsigned char)(n + i);
    if (n == 0u)
        return 0u;
    for (i = 0; i < 6u; i++)
        acc = (unsigned int)(acc + buf[i]);
    return acc;
}

static void test_retthread(void)
{
    static const unsigned char abc[6] = { 'a', 'b', 'c', 'd', 'e', 0 };

    g_calls = 0;
    g_b = 0;

    store_if_new(7);
    assertEqual(g_b, 7u);
    store_if_new(7);                 /* condition taken: the `ret z` path */
    assertEqual(g_b, 7u);
    store_if_new(9);
    assertEqual(g_b, 9u);

    cc_z(4);   assertEqual(g_calls, 1u);
    cc_z(3);   assertEqual(g_calls, 1u);
    cc_nz(3);  assertEqual(g_calls, 3u);
    cc_nz(9);  assertEqual(g_calls, 3u);
    cc_c(5);   assertEqual(g_calls, 7u);
    cc_c(1);   assertEqual(g_calls, 7u);
    cc_nc(1);  assertEqual(g_calls, 15u);
    cc_nc(5);  assertEqual(g_calls, 15u);

    two_arm(1); assertEqual(g_calls, 31u);
    two_arm(2); assertEqual(g_calls, 63u);

    skip_z(4);   assertEqual(g_calls, 127u);
    skip_z(3);   assertEqual(g_calls, 127u);
    skip_nz(3);  assertEqual(g_calls, 255u);
    skip_nz(9);  assertEqual(g_calls, 255u);
    skip_c(5);   assertEqual(g_calls, 511u);
    skip_c(1);   assertEqual(g_calls, 511u);
    skip_nc(1);  assertEqual(g_calls, 1023u);
    skip_nc(5);  assertEqual(g_calls, 1023u);

    assertEqual(ji_shape(7),   42u);
    assertEqual(ji_shape(101), 1u);
    assertEqual(ji_shape(3),   2u);

    scan(abc, 'c'); assertEqual(g_hit, 1u);
    scan(abc, 'z'); assertEqual(g_hit, 0u);
    scan(abc, 'a'); assertEqual(g_hit, 1u);

    assertEqual(framed(0), 0u);
    assertEqual(framed(1), 21u);     /* 1+2+3+4+5+6 */
    assertEqual(framed(2), 27u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Branch-to-return (jp cc,L_ret -> ret cc)");
    suite_add_test(test_retthread);
    return suite_run();
}
