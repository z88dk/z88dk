/* Local scalar field promotion: fixed-offset, nonescaping fields can become
 * compiler values. Escaped locals and overlapping union views must stay in
 * memory. */
#include "test.h"

struct fields { int a, b, c, d; };

static unsigned int update(unsigned int seed)
{
    struct fields r;
    int i;
    r.a = seed & 255;
    r.b = (seed >> 4) & 255;
    r.c = (seed >> 8) & 255;
    r.d = 0;
    for (i = 0; i < 8; i++) {
        r.d = (r.d + r.a) & 4095;
        r.a = (r.a ^ r.b) & 255;
        r.b = (r.b + r.c + i) & 255;
        r.c = (r.c ^ r.d) & 255;
    }
    return r.a + r.b + r.c + r.d;
}

static void add_to(int *p, int n)
{
    *p += n;
}

static int escaped(void)
{
    struct fields r;
    r.a = 100;
    add_to(&r.a, 7);
    return r.a;
}

union overlay { unsigned int word; unsigned long wide; };

static unsigned long overlap(void)
{
    union overlay u;
    u.wide = 0x12345678UL;
    u.word = 0xABCD;
    return u.wide;
}

static void test_aggpromote(void)
{
    assertEqual(update(0x4215), 1600);
    assertEqual(escaped(), 107);
    assertEqual(overlap(), 0x1234ABCDUL);
}

int main(void)
{
    suite_setup("local aggregate field promotion");
    suite_add_test(test_aggpromote);
    return suite_run();
}
