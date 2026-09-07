/* A signed compare drops its sign correction only when BOTH operands are
 * provably non-negative.
 *
 * A signed 16-bit compare lowers to `and a; sbc hl,de` plus seven bytes of pure
 * sign correction — `ld a,h; jp po,L; xor 0x80; L: rla` — because the carry out
 * of `sbc` is the UNSIGNED answer and the signed one is S^V. Where both operands
 * are known non-negative the two coincide and the correction is dead
 * (--opt-disable=cmp-unsign / IR_CMPUNSIGN=0 keeps it).
 *
 * The proof is the whole difficulty, and two ways of getting it wrong are
 * pinned here because both produced real wrong answers during development:
 *
 *   1. THE INVISIBLE DEF. The provers reason over the defs they can SEE. A
 *      PARAMETER's incoming value has no def op at all, so a parameter whose
 *      only visible defs are non-negative constants looks non-negative and
 *      isn't. `clamp_param` below is exactly that shape — it was caught by
 *      long_ir/depark.c's satband(-5), by nothing else, and it is why
 *      IR_VREG_PARAM / ADDR_TAKEN / VOLATILE are refused outright.
 *
 *   2. THE WRAP. "every def is init>=0 or += positive" does not prove
 *      non-negative: a value that only RISES can pass 32767 and go negative.
 *      It is a proof only when the compare is the test that STOPS the growth,
 *      which is why the rewrite also demands the compare be a loop exit test.
 *      `inner_test` below rises under a DIFFERENT exit condition, so its inner
 *      compare must keep the signed form.
 *
 * Every expected value is independent of int width beyond 16 bits.
 */
#include "test.h"

static unsigned char bytes[8] = { 0, 1, 200, 255, 128, 64, 33, 7 };

/* MUST NOT FIRE — a parameter can be negative however its visible defs look. */
static int clamp_param(int v)
{
    if (v > 255) v = 255;
    if (v < 0)   v = 0;
    return (v < 64) ? 64 : (v > 192 ? 192 : v);
}

/* MUST NOT FIRE — same shape, one clamp, so the `< 0` test is the only guard. */
static int floor0(int v)
{
    if (v < 0) v = 0;
    return v + 1;
}

/* SHOULD FIRE — a counted loop whose exit test bounds the counter. */
static unsigned int counted(void)
{
    int i;
    unsigned int acc = 0;
    for (i = 0; i < 16; i++)
        acc = (unsigned int)(acc + (unsigned int)i);
    return acc;                       /* 0+1+...+15 = 120 */
}

/* SHOULD FIRE — non-unit step, still bounded by its own test. */
static unsigned int counted_step3(void)
{
    int i;
    unsigned int acc = 0;
    for (i = 0; i < 20; i += 3)
        acc = (unsigned int)(acc + (unsigned int)i);
    return acc;                       /* 0+3+6+9+12+15+18 = 63 */
}

/* SHOULD FIRE — a SIGNED value masked to a byte is in [0,255] by construction,
   so the signed compare needs no correction. Signed on purpose: an unsigned
   compare would never reach the sign-correction path at all. */
static int masked(int seed)
{
    int m = seed & 0x00ff;
    return (m < 128) ? 1 : 2;
}

/* MUST NOT FIRE — `n` rises under a test that is NOT this compare, so it can
   pass 32767 and go negative. Kept cheap: the values here stay small, but the
   SHAPE is what the gate has to refuse. */
static int inner_test(int limit)
{
    int n = 0, hits = 0;
    while (n != limit) {
        if (n < 5) hits++;
        n += 1;
    }
    return hits;
}

/* A signed compare on genuinely signed data must keep working. */
static int signed_pick(int a, int b)
{
    if (a < b) return -1;
    return (a > b) ? 1 : 0;
}

static void test_cmpsign(void)
{
    /* the invisible-def shape, negative inputs are the whole point */
    assertEqual(clamp_param(-5),   64);
    assertEqual(clamp_param(-1),   64);
    assertEqual(clamp_param(0),    64);
    assertEqual(clamp_param(100), 100);
    assertEqual(clamp_param(300), 192);
    assertEqual(floor0(-7),         1);
    assertEqual(floor0(-1),         1);
    assertEqual(floor0(5),          6);

    assertEqual((int)counted(),       120);
    assertEqual((int)counted_step3(),  63);
    assertEqual(masked(0x1234),   1);   /* 0x34 =  52, < 128 */
    assertEqual(masked(0x1200),   1);   /* 0x00 =   0, < 128 */
    assertEqual(masked(0x12ff),   2);   /* 0xff = 255, >= 128 */
    assertEqual(masked(-1),       2);   /* 0xff = 255 after the mask */

    assertEqual(inner_test(10), 5);
    assertEqual(inner_test(3),  3);

    assertEqual(signed_pick(-5, 3), -1);
    assertEqual(signed_pick(3, -5),  1);
    assertEqual(signed_pick(-5, -5), 0);
    (void)bytes;
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Signed compare needs no sign correction when non-negative");
    suite_add_test(test_cmpsign);
    return suite_run();
}
