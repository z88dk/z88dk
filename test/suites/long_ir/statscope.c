/* Block scoping for `static` locals.
 *
 * The storage of a static local is a global, but C scopes its NAME to the
 * block. Two of them named the same thing in sibling or nested blocks are
 * legal, and an inner declaration shadows an outer one -- whatever the outer
 * one's storage. 80cc derived the global name from (function, source name)
 * alone, so the second declaration collided and valid code was REJECTED:
 * "fatal error: Symbol st_main_v is already defined".
 *
 * Two bugs are pinned here:
 *   - the collision itself (nested/sibling/loop cases below);
 *   - `shadowed`: a static in an inner block did not shadow an AUTOMATIC of
 *     the same name outside it, because identifier lookup tried findloc before
 *     findstc and took the automatic regardless of depth. That one compiled
 *     fine before and silently read the wrong variable.
 *
 * Values are distinct and non-zero so a wrong resolution cannot read as a
 * right answer, and every result is folded into one order-independent
 * accumulator -- no reliance on argument evaluation order.
 */
#include "test.h"

static int g;
static void acc(int v) { g = g * 7 + v; }

/* An inner static shadows an outer static; the outer is visible again after. */
static void shadow_static(void)
{
    static int v = 1;
    acc(v);                            /* 1 */
    { static int v = 2; acc(v); }      /* 2 */
    acc(v);                            /* 1 again */
    { static int v = 3; acc(v); }      /* sibling, same name */
    acc(v);                            /* 1 */
}

/* Three levels deep, each shadowing the last. */
static void nested(void)
{
    { static int v = 10; acc(v);
      { static int v = 11; acc(v);
        { static int v = 12; acc(v); }
        acc(v); }                      /* 11 */
      acc(v); }                        /* 10 */
}

/* A static shadowing an AUTOMATIC of the same name. */
static void shadow_auto(void)
{
    int v = 7;
    acc(v);                            /* 7, automatic */
    { static int v = 8; acc(v); }      /* 8, the static */
    acc(v);                            /* 7, automatic again */
}

/* Same name in a different function must be a different object. */
static void other_fn(void) { static int v = 99; acc(v); }

/* A static in a loop body: one object, and it persists across iterations. */
static void loop_scope(void)
{
    int i;
    for (i = 0; i < 3; i++) { static int v = 0; v++; acc(v); }   /* 1,2,3 */
    { static int v = 50; acc(v); }
}

/* Statics keep their value across calls, and the shadowed one is untouched. */
static int counter(void)
{
    static int n = 0;
    { static int n = 100; (void)n; }
    return ++n;
}

/* Different types with the same name in sibling blocks. */
static void mixed_types(void)
{
    { static char v = 100; acc(v); }
    { static long v = 200; acc((int)v); }
    { static int  v = 300; acc(v); }
}

static void run(void)
{
    g = 0; shadow_static(); Assert(g == 3158, "static shadows static");
    g = 0; nested();        Assert(g == 28458, "three nested levels");
    g = 0; shadow_auto();   Assert(g == 406, "static shadows an automatic");
    g = 0; other_fn();      Assert(g == 99, "same name, other function");
    g = 0; loop_scope();    Assert(g == 512, "static in a loop body");
    g = 0; mixed_types();   Assert(g == 6600, "same name, different types");

    /* Sequenced explicitly -- argument evaluation order is unspecified. */
    {
        int a = counter(), b = counter(), c = counter();
        Assert(a == 1 && b == 2 && c == 3, "static persists across calls");
    }
}
int main(int c, char **v)
{
    (void)c; (void)v;
    suite_setup("statscope");
    suite_add_test(run);
    return suite_run();
}
