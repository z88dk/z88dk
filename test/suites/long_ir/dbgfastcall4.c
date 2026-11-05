/* Under -debug every function prologue calls l_debug_push_frame. A
 * __z88dk_fastcall long or float arrives in DEHL, so the helper must preserve
 * DE: the gbz80 one clobbered it, and the callee saw a different high word. */
#include "test.h"
#include <stdint.h>

/* The software frame-pointer chain (asm symbol __debug_framepointer). */
extern uint16_t _debug_framepointer;

static uint32_t gl;
static float gf;

static uint32_t fcl(uint32_t x) __z88dk_fastcall
{
    x = x + 70000;
    gl = x + gl;
    return x;
}

static float ffc(float a) __z88dk_fastcall
{
    a = a * 3;
    gf = a + gf;
    return a;
}

void test_dbgfastcall4(void)
{
    uint16_t fp0 = _debug_framepointer;

    gl = 1;
    assertEqual(fcl(1) == 70001UL, 1);
    /* the helper pair must leave the caller's frame pointer as it found it, or
       the debugger loses the caller's locals while the program still runs */
    assertEqual(_debug_framepointer == fp0, 1);
    assertEqual(gl == 70002UL, 1);
    gf = 1;
    assertEqual((int)ffc(2.0f), 6);
    assertEqual((int)gf, 7);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("-debug fastcall 4-byte parameter");
    suite_add_test(test_dbgfastcall4);
    return suite_run();
}
