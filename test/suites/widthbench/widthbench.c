/*
 * widthbench.c — mixed-width integer conversion.
 *
 * Real code mixes char, int and long freely, and every mix costs instructions
 * that no library call is involved in: sign-extending a signed char into an int,
 * zero-extending an unsigned one, widening 16 to 32 bits, and narrowing back
 * with a truncating store.
 *
 * This measures the C promotion machinery rather than arithmetic — which
 * conversions the compiler can prove unnecessary, whether a narrow value is kept
 * narrow or widened at every use, and whether a truncating store writes one byte
 * or clobbers its neighbour. No other bench in the corpus mixes widths as its
 * hot operation: charbench stays in char, intbench in int, crcbench in long.
 *
 * Both signednesses appear on purpose, because unsigned char promotes to a
 * SIGNED int.
 *
 * All int values stay inside +/-32767 and every long is masked to 32 bits, so
 * the checksum is identical on a 16-bit-int target and the verifying host.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define STREAM 500
#define REPS   26
#define CHK    63290u        /* host-verified (gcc -DHOST_VERIFY) */

static signed char   sbuf[64];
static unsigned char ubuf[64];
static int           ibuf[64];

/* char -> int: sign-extend vs zero-extend, and the promotion of unsigned char
   to SIGNED int (so the sum can go negative even though one operand cannot). */
static int mix_char(int k)
{
    signed char   s = sbuf[k & 63];
    unsigned char u = ubuf[k & 63];
    int acc = 0;
    acc += s;                       /* sign-extended */
    acc += u;                       /* zero-extended, promotes to signed int */
    acc += (signed char)(u ^ 0x80u);
    acc += (unsigned char)(s + 3);  /* narrow, then widen again */
    return acc;
}

/* int <-> long: widen for the arithmetic, narrow for the store. */
static unsigned long mix_long(int k)
{
    int i = ibuf[k & 63];
    unsigned long a = (unsigned long)(long)i & 0xFFFFFFFFUL;   /* sign-extend */
    /* Narrow to 16 bits BEFORE widening — (unsigned int)(-1) differs between a
       16-bit-int target and the host, and the two diverge once shifted up. */
    unsigned long b = (unsigned long)((unsigned int)i & 0xffffu);  /* zero-extend */
    unsigned long acc = (a + (b << 3)) & 0xFFFFFFFFUL;
    acc = (acc ^ (unsigned long)(unsigned char)(k & 0xff)) & 0xFFFFFFFFUL;
    return acc;
}

/* The narrowing stores: a wide value truncated into a narrow slot. Getting the
   width wrong here overruns the neighbouring element. */
static void mix_store(int k, unsigned long v)
{
    sbuf[k & 63] = (signed char)(v >> 5);
    ubuf[k & 63] = (unsigned char)(v >> 11);
    ibuf[k & 63] = (int)(short)(v >> 3);
}

static unsigned int width_compute(void)
{
    unsigned int chk = 0, seed = 0x2B1Du;
    int r, i, k;

    for (k = 0; k < 64; k++) {
        sbuf[k] = (signed char)(k * 7 - 200);
        ubuf[k] = (unsigned char)(k * 11 + 3);
        ibuf[k] = (int)(k * 517 - 16000);
    }

    for (r = 0; r < REPS; r++) {
        for (i = 0; i < STREAM; i++) {
            unsigned long w;
            seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
            k = (int)(seed & 63u);

            chk = (unsigned int)(chk + (unsigned int)mix_char(k));
            w = mix_long(k);
            chk = (unsigned int)(chk + (unsigned int)(w & 0xffffUL));
            chk = (unsigned int)(chk + (unsigned int)((w >> 16) & 0xffffUL));
            mix_store(k, w);
            chk &= 0xffffu;
        }
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void width_run(void)
{
    unsigned int chk = width_compute();
    Assert(chk == CHK, "mixed-width conversion checksum (host-verified)");
}

int suite_width(void)
{
    suite_setup("Mixed-Width Conversion Tests");
    suite_add_test(width_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_width();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", width_compute()); return 0; }
#endif
