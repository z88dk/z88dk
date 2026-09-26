/* Regression test for ravn/z88dk#31: variadic stdio return values were
 * garbage (printf returned -332, sscanf returned -362) because __vasmallc
 * expanded to empty for llvmz80 so clang read DE instead of HL from the
 * classic clib workers.  Fix: #define __vasmallc __smallc under __LLVMZ80.
 *
 * Green: prints "PASS printf/sprintf/sscanf return values correct"
 * Red  : prints "FAIL <function> ret <wrong> want <right>"
 *
 * The program always returns 0 so ntvcm does not loop.
 */
#include <stdio.h>
#include <string.h>

int main(void) {
    int ok = 1;
    int n;
    char buf[32];
    int a, b;

    /* printf: "hi\n" = 3 chars */
    n = printf("hi\n");
    if (n != 3) {
        printf("FAIL printf ret %d want 3\n", n);
        ok = 0;
    }

    /* sprintf: "42" = 2 chars */
    n = sprintf(buf, "%d", 42);
    if (n != 2 || strcmp(buf, "42") != 0) {
        printf("FAIL sprintf ret %d buf [%s] want 2 [42]\n", n, buf);
        ok = 0;
    }

    /* sprintf: "hello world" = 11 chars */
    n = sprintf(buf, "%s %s", "hello", "world");
    if (n != 11) {
        printf("FAIL sprintf(str) ret %d want 11\n", n);
        ok = 0;
    }

    /* sscanf: matches 2 fields */
    n = sscanf("10 20", "%d %d", &a, &b);
    if (n != 2 || a != 10 || b != 20) {
        printf("FAIL sscanf ret %d a=%d b=%d want 2 10 20\n", n, a, b);
        ok = 0;
    }

    /* snprintf: writes "FF" + NUL into 3-byte buf -> ret 2 */
    char small[3];
    n = snprintf(small, sizeof small, "%X", 0xFF);
    if (n != 2 || strcmp(small, "FF") != 0) {
        printf("FAIL snprintf ret %d buf [%s] want 2 [FF]\n", n, small);
        ok = 0;
    }

    if (ok)
        printf("PASS printf/sprintf/snprintf/sscanf return values correct\n");
    return 0;
}
