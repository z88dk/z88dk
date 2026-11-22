/* x * (2^a + 1), x * (2^a - 1) and the same times 2^b on words: x is copied to DE across the shift
 * instead of being spilled, so the add or subtract can read it back. Checked
 * against repeated addition, in functions that keep other values live in the
 * registers around the multiply.
 */
#include "test.h"

int gx;
static int sink;

static int ref(int x, int n)
{
    int r = 0, k;
    for (k = 0; k < n; k++)
        r += x;
    return r;
}

static int m3(int x)  { return x * 3; }
static int m5(int x)  { return x * 5; }
static int m7(int x)  { return x * 7; }
static int m9(int x)  { return x * 9; }
static int m15(int x) { return x * 15; }
static int m17(int x) { return x * 17; }
static int m6(int x)  { return x * 6; }
static int m10(int x) { return x * 10; }
static int m12(int x) { return x * 12; }
static int m14(int x) { return x * 14; }
static int m20(int x) { return x * 20; }
static int m24(int x) { return x * 24; }
static int m100(int x){ return x * 100; }
static int m96(int x) { return x * 96; }
static int g5(void)   { return gx * 5; }
static int g7(void)   { return gx * 7; }

/* a byte loop and a counter keep other homes busy */
static int busy(int x, unsigned char n)
{
    unsigned char i;
    int acc = 0;
    for (i = 0; i < n; i++) {
        acc += x * 5;
        acc += (x + i) * 7;
        sink += i;
    }
    return acc;
}

static int two(int a, int b) { return a * 3 + b * 5; }

static void check(void)
{
    static const int v[] = { 0, 1, -1, 2, 100, -100, 1000, 12345, -12345, 32767, -32768 };
    int i;

    for (i = 0; i < (int)(sizeof v / sizeof v[0]); i++) {
        int x = v[i];
        gx = x;
        assertEqual(m3(x), ref(x, 3));
        assertEqual(m5(x), ref(x, 5));
        assertEqual(m7(x), ref(x, 7));
        assertEqual(m9(x), ref(x, 9));
        assertEqual(m15(x), ref(x, 15));
        assertEqual(m17(x), ref(x, 17));
        assertEqual(m6(x), ref(x, 6));
        assertEqual(m10(x), ref(x, 10));
        assertEqual(m12(x), ref(x, 12));
        assertEqual(m14(x), ref(x, 14));
        assertEqual(m20(x), ref(x, 20));
        assertEqual(m24(x), ref(x, 24));
        assertEqual(m100(x), ref(x, 100));
        assertEqual(m96(x), ref(x, 96));
        assertEqual(g5(), ref(x, 5));
        assertEqual(g7(), ref(x, 7));
        assertEqual(two(x, 3), ref(x, 3) + 15);
        assertEqual(busy(x, 4), 4 * ref(x, 5) + ref(x, 7) * 4 + ref(6, 7));
    }
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("word multiply by 2^a +- 1");
    suite_add_test(check);
    return suite_run();
}
