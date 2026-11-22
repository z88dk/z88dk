/* A loop-carried pointer or counter homed in IX/IY is stepped by one or two
 * with inc/dec of the register; each shape here is checked against a result
 * worked out from the data.
 */
#include "test.h"

static const unsigned char a1[6] = { 1, 2, 3, 4, 5, 6 };
static unsigned char b1[6]       = { 1, 2, 3, 4, 5, 6 };

static int key_eq(const unsigned char *a, const unsigned char *b)
{
    int i;
    for (i = 0; i < 6; i++)
        if (a[i] != b[i]) return 0;
    return 1;
}

static int sum_step2(const unsigned char *p)
{
    int i, s = 0;
    for (i = 0; i < 6; i += 2) s += p[i];
    return s;
}

static int sum_back(const unsigned char *p)
{
    int i, s = 0;
    for (i = 5; i >= 0; i--) s = s * 3 + p[i];
    return s;
}

static unsigned int hash(const unsigned char *k)
{
    unsigned int h = 5381u;
    int i;
    for (i = 0; i < 6; i++)
        h = (unsigned int)(((h << 5) + h + k[i]) & 0xffffu);
    return h;
}

static void check(void)
{
    assertEqual(key_eq(a1, b1), 1);
    b1[5] = 9;
    assertEqual(key_eq(a1, b1), 0);
    b1[5] = 6; b1[0] = 0;
    assertEqual(key_eq(a1, b1), 0);
    assertEqual(sum_step2(a1), 1 + 3 + 5);
    assertEqual(sum_back(a1), ((((6 * 3 + 5) * 3 + 4) * 3 + 3) * 3 + 2) * 3 + 1);
    assertEqual(hash(a1), 0x153a);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("index register step");
    suite_add_test(check);
    return suite_run();
}
