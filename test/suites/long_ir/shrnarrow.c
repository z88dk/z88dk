/* A truncated long shift needs only the bytes that survive [IR_SHRNARROW].
 *
 * `(narrow_t)(v >> K)` with K constant: result byte i is source bits
 * [8i+K, 8i+K+8), so a W-byte result needs only source bytes
 * [K/8, (K+8W-1)/8]. The lowering trims BOTH ends — the low bytes the shift
 * discards and the high bytes the truncation discards — and past K%8 == 4 it
 * flips direction, shifting the 2-byte window LEFT by 8-K and keeping byte 1
 * (`add hl,hl` is one byte against the two-op `srl h; rr l`).
 *
 * The high result bytes are deliberately left WRONG, so the guard is a
 * WHOLE-FUNCTION single-use test. The must-NOT-fire cases below are the
 * valuable half: if the narrowing ever fires where the full width is read,
 * multi_use and no_trunc come back with zeroed high bytes.
 *
 * Counts chosen to hit every path: K%8 of 0 (no bit shift), 3 (right, below
 * the flip), 4 (the flip boundary) and 5/7 (flipped), at byte_shift 0..3.
 */
#include "test.h"

static unsigned long src  = 0x12345678UL;
static unsigned long src2 = 0xDEADBEEFUL;

/* The long arrives as a PARAMETER so it lives in a frame slot: the narrowing
   loads a byte WINDOW out of that slot, so a value already sitting in DEHL
   (`unsigned long v = global;` then shift) does not exercise it at all — the
   first version of this test was byte-identical with the gate on and off. */

/* byte_shift 0, no bit shift — pure high trim. */
static unsigned int k0(unsigned long v)  { return (unsigned int)(unsigned char)(v >> 0); }
/* byte_shift 0, right shift below the flip boundary. */
static unsigned int k3(unsigned long v)  { return (unsigned int)(unsigned char)(v >> 3); }
/* the flip boundary itself. */
static unsigned int k4(unsigned long v)  { return (unsigned int)(unsigned char)(v >> 4); }
/* flipped: shifts left by 3 and keeps byte 1. */
static unsigned int k5(unsigned long v)  { return (unsigned int)(unsigned char)(v >> 5); }
/* flipped, maximum: shifts left by 1. */
static unsigned int k7(unsigned long v)  { return (unsigned int)(unsigned char)(v >> 7); }
/* byte_shift 1 combined with a high trim — the two-ended window. */
static unsigned int k11(unsigned long v) { return (unsigned int)(unsigned char)(v >> 11); }
/* byte_shift 2 and 3. */
static unsigned int k17(unsigned long v) { return (unsigned int)(unsigned char)(v >> 17); }
static unsigned int k24(unsigned long v) { return (unsigned int)(unsigned char)(v >> 24); }
/* a WORD result: window is one byte wider, and the flip must NOT apply. */
static unsigned int w3(unsigned long v)  { return (unsigned int)(v >> 3); }
static unsigned int w13(unsigned long v) { return (unsigned int)(v >> 13); }

/* MUST NOT FIRE: the shift result is read at FULL width as well, so the high
   bytes must be right. Narrowing here would zero them. */
static unsigned long multi_use(unsigned long v)
{
    unsigned long s = v >> 5;
    unsigned char b = (unsigned char)s;             /* a truncating use ... */
    return (s ^ (unsigned long)b) & 0xFFFFFFFFUL;   /* ... and a full-width one */
}

/* MUST NOT FIRE: no truncation at all. */
static unsigned long no_trunc(unsigned long v)
{
    return (v >> 5) & 0xFFFFFFFFUL;
}

static void test_shrnarrow(void)
{
    /* 0x12345678 */
    assertEqual(k0(src),  0x78u);
    assertEqual(k3(src),  0xCFu);              /* 0x02468ACF */
    assertEqual(k4(src),  0x67u);              /* 0x01234567 */
    assertEqual(k5(src),  0xB3u);              /* 0x0091A2B3 */
    assertEqual(k7(src),  0xACu);              /* 0x002468AC */
    assertEqual(k11(src), 0x8Au);              /* 0x0002468A */
    assertEqual(k17(src), 0x1Au);              /* 0x0000091A */
    assertEqual(k24(src), 0x12u);
    assertEqual(w3(src),  0x8ACFu);
    assertEqual(w13(src), 0x91A2u);            /* 0x00091A2B */

    /* 0xDEADBEEF >> 5 = 0x06F56DF7; low byte 0xF7 */
    assertEqual(multi_use(src2), 0x06F56DF7UL ^ 0xF7UL);
    assertEqual(no_trunc(src2),  0x06F56DF7UL);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Truncated long shift narrowing");
    suite_add_test(test_shrnarrow);
    return suite_run();
}
