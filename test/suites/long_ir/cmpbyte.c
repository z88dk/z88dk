/* A zero-extended byte compared with a word temp that only byte constants
 * define: both read as bytes. The temp must stay a word where something else
 * reads it, and the byte must not change between its widening and the compare.
 */
#include "test.h"

static unsigned char ge(unsigned char k, unsigned char s) { return k >= (s ? 32 : 33) && k < 127; }

static unsigned char lt(unsigned char k, unsigned char s) { return k < (s ? 100 : 200); }

static unsigned char eq(unsigned char k, unsigned char s) { return k == (s ? 7 : 250); }

static unsigned char ne(unsigned char k, unsigned char s) { return k != (s ? 7 : 250); }

/* The temp is also returned, so it keeps its word width. */
static unsigned both(unsigned char k, unsigned char s, unsigned *out)
{
    unsigned lim = s ? 32 : 255;

    *out = lim;
    return k >= lim;
}

/* The byte steps after it was widened and before the compare reads it. */
static unsigned char stepped(unsigned char k, unsigned char s)
{
    unsigned w = k;
    unsigned lim = s ? 32 : 33;

    k++;
    return w >= lim;
}

static unsigned loop(unsigned char s, unsigned char n)
{
    unsigned acc = 0;
    unsigned char i;

    for (i = 0; i < n; i++)
        if (i >= (s ? 32 : 33))
            acc += i;
    return acc;
}

static void check(void)
{
    unsigned o;

    assertEqual(ge(31, 1), 0);
    assertEqual(ge(32, 1), 1);
    assertEqual(ge(32, 0), 0);
    assertEqual(ge(33, 0), 1);
    assertEqual(ge(126, 0), 1);
    assertEqual(ge(127, 0), 0);
    assertEqual(ge(255, 0), 0);
    assertEqual(lt(99, 1), 1);
    assertEqual(lt(100, 1), 0);
    assertEqual(lt(199, 0), 1);
    assertEqual(lt(200, 0), 0);
    assertEqual(lt(255, 0), 0);
    assertEqual(eq(7, 1), 1);
    assertEqual(eq(7, 0), 0);
    assertEqual(eq(250, 0), 1);
    assertEqual(eq(250, 1), 0);
    assertEqual(ne(7, 1), 0);
    assertEqual(ne(8, 1), 1);
    assertEqual(ne(250, 0), 0);
    assertEqual(ne(249, 0), 1);
    assertEqual(both(31, 1, &o), 0);
    assertEqual(o, 32);
    assertEqual(both(32, 1, &o), 1);
    assertEqual(both(254, 0, &o), 0);
    assertEqual(o, 255);
    assertEqual(both(255, 0, &o), 1);
    assertEqual(stepped(31, 1), 0);
    assertEqual(stepped(32, 1), 1);
    assertEqual(stepped(255, 0), 1);
    assertEqual(loop(1, 40), 284);
    assertEqual(loop(0, 40), 252);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte compare of byte-valued operands");
    suite_add_test(check);
    return suite_run();
}
