/* [de-widen] a byte zero-extended into DE and then copied to HL.
 *
 * `ld e,S; ld d,0; ld hl,de` becomes `ld l,S; ld h,0` — 2 bytes and 8 cycles,
 * and the copy is gone. The one condition is that D and E are DEAD after the
 * copy: the rewrite stops defining DE, so a later reader would see whatever DE
 * held before. No flag condition — all four spellings are register moves and an
 * immediate load, and none of them touches F.
 *
 * What each function is FOR, verified by diffing the z80 asm per function,
 * gate-on against gate-off:
 *
 *  - sdiv    THE firing shape, and the corpus's own (divbench). A `%` by a
 *            power of two leaves the remainder in A; load_to_de widens it into
 *            DE; then gen_add takes its `add hl,bc` arm (adr/0059) because the
 *            accumulator has a BC home, wants the value in HL, and finds only
 *            the DE cache. SIX sites in this one function, all converted.
 *  - kmix    divbench's own, and it carries BOTH answers: of its two candidate
 *            sites one converts and one is DECLINED, because there the copy is
 *            followed by `ex de,hl ... add hl,de` and DE reads live back
 *            through the swap.
 *
 *            Say exactly what that decline proves, and no more. Building this
 *            file with the `!d_live && !e_live` test deleted converts that site
 *            and the suite STILL PASSES — the decline here is conservative, not
 *            load-bearing. So kmix proves the guard is REACHED, which is what a
 *            regression test can honestly hold; whether the guard is ever the
 *            only thing between the corpus and a wrong answer is settled by
 *            long_ir and the corpus, not here. Claiming otherwise is what went
 *            wrong in adr/0039 and again in adr/0077.
 *
 *            kmix must NOT be `static`: made static and called with constants
 *            it is specialised, both sites convert, and the guard is no longer
 *            reached at all.
 *
 * The one control that matters is `dewiden_keep`, which builds with the rung
 * off: it must be byte-identical to the compiler before the rung existed.
 * Every CPU is a candidate — `ld hl,de` is a pair copy everywhere and a
 * one-byte native instruction on Rabbit 4000/6000 (adr/0074's bargain) — so the
 * 8080 and gbz80 targets here are second measurements, not controls.
 * Self-verifying, no printf.
 */
#include "test.h"

static unsigned char tab[8] = { 3, 9, 17, 33, 65, 129, 200, 250 };
static unsigned int  acc;

/* divbench's sdiv: the remainder widens into DE, the accumulator lives in BC. */
static int sdiv(int v)
{
    int a = 0;

    a += (v / 2) + (v % 2);
    a += (v / 8) + (v % 8);
    a += (v / 64) + (v % 64);
    return a;
}

/* divbench's kmix: two candidate sites, one converted and one declined. */
int kmix(int v)
{
    return ((v / 4) * 6) + ((v / 16) * 3);
}

/* A second operand spelling — the byte arrives from memory, not from A. It does
   not reach the rung, and is here for the arithmetic, not as a guard. */
static unsigned int frommem(const unsigned char *p, int n)
{
    unsigned int s = 0;
    int i;

    for (i = 0; i < n; i++)
        s = (unsigned int)((s + (p[i] & 7u)) & 0xffffu);
    return s;
}

void test_dewiden(void)
{
    assertEqual(sdiv(1000), 680);
    assertEqual(sdiv(-1000), -680);
    assertEqual(sdiv(7), 18);
    assertEqual(sdiv(0), 0);

    assertEqual(kmix(1000), 1686);
    assertEqual(kmix(-1000), -1686);
    assertEqual(kmix(7), 6);

    assertEqual(frommem(tab, 4), 6u);
    assertEqual(frommem(tab, 8), 10u);
    assertEqual(frommem(tab + 4, 4), 4u);

    acc = (unsigned int)(sdiv(64) + kmix(64)) + frommem(tab, 2);
    assertEqual(acc, 153u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("de-widen: widen into the register the consumer wants");
    suite_add_test(test_dewiden);
    return suite_run();
}
