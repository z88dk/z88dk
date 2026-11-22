/* Byte-width comparison results.
 *
 * A comparison yields 0 or 1, so its high byte is always zero: ir_opt narrows
 * the dst to width 1 (narrow_def_kind) and the lowerer builds the boolean in A
 * -- `ld a,0 / jr cc,ASMPC+3 / inc a` -- instead of HL. Two things must hold,
 * and each has a silent failure mode:
 *
 *  - The boolean is EXACTLY 0 or 1, for every compare kind and both
 *    polarities. A wrong skip condition inverts the answer with no crash, so
 *    every kind is checked against a literal expected bit pattern.
 *  - The commit writes ONE byte. A word commit into a one-byte slot overruns
 *    its neighbour, so `neighbours` keeps three byte locals live across two
 *    bool commits and checks all three afterwards.
 *
 * The bool is built with `ld a,0`, never `xor a`: the skip tests the compare's
 * own flags and `xor a` would destroy them. A flag-destroying variant shows up
 * here as a wrong boolean rather than a wrong guard byte.
 *
 * Every case is a VALUE path -- the result is combined arithmetically, never
 * branched on -- because a branch-fused compare never materialises a dst at
 * all and would test nothing. No printf (it perturbs allocation).
 */
#include "test.h"

static int sink;

/* All six signed ordered/equality kinds at once, each result narrowed to a
 * byte by its char local. Returns a 6-bit mask. */
static unsigned char ord_signed(int a, int b)
{
    unsigned char lt = (unsigned char)(a <  b);
    unsigned char le = (unsigned char)(a <= b);
    unsigned char gt = (unsigned char)(a >  b);
    unsigned char ge = (unsigned char)(a >= b);
    unsigned char eq = (unsigned char)(a == b);
    unsigned char ne = (unsigned char)(a != b);
    return (unsigned char)(lt | (le << 1) | (gt << 2) | (ge << 3)
                              | (eq << 4) | (ne << 5));
}

/* The unsigned kinds take different lowering paths (no S^V correction). */
static unsigned char ord_unsigned(unsigned int a, unsigned int b)
{
    unsigned char lt = (unsigned char)(a <  b);
    unsigned char le = (unsigned char)(a <= b);
    unsigned char gt = (unsigned char)(a >  b);
    unsigned char ge = (unsigned char)(a >= b);
    unsigned char eq = (unsigned char)(a == b);
    unsigned char ne = (unsigned char)(a != b);
    return (unsigned char)(lt | (le << 1) | (gt << 2) | (ge << 3)
                              | (eq << 4) | (ne << 5));
}

/* Width-4 operands: the byte-wise sub/sbc chain (and, on gbz80, the
 * sign-flipped form) feeding the same byte commit. */
static unsigned char ord_long(long a, long b)
{
    unsigned char lt = (unsigned char)(a <  b);
    unsigned char gt = (unsigned char)(a >  b);
    unsigned char eq = (unsigned char)(a == b);
    unsigned char ne = (unsigned char)(a != b);
    return (unsigned char)(lt | (gt << 1) | (eq << 2) | (ne << 3));
}

/* Byte operands: the `cp` paths, which reach the commit without ever widening
 * an operand. Includes == 0 (the `or a` test form). */
static unsigned char ord_byte(unsigned char a, unsigned char b)
{
    unsigned char eq   = (unsigned char)(a == b);
    unsigned char ne   = (unsigned char)(a != b);
    unsigned char lt   = (unsigned char)(a < b);
    unsigned char zero = (unsigned char)(a == 0);
    return (unsigned char)(eq | (ne << 1) | (lt << 2) | (zero << 3));
}

/* Signed byte against a constant: biased `xor 0x80; cp K'` into the carry
 * commit, plus the `< 0` sign test. */
static unsigned char signed_byte_const(signed char c)
{
    unsigned char neg  = (unsigned char)(c < 0);
    unsigned char small= (unsigned char)(c < 5);
    unsigned char big  = (unsigned char)(c >= 100);
    return (unsigned char)(neg | (small << 1) | (big << 2));
}

