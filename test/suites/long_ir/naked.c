/* What a __naked body may contain (ir_build naked_stmt_is_frameless, and the
 * naked emit path in ir_lower).
 *
 * The old rule was "one asm block, or a compound of asm statements". It did
 * not recurse, so `__asm__("…")` — which parses as a call expression and
 * arrives as a compound inside a compound — was refused outright; only the
 * `#asm` spelling compiled. It also refused argument-free calls, which need
 * no frame, and the `do { … } while(0)` wrapper. z88dk's FreeRTOS port writes
 * its context switch as asm blocks around `xTaskIncrementTick();
 * vTaskSwitchContext();`.
 *
 * The lowerer's naked path emitted IR_ASM and silently skipped everything
 * else, so allowing calls through without teaching it to render them would
 * have dropped them. These functions check their side effects, so a dropped
 * call fails the test rather than just changing the asm.
 */
#include "test.h"

static int g_ticks;
static int g_switches;

static void tick(void)   { g_ticks++; }
static void switcher(void) { g_switches++; }

/* 1: the `#asm` spelling — the only one that used to work. */
static void naked_hash_asm(void) __naked
{
#asm
    ret
#endasm
}

/* 2: a single `__asm__()` statement. */
static void naked_one_asm(void) __naked
{
    __asm__("ret");
}

/* 3: several `__asm__()` statements. */
static void naked_two_asm(void) __naked
{
    __asm__("nop");
    __asm__("ret");
}

/* 4: the FreeRTOS shape — asm around argument-free calls. */
static void naked_calls(void) __naked
{
    __asm__("nop");
    tick();
    switcher();
    __asm__("ret");
}

/* 5: the same, with every part wrapped in `do { } while(0)` as the port
 * macros write it. */
static void naked_do_while(void) __naked
{
    do { __asm__("nop"); } while (0);
    do { tick(); } while (0);
    __asm__("ret");
}

static void test_naked(void)
{
    g_ticks = 0;
    g_switches = 0;

    naked_hash_asm();
    naked_one_asm();
    naked_two_asm();
    assertEqual(g_ticks, 0);
    assertEqual(g_switches, 0);

    /* The calls must actually be emitted, not dropped. */
    naked_calls();
    assertEqual(g_ticks, 1);
    assertEqual(g_switches, 1);

    naked_calls();
    assertEqual(g_ticks, 2);
    assertEqual(g_switches, 2);

    naked_do_while();
    assertEqual(g_ticks, 3);
    assertEqual(g_switches, 2);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("__naked bodies: asm blocks and argument-free calls");
    suite_add_test(test_naked);
    return suite_run();
}
