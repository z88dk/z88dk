/* A branch on a value the block has already tested is folded; a branch after
 * the value is rewritten, or on a different value, is not.
 */
#include "test.h"

static unsigned char nx;

static unsigned char nxt(void) { return nx++; }

static int dupor(unsigned char k, unsigned char n)
{
    if ((k == 8 || k == 8) && n)
        return 1;
    return 0;
}

static int twice(unsigned char k)
{
    int r = 0;

    if (k == 3) r += 1;
    if (k == 3) r += 10;
    return r;
}

static int redef(unsigned char k)
{
    int r = 0;

    if (k) r++;
    k = nxt();
    if (k) r += 2;
    return r;
}

static int nz(unsigned char k, unsigned char m)
{
    if (k && m) {
        if (k)
            return 1;
    }
    return 0;
}

static int diff(unsigned char a, unsigned char b)
{
    if (a == 5 || b == 5)
        return 1;
    return 0;
}

static void check(void)
{
    assertEqual(dupor(8, 1), 1);
    assertEqual(dupor(8, 0), 0);
    assertEqual(dupor(7, 1), 0);
    assertEqual(twice(3), 11);
    assertEqual(twice(4), 0);
    nx = 0;
    assertEqual(redef(1), 1);
    nx = 1;
    assertEqual(redef(0), 2);
    nx = 1;
    assertEqual(redef(1), 3);
    assertEqual(nz(1, 1), 1);
    assertEqual(nz(0, 1), 0);
    assertEqual(nz(1, 0), 0);
    assertEqual(diff(5, 0), 1);
    assertEqual(diff(0, 5), 1);
    assertEqual(diff(1, 2), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("branch on an already-tested value");
    suite_add_test(check);
    return suite_run();
}
