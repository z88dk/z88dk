/* A value defined before an if/else and updated on both arms, with the else
 * arm laid out after the join so it jumps to a lower-numbered block. That jump
 * is not a loop, but the id-based back-edge test treated it as one and homed
 * the value in IY as a loop-carried accumulator. These functions have no loop,
 * so no IY may appear in their code (the asm check builds with -DASMONLY).
 */
#include <stdint.h>
#include "test.h"

int across(int v)
{
    int n = v >> 1;
    if (v & 1) n = n + 3; else n = n - 3;
    return n;
}

int across_sub(int v)
{
    int n = v + 100;
    if (v < 0) n = n - v; else n = n + v;
    return n;
}

#ifndef ASMONLY
static int ref_across(volatile int v)
{
    int n = v >> 1;
    if (v & 1) n = n + 3; else n = n - 3;
    return n;
}

static int ref_across_sub(volatile int v)
{
    int n = v + 100;
    if (v < 0) n = n - v; else n = n + v;
    return n;
}

/* a real loop-carried accumulator must still work */
static int loop_sum(const int *p, int n)
{
    int s = 0;
    while (n--) s += *p++;
    return s;
}

static void check(void)
{
    static const int vals[] = { 0, 1, 2, 3, -1, -2, -3, 100, 101, -100, -101, 32767, -32768 };
    unsigned i;
    for (i = 0; i < sizeof vals / sizeof vals[0]; i++) {
        assertEqual(across(vals[i]), ref_across(vals[i]));
        assertEqual(across_sub(vals[i]), ref_across_sub(vals[i]));
    }
}

static void check_loop(void)
{
    static const int a[] = { 1, 2, 3, 4, 5, -20 };
    assertEqual(loop_sum(a, 6), -5);
    assertEqual(loop_sum(a, 0), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("join value not a loop accumulator");
    suite_add_test(check);
    suite_add_test(check_loop);
    return suite_run();
}
#endif
