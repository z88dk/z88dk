/* Signed remainder by a constant power of two, 16-bit, checked against the
 * helper (a variable divisor) over the edges and a spread of values, including
 * the most negative int; and a signed byte shifted right by 7 or more, which is
 * the sign mask (`add a,a; sbc a,a`).
 */
#include "test.h"

static int vals[] = {0, 1, 2, 3, 4, 5, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64,
    65, 127, 128, 129, 255, 256, 257, 1000, 4095, 4096, 32766, 32767,
    -1, -2, -3, -4, -5, -7, -8, -9, -15, -16, -17, -31, -32, -33, -63, -64,
    -65, -127, -128, -129, -255, -256, -257, -1000, -4095, -4096, -32767, -32767 - 1,
    0};
#define NV (int)(sizeof vals / sizeof vals[0])

volatile int dv;

static int run(void)
{
    int bad = 0, i, n;
    for (i = 0; i < NV; i++) {
        int x = vals[i];
        dv = 2;   n = dv; if (x % 2   != x % n) bad++;
        dv = 4;   n = dv; if (x % 4   != x % n) bad++;
        dv = 8;   n = dv; if (x % 8   != x % n) bad++;
        dv = 16;  n = dv; if (x % 16  != x % n) bad++;
        dv = 64;  n = dv; if (x % 64  != x % n) bad++;
        dv = 128; n = dv; if (x % 128 != x % n) bad++;
        dv = 256; n = dv; if (x % 256 != x % n) bad++;
    }
    return bad;
}

static int idx(int a) { static const int t[4] = {10, 20, 30, 40}; return t[a % 4 + (a % 4 < 0 ? 4 : 0)]; }

static int signs(void)
{
    int bad = 0, i;
    for (i = -128; i < 128; i++) {
        signed char c = (signed char)i;
        signed char m = (signed char)(c >> 7);
        if (m != (i < 0 ? -1 : 0)) bad++;
        if ((signed char)(c >> 8) != (i < 0 ? -1 : 0)) bad++;
    }
    return bad;
}

static void check(void)
{
    assertEqual(signs(), 0);
    assertEqual(run(), 0);
    assertEqual(idx(5), 20);
    assertEqual(idx(-1), 40);
    assertEqual(idx(-6), 30);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("signed word remainder by a power of two");
    suite_add_test(check);
    return suite_run();
}
