/* AN INDIRECT CALL'S TARGET IS READ STRAIGHT FROM HL.
 *
 * For a near call with no arguments the function pointer is loaded into HL by
 * the op just before the call and consumed there (`call l_jphl`), so the frame
 * copy of the pointer is never read and is no longer stored. Any argument,
 * result handling, or a pointer used again afterwards still needs its slot —
 * the cases below put the pointer in each of those positions so a store
 * dropped too eagerly shows as a call to garbage or a wrong count.
 */
#include <setjmp.h>
#include "test.h"

static int hits;

static void bump(void)      { hits++; }
static void bump10(void)    { hits += 10; }
static int  ret7(void)      { hits++; return 7; }
static int  add_arg(int a)  { hits += a; return a + 1; }

typedef struct { void (*setup)(void); void (*run)(void); void (*done)(void); } Ops;

static Ops ops = { bump, bump10, bump };
static void (*table[3])(void) = { bump, bump10, bump };

/* member, with a null guard between two uses: the pointer is loaded twice */
static void guarded(Ops *o)
{
    if (o->done) o->done();
}

/* indexed element, the pointer computed just before the call */
static void by_index(int i) { table[i](); }

/* held in a local across another call: needs its slot */
static void held(void)
{
    void (*f)(void) = ops.run;
    f();
    bump();
    f();
}

/* pointer reused after the call */
static int reuse(void)
{
    int (*g)(void) = ret7;
    int a = g();
    int b = g();
    return a + b;
}

/* with an argument: the pointer must survive loading the argument */
static int with_arg(int (*h)(int), int v) { return h(v); }

/* result consumed */
static int result_used(void)
{
    int (*g)(void) = ret7;
    return g() + 1;
}

/* a pointer chosen on two paths */
static void either(int c)
{
    void (*f)(void) = c ? bump : bump10;
    f();
}

/* setjmp keeps every value of its function in memory, so here the target's
   slot is the only thing a dropped store could have mattered to. */
static jmp_buf jb;
static void jump(void) { longjmp(jb, 1); }
static Ops jops = { bump, jump, bump };

static int loop_sj(Ops *o, int n)
{
    int i, t = 0;
    if (setjmp(jb) == 0) {
        for (i = 0; i < n; i++) {
            o->setup();
            t += hits;
            o->run();
        }
    }
    return t;
}

static int jumper(Ops *o)
{
    int r = setjmp(jb);
    if (r == 0) {
        o->setup();
        o->run();
        return -1;
    }
    o->done();
    return r;
}

static void test_fnptrdead(void)
{
    hits = 0;
    ops.setup(); assertEqual(hits, 1);
    ops.run();   assertEqual(hits, 11);
    guarded(&ops); assertEqual(hits, 12);
    ops.done = 0;
    guarded(&ops); assertEqual(hits, 12);
    ops.done = bump;

    hits = 0;
    by_index(0); by_index(1); by_index(2);
    assertEqual(hits, 12);

    hits = 0;
    held();
    assertEqual(hits, 21);

    hits = 0;
    assertEqual(reuse(), 14);
    assertEqual(hits, 2);

    hits = 0;
    assertEqual(with_arg(add_arg, 5), 6);
    assertEqual(hits, 5);

    hits = 0;
    assertEqual(result_used(), 8);

    hits = 0;
    assertEqual(loop_sj(&ops, 3), 36);
    assertEqual(hits, 33);

    hits = 0;
    assertEqual(jumper(&jops), 1);
    assertEqual(hits, 2);

    hits = 0;
    either(1); assertEqual(hits, 1);
    either(0); assertEqual(hits, 11);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("An indirect call's target is read straight from HL");
    suite_add_test(test_fnptrdead);
    return suite_run();
}
