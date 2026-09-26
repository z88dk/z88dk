/* runtime_attr.c -- GNU __attribute__ on a function survives compilation.
 *
 * GREEN: a function marked __attribute__((noinline)) compiles, links, and runs
 *        (noinline keeps it a real call, not folded away).  Works on the
 *        classic clib.
 * NEWLIB: currently FAILS with "syntax error: token -> '(' ; column 15" from
 *        the z88dk-ucpp -D__SDCC stage -- __attribute__((...)) is rejected on
 *        the newlib preprocessing path (plan Phase C, the divergent newlib
 *        sys/compiler.h llvmz80 handling).  Broader than __smallc: a large
 *        class of ordinary C uses attributes.  Skip-listed on newlib; will
 *        PASS there once the header handling is fixed.
 */
#include <stdio.h>

__attribute__((noinline)) static int add(int a, int b) { return a + b; }

int main(void) {
    volatile int x = 40, y = 2;
    printf("attr=%d\n", add(x, y));
    return 0;
}
