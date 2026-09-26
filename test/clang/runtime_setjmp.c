#include <stdio.h>
#include <setjmp.h>

static jmp_buf jb;
static int stage = 0;

int main(void) {
    // `vloc` is declared BEFORE setjmp and modified between setjmp and
    // longjmp.  Per C a `volatile` local so used MUST hold its last stored
    // value after the longjmp-induced second return (a non-volatile local
    // would be indeterminate there).  This pins the return-twice robustness
    // of the llvmz80 lowering: with +static-frame the local is memory-
    // resident and must be reloaded, not cached in a register that longjmp's
    // IX/IY/SP restore would revert.  Verified identical on classic /
    // newlib_iy / newlib_ix.
    volatile int vloc = 100;
    int rv;

    if ((rv = setjmp(jb)) == 0) {
        printf("A_SETJMP0\n");
        stage = 1;
        vloc = 111;
        longjmp(jb, 7);
        printf("UNREACHABLE\n");
    } else {
        // rv must equal the value passed to longjmp (7); vloc must be 111.
        printf("B_AFTER_LONGJMP stage=%d rv=%d vloc=%d\n", stage, rv, vloc);
    }
    printf("C_DONE\n");
    return 0;
}
