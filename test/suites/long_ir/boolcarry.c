/* A comparison kept as a 0/1 byte, with the carry set and with it clear. The
 * references subtract and test the sign, so they never use the same compare.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;

volatile u8 sink8;

static u8 lt8(u8 a, u8 b)   { return a < b; }
static u8 ge8(u8 a, u8 b)   { return a >= b; }
static u8 gt8(u8 a, u8 b)   { return a > b; }
static u8 le8(u8 a, u8 b)   { return a <= b; }
static u8 ltk(u8 a)         { return a < 100; }
static u8 gek(u8 a)         { return a >= 100; }
static u8 lt16(u16 a, u16 b){ return a < b; }
static u8 ge16(u16 a, u16 b){ return a >= b; }
static int use(u8 a, u8 b)
{
    u8 x = a < b, y = a >= b;      /* both polarities live at once */
    sink8 = x;
    return x * 10 + y * 3;
}

static void check(void)
{
    int bad = 0;
    unsigned x, y;
    for (x = 0; x < 256; x += 5)
        for (y = 0; y < 256; y += 7) {
            u8 a = (u8)x, b = (u8)y;
            u16 p = (u16)(x * 251u), q = (u16)(y * 241u);
            int lt = (int)a - (int)b < 0, ge = !lt;
            int gt = (int)b - (int)a < 0, le = !gt;
            if (lt8(a, b) != lt) ++bad;
            if (ge8(a, b) != ge) ++bad;
            if (gt8(a, b) != gt) ++bad;
            if (le8(a, b) != le) ++bad;
            if (ltk(a) != ((int)a - 100 < 0)) ++bad;
            if (gek(a) != ((int)a - 100 >= 0)) ++bad;
            if (lt16(p, q) != ((long)p - (long)q < 0)) ++bad;
            if (ge16(p, q) != ((long)p - (long)q >= 0)) ++bad;
            if (use(a, b) != lt * 10 + ge * 3) ++bad;
            if (sink8 != lt) ++bad;
        }
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("comparison results as bytes");
    suite_add_test(check);
    return suite_run();
}