/* Three byte locals live ACROSS two bool commits. A word commit into a
 * one-byte bool slot lands its high half in whichever of these is adjacent. */
static int neighbours(int a, int b)
{
    unsigned char p = 0xA5, q = 0x5A, r = 0x3C;
    unsigned char v = (unsigned char)(a < b);
    unsigned char w = (unsigned char)(a == b);
    sink = (int)p + (int)q + (int)r;      /* keep all three live past the commits */
    return (int)v
         + ((int)w << 1)
         + ((p == 0xA5) << 2)
         + ((q == 0x5A) << 3)
         + ((r == 0x3C) << 4);
}

/* A bool that must survive as a value across a call: it is committed to its
 * (byte) home/slot, clobbered, then read back. */
static int bump(int x) { sink += x; return x + 1; }

static int bool_across_call(int a, int b)
{
    unsigned char v = (unsigned char)(a >= b);
    int t = bump(a);
    return (int)v * 100 + t;
}

static void test_boolbyte(void)
{
    /* a<b: lt,le,ne set; gt,ge,eq clear  => 0b100011 = 0x23 */
    assertEqual(ord_signed(3, 7), 0x23);
    /* a>b: gt,ge,ne                       => 0b101100 = 0x2C */
    assertEqual(ord_signed(7, 3), 0x2C);
    /* a==b: le,ge,eq                      => 0b011010 = 0x1A */
    assertEqual(ord_signed(5, 5), 0x1A);
    /* negatives exercise the S^V correction */
    assertEqual(ord_signed(-9, 4), 0x23);
    assertEqual(ord_signed(4, -9), 0x2C);
    assertEqual(ord_signed(-9, -9), 0x1A);

    assertEqual(ord_unsigned(3u, 7u), 0x23);
    assertEqual(ord_unsigned(7u, 3u), 0x2C);
    assertEqual(ord_unsigned(5u, 5u), 0x1A);
    /* 0x8000 vs 1 must compare UNSIGNED (0x8000 > 1), not as a negative */
    assertEqual(ord_unsigned(0x8000u, 1u), 0x2C);

    /* lt,ne => 0b1001 = 0x9 ; gt,ne => 0b1010 = 0xA ; eq => 0b0100 = 0x4 */
    assertEqual(ord_long(3L, 7L), 0x9);
    assertEqual(ord_long(7L, 3L), 0xA);
    assertEqual(ord_long(5L, 5L), 0x4);
    assertEqual(ord_long(-100000L, 3L), 0x9);
    assertEqual(ord_long(0x12345678L, 0x12345679L), 0x9);

    /* eq => 0b0001 ; ne,lt => 0b0110 = 0x6 ; ne (a>b) => 0b0010 */
    assertEqual(ord_byte(9, 9), 0x1);
    assertEqual(ord_byte(9, 200), 0x6);
    assertEqual(ord_byte(200, 9), 0x2);
    /* a==0: eq clear (0 != 7), ne, lt, zero => 0b1110 = 0xE */
    assertEqual(ord_byte(0, 7), 0xE);

    /* neg,small => 0b011 = 3 ; small only => 0b010 = 2 ; big => 0b100 = 4 */
    assertEqual(signed_byte_const(-1), 3);
    assertEqual(signed_byte_const(0), 2);
    assertEqual(signed_byte_const(100), 4);
    assertEqual(signed_byte_const(50), 0);

    /* v=1,w=0, all three guards intact => 1 + 0 + 4 + 8 + 16 = 29 */
    assertEqual(neighbours(1, 2), 29);
    /* v=0,w=1 => 0 + 2 + 28 = 30 */
    assertEqual(neighbours(2, 2), 30);
    /* v=0,w=0 => 28 */
    assertEqual(neighbours(3, 2), 28);

    sink = 0;
    assertEqual(bool_across_call(5, 5), 106);   /* 1*100 + 6 */
    assertEqual(bool_across_call(2, 9), 3);     /* 0*100 + 3 */
    assertEqual(sink, 7);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Byte-width compare results");
    suite_add_test(test_boolbyte);
    return suite_run();
}
