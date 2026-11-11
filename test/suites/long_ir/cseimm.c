/* The same constant shifted, masked or subtracted twice must be computed once
 * without confusing it with a different constant of the same width.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;

volatile u8 vk;
volatile u16 vw;

static void twice(u8 *art, u8 r, u8 x)
{
    art[r] ^= (u8)(0xC0 >> ((x & 3) * 2));
    art[r + 1] ^= (u8)(0xC0 >> ((x & 3) * 2));
}
static void twicev(u8 *art, u8 r, u8 x)
{
    volatile u8 n = (u8)((x & 3) * 2);
    art[r] ^= (u8)(0xC0 >> n);
    art[r + 1] ^= (u8)(0xC0 >> n);
}
/* two constants of one width that differ */
static u16 pair(u16 n)
{
    u16 a = 0x1234 >> (n & 7);
    u16 b = 0x4321 >> (n & 7);
    u16 c = 0x1234 >> (n & 7);
    return a + 3 * b + 5 * c;
}
static u16 pairv(u16 n)
{
    volatile u16 k1 = 0x1234, k2 = 0x4321;
    volatile u16 m = (u16)(n & 7);
    u16 a = (u16)(k1 >> m), b = (u16)(k2 >> m), c = (u16)(k1 >> m);
    return a + 3 * b + 5 * c;
}
static u16 sub(u16 x, u16 y)
{
    u16 a = 1000 - x, b = 1001 - y, c = 1000 - x;
    return a * 2 + b + c;
}
static u16 subv(u16 x, u16 y)
{
    volatile u16 k = 1000, k1 = 1001;
    u16 a = (u16)(k - x), b = (u16)(k1 - y), c = (u16)(k - x);
    return a * 2 + b + c;
}
static u8 bytes(u8 n)
{
    u8 a = (u8)(0x81 >> (n & 7)), b = (u8)(0x18 >> (n & 7)), c = (u8)(0x81 >> (n & 7));
    return (u8)(a + b * 3 + c * 5);
}
static u8 bytesv(u8 n)
{
    volatile u8 k1 = 0x81, k2 = 0x18, m = (u8)(n & 7);
    u8 a = (u8)(k1 >> m), b = (u8)(k2 >> m), c = (u8)(k1 >> m);
    return (u8)(a + b * 3 + c * 5);
}

static void check(void)
{
    int bad = 0;
    unsigned n, x;
    u8 a1[4], a2[4];
    for (n = 0; n < 40; ++n) {
        for (x = 0; x < 4; ++x) { a1[x] = a2[x] = (u8)(x * 17 + n); }
        twice(a1, 1, (u8)n); twicev(a2, 1, (u8)n);
        for (x = 0; x < 4; ++x) if (a1[x] != a2[x]) ++bad;
        if (pair((u16)n) != pairv((u16)n)) ++bad;
        if (sub((u16)(n * 77), (u16)(n * 31)) != subv((u16)(n * 77), (u16)(n * 31))) ++bad;
        if (bytes((u8)n) != bytesv((u8)n)) ++bad;
    }
    /* fixed values */
    if (pair(0) != (u16)(0x1234 + 3 * 0x4321 + 5 * 0x1234)) ++bad;
    if (pair(4) != (u16)(0x123 + 3 * 0x432 + 5 * 0x123)) ++bad;
    if (bytes(1) != (u8)(0x40 + 0x0c * 3 + 0x40 * 5)) ++bad;
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("repeated constants in shifts and subtractions");
    suite_add_test(check);
    return suite_run();
}
