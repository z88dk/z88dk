/* XFAIL: z88dk newlib 16-bit signed-modulo sign bug (stale prebuilt library).
 *
 * C requires a%b to take the sign of the DIVIDEND a, so -30000 % 7 == -5.
 * The z88dk newlib library returns |a%b| == +5 for 8/16-bit signed modulo:
 * the remainder-sign negation is dropped.  This is NOT a clang/llvmz80 bug;
 * stock z88dk reproduces it with its OWN compilers, and ONLY on newlib:
 *
 *     -30000 % 7   (C standard: -5)
 *     ----------------------------------------
 *     sccz80  -clib=default (classic)   -5   correct
 *     sccz80  -clib=new     (newlib)    +5   WRONG
 *     sdcc    -clib=default (classic)   +5   WRONG (sdcc own __modsint)
 *     sdcc    -clib=sdcc_iy (newlib)    +5   WRONG
 *     llvmz80 -clib=default (classic)   -5   correct
 *     llvmz80 -clib=newlib_iy(newlib)   +5   WRONG (matches z88dk newlib)
 *
 * Root cause: the SOURCE was fixed upstream in z88dk commit af5630797c
 * ("fix signed % remainder: l_small_divs jp m->call m ...", suborb,
 * 2026-06-28), but the committed prebuilt newlib archives under
 * libsrc/newlib/lib/ (last regenerated 2026-03-26) predate the fix and
 * still ship the buggy l_small_divs_16_16x16 core.  Rebuilding the newlib libs
 * from current source would fix it.  See BUG_newlib_signed_mod.md.
 *
 * Acceptance for now (user 2026-07-23): matching z88dk own newlib result is
 * "good enough" -- clang faithfully reproduces the library behaviour, so the
 * fix belongs in z88dk newlib, not in the llvmz80 integer bridge.  The .sh:
 *   PASS  = C-correct -5 (classic clib)         -- mod is right there
 *   XFAIL = +5, matching stock z88dk newlib     -- the known stale-lib bug
 *   FAIL  = anything else                       -- clang diverged from BOTH
 */
#include <stdio.h>

volatile int a16 = -30000, b16 = 7;

int main(void) {
    int r = a16 % b16;          /* C: -5 ; z88dk newlib: +5 */
    printf("s16mod=%d\n", r);
    return 0;
}
