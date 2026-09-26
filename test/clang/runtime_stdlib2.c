/* Runtime regression test for the llvmz80 stdlib bridges fixed in
 * "Group C klasse 2 batch A": isqrt, unbcd
 * (include/stdlib.h __STDC_ABI_ONLY fastcall-gating class).
 *
 * clang/llvmz80 defines __STDC_ABI_ONLY, which used to skip the
 * "#ifndef __STDC_ABI_ONLY" rescue block entirely, leaving the plain
 * declaration in effect. llvmz80's default calling convention is
 * sdcccall(1) (register-passing), but the classic asm workers
 * (isqrt.asm, unbcd.c) expect the stack-based smallc convention -- so
 * every call silently read garbage off the stack instead of the real
 * argument.
 *
 * isqrt: fixed via a "#elif defined(__LLVMZ80)" rescue routing to
 *   isqrt_fastcall (same pattern already used for abs/labs).
 * unbcd: fixed by adding an unconditional __smallc attribute to its
 *   single declaration (no _fastcall sibling exists); __smallc is a
 *   no-op for sccz80/SDCC (their own native calling-convention keyword).
 *
 * RED:  pre-fix, isqrt(n) always returns 45 regardless of n, and
 *       unbcd(n) always returns 0.
 * GREEN: both bridges compute the correct result.
 */
#include <stdlib.h>
#include <stdio.h>

int main(void) {
    unsigned int i1 = isqrt(144);      /* expect 12 */
    unsigned int i2 = isqrt(10000);    /* expect 100 */

    unsigned int u1 = unbcd(0x1234);   /* expect 1234 */
    unsigned int u2 = unbcd(0x9999);   /* expect 9999 */
    unsigned int u3 = unbcd(0x0001);   /* expect 1 */

    printf("stdlib2 i1=%u i2=%u u1=%u u2=%u u3=%u\n", i1, i2, u1, u2, u3);
    return 0;
}
