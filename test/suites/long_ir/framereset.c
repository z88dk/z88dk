/* Argument cleanup that sits right before the frame reset is dropped. The
 * result, the callee-saved registers and the caller's own frame must be intact
 * after calls with different argument counts in tail position. */
#include "test.h"

static volatile int sink;
static int total;

static void take0(void) { total += 1; }
static void take1(int a) { total += a; }
static void take3(int a, int b, int c) { total += a + b * c; }
static int  take5(int a, int b, int c, int d, int e) { return a + b + c + d + e; }
static void take10(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j)
{
    total += a + b + c + d + e + f + g + h + i + j;
}
static void takechar(char a, char b) { total += a - b; }

static void tail0(void) { int pad[3]; pad[0] = 1; sink = pad[0]; take0(); }
static void tail1(int x) { int pad[3]; pad[1] = x; sink = pad[1]; take1(x); }
static void tail3(int x) { int pad[3]; pad[2] = x; sink = pad[2]; take3(x, 2, 3); }
static void tail10(int x) { int pad[3]; pad[0] = x; sink = pad[0]; take10(x, 1, 2, 3, 4, 5, 6, 7, 8, 9); }
static void tailc(char x) { int pad[3]; pad[0] = x; sink = pad[0]; takechar(x, 1); }
static int  retconst(int x) { int pad[3]; pad[0] = x; sink = pad[0]; take1(x); return 0; }
static int  retval(int x) { int pad[3]; pad[0] = x; sink = pad[0]; return take5(x, 1, 2, 3, 4); }
static long retlong(int x) { int pad[3]; pad[0] = x; sink = pad[0]; take1(x); return 0x12340000L + x; }
static int  retnested(int x) { int pad[3]; pad[0] = x; sink = pad[0]; return take5(take5(x, 1, 1, 1, 1), 2, 3, 4, 5); }

void test_framereset(void)
{
    int i, keep = 77;
    long lk = 0x55667788L;
    total = 0;
    tail0(); tail1(10); tail3(4); tail10(5); tailc(9);
    assertEqual(total, 1 + 10 + (4 + 6) + (5 + 45) + 8);
    total = 0;
    assertEqual(retconst(3), 0);
    assertEqual(total, 3);
    assertEqual(retval(10), 20);
    assertEqual(retlong(7) == 0x12340007L, 1);
    assertEqual(retnested(1), 5 + 2 + 3 + 4 + 5);
    for (i = 0; i < 3; i++) {
        tail3(i);
        assertEqual(retval(i), i + 10);
    }
    assertEqual(keep, 77);
    assertEqual(lk == 0x55667788L, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("argument cleanup before the frame reset");
    suite_add_test(test_framereset);
    return suite_run();
}
