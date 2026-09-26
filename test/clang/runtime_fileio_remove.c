/* runtime_fileio_remove.c -- remove() deletes a file; subsequent fopen returns NULL.
 *
 * Creates RM.TXT, writes to it, closes it, calls remove(), then attempts to
 * open it for reading.  The open must fail (NULL) because remove() called
 * CP/M BDOS-19 (Delete File).
 *
 * GREEN (classic): remove succeeds, fopen returns NULL; console shows "remove[ok]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>

int main(void) {
    FILE *f;

    f = fopen("RM.TXT", "w");
    if (!f) { puts("FAIL open-w"); return 1; }
    fputs("to be deleted\n", f);
    fclose(f);

    if (remove("RM.TXT") != 0) { puts("FAIL remove"); return 1; }

    f = fopen("RM.TXT", "r");
    if (f != NULL) {
        fclose(f);
        puts("remove[NOTNIL]");
        return 1;
    }
    puts("remove[ok]");
    return 0;
}
