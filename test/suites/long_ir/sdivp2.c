/* Signed division by a power of two must round toward zero. The references
 * divide by a volatile, so they go through the division routine.
 */
#include "test.h"

typedef signed char i8;
typedef short i16;

volatile i16 d2 = 2, d4 = 4, d8 = 8, d16 = 16;

static i16 h2(i16 x)  { return x / 2; }
static i16 h4(i16 x)  { return x / 4; }
static i16 h8(i16 x)  { return x / 8; }
static i16 h16(i16 x) { return x / 16; }
static i16 hb(i8 x)   { return (i16)x / 2; }
static i16 hb4(i8 x)  { return (i16)x / 4; }
static i16 r2(i16 x)  { return x % 2; }
static i16 use(i16 x) { i16 q = x / 4; return q + x; }

static void check(void)
{
    int bad = 0;
    long v;
    static const i16 edge[] = { -32768, -32767, -17, -16, -15, -9, -8, -7, -5, -4, -3, -2, -1,
                                0, 1, 2, 3, 4, 5, 7, 8, 9, 15, 16, 17, 32766, 32767 };
    unsigned k;
    for (k = 0; k < sizeof edge / sizeof edge[0]; ++k) {
        i16 x = edge[k];
        if (h2(x)  != x / d2)  ++bad;
        if (h4(x)  != x / d4)  ++bad;
        if (h8(x)  != x / d8)  ++bad;
        if (h16(x) != x / d16) ++bad;
        if (r2(x)  != x % d2)  ++bad;
        if (use(x) != (i16)(x / d4 + x)) ++bad;
    }
    for (v = -32768L; v < 32768L; v += 211) {
        i16 x = (i16)v;
        if (h2(x)  != x / d2)  ++bad;
        if (h4(x)  != x / d4)  ++bad;
        if (h8(x)  != x / d8)  ++bad;
        if (h16(x) != x / d16) ++bad;
    }
    for (v = -128; v < 128; ++v) {
        if (hb((i8)v)  != (i16)v / d2) ++bad;
        if (hb4((i8)v) != (i16)v / d4) ++bad;
    }
    /* fixed values */
    if (h2(-1) != 0 || h2(-3) != -1 || h2(3) != 1 || h4(-5) != -1 || h8(-9) != -1) ++bad;
    if (h16(-17) != -1 || h16(-16) != -1 || h16(-15) != 0 || h2(-32768) != -16384) ++bad;
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("signed division by a power of two");
    suite_add_test(check);
    return suite_run();
}
