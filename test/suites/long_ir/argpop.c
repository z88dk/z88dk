/* The first stack argument of a leaf function is taken with pop/pop/push/push
 * when A and DE are free after it; the return address and the argument must
 * survive, and a caller's DE and A must not be needed by the callee.
 */
#include "test.h"

static int first(int *p)             { return *(char *)p; }
static int lo(char *p)               { return p[0] + p[1]; }
static int twice(int x)              { return x + x; }
static int second(int a, int b)      { return a - b; }
static unsigned char bytep(unsigned char *p) { return (unsigned char)(*p << 1); }
static int loopsum(int *p, int n)    { int s = 0; while (n--) s += *p++; return s; }

static void check(void)
{
    int v = 0x1234, i;
    int tab[4] = { 1, 20, 300, 4000 };
    char s[3] = { 5, 6, 0 };
    unsigned char b = 100;

    for (i = 0; i < 4; i++) {
        assertEqual(twice(tab[i]), tab[i] * 2);
        assertEqual(second(tab[i], i), tab[i] - i);
    }
    assertEqual(first(&v), 0x34);
    assertEqual(lo(s), 11);
    assertEqual(bytep(&b), 200);
    assertEqual(loopsum(tab, 4), 4321);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("first argument of a leaf function");
    suite_add_test(check);
    return suite_run();
}
