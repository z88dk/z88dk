/* runtime_preserves.c -- register preservation across a chain of clib calls.
 *
 * This targets the deepest ABI risk of the newlib path (plan Phase B): newlib
 * workers declare __preserves_regs(...), which is a no-op for clang, so if a
 * worker preserves FEWER registers than clang's convention assumes, a live
 * value clang parked in that register is silently clobbered across the call.
 *
 * GREEN: five independent live integers (a..e) survive a chain of interleaved
 *        string/ctype/stdlib calls and print back unchanged, alongside the
 *        call results.  If any call clobbers a caller-saved register clang was
 *        relying on, one of a..e comes back corrupted.
 *        Portable: uses only heap-free clib functions (no malloc), so it passes
 *        under both the classic clib and newlib.
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void) {
    int a = 11, b = 22, c = 33, d = 44, e = 55;
    char buf[16];

    strcpy(buf, "ab");
    int l1 = strlen(buf);
    int m  = atoi("7");
    strcat(buf, "cd");
    int l2 = strlen(buf);
    int cmp = strncmp(buf, "abcd", 4);
    int ai  = abs(-9);

    printf("%d %d %d %d %d | l1=%d m=%d l2=%d cmp=%d abs=%d\n",
           a, b, c, d, e, l1, m, l2, cmp, ai);
    return 0;
}
