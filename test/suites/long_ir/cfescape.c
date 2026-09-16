/* [const-fold] A local whose ADDRESS ESCAPES is not a known constant.
 *
 * `ir_opt_const_fold` tracked a local's constant initialiser and cleared the
 * belief only on a REDEFINITION — so a call handed the local's address could
 * write it and the fold kept the old value:
 *
 *     unsigned int a = 0; bump(&a); return a + x;     ->     return x;
 *
 * A silent wrong answer on ordinary C, in BOTH frame modes, on every CPU. gcc
 * and sccz80 both say `a + x`. Found while building the ez80 `lea` rung: this
 * exact shape was written as a codegen test, and it failed for a reason that
 * had nothing to do with the rung. adr/0082.
 *
 *  - c_init   the bug: constant initialiser, address escapes, value used in
 *             later arithmetic. Was 5, must be 6.
 *  - c_twice  two escaping calls, so a fix that only handles the first is
 *             still caught. Was 5, must be 7.
 *  - v_init   the control that always worked: a NON-constant initialiser was
 *             never tracked, so the fold never had a stale belief to use.
 *  - c_plain  the other control that always worked: `return a` reads the slot,
 *             with no arithmetic for the fold to rewrite.
 *  - c_fold   folding must still HAPPEN where nothing escapes — this is the
 *             half a blunt fix would break, and it is pinned by value rather
 *             than by inspecting the asm.
 */
#include "test.h"

static unsigned int g_zero;

static void bump(unsigned int *q) { *q += 1u; }
static void bump2(unsigned int *q) { *q += 2u; }

static unsigned int c_init(unsigned int x)
{
    unsigned int a = 0;

    bump(&a);
    return (unsigned int)((a + x) & 0xffffu);
}

static unsigned int c_twice(unsigned int x)
{
    unsigned int a = 0;

    bump(&a);
    bump2(&a);
    return (unsigned int)((a + x) & 0xffffu);
}

static unsigned int v_init(unsigned int x)
{
    unsigned int a = g_zero;

    bump(&a);
    return (unsigned int)((a + x) & 0xffffu);
}

static unsigned int c_plain(void)
{
    unsigned int a = 0;

    bump(&a);
    return a;
}

/* No escape: the fold is free to turn `a + x` into `x` and `b * 1` into `b`. */
static unsigned int c_fold(unsigned int x)
{
    unsigned int a = 0, b = 1;

    return (unsigned int)(((a + x) * b) & 0xffffu);
}

void test_cfescape(void)
{
    g_zero = 0;

    assertEqual(c_init(0u), 1u);
    assertEqual(c_init(5u), 6u);
    assertEqual(c_init(0xffffu), 0u);

    assertEqual(c_twice(0u), 3u);
    assertEqual(c_twice(5u), 8u);

    assertEqual(v_init(5u), 6u);
    assertEqual(c_plain(), 1u);

    assertEqual(c_fold(0u), 0u);
    assertEqual(c_fold(9u), 9u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("address-escaped locals are not constants");
    suite_add_test(test_cfescape);
    return suite_run();
}
