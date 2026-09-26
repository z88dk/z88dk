/* runtime_fileio_multi.c -- two FILE* streams open simultaneously.
 *
 * Opens F1.TXT and F2.TXT for writing at the same time, interleaves writes to
 * each, closes both, then reads them back and prints.  Verifies that the FILE*
 * layer correctly tracks multiple open streams without cross-contamination.
 *
 * GREEN (classic): each file holds its own content; console shows "multi[aa][bb]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>
#include <string.h>

int main(void) {
    char b1[16], b2[16];
    FILE *f1, *f2;

    f1 = fopen("F1.TXT", "w");
    if (!f1) { puts("FAIL open-f1-w"); return 1; }
    f2 = fopen("F2.TXT", "w");
    if (!f2) { puts("FAIL open-f2-w"); return 1; }

    fputs("aa\n", f1);
    fputs("bb\n", f2);
    fputs("cc\n", f1);   /* second write to f1 while f2 is still open */

    fclose(f1);
    fclose(f2);

    f1 = fopen("F1.TXT", "r");
    if (!f1) { puts("FAIL open-f1-r"); return 1; }
    b1[0] = 0;
    fgets(b1, sizeof b1, f1);
    fclose(f1);
    b1[strcspn(b1, "\r\n")] = 0;

    f2 = fopen("F2.TXT", "r");
    if (!f2) { puts("FAIL open-f2-r"); return 1; }
    b2[0] = 0;
    fgets(b2, sizeof b2, f2);
    fclose(f2);
    b2[strcspn(b2, "\r\n")] = 0;

    printf("multi[%s][%s]\n", b1, b2);
    return 0;
}
