/* 16-bit byte-pack folding (ir_match "packbytes", width-2 arm).
 *
 * The pattern already folded the width-4 LITTLE-endian spelling into one wide
 * load. Endianness falls straight out of how each lane's byte offset relates
 * to the shift that places it:
 *
 *     little-endian:  offset - shift/8   is the same for every lane
 *     big-endian:     offset + shift/8   is the same for every lane
 *
 * so both spellings, at width 2 and 4, are one generalised test. Big-endian
 * needs a byte reversal after the load; at width 2 that IS a rotate by 8, so
 * it reuses IR_ROTL and needs no new IR op (a width-4 byte REVERSE is not any
 * rotation and does, which is why width-4 big-endian is still rejected).
 *
 * These read a byte array, so the value is genuinely assembled from memory and
 * a wrong fold shows up as a swapped or misaddressed result rather than a
 * crash. The buffer is deliberately NOT symmetric and no two adjacent bytes
 * are equal, so a swapped pair or an off-by-one offset cannot coincide with
 * the right answer.
 *
 * Cases:
 *  - be/le at offset 0 and at a non-zero offset (the fold has to recover the
 *    base offset from the lanes, and gets it from a different expression for
 *    each endianness -- an off-by-one there is exactly what this catches).
 *  - odd (unaligned) offsets, since a wide load at an odd address is fine on
 *    z80 but is the kind of thing a fold can wrongly reject or mis-round.
 *  - be32, which must still compute correctly via the UNFOLDED path (width-4
 *    big-endian is rejected) -- it pins that rejecting is not the same as
 *    breaking.
 *  - vol, whose pointer target is volatile: must not fold, must be right.
 *
 * Self-verifying against constants computed by hand from the buffer.
 */
#include "test.h"

static unsigned char buf[10] = { 0x12, 0x34, 0x56, 0x78, 0x9A,
                                 0xBC, 0xDE, 0xF0, 0x11, 0x22 };

static unsigned int be16(unsigned char *b)
{
    return ((unsigned int)b[0] << 8) | (unsigned int)b[1];
}

static unsigned int le16(unsigned char *b)
{
    return ((unsigned int)b[1] << 8) | (unsigned int)b[0];
}

/* Non-zero base offsets, both parities. */
static unsigned int be16_at(unsigned char *b, int i)
{
    return ((unsigned int)b[i] << 8) | (unsigned int)b[i + 1];
}

static unsigned long be32(unsigned char *b)
{
    return ((unsigned long)b[0] << 24) | ((unsigned long)b[1] << 16)
         | ((unsigned long)b[2] << 8)  | (unsigned long)b[3];
}

static unsigned long le32(unsigned char *b)
{
    return ((unsigned long)b[3] << 24) | ((unsigned long)b[2] << 16)
         | ((unsigned long)b[1] << 8)  | (unsigned long)b[0];
}

static volatile unsigned char *vp;
static unsigned int vol16(void)
{
    return ((unsigned int)vp[0] << 8) | (unsigned int)vp[1];
}

static void test_pack16(void)
{
    Assert(be16(&buf[0]) == 0x1234u, "be16 @0");
    Assert(le16(&buf[0]) == 0x3412u, "le16 @0");
    Assert(be16(&buf[2]) == 0x5678u, "be16 @2 (even)");
    Assert(le16(&buf[2]) == 0x7856u, "le16 @2 (even)");
    Assert(be16(&buf[1]) == 0x3456u, "be16 @1 (odd)");
    Assert(le16(&buf[1]) == 0x5634u, "le16 @1 (odd)");
    Assert(be16(&buf[8]) == 0x1122u, "be16 @8 (last pair)");

    Assert(be16_at(buf, 0) == 0x1234u, "be16_at 0");
    Assert(be16_at(buf, 3) == 0x789Au, "be16_at 3");
    Assert(be16_at(buf, 6) == 0xDEF0u, "be16_at 6");

    Assert(be32(&buf[0]) == 0x12345678UL, "be32 @0 (unfolded path)");
    Assert(le32(&buf[0]) == 0x78563412UL, "le32 @0 (folded)");
    Assert(be32(&buf[4]) == 0x9ABCDEF0UL, "be32 @4");
    Assert(le32(&buf[4]) == 0xF0DEBC9AUL, "le32 @4");

    vp = buf;
    Assert(vol16() == 0x1234u, "vol16 (must not fold)");
    vp = &buf[4];
    Assert(vol16() == 0x9ABCu, "vol16 @4");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("16-bit byte-pack fold (both endiannesses)");
    suite_add_test(test_pack16);
    return suite_run();
}
