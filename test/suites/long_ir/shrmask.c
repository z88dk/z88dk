/* [IR_SHRMASK] A right shift whose result is only ever masked to bits the
 * source's HIGH byte cannot reach narrows to a byte shift, even though the
 * source is a full word.
 *
 * `(x >> n) & M` takes result bit i from source bit i+n, so the high byte
 * reaches result bits 8-n and up. If M has no bit there, the shift may read
 * the low byte alone and 80cc emits `srl a` x n instead of walking the pair
 * with `srl h; rr l` (4 bytes a bit) to produce bits the `and` discards.
 *
 * The half that MUST FIRE:
 *   fit_3_31, fit_5_7, fit_1_1, fit_4_15, fit_7_1 — mask strictly inside the
 *   window. fit_7_1 is the extreme: shift 7, one bit left.
 *
 * The TOP-BYTE half: a field that straddles the byte boundary cannot be read
 * from one source byte, but `(x >> n) & M` with M inside a byte is the HIGH
 * byte of `x << (8-n)` — (8-n) one-byte `add hl,hl` instead of n four-byte
 * `srl h; rr l`, and on 808x instead of a call to the l_asr_u runtime loop.
 * span_6_127, span_3_255, span_4_255 and span_2_63 take that route. Their
 * source must NOT be narrowed underneath them: that lowering reads the WHOLE
 * word, and an earlier version of demands_low_byte_only assumed any narrowed
 * shift reads only the low byte, which handed the source a one-byte slot.
 *
 * The half that MUST NOT FIRE — this is the half worth having, because
 * over-application is a SILENT wrong answer, not a crash:
 *   span_3_255  mask 255 with shift 3: result bits 5,6,7 come from the high
 *               byte. Narrowing returns (low>>3) and loses them.
 *   span_6_127  7-bit field at offset 6: five of its bits are in the high byte.
 *   span_4_4095 a 12-bit field — the common real-world bitfield that genuinely
 *               spans both bytes.
 *   edge_3_32   mask 32 is exactly ONE bit above the window for shift 3
 *               (window is 0..31). An off-by-one in the window test shows here
 *               and NOWHERE else.
 *   var_shift   a non-constant count: no immediate to reason about at all.
 *
 * Every function returns unsigned char ON PURPOSE: narrowing requires the
 * AND's result to be byte-wide, so an `unsigned int` return blocks the pass
 * outright and the test becomes decoration (it was, once — the gate-on/gate-off
 * asm diff was empty and it passed against a deliberately broken window).
 *
 * Constants derived independently in 16-bit modular arithmetic, not read back
 * from this compiler. No printf (it perturbs allocation).
 */
#include "test.h"

static volatile unsigned int vsink;

/* Opaque to the optimiser: forces a real 16-bit value with no provenance. */
static unsigned int opaque(unsigned int x) { vsink = x; return vsink; }

static unsigned char fit_3_31 (unsigned int x) { return (x >> 3)  & 31u; }
static unsigned char fit_5_7  (unsigned int x) { return (x >> 5)  & 7u; }
static unsigned char fit_1_1  (unsigned int x) { return (x >> 1)  & 1u; }
static unsigned char fit_4_15 (unsigned int x) { return (x >> 4)  & 15u; }
static unsigned char fit_7_1  (unsigned int x) { return (x >> 7)  & 1u; }

static unsigned char span_3_255 (unsigned int x) { return (x >> 3) & 255u; }
static unsigned char span_6_127 (unsigned int x) { return (x >> 6) & 127u; }
static unsigned char span_4_4095(unsigned int x) { return (x >> 4) & 4095u; }
static unsigned char span_4_255 (unsigned int x) { return (x >> 4) & 255u; }
static unsigned char span_2_63  (unsigned int x) { return (x >> 2) & 63u; }
static unsigned char span_7_3   (unsigned int x) { return (x >> 7) & 3u; }
static unsigned char edge_3_32  (unsigned int x) { return (x >> 3) & 32u; }
static unsigned char var_shift (unsigned int x, unsigned char n)
                                                { return (x >> n) & 31u; }

/* A LOCAL whose only use is a top-byte shift. If demands_low_byte_only lets it
 * narrow, the ADD defining it becomes a BYTE add and its high byte is lost —
 * a silent wrong answer. A PARAMETER source does not catch this (its slot
 * belongs to the caller, so the word is still read correctly); this shape was
 * added after the parameter-only version passed against the broken guard.
 * Verified: with the guard removed this returns 2 instead of 42. */
