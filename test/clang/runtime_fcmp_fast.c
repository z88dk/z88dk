/* Runtime test for the ravn/llvm-z80 clang f32 FAST-MATH compare bridge
 * (libsrc/l/llvmz80/__cmpsf2.asm's ___cmpsf2_fast -> z88dk math32's raw
 * m32_compare core, no NaN check). ravn/llvm-z80 #277 follow-up.
 *
 * ___cmpsf2_fast is only emitted by Z80LegalizerInfo.cpp's
 * hasAllFastFlags() path, i.e. only when every fcmp in this TU carries all
 * three fast-math flags (nnan+ninf+nsz) -- which needs -ffast-math (or an
 * equivalent per-function attribute) at compile time. This test is built
 * with -ffast-math specifically so the compiler takes that path instead of
 * the NaN-checked ___cmpsf2/__gtsf2/__gesf2 (already covered, with NaN
 * cases, by runtime_fcmp.c/.sh).
 *
 * NaN is deliberately NOT exercised here -- -ffast-math tells the compiler
 * NaN cannot occur, so its behaviour on a NaN input is unspecified by
 * design, not a bug to pin down. This test only has to prove the ordinary
 * (non-NaN) tri-state compare is still correct once the NaN check is
 * removed, across all six ordered predicates clang can lower to
 * ___cmpsf2_fast (see the OrderedPred switch in Z80LegalizerInfo.cpp).
 */
#include <stdio.h>

static int fails = 0;

static void chk(const char *name, int got, int want) {
    if ((got != 0) != (want != 0)) {
        printf("FAIL %s: got %d want %d\n", name, got, want);
        fails++;
    }
}

/* volatile -> real libcalls, no constant folding */
static volatile float f1 = 1.0f, f2 = 2.0f, f2b = 2.0f, f3 = 3.0f;

int main(void) {
    chk("eq.eq", f2 == f2b, 1);
    chk("eq.lt", f1 == f2, 0);
    chk("eq.gt", f3 == f2, 0);

    chk("ne.eq", f2 != f2b, 0);
    chk("ne.lt", f1 != f2, 1);
    chk("ne.gt", f3 != f2, 1);

    chk("lt.lt", f1 < f2, 1);
    chk("lt.eq", f2 < f2b, 0);
    chk("lt.gt", f3 < f2, 0);

    chk("le.lt", f1 <= f2, 1);
    chk("le.eq", f2 <= f2b, 1);
    chk("le.gt", f3 <= f2, 0);

    chk("gt.lt", f1 > f2, 0);
    chk("gt.eq", f2 > f2b, 0);
    chk("gt.gt", f3 > f2, 1);

    chk("ge.lt", f1 >= f2, 0);
    chk("ge.eq", f2 >= f2b, 1);
    chk("ge.gt", f3 >= f2, 1);

    if (fails == 0)
        printf("ALL PASS\r\n");
    else
        printf("%d FAILURES\r\n", fails);

    return 0;
}
