/* Thorough runtime test for the ravn/llvm-z80 clang 32-bit float bridges
 * (libsrc/l/llvmz80/__addsf3.asm -> z88dk math32).  ravn/llvm-z80 #277.
 *
 * With double==float==binary32, clang lowers arithmetic to __addsf3/__subsf3/
 * __mulsf3/__divsf3.  This test checks each by BIT PATTERN (memcpy the result
 * to a u32 and compare to the IEEE-754 bits of the expected value), so it
 * depends on NOTHING but the arithmetic bridges -- no float<->int conversion,
 * no printf("%f").  Operands are volatile to defeat constant folding, forcing
 * a real libcall.  Order-sensitive cases (sub, div) are tested both ways to
 * catch an operand-order bug in the bridge.
 */
#include <stdio.h>
#include <string.h>

typedef unsigned long u32;

static int fails = 0;

static u32 bits(float f) { u32 x; memcpy(&x, &f, 4); return x; }

static void chk(const char *name, float got, float want) {
    u32 g = bits(got), w = bits(want);
    if (g != w) {
        printf("FAIL %s: got %08lx want %08lx\n", name, g, w);
        fails++;
    }
}

/* volatile source operands -> real runtime libcalls (no constant folding) */
static volatile float f2 = 2.0f, f4 = 4.0f, f6 = 6.0f, f8 = 8.0f;
static volatile float fhalf = 0.5f, fquarter = 0.25f, f1 = 1.0f, f1_5 = 1.5f;
static volatile float fneg3 = -3.0f, f3 = 3.0f, fneg8 = -8.0f;

int main(void) {
    /* add (commutative) */
    chk("add",       f2 + f2,   4.0f);
    chk("add.frac",  fhalf + fquarter, 0.75f);
    chk("add.comm",  f6 + f2,   8.0f);

    /* mul (commutative) */
    chk("mul",       f2 * f4,   8.0f);
    chk("mul.frac",  fhalf * fhalf, 0.25f);

    /* sub (order-sensitive) */
    chk("sub",       f6 - f2,   4.0f);
    chk("sub.rev",   f2 - f6,  -4.0f);   /* catches b-a bug */
    chk("sub.frac",  f1_5 - fhalf, 1.0f);
    chk("sub.zero",  f4 - f4,   0.0f);   /* +0, not -0: catches negate-approach */

    /* div (order-sensitive) */
    chk("div",       f8 / f2,   4.0f);
    chk("div.rev",   f2 / f8,   0.25f);  /* catches b/a bug */
    chk("div.frac",  f1 / f4,   0.25f);
    chk("div.neg",   fneg8 / f2, -4.0f); /* exactly representable quotient */
    /* NOTE: math32 divides via a Newton-Raphson reciprocal (a/b = a*(1/b)),
     * so a/b can differ from a correctly-rounded quotient by ~1 ULP when 1/b
     * is inexact (e.g. -3.0f/3.0f -> 0xbf800001 instead of 0xbf800000).  That
     * is a math32 numerics property, not a bridge bug, so this bridge test uses
     * exactly-representable quotients only. */

    /* signs */
    chk("mul.neg",   fneg3 * f2, -6.0f);
    chk("add.neg",   fneg3 + f3,  0.0f);

    if (fails == 0)
        printf("ALL PASS\n");
    else
        printf("%d FAIL\n", fails);
    return fails;
}
