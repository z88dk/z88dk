/*
 * shiftbench.c — variable and constant shift counts.
 *
 * The z80 has no barrel shifter, so every shift is a codegen decision with no
 * library routine behind it at 8 or 16 bits: a constant count becomes a chain of
 * `add hl,hl` or `srl h; rr l`, a byte shift by four can become a nibble swap,
 * and a RUNTIME count has to become a counted loop with its own exit test.
 *
 *   vshift    runtime counts on a word — the loop the compiler has to build
 *   bvshift   the same on a byte, where the register and the bound both differ
 *   kshift    constant counts spread across the range, each with its own best
 *             lowering, so the cost curve is what picks between them
 *   kbshift   constant counts on a value that never leaves a byte — nibble
 *             extraction and bit packing, where the choice is whether to keep
 *             the whole sequence in the accumulator or widen it to a pair
 *   ksbshift  the signed form, where the sign must propagate from bit 7
 *   funnel    a shift pair recombined, the rotate idiom
 *   sarith    a signed right shift, which must be arithmetic rather than logical
 *
 * maskbench and fixedbench shift by constants only; no other bench uses a shift
 * count that is not known at compile time, and none shifts a byte by a constant
 * — charbench, lexbench and hashbench contain no `>>` at all.
 *
 * Every result is masked to 16 bits and every count stays inside 1..15, so the
 * checksum is identical on a 16-bit-int target and the verifying host.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define STREAM 600
#define REPS   24
#define CHK    27656u          /* host-verified (gcc -DHOST_VERIFY) */

/* Runtime count: neither half can be folded, so the compiler must emit a loop. */
static unsigned int vshift(unsigned int v, int n)
{
    unsigned int a = (unsigned int)((v << n) & 0xffffu);
    unsigned int b = (unsigned int)(v >> n);
    return (unsigned int)((a | b) & 0xffffu);
}

/* Byte width: an 8-bit shift loop, and the `swap`-style four-bit special case. */
static unsigned char bvshift(unsigned char v, int n)
{
    unsigned char a = (unsigned char)(v << n);
    unsigned char b = (unsigned char)(v >> n);
    return (unsigned char)(a ^ b);
}

/* Constant counts: 1 and 8 are near-free, 4 and 12 are where the lowering
   choice actually costs something. */
static unsigned int kshift(unsigned int v)
{
    unsigned int acc = 0;
    acc = (unsigned int)(acc + ((v << 1) & 0xffffu));
    acc = (unsigned int)(acc + ((v << 4) & 0xffffu));
    acc = (unsigned int)(acc + ((v << 8) & 0xffffu));
    acc = (unsigned int)(acc + (v >> 1));
    acc = (unsigned int)(acc + (v >> 4));
    acc = (unsigned int)(acc + (v >> 8));
    acc = (unsigned int)(acc + (v >> 12));
    return acc & 0xffffu;
}

/* Constant counts on a value that never leaves a byte — nibble extraction and
   bit packing, the commonest byte-shift shape in real code. Distinct from
   kshift (16-bit) and bvshift (runtime count): a compiler may keep this whole
   sequence in the accumulator, or widen each value to a pair and shift that. */
static unsigned char kbshift(unsigned char v)
{
    unsigned char acc = 0;
    acc = (unsigned char)(acc + (v >> 1));
    acc = (unsigned char)(acc + (v >> 4));   /* the nibble */
    acc = (unsigned char)(acc + (v >> 7));   /* the top bit */
    acc = (unsigned char)(acc + (unsigned char)(v << 3));
    return acc;
}

/* Signed byte: an arithmetic shift, so the sign must propagate from bit 7 and
   not from bit 15 of a widened value. */
static signed char ksbshift(signed char v)
{
    signed char acc = 0;
    acc = (signed char)(acc + (v >> 1));
    acc = (signed char)(acc + (v >> 3));
    return acc;
}

/* Rotate: n stays in 1..15 so neither half shifts by the full width. */
static unsigned int funnel(unsigned int v, int n)
{
    return (unsigned int)(((v << n) | (v >> (16 - n))) & 0xffffu);
}

/* Arithmetic right shift — the sign bit propagates, so this is `sra h; rr l`
   rather than `srl h; rr l`. */
static int sarith(int v, int n)
{
    return v >> n;
}

static unsigned int shift_compute(void)
{
    unsigned int chk = 0, seed = 0x3C7Bu;
    int r, i;

    for (r = 0; r < REPS; r++) {
        for (i = 0; i < STREAM; i++) {
            unsigned int v;
            int n;

            seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
            v = seed;
            n = (int)(seed & 7u) + 1;            /* 1..8 */

            chk = (unsigned int)(chk + vshift(v, n));
            chk = (unsigned int)(chk + bvshift((unsigned char)(v >> 5), n & 7));
            chk = (unsigned int)(chk + kshift(v));
            chk = (unsigned int)(chk + kbshift((unsigned char)(v >> 3)));
            chk = (unsigned int)(chk
                  + (unsigned int)(ksbshift((signed char)(v & 0xffu)) & 0xff));
            chk = (unsigned int)(chk + funnel(v, n));
            /* Negative on purpose, so the shift has to be arithmetic. */
            chk = (unsigned int)(chk
                  + (unsigned int)(sarith((int)(v & 0x3fffu) - 8192, n & 3)
                                   & 0xffff));
            chk &= 0xffffu;
        }
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void shift_run(void)
{
    unsigned int chk = shift_compute();
    Assert(chk == CHK, "variable/constant shift checksum (host-verified)");
}

int suite_shift(void)
{
    suite_setup("Shift Count Tests");
    suite_add_test(shift_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_shift();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", shift_compute()); return 0; }
#endif
