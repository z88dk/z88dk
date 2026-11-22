/* BYTE ADD AND SUBTRACT READ THEIR OPERANDS IN PLACE.
 *
 *     origin = cur - view;      a global byte feeding a byte add or subtract
 *                               is read at the operation, not spilled first
 *     r = x - f(...)            a subtrahend already in A is negated, not stored
 *
 * Every shape here has a case where the shortcut would be wrong: the subtrahend
 * used again afterwards (it must survive), a global written between the load
 * and the subtract (the OLD value is wanted), and both operand orders.
 */
#include "test.h"

static unsigned char ga, gb, gc, out;
static unsigned char arr[4] = { 10, 20, 30, 40 };
static int sink;

static void sub_g(void)        { out = (unsigned char)(ga - gb); }
static void add_g(void)        { out = (unsigned char)(ga + gb); }
static void rsub_g(void)       { out = (unsigned char)(200 - gb); }
static void sub_k(void)        { out = (unsigned char)(ga - 7); }

/* the subtrahend is a fresh value in A and dies: a - (b >> 1) */
static void sub_fresh(void)    { out = (unsigned char)(ga - (gb >> 1)); }
/* ...and one that is used again afterwards */
static unsigned char sub_live(unsigned char x)
{
    unsigned char h = (unsigned char)(x >> 1);
    sink = (unsigned char)(ga - h);
    return h;
}
static void sub_live2(void)
{
    unsigned char h = (unsigned char)(gb >> 1);
    out = (unsigned char)(ga - h);
    sink = h;
}
/* a global written between its load and the subtract: the old value counts */
static void sub_hazard(void)
{
    unsigned char old = ga;
    ga = 99;
    out = (unsigned char)(old - gb);
}
static void add_hazard(void)
{
    unsigned char old = gb;
    gb = 1;
    out = (unsigned char)(old + gc);
}

/* more shapes where the subtrahend is read again after the subtract */
static int live_branch(void)
{
    unsigned char h = (unsigned char)(gb >> 1);
    unsigned char r = (unsigned char)(ga - h);
    if (r > 3) return h + 1;
    return h;
}
static int live_call(void)
{
    unsigned char h = (unsigned char)(gb + gc);
    unsigned char r = (unsigned char)(ga - h);
    sink = r;
    return h * 2 + r;
}
static int live_two_subs(void)
{
    unsigned char h = (unsigned char)(gb >> 1);
    unsigned char r1 = (unsigned char)(ga - h);
    unsigned char r2 = (unsigned char)(gc - h);
    return r1 * 3 + r2;
}
static unsigned char live_loop(unsigned char n)
{
    unsigned char i, h = (unsigned char)(gb >> 1), acc = 0;
    for (i = 0; i < n; i++) acc = (unsigned char)(acc + (unsigned char)(ga - h));
    return (unsigned char)(acc + h);
}


/* K - x narrowed to a byte */
static void rsub_live(void)        { unsigned char t = gb; out = (unsigned char)(200 - t); sink = t + 1; }
static unsigned char rsub_word(int i) { return (unsigned char)(120 - i); }
static void rsub_fresh(void)       { out = (unsigned char)(10 - (gb >> 1)); }
static void rsub_sc(signed char c) { out = (unsigned char)(20 - c); }
static void rsub_big(void)         { out = (unsigned char)(300 - gb); }

static int chain(void)         { return (unsigned char)(ga - gb) + (unsigned char)(gb - gc); }
static unsigned char via_arr(int i) { return (unsigned char)(arr[i] - arr[i - 1]); }

void test_bytearith(void)
{
    int i;
    ga = 50; gb = 20; gc = 5;
    sub_g();     assertEqual(out, 30);
    add_g();     assertEqual(out, 70);
    rsub_g();    assertEqual(out, 180);
    sub_k();     assertEqual(out, 43);
    sub_fresh(); assertEqual(out, 40);            /* 50 - 10 */
    ga = 3; gb = 9;
    sub_g();     assertEqual(out, 250);           /* wraps */
    add_g();     assertEqual(out, 12);
    ga = 250; gb = 10;
    add_g();     assertEqual(out, 4);             /* wraps */
    sub_fresh(); assertEqual(out, 245);           /* 250 - 5 */

    ga = 100; gb = 40;
    assertEqual(sub_live(8), 4);   assertEqual(sink, 96);
    sub_live2(); assertEqual(out, 80); assertEqual(sink, 20);

    ga = 60; gb = 15; gc = 4;
    sub_hazard(); assertEqual(out, 45); assertEqual(ga, 99);   /* 60 - 15, not 99 - 15 */
    gb = 15; gc = 4;
    add_hazard(); assertEqual(out, 19); assertEqual(gb, 1);    /* 15 + 4, not 1 + 4 */


    ga = 100; gb = 40; gc = 30;
    assertEqual(live_branch(), 21);                 /* h=20, r=80 -> h+1 */
    assertEqual(live_call(), 70 * 2 + 30);          /* h=70, r=30 */
    assertEqual(live_two_subs(), 80 * 3 + 10);      /* h=20 */
    assertEqual(live_loop(3), (unsigned char)(3 * 80 + 20));

    gb = 15;
    rsub_live();      assertEqual(out, 185);  assertEqual(sink, 16);
    assertEqual(rsub_word(5), 115);   assertEqual(rsub_word(300), 76);   assertEqual(rsub_word(-3), 123);
    rsub_fresh();     assertEqual(out, 3);
    gb = 40;
    rsub_fresh();     assertEqual(out, 246);                      /* 10 - 20 wraps */
    rsub_sc(-5);      assertEqual(out, 25);   rsub_sc(30);        assertEqual(out, 246);
    gb = 15;
    rsub_big();       assertEqual(out, 29);                       /* 300 - 15 = 285 */

    ga = 200; gb = 90; gc = 30;
    assertEqual(chain(), 110 + 60);

    for (i = 1; i < 4; i++) assertEqual(via_arr(i), 10);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte add and subtract read their operands in place");
    suite_add_test(test_bytearith);
    return suite_run();
}
