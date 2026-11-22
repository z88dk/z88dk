/* A __z88dk_callee function with a long return and a local array: the callee
 * drops its own arguments while the result sits in DEHL (8080/8085/vm1 pop them
 * into AF), the frame is released with the call's stack cleanup folded in, and
 * the unused four-byte slot of the call result is not reserved. */
#include "test.h"

static volatile int sink;

static long target(char *p, int a, int b)
{
    p[0] = (char)a;
    p[99] = (char)b;
    return (long)a * 100000L + b + p[0] + p[99];
}

static long target4(char *p, long a, int b)
{
    p[0] = 1;
    return a + b + p[0];
}

long func2(int i, int j) __z88dk_callee;
long func2(int i, int j) __z88dk_callee
{
    char buf[100];
    return target(buf, i, j);
}

long func3(int i, int j, int k) __z88dk_callee;
long func3(int i, int j, int k) __z88dk_callee
{
    char buf[100];
    sink = k;
    return target(buf, i, j) + k;
}

long func4(long a, int b, int c) __z88dk_callee;
long func4(long a, int b, int c) __z88dk_callee
{
    char buf[40];
    return target4(buf, a, b) + c;
}

long func6(long a, long b, long c) __z88dk_callee;
long func6(long a, long b, long c) __z88dk_callee
{
    char buf[40];
    return target4(buf, a, (int)b) + c;
}

long func8(long a, long b, long c, long d) __z88dk_callee;
long func8(long a, long b, long c, long d) __z88dk_callee
{
    char buf[16];
    return target4(buf, a + b, (int)c) + d;
}

long func1(int i) __z88dk_callee;
long func1(int i) __z88dk_callee
{
    char buf[100];
    return target(buf, i, i);
}

static void test_calleelong(void)
{
    assertEqual(func2(3, 4) == 300000L + 4 + 3 + 4, 1);
    assertEqual(func2(-2, 7) == -200000L + 7 + (-2) + 7, 1);
    assertEqual(func3(1, 2, 30) == 100000L + 2 + 1 + 2 + 30, 1);
    assertEqual(func4(0x12340000L, 5, 6) == 0x12340000L + 5 + 1 + 6, 1);
    assertEqual(func1(9) == 900000L + 9 + 9 + 9, 1);
    assertEqual(func6(0x10000L, 7L, 0x20000L) == 0x10000L + 7 + 1 + 0x20000L, 1);
    assertEqual(func8(0x100L, 0x200L, 3L, 0x40000L) == 0x300L + 3 + 1 + 0x40000L, 1);
    assertEqual(sink, 30);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("callee long return");
    suite_add_test(test_calleelong);
    return suite_run();
}
