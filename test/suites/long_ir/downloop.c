/* Down-counting loops. The test of a loop whose counter never goes below zero
 * can be unsigned; the others must stay signed, or they run forever / skip.
 *
 *  guarded       x > 29, x--             may be unsigned
 *  step2         x >= 2,  x -= 2         may be unsigned
 *  overshoot     x > 0,  x -= 2          x reaches -1: must stay signed
 *  to_zero       x >= 0, x--             x reaches -1: must stay signed
 *  reinit        x set again in the loop must stay signed
 *  param_init    x starts from a parameter (may be negative)
 *  reused        one variable through a down loop and two up loops
 */
#include "test.h"

static volatile int sink;

static int guarded(void)
{
    int x, n = 0;
    for (x = 37; x > 29; x--) { sink = x; n++; }
    return n * 100 + x;
}

static int step2(void)
{
    int x, n = 0;
    for (x = 10; x >= 2; x -= 2) { sink = x; n++; }
    return n * 100 + x;
}

static int overshoot(int start)
{
    int x, n = 0;
    for (x = start; x > 0; x -= 2) { sink = x; n++; if (n > 50) break; }
    return n * 1000 + (x + 100);
}

static int to_zero(int start)
{
    int x, n = 0;
    for (x = start; x >= 0; x--) { sink = x; n++; if (n > 50) break; }
    return n * 1000 + (x + 100);
}

static int reinit(void)
{
    int x, n = 0;
    for (x = 20; x > 10; x--) {
        n++;
        if (x == 15) x = 3;           /* a second definition in the loop */
        if (n > 40) break;
    }
    return n * 1000 + (x + 100);
}

static int param_init(int p)
{
    int x, n = 0;
    for (x = p; x > 29; x--) { n++; if (n > 60) break; }
    return n * 1000 + (x + 100);
}

static int reused(void)
{
    int x, a = 0, b = 0, c = 0;
    for (x = 37; x > 29; x--) a += x;
    for (x = 40; x < 48; x++) b += x;
    for (x = 0; x < 11; x++) c += x;
    return a + b + c;
}

static int nested(void)
{
    int x, y, t = 0;
    for (x = 5; x > 2; x--)
        for (y = 4; y > 1; y--)
            t += x * 10 + y;
    return t;
}

static void check(void)
{
    assertEqual(guarded(), 8 * 100 + 29);
    assertEqual(step2(), 5 * 100 + 0);
    assertEqual(overshoot(3), 2 * 1000 + (-1 + 100));
    assertEqual(overshoot(4), 2 * 1000 + (0 + 100));
    assertEqual(to_zero(3), 4 * 1000 + (-1 + 100));
    assertEqual(to_zero(0), 1 * 1000 + (-1 + 100));
    assertEqual(reinit(), 6 * 1000 + (2 + 100));
    assertEqual(param_init(33), 4 * 1000 + (29 + 100));
    assertEqual(param_init(-5), 0 * 1000 + (-5 + 100));
    assertEqual(reused(), (37+36+35+34+33+32+31+30) + (40+41+42+43+44+45+46+47) + 55);
    assertEqual(nested(), (5*10+4)+(5*10+3)+(5*10+2)+(4*10+4)+(4*10+3)+(4*10+2)+(3*10+4)+(3*10+3)+(3*10+2));
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("down-counting loops");
    suite_add_test(check);
    return suite_run();
}
