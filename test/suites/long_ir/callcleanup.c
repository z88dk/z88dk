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

char seven_char(int a, int b, int c, int d, int e, int f, int g)
{
    calls++;
    return (char)(a + b + c + d + e + f + g);
}

/* A one-long-argument fastcall: the producer's BC stash is dead into it, and the
 * values kept across it must still survive. */
long __FASTCALL__ fc_long(long x)
{
    calls++;
    return x + 1;
}

static long fc_chain(long a, long b)
{
    long t = a + 1;
    long u = fc_long(t);
    long v = fc_long(b + u);
    return v + t;
}

static int fc_loop(int n)
{
    long acc = 0;
    int i;
    for (i = 0; i < n; i++)
        acc += fc_long((long)i * 3 + n);
    return (int)acc;
}

static void check(void)
{
    calls = 0;
    (void)seven_int(1, 2, 3, 4, 5, 6, 7);
    assertEqual(calls, 1);
    assertEqual(seven_int(1, 2, 3, 4, 5, 6, 7), 28);
    assertEqual(seven_long(1, 2, 3, 4, 5, 6, 7), 28L);
    assertEqual(seven_double(1, 2, 3, 4, 5, 6, 7), 28.0);
    assertEqual(seven_char(1, 2, 3, 4, 5, 6, 7), 28);
    assertEqual(calls, 5);
    calls = 0;
    assertEqual(fc_chain(10L, 20L), 44L);
    assertEqual(calls, 2);
    assertEqual(fc_loop(4), 38);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("caller cleanup respects live return values");
    suite_add_test(check);
    return suite_run();
}
