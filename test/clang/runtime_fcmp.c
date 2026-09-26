/* Thorough runtime test for the ravn/llvm-z80 clang f32 compare bridges
 * (libsrc/l/llvmz80/__cmpsf2.asm -> z88dk math32's raw m32_compare core).
 * ravn/llvm-z80 #277 (follow-up to runtime_float.c/runtime_fconv.c).
 *
 * Unlike arithmetic/conversions, the compare bridge is NOT a pure alias: it
 * open-codes a NaN check (m32_compare itself has none) ahead of translating
 * m32_compare's Z/C flags to GCC's -1/0/+1 tri-state. This test therefore
 * exercises every ordered/unordered FCMP predicate clang can lower to these
 * libcalls, with BOTH plain values (equal/less/greater) AND NaN operands (in
 * both operand positions), to prove the NaN short-circuit is right in every
 * predicate, not just the common case.
 *
 * `==`,`!=`,`<`,`<=`,`>`,`>=` map to the six *ordered* FCMP predicates
 * (oeq/une/olt/ole/ogt/oge -- NB: `!=` is UNE, unordered-or-not-equal, which
 * is why it alone is true for NaN). The C99 __builtin_isless family exercises
 * the remaining unordered predicates and __unordsf2 directly:
 *   __builtin_isless(a,b)        -> olt  (already covered by `<`, kept for
 *                                         symmetry)
 *   __builtin_islessgreater(a,b) -> one  (ordered not-equal; false for NaN,
 *                                         unlike `!=`/une -- this is the
 *                                         "NeedsNaNCheck && IsONE" path in
 *                                         Z80LegalizerInfo.cpp)
 *   __builtin_isunordered(a,b)   -> calls __unordsf2 directly
 */
#include <stdio.h>
#include <string.h>

typedef unsigned long u32;

static int fails = 0;

static void chk(const char *name, int got, int want) {
    if ((got != 0) != (want != 0)) {
        printf("FAIL %s: got %d want %d\n", name, got, want);
        fails++;
    }
}

static float from_bits(u32 x) { float f; memcpy(&f, &x, 4); return f; }

/* volatile -> real libcalls, no constant folding */
static volatile float f1 = 1.0f, f2 = 2.0f, f2b = 2.0f, f3 = 3.0f;
static volatile float fnan, fnan2;   /* set to NaN bit patterns in main() */

int main(void) {
    fnan  = from_bits(0x7FC00001UL);
    fnan2 = from_bits(0xFFC00042UL);

    /* == (oeq) */
    chk("eq.eq",  f2 == f2b, 1);
    chk("eq.lt",  f1 == f2,  0);
    chk("eq.gt",  f3 == f2,  0);
    chk("eq.nan.l", fnan == f2, 0);
    chk("eq.nan.r", f2 == fnan, 0);
    chk("eq.nan.both", fnan == fnan2, 0);

    /* != (une) -- the only ordered-syntax predicate true for NaN */
    chk("ne.eq",  f2 != f2b, 0);
    chk("ne.lt",  f1 != f2,  1);
    chk("ne.gt",  f3 != f2,  1);
    chk("ne.nan.l", fnan != f2, 1);
    chk("ne.nan.r", f2 != fnan, 1);
    chk("ne.nan.both", fnan != fnan2, 1);

    /* < (olt) */
    chk("lt.eq",  f2 < f2b, 0);
    chk("lt.lt",  f1 < f2,  1);
    chk("lt.gt",  f3 < f2,  0);
    chk("lt.nan.l", fnan < f2, 0);
    chk("lt.nan.r", f2 < fnan, 0);

    /* <= (ole) */
    chk("le.eq",  f2 <= f2b, 1);
    chk("le.lt",  f1 <= f2,  1);
    chk("le.gt",  f3 <= f2,  0);
    chk("le.nan.l", fnan <= f2, 0);
    chk("le.nan.r", f2 <= fnan, 0);

    /* > (ogt) */
    chk("gt.eq",  f2 > f2b, 0);
    chk("gt.lt",  f1 > f2,  0);
    chk("gt.gt",  f3 > f2,  1);
    chk("gt.nan.l", fnan > f2, 0);
    chk("gt.nan.r", f2 > fnan, 0);

    /* >= (oge) */
    chk("ge.eq",  f2 >= f2b, 1);
    chk("ge.lt",  f1 >= f2,  0);
    chk("ge.gt",  f3 >= f2,  1);
    chk("ge.nan.l", fnan >= f2, 0);
    chk("ge.nan.r", f2 >= fnan, 0);

    /* islessgreater (one): ordered not-equal, false for NaN (unlike !=) */
    chk("one.eq",  __builtin_islessgreater(f2, f2b), 0);
    chk("one.lt",  __builtin_islessgreater(f1, f2),  1);
    chk("one.gt",  __builtin_islessgreater(f3, f2),  1);
    chk("one.nan.l", __builtin_islessgreater(fnan, f2), 0);
    chk("one.nan.r", __builtin_islessgreater(f2, fnan), 0);

    /* isunordered: exercises __unordsf2 directly */
    chk("uno.plain", __builtin_isunordered(f2, f3), 0);
    chk("uno.nan.l", __builtin_isunordered(fnan, f2), 1);
    chk("uno.nan.r", __builtin_isunordered(f2, fnan), 1);
    chk("uno.nan.both", __builtin_isunordered(fnan, fnan2), 1);

    if (fails == 0)
        printf("ALL PASS\n");
    else
        printf("%d FAIL\n", fails);
    return fails;
}
