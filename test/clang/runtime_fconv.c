/* Thorough runtime test for the ravn/llvm-z80 clang int<->f32 conversion
 * bridges (libsrc/l/llvmz80/__floatsisf.asm -> z88dk math32).  ravn/llvm-z80
 * #277 (follow-up to runtime_float.c).
 *
 * Covers signed/unsigned conversions both ways, with volatile operands (to
 * defeat constant folding and force real libcalls) and boundary values: zero,
 * negative, INT16_MIN/MAX, and values that don't survive a 16<->32-bit
 * round-trip identically for unsigned (e.g. 0xFFFF).
 *
 * float->int results are checked by exact integer equality (no bit-pattern
 * trick needed, unlike float results). int->float results are checked by
 * IEEE-754 bit pattern (memcpy to u32), same style as runtime_float.c, since
 * these are exactly representable for every int16 value (no rounding).
 */
#include <stdio.h>
#include <string.h>

typedef unsigned long u32;
typedef unsigned short u16;

static int fails = 0;

static u32 bits(float f) { u32 x; memcpy(&x, &f, 4); return x; }

static void chkf(const char *name, float got, float want) {
    u32 g = bits(got), w = bits(want);
    if (g != w) {
        printf("FAIL %s: got %08lx want %08lx\n", name, g, w);
        fails++;
    }
}

static void chki(const char *name, int got, int want) {
    if (got != want) {
        printf("FAIL %s: got %d want %d\n", name, got, want);
        fails++;
    }
}

static void chku(const char *name, unsigned got, unsigned want) {
    if (got != want) {
        printf("FAIL %s: got %u want %u\n", name, got, want);
        fails++;
    }
}

/* volatile sources -> real runtime libcalls (no constant folding) */
static volatile int i0 = 0, i1 = 1, ineg1 = -1, i42 = 42, ineg42 = -42;
static volatile int imin = -32768, imax = 32767;
static volatile unsigned u0 = 0u, u1 = 1u, u42 = 42u, uall = 0xFFFFu, umax_s = 32767u;

static volatile float f0 = 0.0f, f1_0 = 1.0f, fneg1 = -1.0f, f42 = 42.0f;
static volatile float fneg42 = -42.0f, fmin16 = -32768.0f, fmax16 = 32767.0f;
static volatile float fall = 65535.0f;

int main(void) {
    /* int -> float (signed), exact for every int16 value */
    chkf("i2f.zero", (float)i0, 0.0f);
    chkf("i2f.one",  (float)i1, 1.0f);
    chkf("i2f.neg1", (float)ineg1, -1.0f);
    chkf("i2f.42",   (float)i42, 42.0f);
    chkf("i2f.neg42",(float)ineg42, -42.0f);
    chkf("i2f.min",  (float)imin, -32768.0f);
    chkf("i2f.max",  (float)imax, 32767.0f);

    /* unsigned int -> float */
    chkf("u2f.zero", (float)u0, 0.0f);
    chkf("u2f.one",  (float)u1, 1.0f);
    chkf("u2f.42",   (float)u42, 42.0f);
    chkf("u2f.all",  (float)uall, 65535.0f);   /* > INT16_MAX: only correct if
                                                 * treated as unsigned, not
                                                 * sign-extended */
    chkf("u2f.maxs", (float)umax_s, 32767.0f);

    /* float -> int (signed) */
    chki("f2i.zero", (int)f0, 0);
    chki("f2i.one",  (int)f1_0, 1);
    chki("f2i.neg1", (int)fneg1, -1);
    chki("f2i.42",   (int)f42, 42);
    chki("f2i.neg42",(int)fneg42, -42);
    chki("f2i.min",  (int)fmin16, -32768);
    chki("f2i.max",  (int)fmax16, 32767);

    /* float -> unsigned int */
    chku("f2u.zero", (unsigned)f0, 0u);
    chku("f2u.one",  (unsigned)f1_0, 1u);
    chku("f2u.42",   (unsigned)f42, 42u);
    chku("f2u.all",  (unsigned)fall, 65535u);
    chku("f2u.maxs", (unsigned)fmax16, 32767u);

    if (fails == 0)
        printf("ALL PASS\n");
    else
        printf("%d FAIL\n", fails);
    return fails;
}
