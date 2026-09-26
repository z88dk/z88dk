/* Runtime regression test for the llvmz80 stdlib bridge fixed in
 * "Group C klasse 2 batch B": srand
 * (include/stdlib.h __STDC_ABI_ONLY fastcall-gating class, same
 * mechanism as isqrt/unbcd in runtime_stdlib2.c).
 *
 * srand(seed) used to fall through to the plain stack-based-smallc
 * declaration under llvmz80 (clang defines __STDC_ABI_ONLY, skipping the
 * "#ifndef __STDC_ABI_ONLY" rescue that routes sccz80/SDCC to
 * srand_fastcall). llvmz80's default sdcccall(1) passes seed in HL, but
 * srand.asm's plain entry does `pop`, reading garbage instead of the
 * seed -- so the resulting rand() stream did not match the one produced
 * by calling srand_fastcall with the SAME seed directly.
 *
 * inp/sleep/msleep are the same bug class (confirmed via `-S` assembly
 * inspection: the call site loads the arg into HL only, no stack push,
 * while the .asm worker's plain entry unconditionally pops from the
 * stack) but are not exercised here: `inp` needs a real I/O port (no
 * safe, portable one under ntvcm -- the classic asm's `in l,(c)` isn't
 * implemented by ntvcm at all), and `sleep`/`msleep` are real-time
 * delays that ntvcm does not throttle, so a wrong argument does not
 * change wall-clock behavior in this emulator and can't be used as an
 * oracle. Their fix was verified by direct clang `-S` output showing
 * the call site now targets `_sleep_fastcall`/`_msleep_fastcall`/
 * `_inp_fastcall` instead of the broken plain entry (see git log for
 * this commit).
 *
 * RED:  srand(seed) then rand() produced a different value than
 *       srand_fastcall(seed) then rand() for the same seed.
 * GREEN: both produce the identical value.
 */
#include <stdlib.h>
#include <stdio.h>

extern void srand_fastcall(unsigned int seed) __z88dk_fastcall;

int main(void) {
    srand(42);
    int r1 = rand();

    srand_fastcall(42);
    int r2 = rand();

    printf("stdlib3 srand_plain=%d srand_fastcall=%d match=%d\n",
           r1, r2, r1 == r2);
    return 0;
}
