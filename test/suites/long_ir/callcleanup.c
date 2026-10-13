/* Caller cleanup can clobber HL only when the call result is dead or is
 * returned outside HL. Exercise both cases around a seven-word call. */
#include "test.h"

static volatile int calls;

int seven_int(int a, int b, int c, int d, int e, int f, int g)
{
    calls++;
    return a + b + c + d + e + f + g;
}

long seven_long(int a, int b, int c, int d, int e, int f, int g)
{
    calls++;
    return (long)a + b + c + d + e + f + g;
}

double seven_double(int a, int b, int c, int d, int e, int f, int g)
{
    calls++;
    return (double)a + b + c + d + e + f + g;
}

static void check(void)
{
    calls = 0;
    (void)seven_int(1, 2, 3, 4, 5, 6, 7);
    assertEqual(calls, 1);
    assertEqual(seven_int(1, 2, 3, 4, 5, 6, 7), 28);
    assertEqual(seven_long(1, 2, 3, 4, 5, 6, 7), 28L);
    assertEqual(seven_double(1, 2, 3, 4, 5, 6, 7), 28.0);
    assertEqual(calls, 4);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("caller cleanup respects live return values");
    suite_add_test(check);
    return suite_run();
}
