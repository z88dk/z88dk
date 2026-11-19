/* `_Float16 OP <double literal>` stays in _Float16. Strict C promotes to
 * double, which needs the math48 helpers (l_f48_*) that --math16 does not
 * link (examples/z88/cubeflt16 failed to link). The literal is narrowed to
 * _Float16 instead, as sccz80 does. The makefile rule also checks the asm
 * for double-tier helpers. */
#include "test.h"

volatile _Float16 a, b;

static void lit(void)
{
    b = 3;
    a = b * 0.5;  assertEqual((int)(a * 2), 3);
    a = b + 1.0;  assertEqual((int)a, 4);
    a = 2.0 - b;  assertEqual((int)a, -1);
    a = b / 3.0;  assertEqual((int)a, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("_Float16 double-literal operand");
    suite_add_test(lit);
    return suite_run();
}
