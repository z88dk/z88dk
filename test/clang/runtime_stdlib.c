/* Runtime regression test for the ravn/llvm-z80 clang stdlib/stdio bridges in
 * z88dk (fixed 2026-07-12).
 *
 * Under the clang path __STDC_ABI_ONLY is defined, which disables the
 * `#define foo foo_fastcall` routing that sccz80/sdcc rely on, so clang fell
 * back to the classic clib's plain __smallc entries.  Those entries fetch
 * their argument off the stack (`pop`), but llvmz80 passes a single 16-bit arg
 * in HL -> the workers read stack garbage.  Symptoms observed in the dcc
 * benchmark suite:
 *   - atoi("123")            returned 523         (stdlib.h fix: route to
 *                                                  atoi_fastcall for __LLVMZ80)
 *   - free(p) after malloc   freed a garbage ptr, corrupting the heap so the
 *                            next alloc cycle died silently (malloc.h fix:
 *                            route malloc/free to *_fastcall for __LLVMZ80)
 *   - fflush(stdout)         the __smallc worker left SP 2 bytes high ->
 *                            the exit path ran off a corrupted stack and the
 *                            program restarted in an infinite loop (stdio.h +
 *                            libsrc/l/llvmz80/__fflush.asm register-ABI bridge)
 *
 * The program exercises all three, then prints a single result line the .sh
 * harness matches exactly.  The final fflush(stdout)+return only completes if
 * the fflush bridge is correct; otherwise the program loops and never exits,
 * so the harness times out / never sees the line.
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    /* atoi: value must be exact (was 523 with the stack-ABI worker). */
    int a1 = atoi("123");
    int a2 = atoi("-45");

    /* malloc/free heap integrity across cycles: allocate, fill, free, then
     * allocate again.  With the broken free() the heap corrupts and a later
     * allocation returns NULL or overlapping storage. */
    int ok = 1;
    for (int i = 0; i < 8; i++) {
        char *p = (char *)malloc(32);
        if (!p) { ok = 0; break; }
        memset(p, 'Z', 32);
        if (p[0] != 'Z' || p[31] != 'Z') { ok = 0; break; }
        free(p);
    }

    printf("stdlib %d %d %d\n", a1, a2, ok);

    /* fflush must return cleanly so the program can exit; the old __smallc
     * worker corrupted SP here and looped forever. */
    fflush(stdout);
    return 0;
}
