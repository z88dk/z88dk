/* Debug-info regression (80cc, -debug).
 *
 * Under -debug every named local is homed in its frame slot
 * (IR_VREG_ADDR_TAKEN) and its cdb ,B,1,d offset is emitted post-lowering from
 * the real slot, so a debugger resolves it against the frame base — IX on z80,
 * the __debug_framepointer chain on the no-IX CPUs (8080/8085/gbz80).
 *
 * check.sh breaks at the marked line and asserts, via `info locals`, that each
 * param and local (including the reassigned `s`) reads its true value.
 */
#include <stdio.h>

int compute(int a, int b)
{
    int s = a + b;      /* s = 30  */
    int p = a * b;      /* p = 200 */
    s = s + 100;        /* s = 130 (reassigned — slot must update) */
    int r = s + p;      /* r = 330 */
    r = r + s;          /* <-- check.sh BREAK LINE (see check.sh): s,p,r,a,b live */
    return r;
}

int main(void)
{
    volatile int x = compute(10, 20);
    printf("%d\n", x);
    return 0;
}
