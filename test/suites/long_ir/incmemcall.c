/* A global byte stepped in memory before a call: the step goes through HL as
 * `inc (hl)` when the callee ignores A, and keeps the value in A when the
 * callee is __sdcccall(1) and takes that byte in A. A function returning in L
 * lets the step reach `ret` without keeping A.
 */
#include "test.h"

static unsigned char sel;
static unsigned char seen;

void note(void) { seen = (unsigned char)(seen + 1); }

unsigned char sc_take(unsigned char v) __sdcccall(1);
unsigned char sc_take(unsigned char v) __sdcccall(1) { return (unsigned char)(v + 100); }

static void step_note(void)
{
    ++sel;
    note();
}

static unsigned char step_sc(void)
{
    ++sel;
    return sc_take(sel);
}

static unsigned char step_ret(void)
{
    --sel;
    return 0;
}

static void check(void)
{
    sel = 5; seen = 0;
    step_note();
    assertEqual(sel, 6);
    assertEqual(seen, 1);
    assertEqual(step_sc(), 107);
    assertEqual(sel, 7);
    assertEqual(step_ret(), 0);
    assertEqual(sel, 6);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("global byte step before a call");
    suite_add_test(check);
    return suite_run();
}
