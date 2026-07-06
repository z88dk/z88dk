/* Index-half byte home: a hot, single-def, currently-spilled width-1 vreg is
 * promoted to an index-register half (PR_IYL/IYH/IXL/IXH) — a slotless,
 * clobber-free SECOND byte home alongside the E/D home. z80/z80n/ez80 only,
 * where a free index reg exists (sp-mode: IY free → IYL/IYH).
 *
 * This is charbench's schar_mix shape: `acc` (multi-def) takes E, and the
 * per-iteration byte `b` (single-def `*data++`) takes IYL — read/written via A
 * (ld a,iyl / ld iyl,a) and used as a base-page ALU source (sub iyl / add a,iyl
 * / xor iyl). Correctness traps: the half must survive the whole diamond loop
 * (never clobbered), the right register, and NO CB-page op ever hits it
 * (`sla iyl` doesn't exist — shifts route through A). The assert is
 * width-independent so it also validates the slot fallback on non-index CPUs. */
#include "test.h"

static signed char sbuf[24];

/* Signed accumulate with a per-iteration byte b and a shift — two live bytes
 * (acc + b) across an if/else diamond, the two-byte-home shape. */
static signed char mix2(signed char *data, unsigned int len)
{
    signed char acc = -1;
    signed char *end = data + len;
    while (data < end) {
        signed char b = *data++;
        if (b < 0) acc = (signed char)(acc - b);
        else       acc = (signed char)(acc + b);
        acc = (signed char)((acc << 1) ^ b);
    }
    return acc;
}

static void test_idxhome(void)
{
    int i;
    for (i = 0; i < 24; i++) sbuf[i] = (signed char)((i * 11) - 128);
    /* host-computed reference over the full buffer */
    Assert((unsigned char)mix2(sbuf, 24) == 0x0Fu, "idxhome: two byte homes (acc=E, b=half)");
    /* partial length exercises a different trip count / carry */
    Assert((unsigned char)mix2(sbuf, 7) == 0xDCu, "idxhome: partial length");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Index-half byte home");
    suite_add_test(test_idxhome);
    return suite_run();
}
