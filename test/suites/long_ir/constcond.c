/* A CONSTANT OPERAND OF && / || IN A CONDITION IS FOLDED, NOT TESTED.
 *
 *     if (1 && x)  if (x && 1)  if (0 || x)  if (x || 0)
 *     if (0 && x)  if (x && 0)  if (1 || x)  if (x || 1)
 *
 * The constant leaf used to be loaded and branched on. Folding it must keep
 * the other operand's side effects and its evaluation order, and must not
 * turn a value context (`return 1 && x`) into the raw operand: that is 0/1.
 */
#include "test.h"

static int calls;
static int touch(int v) { calls++; return v; }

static int a(int x) { if (1 && x) return 1; return 0; }
static int b(int x) { if (x && 1) return 1; return 0; }
static int c(int x) { if (0 || x) return 1; return 0; }
static int d(int x) { if (x || 0) return 1; return 0; }
static int e(int x) { if (0 && x) return 1; return 0; }
static int f(int x) { if (x && 0) return 1; return 0; }
static int g(int x) { if (1 || x) return 1; return 0; }
static int h(int x) { if (x || 1) return 1; return 0; }

/* side effects of the live operand survive the fold */
static int s1(int x) { if (1 && touch(x)) return 1; return 0; }
static int s2(int x) { if (touch(x) && 1) return 1; return 0; }
static int s3(int x) { if (0 || touch(x)) return 1; return 0; }
static int s4(int x) { if (touch(x) || 0) return 1; return 0; }
static int s5(int x) { if (touch(x) || 1) return 1; return 0; }
static int s6(int x) { if (touch(x) && 0) return 1; return 0; }

/* value contexts stay normalised to 0/1 */
static int v1(int x) { return 1 && x; }
static int v2(int x) { return x || 0; }
static int v3(int x) { return 0 || x; }
static int v4(int x) { return x && 1; }

/* nested and mixed with real tests */
static int n1(int x, int y) { if ((x && 1) || (0 && y)) return 1; return 0; }
static int n2(int x, int y) { if (1 && x && y) return 1; return 0; }
static int n3(int x, int y) { if (x || 0 || y) return 1; return 0; }
static int n4(int x, int y) { if ((x || 1) && y) return 1; return 0; }
static int n5(int x, int y) { if (0 || (1 && x) || (y && 0)) return 1; return 0; }

static int loop_n(int n)
{
    int i = 0;
    while (1 && i < n) i++;
    return i;
}

void test_constcond(void)
{
    int x;
    for (x = -2; x <= 2; x++) {
        int t = x != 0;
        assertEqual(a(x), t); assertEqual(b(x), t);
        assertEqual(c(x), t); assertEqual(d(x), t);
        assertEqual(e(x), 0); assertEqual(f(x), 0);
        assertEqual(g(x), 1); assertEqual(h(x), 1);
        assertEqual(v1(x), t); assertEqual(v2(x), t);
        assertEqual(v3(x), t); assertEqual(v4(x), t);
        assertEqual(n1(x, 7), t); assertEqual(n1(x, 0), t);
        assertEqual(n2(x, 3), t); assertEqual(n2(x, 0), 0);
        assertEqual(n3(x, 0), t); assertEqual(n3(0, x), t);
        assertEqual(n4(x, 5), 1); assertEqual(n4(x, 0), 0);
        assertEqual(n5(x, 9), t);
    }

    calls = 0;
    assertEqual(s1(3), 1); assertEqual(s1(0), 0);
    assertEqual(s2(3), 1); assertEqual(s2(0), 0);
    assertEqual(s3(3), 1); assertEqual(s3(0), 0);
    assertEqual(s4(3), 1); assertEqual(s4(0), 0);
    assertEqual(s5(3), 1); assertEqual(s5(0), 1);
    assertEqual(s6(3), 0); assertEqual(s6(0), 0);
    assertEqual(calls, 12);

    assertEqual(loop_n(0), 0);
    assertEqual(loop_n(5), 5);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant operands of && and || in conditions");
    suite_add_test(test_constcond);
    return suite_run();
}
