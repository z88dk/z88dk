/* Bytes packed into words and longs, byte-masked variable shifts, and signed
 * shifts of byte-sized constants. References use tables, subtraction and a
 * volatile multiplier, never the shapes under test.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;

static const u8 pow8[8] = { 128, 64, 32, 16, 8, 4, 2, 1 };
volatile u16 k256 = 256;
volatile u16 k1 = 1;
u16 sink16;

/* a & b for bytes, taking powers of two off. */
static u8 and8(u8 a, u8 b)
{
    u8 r = 0, i;
    for (i = 0; i < 8; ++i) {
        u8 p = pow8[i];
        u8 ab = 0, bb = 0;
        if (a >= p) { ab = 1; a = (u8)(a - p); }
        if (b >= p) { bb = 1; b = (u8)(b - p); }
        if (ab && bb) r = (u8)(r + p);
    }
    return r;
}
static u8 or8(u8 a, u8 b)  { return (u8)(a + b - and8(a, b)); }
static u8 xor8(u8 a, u8 b) { return (u8)(a + b - 2 * and8(a, b)); }

/* x << 8 | y, x << 8 ^ y, x << 8 + y, and w & y */
static u16 pk_or(u8 x, u8 y)  { return ((u16)x << 8) | y; }
static u16 pk_xor(u8 x, u8 y) { return ((u16)x << 8) ^ y; }
static u16 pk_add(u8 x, u8 y) { return ((u16)x << 8) + y; }
static u16 pk_and(u16 w, u8 y) { return w & y; }
static u16 pk_and2(u16 w, u8 y) { return y & w; }
static u16 pk_ior(u16 w, u8 y) { return w | y; }
static u16 pk_xr(u16 w, u8 y) { return w ^ y; }

static u32 l8(u8 x)  { return (u32)x << 8; }
static u32 l16(u8 x) { return (u32)x << 16; }
static u32 l24(u8 x) { return (u32)x << 24; }
static u32 l4b(u8 a, u8 b, u8 c, u8 d)
{ return ((u32)a << 24) | ((u32)b << 16) | ((u32)c << 8) | d; }

/* 0x80 >> (n & 7), as a byte, masked, and tested */
static u8 v1(u8 n) { return 0x80 >> (n & 7); }
static u8 v2(u8 n, u8 q) { return (q & (0x80 >> (n & 7))) ? 4 : 0; }
static u16 v3(u8 n, u16 w) { return w + (0x80 >> (n & 7)); }
static int v4(u8 n) { int s = 0x40; return s >> (n & 3); }

static void check(void)
{
    int bad = 0;
    unsigned x, y, q;
    for (x = 0; x < 256; x += 11)
        for (y = 0; y < 256; y += 13) {
            u16 hi = (u16)(x * k256);
            u16 w = (u16)(hi + x);                      /* x in both bytes */
            if (pk_or((u8)x, (u8)y)  != (u16)(hi + y)) ++bad;
            if (pk_xor((u8)x, (u8)y) != (u16)(hi + y)) ++bad;
            if (pk_add((u8)x, (u8)y) != (u16)(hi + y)) ++bad;
            if (pk_and(w, (u8)y)  != and8((u8)x, (u8)y)) ++bad;
            if (pk_and2(w, (u8)y) != and8((u8)x, (u8)y)) ++bad;
            if (pk_ior(w, (u8)y) != (u16)(hi + or8((u8)x, (u8)y))) ++bad;
            if (pk_xr(w, (u8)y)  != (u16)(hi + xor8((u8)x, (u8)y))) ++bad;
        }
    for (x = 0; x < 256; x += 7) {
        u32 b = (u32)x;
        if (l8((u8)x)  != (u32)(b * k256)) ++bad;
        if (l16((u8)x) != (u32)(b * k256 * k256)) ++bad;
        if (l24((u8)x) != (u32)(b * k256 * k256 * k256)) ++bad;
    }
    if (l4b(1, 2, 3, 4) != 0x01020304UL) ++bad;
    if (l4b(0xff, 0, 0x80, 0x7f) != 0xff00807fUL) ++bad;
    for (x = 0; x < 256; x += 9) {
        if (v1((u8)x) != pow8[x & 7]) ++bad;
        if (v3((u8)x, 1000) != (u16)(1000 + pow8[x & 7])) ++bad;
        for (q = 0; q < 256; q += 17)
            if (v2((u8)x, (u8)q) != (and8((u8)q, pow8[x & 7]) ? 4 : 0)) ++bad;
    }
    for (x = 0; x < 4; ++x)
        if (v4((u8)x) != (int)(0x40 >> x)) ++bad;
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte packs and variable byte shifts");
    suite_add_test(check);
    return suite_run();
}
