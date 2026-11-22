/* A byte shifted right by a constant and used at word width: the high byte is
 * zero, so the shift acts on the low byte alone. Every byte value and every
 * count is checked against a reference that only subtracts.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;

u8 tbl[256];
u16 sink16;

/* x / 2^n by repeated subtraction. */
static u16 ref(u8 x, u8 n)
{
    u16 d = 1, q = 0, v = x;
    while (n--) d += d;
    while (v >= d) { v -= d; ++q; }
    return q;
}

#define RET(N)  static u16 ret##N(u8 x) { return x >> N; }
#define ADD(N)  static u16 add##N(u8 x, u16 w) { return w + (x >> N); }
#define IDX(N)  static u8  idx##N(u8 x) { return tbl[x >> N]; }
#define MIX(N)  static u16 mix##N(u8 x, u8 y) { return (u16)y * 45 + (x >> N); }
#define ALL(N)  RET(N) ADD(N) IDX(N) MIX(N)
ALL(1) ALL(2) ALL(3) ALL(4) ALL(5) ALL(6) ALL(7)

static void check(void)
{
    int bad = 0;
    unsigned i;
    for (i = 0; i < 256; ++i) tbl[i] = (u8)(i * 7 + 3);
    for (i = 0; i < 256; ++i) {
        u8 x = (u8)i;
#define T(N) \
        if (ret##N(x) != ref(x, N)) ++bad; \
        if (add##N(x, 1000) != (u16)(1000 + ref(x, N))) ++bad; \
        if (idx##N(x) != tbl[ref(x, N)]) ++bad; \
        if (mix##N(x, 200) != (u16)(9000 + ref(x, N))) ++bad;
        T(1) T(2) T(3) T(4) T(5) T(6) T(7)
    }
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte shift at word width");
    suite_add_test(check);
    return suite_run();
}
