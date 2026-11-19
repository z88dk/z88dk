/* `_Float16 OP <double literal>` stays in _Float16. Strict C promotes to
 * double, which needs the math48 helpers (l_f48_*) that --math16 does not
 * link (examples/z88/cubeflt16 failed to link). The literal is narrowed to
 * _Float16 instead, as sccz80 does. The makefile rule also checks the asm
 * for double-tier helpers. */
#include "test.h"

volatile _Float16 a, b;

static _Float16 twice(_Float16 x) { return x + x; }

static void lit(void)
{
    b = 3;
    a = b * 0.5;  assertEqual((int)(a * 2), 3);
    a = b + 1.0;  assertEqual((int)a, 4);
    a = 2.0 - b;  assertEqual((int)a, -1);
    a = b / 3.0;  assertEqual((int)a, 1);
}

/* Compound assignment, initialiser, comparison, call result, and a constant
 * expression of double literals all stay in _Float16 too. */
static void more(void)
{
    volatile _Float16 x = 0.5;
    b = 3;
    a = 1;     a += 0.5;  assertEqual((int)(a * 2), 3);
    a = 3;     a *= 0.5;  assertEqual((int)(a * 2), 3);
    assertEqual((int)(x * 2), 1);
    assertEqual(b < 3.5, 1);
    assertEqual(b > 3.5, 0);
    a = twice(b) * 2.0;   assertEqual((int)a, 12);
    a = (8.0 - 2.0 * 1.5) * b + 1.0;   assertEqual((int)a, 16);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("_Float16 double-literal operand");
    suite_add_test(lit);
    suite_add_test(more);
    return suite_run();
}