static unsigned char local_src(unsigned int a, unsigned int b)
{
    unsigned int t = a + b;
    return (unsigned char)((t >> 6) & 127);
}

/* Two uses of one shift, only one of them narrow: the shift must stay wide,
 * because EVERY reader has to be inside the window, not just the first. */
static unsigned char mixed_uses(unsigned int x)
{
    unsigned int s = x >> 3;
    return (s & 31u) + (s & 255u);
}

/* [IR_SHRWIDE] The same mask proof, one step further up: an immediate AND whose
 * mask lies inside a byte reads only its operand's LOW BYTE whatever the width
 * of the AND's own result. Without this the bitfield-extracted-then-WIDENED
 * shape — a field summed into an int accumulator, which is what reg_get does —
 * stayed on the 16-bit `srl h; rr l` walk. xcc computes it in 8 bits and
 * zero-extends, and is 1.55x faster on bitfieldbench partly for this.
 *
 * The narrowing must survive being widened: every reader of the narrowed value
 * loads it through the width-aware path, which zero-extends.
 *
 * `wide_4_4095` is the guard, and note what it takes to trip: the mask bound is
 * checked TWICE, on the def side (shr_result_byte_wide) and on the use side
 * (the IR_SHRWIDE clause in demands_low_byte_only). Loosening EITHER alone past
 * 0xFF is invisible — the other still refuses. Loosening BOTH makes this assert
 * fail, which is how it was verified. Do not "simplify" by dropping one of them
 * on the grounds that the tests still pass. */
static unsigned int wide_3_31(unsigned int x) { return ((x >> 3) & 31u) + 1000u; }
static unsigned int wide_5_7 (unsigned int x) { return ((x >> 5) & 7u)  + 40000u; }
static unsigned int wide_2_63(unsigned int x) { return ((x >> 2) & 63u) * 3u; }
/* mask EXCEEDS a byte: must stay wide, and the full 12-bit value must survive */
static unsigned int wide_4_4095(unsigned int x) { return ((x >> 4) & 4095u) + 1u; }

static void test_shrmask(void)
{
    unsigned int x = opaque(0xBEEFu);      /* 1011 1110 1110 1111 */

    assertEqual(fit_3_31(x),  0x1Du);
    assertEqual(fit_5_7(x),   0x7u);
    assertEqual(fit_1_1(x),   0x1u);
    assertEqual(fit_4_15(x),  0xEu);
    assertEqual(fit_7_1(x),   0x1u);

    assertEqual(span_3_255(x),  0xDDu);
    assertEqual(span_6_127(x),  0x7Bu);
    assertEqual(span_4_4095(x), 0xEEu);   /* 0xBEE truncated to the char return */
    assertEqual(edge_3_32(x),   0x0u);
    assertEqual(span_4_255(x),  0xEEu);
    assertEqual(span_2_63(x),   0x3Bu);
    assertEqual(span_7_3(x),    0x1u);
    assertEqual(var_shift(x, 3), 0x1Du);
    assertEqual(mixed_uses(x),  0xFAu);
    assertEqual(wide_3_31(x),   0x1Du + 1000u);
    assertEqual(wide_5_7(x),    (unsigned int)(0x7u + 40000u));
    assertEqual(wide_2_63(x),   (unsigned int)(0x3Bu * 3u));
    assertEqual(wide_4_4095(x), 0xBEEu + 1u);
    /* 0x1234 + 0x9876 = 0xAAAA; (0xAAAA >> 6) & 127 = 42 */
    assertEqual(local_src(opaque(0x1234u), opaque(0x9876u)), 42u);

    /* A second value, chosen so the high byte is nonzero where the first's
       was not, and vice versa — a window off-by-one that happens to agree on
       0xBEEF is unlikely to agree here too. */
    x = opaque(0x0140u);                   /* 0000 0001 0100 0000 */
    assertEqual(fit_3_31(x),   0x8u);
    assertEqual(span_3_255(x), 0x28u);
    assertEqual(span_6_127(x), 0x5u);
    assertEqual(span_4_255(x), 0x14u);
    assertEqual(span_2_63(x),  0x10u);
    assertEqual(span_7_3(x),   0x2u);
    /* NONZERO here (bit 5 of x>>3 is set) — this is the value that makes the
       off-by-one detectable; on 0xBEEF the edge case is 0 either way. */
    assertEqual(edge_3_32(x),  0x20u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("IR_SHRMASK: masked right shift narrowing");
    suite_add_test(test_shrmask);
    return suite_run();
}
