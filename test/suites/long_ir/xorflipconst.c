/* Post-render fold of the signed-comparison sign-flip trick against a
 * compile-time constant (ir_lower.c fold_const_xorflip, `[IR_XORFLIP_FOLD]`,
 * `xorflip-const`). On CPUs without `sbc hl,de` (gbz80, 8080, vm1 — z80
 * never needs this: it has `sbc hl,de` plus an overflow-flag check), a
 * signed comparison flips the sign bit of both operands' high bytes and
 * compares as unsigned:
 *
 *     ld de,11        <- one side is a compile-time constant
 *     ...
 *     ld a,d          <- d is PROVABLY 0 (11's high byte) here
 *     xor 0x80        <- so d^0x80 is PROVABLY 0x80, always
 *     ld d,a
 *
 * The flip only needs computing at runtime when the operand is NOT known at
 * compile time. When it is, the compiler can fold the flip into the
 * constant's own immediate load and delete the three-instruction runtime
 * flip entirely.
 *
 * Found mining examples/console/*.c compiled +test -clib=gbz80: 216 real
 * hits (probe-verified) across 28 files, plus 19 on the corpus (not a
 * corpus-only artifact — real interactive apps just have far more
 * signed-comparison-against-a-constant code, e.g. loop bounds and menu
 * indices, than the synthetic bench corpus). z80 = 0 hits everywhere
 * (confirmed no-op on the CPU family with a native `sbc hl,de`).
 *
 * cmp_lt_const(): the exact shape — one side of `<` is a literal. Proven to
 * fire by diffing `-a` output with IR_OFF=xorflip-const: `ld de,11` becomes
 * `ld de,32779` (11 with the high byte's sign bit pre-flipped, 0x800B) and
 * the three-line runtime flip disappears.
 *
 * cmp_lt_var(): the valuable half — BOTH sides are runtime values, so
 * neither flip has a compile-time-constant operand to fold into. Proven NOT
 * to fire the same way: byte-identical between gate on and off.
 *
 * A wrong fold here does not abort — a mis-flipped constant just makes the
 * comparison return the wrong side for values near the flip boundary.
 * assertEqual catches that as a wrong boolean, not a crash.
 */
#include "test.h"

static int cmp_lt_const(int v) { return v < 11; }
static int cmp_lt_var(int v, int w) { return v < w; }

static void test_xorflipconst(void)
{
    assertEqual(cmp_lt_const(5), 1);
    assertEqual(cmp_lt_const(11), 0);
    assertEqual(cmp_lt_const(20), 0);
    assertEqual(cmp_lt_const(-5), 1);

    assertEqual(cmp_lt_var(5, 20), 1);
    assertEqual(cmp_lt_var(20, 5), 0);
    assertEqual(cmp_lt_var(5, 5), 0);
    assertEqual(cmp_lt_var(-5, 5), 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Post-render const-operand sign-flip fold");
    suite_add_test(test_xorflipconst);
    return suite_run();
}
