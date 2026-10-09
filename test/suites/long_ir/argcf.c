/* A CALL ARGUMENT WITH CONTROL FLOW MUST NOT FORCE THE OTHERS TO SPILL.
 *
 * `?:`, `&&` and `||` end the basic block, and a call's arguments can only be
 * pushed as they are produced while they all sit in one block. A control-flow
 * argument therefore sent every earlier argument through a frame slot. When
 * every argument is free of side effects (and at most one touches a volatile),
 * evaluation order is unobservable, so the control-flow arguments are now
 * built first and the rest form one straight run of pushes.
 *
 * The weighted sum below makes any permutation of the arguments visible. The
 * cases that must keep their order — an argument that calls, assigns or steps
 * a variable — are at the end: their left-to-right order is observable.
 */
#include "test.h"

static int w4(int a, int b, int c, int d) { return a * 1000 + b * 100 + c * 10 + d; }
static int w6(int a, int b, int c, int d, int e, int f)
{
    return ((((a * 7 + b) * 7 + c) * 7 + d) * 7 + e) * 7 + f;
}

static int g1 = 1, g2 = 2, g3 = 3;
static char gc = 4;
static volatile int vol = 5;
static int cnt;

static int next(void) { return ++cnt; }

/* the control-flow argument last, first, in the middle, and nested */
static int last(int c)    { return w4(g1, g2, g3, c ? 7 : 8); }
static int first(int c)   { return w4(c ? 7 : 8, g1, g2, g3); }
static int middle(int c)  { return w4(g1, c ? 7 : 8, g2, g3); }
static int nested(int c, int d) { return w4(g1, c ? (d ? 6 : 7) : 8, g2, g3); }

/* && and || as value arguments */
static int logic(int a, int b) { return w4(g1, a && b, a || b, g3); }

/* two control-flow arguments, plus plain ones between and after */
static int twocf(int c, int d)
{
    return w6(g1, c ? 1 : 2, g2, d ? 3 : 4, g3, gc);
}

/* a string-literal argument next to a ternary (the framework's printf) */
static const char *pick(int c)
{
    static const char *r;
    r = 0;
    (void)w4(g1, g2, c, 0);
    r = c ? "yes" : "no";
    return r;
}

/* one volatile read among the arguments is fine */
static int onevol(int c) { return w4(g1, vol, g3, c ? 7 : 8); }

/* must keep left-to-right: calls and steps in the argument list */
static int withcall(int c)
{
    cnt = 0;
    return w4(next(), next(), g3, c ? 7 : 8);
}

static int withstep(int c)
{
    int i = 1;
    return w4(i++, i++, g3, c ? 7 : 8);   /* unspecified in C; ours is L->R */
}

static void test_argcf(void)
{
    assertEqual(last(1),   1237);
    assertEqual(last(0),   1238);
    assertEqual(first(1),  7123);
    assertEqual(first(0),  8123);
    assertEqual(middle(1), 1723);
    assertEqual(middle(0), 1823);
    assertEqual(nested(1, 1), 1623);
    assertEqual(nested(1, 0), 1723);
    assertEqual(nested(0, 1), 1823);

    assertEqual(logic(1, 1), 1 * 1000 + 1 * 100 + 1 * 10 + 3);
    assertEqual(logic(1, 0), 1 * 1000 + 0 * 100 + 1 * 10 + 3);
    assertEqual(logic(0, 0), 1 * 1000 + 0 * 100 + 0 * 10 + 3);

    assertEqual(twocf(1, 1), w6(1, 1, 2, 3, 3, 4));
    assertEqual(twocf(0, 1), w6(1, 2, 2, 3, 3, 4));
    assertEqual(twocf(1, 0), w6(1, 1, 2, 4, 3, 4));
    assertEqual(twocf(0, 0), w6(1, 2, 2, 4, 3, 4));

    assertEqual(pick(1)[0], 'y');
    assertEqual(pick(0)[0], 'n');

    assertEqual(onevol(1), 1 * 1000 + 5 * 100 + 3 * 10 + 7);
    assertEqual(onevol(0), 1 * 1000 + 5 * 100 + 3 * 10 + 8);

    assertEqual(withcall(1), 1 * 1000 + 2 * 100 + 3 * 10 + 7);
    assertEqual(withcall(0), 1 * 1000 + 2 * 100 + 3 * 10 + 8);
    assertEqual(withstep(1), 1 * 1000 + 2 * 100 + 3 * 10 + 7);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Control flow in a call argument");
    suite_add_test(test_argcf);
    return suite_run();
}
