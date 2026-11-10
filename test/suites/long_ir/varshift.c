/* Variable-count byte shifts, counts 0..15, every byte value. The reference
 * halves or doubles one step at a time, so it never uses a variable shift.
 */
#include "test.h"

typedef unsigned char u8;
typedef signed char s8;
typedef unsigned short u16;

static u8 vshl(u8 x, u8 n) { return (u8)(x << n); }
static u8 vshr(u8 x, u8 n) { return (u8)(x >> n); }
static s8 vsar(s8 x, u8 n) { return (s8)(x >> n); }
static u8 vmask(u8 n, u8 q) { return (q & (0x80 >> (n & 7))) ? 4 : 0; }

static u8 ref_shl(u8 x, u8 n)
{
    u16 v = x;
    while (n--) v = (u16)(v + v);
    return (u8)v;
}
static u8 ref_shr(u8 x, u8 n)
{
    u16 v = x;
    while (n--) v = (u16)(v / 2);
    return (u8)v;
}
static s8 ref_sar(s8 x, u8 n)
{
    int v = x;
    while (n--) v = (v < 0) ? (v - 1) / 2 : v / 2;      /* floor halving */
    return (s8)v;
}

static void check(void)
{
    int bad = 0;
    unsigned x, n;
    for (x = 0; x < 256; ++x)
        for (n = 0; n < 16; ++n) {
            if (vshl((u8)x, (u8)n) != ref_shl((u8)x, (u8)n)) ++bad;
            if (vshr((u8)x, (u8)n) != ref_shr((u8)x, (u8)n)) ++bad;
            if (vsar((s8)x, (u8)n) != ref_sar((s8)x, (u8)n)) ++bad;
        }
    for (n = 0; n < 16; ++n)
        for (x = 0; x < 256; x += 17)
            if (vmask((u8)n, (u8)x) != ((ref_shr(0x80, (u8)(n & 7)) & x) ? 4 : 0)) ++bad;
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("variable-count byte shifts");
    suite_add_test(check);
    return suite_run();
}
