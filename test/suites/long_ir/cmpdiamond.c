/* A byte compared against a constant chosen by a ternary: the diamond loads
 * one constant ahead of the branch, and the byte compare parks the second
 * operand in E. A word accumulator that lives across the compare must survive.
 */
#include "test.h"

static unsigned char ge(unsigned char k, unsigned char s) { return k >= (s ? 32 : 33); }

static unsigned char ge2(unsigned char k, unsigned char s)
{
    unsigned char lim = s ? 32 : 33;
    return k >= lim;
}

static unsigned art(unsigned char inv, unsigned a) { return a ^ (inv ? 0x8000 : 0); }

static unsigned loop(unsigned char s, unsigned char n)
{
    unsigned i, acc = 0;

    for (i = 0; i < n; i++)
        if ((unsigned char)i >= (s ? 32 : 33))
            acc += i;
    return acc;
}

static unsigned loop2(unsigned char s, unsigned char n)
{
    unsigned i, acc = 0;
    unsigned char lim;

    for (i = 0; i < n; i++) {
        lim = s ? 32 : 33;
        if ((unsigned char)i >= lim)
            acc += i;
    }
    return acc;
}

static void check(void)
{
    assertEqual(ge(31, 1), 0);
    assertEqual(ge(32, 1), 1);
    assertEqual(ge(32, 0), 0);
    assertEqual(ge(33, 0), 1);
    assertEqual(ge(255, 0), 1);
    assertEqual(ge(0, 1), 0);
    assertEqual(ge2(31, 1), 0);
    assertEqual(ge2(32, 1), 1);
    assertEqual(ge2(32, 0), 0);
    assertEqual(ge2(33, 0), 1);
    assertEqual(art(1, 0x0123), 0x8123);
    assertEqual(art(0, 0x0123), 0x0123);
    assertEqual(art(1, 0x8123), 0x0123);
    assertEqual(loop(1, 40), 284);
    assertEqual(loop(0, 40), 252);
    assertEqual(loop2(1, 40), 284);
    assertEqual(loop2(0, 40), 252);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte compare against a ternary constant");
    suite_add_test(check);
    return suite_run();
}
