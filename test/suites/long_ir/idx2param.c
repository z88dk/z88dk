/* Two parameters whose live ranges do not overlap must not share the spare
 * index register: the prologue loads every parameter into its home, so the
 * second load overwrote the first before its last use.
 */
#include "test.h"

static unsigned char cell[32];

static unsigned int f(unsigned char *p, unsigned int rc, int a, int b, int c)
{
    unsigned int n = 0;

    n += (rc == 0xFEu && p[0] == 0xFE && p[7] != 0xFF);
    n += (rc == 0u && p[3] == 0 && p[12] != 1);
    n += (rc == 1u && p[6] == 1 && p[17] != 2);
    n += (a < b);
    n += (a > c);
    n += (a <= b);
    n += (b >= c);
    n += (a == c);
    n += (b != a);
    return n;
}

static void check(void)
{
    int i;

    for (i = 0; i < 32; i++)
        cell[i] = (unsigned char)(i * 13 + 5);
    assertEqual(f(cell, 0, -8, -7, 0), 3);
    assertEqual(f(cell, 1, -8, -7, 0), 3);
    assertEqual(f(cell, 0xFE, 5, 5, 5), 3);
    assertEqual(f(cell, 7, 9, -2, 4), 2);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("disjoint index-home parameters");
    suite_add_test(check);
    return suite_run();
}
