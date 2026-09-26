/* runtime_file.c -- stdio FILE* layer round-trip (write then read back).
 *
 * GREEN: fopen(w) / fputs / fclose then fopen(r) / fgets / fclose returns the
 *        written line.  The FILE* layer is complete and MAME-verified on the
 *        classic clib.
 * NEWLIB: currently fails to LINK (undefined asm_target_open_p1/p2 -- the CP/M
 *        target-open primitives are not in the newlib lib set); skip-listed on
 *        the newlib path in run_all.sh.  When that gap closes this test will
 *        build and PASS there too.
 */
#include <stdio.h>
#include <string.h>

int main(void) {
    FILE *f = fopen("RTFILE.TXT", "w");
    if (!f) { puts("FAIL open-w"); return 1; }
    fputs("hello file 123\n", f);
    fclose(f);

    f = fopen("RTFILE.TXT", "r");
    if (!f) { puts("FAIL open-r"); return 1; }
    char b[32] = {0};
    fgets(b, sizeof b, f);
    fclose(f);

    /* strip trailing newline for a stable one-line compare */
    b[strcspn(b, "\r\n")] = 0;
    printf("file=[%s]\n", b);
    return 0;
}
