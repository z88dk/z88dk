/* De Morgan, in the direction that REMOVES a complement:
 *
 *      (~x) & (~y)  ==  ~(x | y)
 *      (~x) | (~y)  ==  ~(x & y)
 *
 * Same structural point as the mux rewrite one step smaller. On the left both
 * complements are live at the combining op, so at width 4 two 32-bit values
 * want registers at once and one gets parked on the stack; on the right it is
 * a chain -- combine, then complement -- and only one is ever live. A whole
 * NOT also disappears, which at width 4 is a 12-instruction byte walk.
 *
 * Cases:
 *  - and32 / or32      the two directions at width 4 (the anchor matches
 *                      AND or OR via kind_alt, and the apply must emit the
 *                      DUAL -- emitting the same operator is the obvious bug
 *                      and these catch it immediately).
 *  - and16 / or16      width 2.
 *  - same_operand      `(~x) & (~x)`. Degenerates to ~x; the rewrite gives
 *                      ~(x|x) which is also ~x, so both must agree.
 *  - one_shared        `~x` used again outside the shape: single-use fails,
 *                      must not rewrite, must still be right.
 *  - chained           `(~a & ~b) & ~c` -- the rewrite's own output feeds
 *                      another instance, so this pins that iterating to
 *                      fixpoint stays correct.
 *
 * Vectors include complementary pairs (0xA5A5A5A5 / 0x5A5A5A5A, whose AND is
 * 0 and OR is all-ones) and both all-ones and all-zeroes, so a swapped
 * operator cannot coincidentally agree.
 *
 * Self-verifying against constants computed off-target. No printf.
 */
#include "test.h"

typedef unsigned long u32;
typedef unsigned int  u16;

static u32 and32(u32 x, u32 y) { return (~x) & (~y); }
static u32 or32 (u32 x, u32 y) { return (~x) | (~y); }
static u16 and16(u16 x, u16 y) { return (u16)((~x) & (~y)); }
static u16 or16 (u16 x, u16 y) { return (u16)((~x) | (~y)); }

static u32 same_operand(u32 x) { return (~x) & (~x); }

/* ~x escapes, so the temp is not single-use and the fold must not fire. */
static u32 one_shared(u32 x, u32 y, u32 *nx)
{
    u32 n = ~x;
    *nx = n;
    return n & (~y);
}

/* The rewrite's output is itself a De Morgan operand: fixpoint iteration. */
static u32 chained(u32 a, u32 b, u32 c)
{
    return ((~a) & (~b)) & (~c);
}

static void test_demorgan(void)
{
    Assert(and32(0x12345678UL, 0x0F0F0F0FUL) == 0xE0C0A080UL, "and32");
    Assert(and32(0xFFFFFFFFUL, 0x00000000UL) == 0x00000000UL, "and32");
    Assert(and32(0x00000000UL, 0x00000000UL) == 0xFFFFFFFFUL, "and32");
    Assert(and32(0xA5A5A5A5UL, 0x5A5A5A5AUL) == 0x00000000UL, "and32");
    Assert(and32(0xDEADBEEFUL, 0xCAFEBABEUL) == 0x21004100UL, "and32");

    Assert(or32 (0x12345678UL, 0x0F0F0F0FUL) == 0xFDFBF9F7UL, "or32");
    Assert(or32 (0xFFFFFFFFUL, 0x00000000UL) == 0xFFFFFFFFUL, "or32");
    Assert(or32 (0x00000000UL, 0x00000000UL) == 0xFFFFFFFFUL, "or32");
    Assert(or32 (0xA5A5A5A5UL, 0x5A5A5A5AUL) == 0xFFFFFFFFUL, "or32");
    Assert(or32 (0xDEADBEEFUL, 0xCAFEBABEUL) == 0x35534551UL, "or32");

    Assert(and16(0x1234u, 0x0F0Fu) == 0xE0C0u, "and16");
    Assert(or16 (0x1234u, 0x0F0Fu) == 0xFDFBu, "or16");
    Assert(and16(0xFFFFu, 0x0000u) == 0x0000u, "and16");
    Assert(or16 (0xFFFFu, 0x0000u) == 0xFFFFu, "or16");
    Assert(and16(0xA5A5u, 0x5A5Au) == 0x0000u, "and16");
    Assert(or16 (0xA5A5u, 0x5A5Au) == 0xFFFFu, "or16");

    Assert(same_operand(0x12345678UL) == 0xEDCBA987UL, "same_operand");
    Assert(same_operand(0xFFFFFFFFUL) == 0x00000000UL, "same_operand");
    Assert(same_operand(0x00000000UL) == 0xFFFFFFFFUL, "same_operand");

    {
        u32 nx = 0;
        Assert(one_shared(0x12345678UL, 0x0F0F0F0FUL, &nx) == 0xE0C0A080UL, "one_shared value");
        Assert(nx == 0xEDCBA987UL, "one_shared escaped ~x");
        Assert(one_shared(0xFFFFFFFFUL, 0x00000000UL, &nx) == 0x00000000UL, "one_shared value");
        Assert(nx == 0x00000000UL, "one_shared escaped ~x");
    }

    Assert(chained(0x12345678UL, 0x0F0F0F0FUL, 0x0F0F0F0FUL) == 0xE0C0A080UL, "chained");
    Assert(chained(0xFFFFFFFFUL, 0x00000000UL, 0x0F0F0F0FUL) == 0x00000000UL, "chained");
    Assert(chained(0x00000000UL, 0x00000000UL, 0x0F0F0F0FUL) == 0xF0F0F0F0UL, "chained");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("De Morgan complement-distribution");
    suite_add_test(test_demorgan);
    return suite_run();
}
