/* A 32-bit value read through a truncate loads only the bytes it keeps, and a
 * 32-bit AND with a byte constant is one byte AND zero-extended
 * (ir_opt_narrow_load, ir_opt_long_mask_byte).
 *
 * Both change how many bytes are fetched and written, never the value, so the
 * checks are about the neighbours: a field read too narrowly would lose bits, a
 * load or store at the wrong width would touch the field next to it. The data
 * has every byte different, a set top bit in each byte, and sentinels either
 * side of the field so a stray read or write shows.
 */
#include "test.h"

struct rec {
    unsigned int  before;
    unsigned long val;
    unsigned int  after;
};

static struct rec r;

static unsigned char lo8(struct rec *p)  { return (unsigned char)p->val; }
static unsigned int  lo16(struct rec *p) { return (unsigned int)p->val; }
static unsigned long mask7(struct rec *p)   { return p->val & 127; }
static unsigned long mask_ff(struct rec *p) { return p->val & 0xff; }
static unsigned long mask_80(struct rec *p) { return p->val & 0x80; }
static unsigned int  mod128(struct rec *p)  { return (unsigned int)(p->val % 128); }
static unsigned long mask_reg(unsigned long x) { return x & 0x3f; }

/* a mask that only feeds a branch keeps its single-bit test */
static int bit0(unsigned long x) { return (x & 1) ? 1 : 2; }
static int bit7(unsigned long x) { return (x & 0x80) ? 1 : 2; }

/* the masked value used again at full width */
static unsigned long mask_then_add(struct rec *p)
{
    unsigned long m = p->val & 0x7f;
    return m + p->val;
}

/* offset is 0..127 and size 1..128, so both are bytes even though the source is
   a long and the arithmetic is written in int (ir_opt_range_byte). */
static unsigned long off_size(unsigned long pos, unsigned len)
{
    unsigned offset = (unsigned)(pos % 128);
    unsigned size = 128 - offset;
    if (size > len) size = len;
    return (unsigned long)offset * 1000UL + size + ((offset + 1 == 128) ? 7UL : 0UL);
}

static void test_longmask(void)
{
    r.before = 0xA5A5u;
    r.val    = 0xC3E1A97FUL;
    r.after  = 0x5A5Au;

    assertEqual(lo8(&r),  0x7F);
    assertEqual(lo16(&r), 0xA97F);
    assertEqual(mask7(&r) == 0x7FUL, 1);
    assertEqual(mask_ff(&r) == 0x7FUL, 1);
    assertEqual(mask_80(&r) == 0UL, 1);
    assertEqual(mod128(&r), 0x7F);

    r.val = 0xC3E1A9FEUL;                    /* low byte 0xFE: bit 7 set, bit 0 clear */
    assertEqual(lo8(&r), 0xFE);
    assertEqual(lo16(&r), 0xA9FE);
    assertEqual(mask7(&r) == 0x7EUL, 1);
    assertEqual(mask_ff(&r) == 0xFEUL, 1);
    assertEqual(mask_80(&r) == 0x80UL, 1);
    assertEqual(mod128(&r), 0x7E);
    assertEqual(mask_then_add(&r) == 0x7EUL + 0xC3E1A9FEUL, 1);

    /* high bytes must not leak into a masked result */
    assertEqual(mask_reg(0xFFFFFFFFUL) == 0x3FUL, 1);
    assertEqual(mask_reg(0x12345600UL) == 0UL, 1);

    assertEqual(bit0(0x00000001UL), 1);
    assertEqual(bit0(0xFFFFFFFEUL), 2);
    assertEqual(bit7(0x00000080UL), 1);
    assertEqual(bit7(0xFFFFFF7FUL), 2);

    assertEqual(off_size(0UL, 500) == 128UL, 1);
    assertEqual(off_size(127UL, 500) == 127008UL, 1);
    assertEqual(off_size(128UL, 500) == 128UL, 1);
    assertEqual(off_size(1000UL, 500) == 104024UL, 1);
    assertEqual(off_size(1000UL, 10) == 104010UL, 1);
    assertEqual(off_size(0xFFFFFFFFUL, 500) == 127008UL, 1);
    assertEqual(off_size(0x12345680UL, 3) == 3UL, 1);

    /* neighbours untouched */
    assertEqual(r.before, 0xA5A5);
    assertEqual(r.after, 0x5A5A);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("32-bit truncated loads and byte masks");
    suite_add_test(test_longmask);
    return suite_run();
}
