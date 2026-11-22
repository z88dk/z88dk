/* Post-render fold of a chained signed-comparison range check that
 * re-derives the sign-flipped value from scratch at each step instead of
 * keeping it (ir_lower.c fold_xorflip_chain, `[IR_XORFLIP_CHAIN_FOLD]`,
 * `xorflip-chain`). Found next to the const-operand fold in
 * examples/othello.c's board-bounds checks:
 *
 *     xor 0x80        <- A already flipped from an earlier `xor 0x80`
 *     cp N1
 *     jp/jr cc,LABEL  <- taken path: untouched by this fold
 *     ld a,(hl)        \  fall-through: reload the ORIGINAL value...
 *     xor 0x80          | ...then flip it AGAIN
 *     cp N2
 *
 * Algebraically: right before the branch, A == V^0x80 for whatever V the
 * earlier flip started from. Neither `cp` nor the branch touches A or the
 * memory at `(hl)`, so on the fall-through path the reload+re-flip just
 * computes `(V^0x80 reload) -> V -> V^0x80` — exactly what's already in A.
 * Deleting the reload and re-flip is a pure no-op removal.
 *
 * in_range() reproduces the exact real shape (fall-through continues to the
 * next check, the taken branch jumps AWAY to a shared failure path) that
 * `v < LOW || v >= HIGH` compiles to — the valuable structural detail: an
 * `if (v<A) ...; if (v<B) ...;` shape with a RETURN inside the first branch
 * does NOT reproduce this (the compiler inserts a label between the branch
 * and the reload for that shape, which this fold deliberately does not
 * cross — see the function comment in ir_lower.c). Proven to fire by
 * diffing `-a` output with IR_OFF=xorflip-chain: exactly one
 * `ld a,(hl)` + `xor 0x80` pair disappears.
 *
 * A wrong fold here does not abort — a stale flipped value would make the
 * SECOND half of the range check silently use the wrong sign convention,
 * so a value just outside (or inside) the true range would be misclassified.
 * assertEqual catches that as a wrong boolean, not a crash.
 */
#include "test.h"

static int in_range(char v)
{
    if (v < 5 || v >= 10) return 0;
    return 1;
}

static void test_xorflipchain(void)
{
    assertEqual(in_range(0), 0);
    assertEqual(in_range(4), 0);
    assertEqual(in_range(5), 1);
    assertEqual(in_range(9), 1);
    assertEqual(in_range(10), 0);
    assertEqual(in_range(-5), 0);
    assertEqual(in_range(-1), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Post-render chained sign-flip fold");
    suite_add_test(test_xorflipchain);
    return suite_run();
}
