/* Loop-invariant expressions of several sizes, in conditional arms and out of
 * them, under --opt-code-size. Each is checked against a volatile twin that
 * recomputes it every time.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;

u8 tab2[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
u8 tab4[32];
volatile u16 vk;

static u16 nest(u8 y, u8 ty, u8 kind, const u8 *l)
{
    u16 t = 0;
    u8 i, tx;
    for (i = 0; i < 4; ++i) {
        const u8 *b;
        tx = (u8)(ty + i);
        if (kind == 1)      b = tab2 + ((y & 1) << 1);
        else if (kind == 2) b = tab4 + ((y & 3) << 2) + ((tx & 1) << 1);
        else                b = tab4 + ((ty & 3) << 2) + (tx & 3);
        t += (u16)(l[i] > b[0]) + (u16)b[1];
    }
    return t;
}
static u16 nestv(u8 y, u8 ty, u8 kind, const u8 *l)
{
    u16 t = 0;
    u8 i, tx;
    volatile u8 vy = y, vt = ty;
    for (i = 0; i < 4; ++i) {
        const u8 *b;
        tx = (u8)(vt + i);
        if (kind == 1)      b = tab2 + ((vy & 1) << 1);
        else if (kind == 2) b = tab4 + ((vy & 3) << 2) + ((tx & 1) << 1);
        else                b = tab4 + ((vt & 3) << 2) + (tx & 3);
        t += (u16)(l[i] > b[0]) + (u16)b[1];
    }
    return t;
}
static u16 sums(u8 a, u8 b, u8 n)
{
    u16 t = 0;
    u8 i;
    for (i = 0; i < n; ++i)
        t += (u16)(a + b) + (u16)(a * 3 + (b << 2)) + i;
    return t;
}
static u16 sumsv(u8 a, u8 b, u8 n)
{
    u16 t = 0;
    u8 i;
    volatile u8 va = a, vb = b;
    for (i = 0; i < n; ++i)
        t += (u16)(va + vb) + (u16)(va * 3 + (vb << 2)) + i;
    return t;
}

static void check(void)
{
    int bad = 0;
    unsigned i, y, k;
    u8 l[4] = { 3, 9, 14, 20 };
    for (i = 0; i < sizeof tab4; ++i) tab4[i] = (u8)(i * 5 + 2);
    for (y = 0; y < 8; ++y)
        for (k = 0; k < 4; ++k)
            if (nest((u8)y, (u8)(y + 3), (u8)k, l) != nestv((u8)y, (u8)(y + 3), (u8)k, l)) ++bad;
    for (y = 0; y < 40; y += 3)
        for (k = 0; k < 9; ++k)
            if (sums((u8)y, (u8)(y + k), (u8)k) != sumsv((u8)y, (u8)(y + k), (u8)k)) ++bad;
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("invariants under --opt-code-size");
    suite_add_test(check);
    return suite_run();
}
