/* && and || used as values: 0 or 1 whatever the operands, operands evaluated
 * left to right and only as far as needed, nested forms, mixed widths.
 */
#include "test.h"

static int calls;
static int tick(int v) { calls++; return v; }

static int v_and(int a, int b, int c) { return a && b && c; }
static int v_or(int a, int b, int c) { return a || b || c; }
static int v_mix(int a, int b, int c) { return (a && b) || c; }
static int v_mix2(int a, int b, int c) { return a && (b || c); }
static int v_not(int a, int b) { return !(a && b) + 2 * !(a || b); }
static long v_long(long a, long b) { return (a && b) + 4 * (a || b); }
static int v_byte(unsigned char a, unsigned char b) { return a && b; }
static unsigned int v_sum(unsigned char *p, unsigned int k)
{
    unsigned int n = 0;
    n += (k == 3u && p[0] == 7 && p[1] != 8);
    n += (k > 1u || p[2] == 9);
    n += (p[0] < 5 && k != 0u) + (p[1] == 8 || k == 3u);
    return n;
}

static void check(void)
{
    unsigned char p[3];
    int a, b, c, expect;

    for (a = 0; a < 3; a++)
        for (b = 0; b < 3; b++)
            for (c = 0; c < 3; c++) {
                assertEqual(v_and(a, b, c), (a && b && c));
                assertEqual(v_or(a, b, c), (a || b || c));
                assertEqual(v_mix(a, b, c), ((a && b) || c));
                assertEqual(v_mix2(a, b, c), (a && (b || c)));
            }
    assertEqual(v_not(0, 0), 3);
    assertEqual(v_not(1, 0), 1);
    assertEqual(v_not(1, 1), 0);
    assertEqual(v_long(0L, 0L), 0);
    assertEqual(v_long(0x10000L, 0L), 4);
    assertEqual(v_long(0x10000L, 0x20000L), 5);
    assertEqual(v_byte(0, 5), 0);
    assertEqual(v_byte(2, 5), 1);
    calls = 0;
    expect = tick(0) && tick(1);
    assertEqual(expect, 0);
    assertEqual(calls, 1);
    calls = 0;
    expect = tick(1) || tick(1);
    assertEqual(expect, 1);
    assertEqual(calls, 1);
    calls = 0;
    expect = tick(1) && tick(0) && tick(1);
    assertEqual(expect, 0);
    assertEqual(calls, 2);
    p[0] = 7; p[1] = 9; p[2] = 9;
    assertEqual(v_sum(p, 3), 3);
    p[0] = 7; p[1] = 8; p[2] = 0;
    assertEqual(v_sum(p, 3), 2);
    assertEqual(v_sum(p, 0), 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("short-circuit operators as values");
    suite_add_test(check);
    return suite_run();
}
