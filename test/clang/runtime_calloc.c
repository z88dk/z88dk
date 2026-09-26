/* Runtime regression test for the ravn/llvm-z80 clang calloc bridge in z88dk
 * (fixed 2026-07-14).
 *
 * Under the clang path __STDC_ABI_ONLY is defined, which disables the
 * `#define calloc calloc_callee` routing that sccz80/sdcc rely on.  calloc
 * therefore fell back to malloc.h's __ZPROTO2 form, which for clang expands to
 * an argument-swapping inline calling `__calloc` -- a hand-written bridge in
 * libsrc/l/llvmz80/__calloc.asm that referenced a raw user-provided `_heap`
 * symbol.  That symbol does not exist under the auto-managed heap that
 * malloc_fastcall uses, so any clang program calling calloc failed to link
 * ("undefined symbol: _heap").
 *
 * The fix routes calloc -> calloc_callee (__smallc __z88dk_callee =
 * sdcccall(0)+z80_callee, honoured natively by clang, already present in the
 * classic malloc-classic clib) in the __STDC_ABI_ONLY && __LLVMZ80 block of
 * malloc.h, exactly like the non-__STDC_ABI_ONLY path -- and deletes the
 * __calloc.asm bridge.
 *
 * This program allocates a zeroed array via calloc, checks it reads back as
 * zero, writes one cell, and prints a single result line the .sh harness
 * matches exactly.
 */
#include <stdlib.h>
#include <stdio.h>

int main(void) {
    int *p = calloc(5, sizeof(int));
    if (!p) { printf("calloc FAIL\n"); return 1; }

    /* calloc must zero-initialise: sum of the 5 cells must be 0. */
    int sum = 0;
    for (int i = 0; i < 5; i++) sum += p[i];

    p[2] = 42;                       /* prove the storage is writable */
    printf("calloc %d %d\n", sum, p[2]);

    free(p);
    return 0;
}
