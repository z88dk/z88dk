/* The bitwise SELECT identity (ir_match "mux"):
 *
 *      (x & y) | (~x & z)   ==   z ^ (x & (y ^ z))
 *
 * The rewrite matters because the left side is a TREE -- both ANDs are live at
 * the OR, so at width 4 two 32-bit intermediates need registers at once, and
 * the lowerer parks one with push/pop and merges through an SP-derived pointer
 * -- while the right side is a CHAIN, one live intermediate, carried in the
 * register cache. So this test is really pinning an ALGEBRAIC identity, and
 * the failure mode is a silently wrong bit rather than a crash.
 *
 * What it covers, and why each case is here:
 *  - sel_a / sel_b   md5's F (selector in the AND's FIRST slot) and G (SECOND
 *                    slot). The engine binds src slots left-to-right with no
 *                    backtracking, so the role of the selector is read off the
 *                    NOT; get that wrong and one of these two silently stops
 *                    matching (a size regression, not a failure) or binds the
 *                    wrong operand (a WRONG ANSWER, which is what these catch).
 *  - blit            the same shape written the way sprite code writes it,
 *                    `(dst & ~m) | (src & m)`, to prove the match is on the
 *                    shape and not on md5's spelling.
 *  - sel16           width 2 -- the rewrite is width-agnostic.
 *  - shared_not      `~x` used a SECOND time outside the shape. Must not
 *                    rewrite (the single-use condition), and must still be
 *                    right if it ever does.
 *  - vol_sel         a volatile selector. The rewrite reads z twice where the
 *                    original read x twice, so the access COUNT changes;
 *                    volatile operands are excluded. Pinned by value here --
 *                    the access count itself is checked by the compiler gate.
 *
 * Vectors include all-ones and all-zeroes selectors (the mux degenerates to y
 * or to z, catching a swapped pair) and 0xA5A5A5A5 (alternating, so a
 * per-byte or per-bit slip cannot cancel out).
 *
 * Self-verifying against constants computed off-target. No printf.
 */
#include "test.h"

typedef unsigned long u32;
typedef unsigned int  u16;

/* md5's F: selector is the AND's first operand. */
static u32 sel_a(u32 x, u32 y, u32 z) { return ((x) & (y)) | ((~x) & (z)); }

/* md5's G shape: selector is the AND's second operand, and the ~ sits on the
   other AND's second operand -- the mirror of sel_a in both slots. */
static u32 sel_b(u32 x, u32 y, u32 z) { return ((y) & (x)) | ((z) & (~x)); }

/* How masking is actually written when compositing. */
static u32 blit(u32 dst, u32 src, u32 mask)
{
    return (dst & ~mask) | (src & mask);
}

static u16 sel16(u16 x, u16 y, u16 z) { return ((x) & (y)) | ((~x) & (z)); }

/* ~x escapes the shape, so the temp is not single-use: must not fold. */
static u32 shared_not(u32 x, u32 y, u32 z, u32 *nx)
{
    u32 n = ~x;
    *nx = n;
    return (x & y) | (n & z);
}

static volatile u32 vsel;
static u32 vol_sel(u32 y, u32 z) { return (vsel & y) | ((~vsel) & z); }

static void test_mux(void)
{
    Assert(sel_a(0x12345678UL, 0x9ABCDEF0UL, 0x0F0F0F0FUL) == 0x1F3F5F77UL, "sel_a");
    Assert(sel_a(0xFFFFFFFFUL, 0x00000000UL, 0xAAAAAAAAUL) == 0x00000000UL, "sel_a");
    Assert(sel_a(0x00000000UL, 0xDEADBEEFUL, 0x12345678UL) == 0x12345678UL, "sel_a");
    Assert(sel_a(0xA5A5A5A5UL, 0xFFFF0000UL, 0x0000FFFFUL) == 0xA5A55A5AUL, "sel_a");

    Assert(sel_b(0x12345678UL, 0x9ABCDEF0UL, 0x0F0F0F0FUL) == 0x1F3F5F77UL, "sel_b");
    Assert(sel_b(0xFFFFFFFFUL, 0x00000000UL, 0xAAAAAAAAUL) == 0x00000000UL, "sel_b");
    Assert(sel_b(0x00000000UL, 0xDEADBEEFUL, 0x12345678UL) == 0x12345678UL, "sel_b");
    Assert(sel_b(0xA5A5A5A5UL, 0xFFFF0000UL, 0x0000FFFFUL) == 0xA5A55A5AUL, "sel_b");

    Assert(blit(0x12345678UL, 0x9ABCDEF0UL, 0x0F0F0F0FUL) == 0x1A3C5E70UL, "blit");
    Assert(blit(0xFFFFFFFFUL, 0x00000000UL, 0xAAAAAAAAUL) == 0x55555555UL, "blit");
    Assert(blit(0x00000000UL, 0xDEADBEEFUL, 0x12345678UL) == 0x12241668UL, "blit");
    Assert(blit(0xA5A5A5A5UL, 0xFFFF0000UL, 0x0000FFFFUL) == 0xA5A50000UL, "blit");

    Assert(sel16(0x1234u, 0xABCDu, 0x0F0Fu) == 0x0F0Fu, "sel16");
    Assert(sel16(0xFFFFu, 0x0000u, 0xAAAAu) == 0x0000u, "sel16");
    Assert(sel16(0x0000u, 0xBEEFu, 0x1234u) == 0x1234u, "sel16");

    {
        u32 nx = 0;
        Assert(shared_not(0x12345678UL, 0x9ABCDEF0UL, 0x0F0F0F0FUL, &nx) == 0x1F3F5F77UL, "shared_not value");
        Assert(nx == 0xEDCBA987UL, "shared_not escaped ~x");
        Assert(shared_not(0xFFFFFFFFUL, 0x00000000UL, 0xAAAAAAAAUL, &nx) == 0x00000000UL, "shared_not value");
        Assert(nx == 0x00000000UL, "shared_not escaped ~x");
    }

    vsel = 0x12345678UL;
    Assert(vol_sel(0x9ABCDEF0UL, 0x0F0F0F0FUL) == 0x1F3F5F77UL, "vol_sel");
    vsel = 0xFFFFFFFFUL;
    Assert(vol_sel(0x00000000UL, 0xAAAAAAAAUL) == 0x00000000UL, "vol_sel");
    vsel = 0x00000000UL;
    Assert(vol_sel(0xDEADBEEFUL, 0x12345678UL) == 0x12345678UL, "vol_sel");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Bitwise select identity (mux rewrite)");
    suite_add_test(test_mux);
    return suite_run();
}
