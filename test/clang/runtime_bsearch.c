/* Runtime regression test for bsearch() under clang/llvmz80.
 *
 * HISTORY: this was xfail_bsearch -- the classic +cpm clib historically shipped
 * only a non-standard 4-arg l_bsearch (no `size`), so standard 5-arg bsearch
 * was undeclared.  Upstream's shared search/sort core now provides a standard
 * 5-arg _bsearch (libsrc/classic/stdlib/{bsearch,_bsearch}.asm) that reaches
 * the comparator through the l_cmp_sdcc thunk, exactly like qsort.
 *
 * Two ABI facts (both handled in <stdlib.h>, see runtime_qsort.c for detail):
 *   1. The comparator must be __smallc -- l_cmp_sdcc marshals its two operands
 *      on the stack, not in registers.
 *   2. clang's __smallc/sdcccall(0) pushes bsearch's own five arguments right-
 *      to-left, but the _bsearch asm entry expects the z88dk left-to-right
 *      order (key deepest, compar on top).  <stdlib.h> binds a reversed-arg
 *      alias (__bsearch_llvmz80, __asm-labelled to the existing _bsearch symbol)
 *      and swaps the order back with a macro.
 *
 * The test searches a sorted array of squares for every present key (must find
 * the exact element) and for keys known to be absent (must return NULL), then
 * prints a single result line the .sh harness matches exactly.
 */
#include <stdlib.h>
#include <stdio.h>

#define N 16

/* The comparator carries __z88dk_callback (from <stdlib.h>): expands to
 * __attribute__((sdcccall(0))) under llvmz80 to match the library sort/search
 * thunk's operand order, empty for sccz80/sdcc.  No #ifdef here.  See #279. */
__z88dk_callback int cmp(const void *a, const void *b) {
    return *(const int *)a - *(const int *)b;
}

int main(void) {
    static int arr[N];
    int i, hits = 0, misses = 0;

    for (i = 0; i < N; i++) arr[i] = i * i;   /* 0,1,4,9,...,225 -- sorted */

    /* Every present key must be found and point at the matching element. */
    for (i = 0; i < N; i++) {
        int key = i * i;
        int *p = (int *)bsearch(&key, arr, N, sizeof(int), cmp);
        if (p && *p == key) hits++;
    }

    /* Keys between/around the squares are absent -> NULL. */
    {
        int absent[5] = { -1, 2, 8, 50, 1000 };   /* none are squares in 0..225 */
        for (i = 0; i < 5; i++) {
            int *p = (int *)bsearch(&absent[i], arr, N, sizeof(int), cmp);
            if (p == NULL) misses++;
        }
    }

    /* Prints: bsearch 16 5 OK   (hits == N, misses == 5) */
    printf("bsearch %d %d %s\n", hits, misses,
           (hits == N && misses == 5) ? "OK" : "BAD");
    fflush(stdout);
    return 0;
}
