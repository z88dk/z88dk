/* Runtime regression test for the ravn/llvm-z80 clang realloc bridge in z88dk
 * (fixed 2026-08-04).
 *
 * Same bug class as qsort/bsearch/calloc: clang's __smallc / sdcccall(0)
 * pushes stack arguments RIGHT-to-LEFT (first C arg ends up on TOP of the
 * stack), but the classic z88dk `_callee` asm routines were written for the
 * z88dk/SDCC LEFT-to-RIGHT order (first arg deepest, last arg on top).
 *
 * Under the clang path __STDC_ABI_ONLY is defined, so the plain
 * `#define realloc realloc_callee` routing that sccz80/sdcc use is skipped and
 * realloc fell back to malloc.h's __ZPROTO reversed-arg form -> `___realloc`,
 * the CALLER-linkage entry that pops its args off the STACK.  clang passes
 * (p,size) in registers, so `___realloc` popped the return address + stack
 * garbage as the args and handed asm_realloc a bogus pointer/size:
 * realloc(p,300) on a block holding "hello" returned garbage (old data lost)
 * and corrupted the heap enough to hang the program at exit.
 *
 * calloc is masked from this bug by commutativity (nobj*size is symmetric);
 * realloc(p,size) is NOT.  The fix (identical in spirit to the qsort/bsearch
 * reversed-arg macros in stdlib.h) routes realloc -> realloc_callee in the
 * __STDC_ABI_ONLY && __LLVMZ80 block of malloc.h with the two args swapped
 * (`#define realloc(a,b) realloc_callee(b,a)`, and a matching
 * `realloc_callee(unsigned size, void *p)` prototype) so the pointer and size
 * arrive at asm_realloc in the order it expects (hl=p, bc=size).
 *
 * This program exercises realloc(NULL,n)==malloc, grow-preserves-data,
 * shrink-preserves-data, and a run of growing reallocs, then prints a single
 * result line the .sh harness matches exactly.
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    /* realloc(NULL, n) behaves as malloc */
    char *p = realloc(NULL, 8);
    if (!p) { printf("realloc FAIL rNULL\n"); return 1; }
    strcpy(p, "abc");

    /* grow: old contents must be preserved */
    p = realloc(p, 64);
    if (!p || strcmp(p, "abc")) { printf("realloc FAIL grow\n"); return 1; }
    strcat(p, "defghijklmnop");            /* now 16 chars + NUL = 17 bytes */

    /* shrink (still >= 17): contents preserved */
    p = realloc(p, 20);
    if (!p || strcmp(p, "abcdefghijklmnop")) { printf("realloc FAIL shrink\n"); return 1; }

    /* many growing reallocs, each must preserve the string */
    int ok = 1;
    for (int i = 2; i <= 20; i++) {
        p = realloc(p, i * 10);
        if (!p || strcmp(p, "abcdefghijklmnop")) { ok = 0; break; }
    }

    printf("realloc %d %d\n", ok, (int)strlen(p));   /* expect: realloc 1 16 */

    free(p);
    return 0;
}
