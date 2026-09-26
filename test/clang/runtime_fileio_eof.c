/* runtime_fileio_eof.c -- fgets loop to feof, line counting.
 *
 * Writes three lines with fputs, then reads them back in a fgets loop until
 * feof is set, counting lines.  Verifies feof detection works correctly.
 *
 * GREEN (classic): reads 3 lines, feof fires; console shows "eof[3][line-c]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>
#include <string.h>

int main(void) {
    char buf[32];
    int  count;
    FILE *f;

    f = fopen("EOF.TXT", "w");
    if (!f) { puts("FAIL open-w"); return 1; }
    fputs("line-a\n", f);
    fputs("line-b\n", f);
    fputs("line-c\n", f);
    fclose(f);

    f = fopen("EOF.TXT", "r");
    if (!f) { puts("FAIL open-r"); return 1; }
    count = 0;
    buf[0] = 0;
    while (fgets(buf, sizeof buf, f) != NULL) {
        count++;
    }
    if (!feof(f)) { puts("FAIL feof not set"); return 1; }
    fclose(f);

    /* strip trailing newline from last line */
    buf[strcspn(buf, "\r\n")] = 0;

    printf("eof[%d][%s]\n", count, buf);
    return 0;
}
