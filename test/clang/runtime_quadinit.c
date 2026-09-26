/* runtime_quadinit.c -- 64-bit (long long) GLOBAL initializers survive the
 * -compiler=llvmz80 bridge without losing their high 32 bits (ravn/z88dk#27).
 *
 * clang (--target=z80 -S) emits a 64-bit global initializer as a GNU 8-byte
 * `.quad <value>`.  z88dk's assembler has no 8-byte data directive (DEFQ is
 * 4 bytes), so the old copt rule `.quad %1 -> DEFQ %1 / DEFQ 0` truncated the
 * value to its low 32 bits and overwrote the true high 32 with the padding
 * `DEFQ 0`.  Fixed by the splitquad.pl pre-pass (commit a96bebcc61), which
 * splits each `.quad` into two little-endian `.long` halves that copt's correct
 * `.long -> DEFQ` (4-byte) rule then lowers faithfully.
 *
 * Oracle: a RUNTIME store is unaffected by the bug (only the static-initializer
 * data-section emission was wrong), so we read the two 32-bit halves of each
 * statically-initialized global through a union and compare each half to a
 * plain 32-bit literal (a `.long`, never a `.quad`, so itself immune).  Under
 * the buggy bridge g_big/g_mid/g_both read back with a zeroed high word and
 * this test FAILs; under the fix it prints QUADINIT-OK.
 *
 * Scope note: `double` is deliberately NOT exercised here -- on this pipeline
 * clang-z80 lowers `double` to a 4-byte `.long` (float), and z88dk uses the
 * math32/math48 float runtime, so no `double` global emits a `.quad`.  The
 * 8-byte `.quad` path is reached only by `long long` / `unsigned long long`.
 */
#include <stdio.h>

/* File-scope 64-bit globals with non-zero bits ABOVE bit 31 (except g_small,
 * the survives-anyway control). These are the exact values clang emits as
 * `.quad` in the data section. */
unsigned long long g_big   = 0x4008000000000000ULL;  /* hi=0x40080000 lo=0x00000000 */
unsigned long long g_mid   = 0x0000000100000000ULL;  /* hi=0x00000001 lo=0x00000000 */
unsigned long long g_small = 0x0000000000000007ULL;  /* hi=0x00000000 lo=0x00000007 (control) */
unsigned long long g_both  = 0x89ABCDEF01234567ULL;  /* hi=0x89ABCDEF lo=0x01234567 (both halves set) */
signed   long long g_neg   = -1LL;                    /* hi=0xFFFFFFFF lo=0xFFFFFFFF */

/* little-endian view: h[0] = low 32 bits, h[1] = high 32 bits */
union u64 { unsigned long long q; unsigned long h[2]; };

static int check(const char *tag, unsigned long long v,
                 unsigned long want_hi, unsigned long want_lo)
{
    union u64 u;
    u.q = v;
    /* print halves so a failure is diagnosable in the ntvcm log */
    printf("%s lo=%lu hi=%lu\n", tag, u.h[0], u.h[1]);
    return (u.h[0] == want_lo) && (u.h[1] == want_hi);
}

int main(void)
{
    int ok = 1;
    ok &= check("BIG  ", g_big,   0x40080000UL, 0x00000000UL);
    ok &= check("MID  ", g_mid,   0x00000001UL, 0x00000000UL);
    ok &= check("SMALL", g_small, 0x00000000UL, 0x00000007UL);
    ok &= check("BOTH ", g_both,  0x89ABCDEFUL, 0x01234567UL);
    ok &= check("NEG  ", (unsigned long long)g_neg, 0xFFFFFFFFUL, 0xFFFFFFFFUL);
    printf("%s\n", ok ? "QUADINIT-OK" : "QUADINIT-FAIL");
    return 0;
}
