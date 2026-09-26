/* runtime_fileio_null.c -- fopen returns NULL for a non-existent file.
 *
 * Attempts to open a file that does not exist for reading.  On CP/M, this
 * should fail and fopen must return NULL.  Verifies that the FILE* layer
 * correctly propagates the BDOS "file not found" error.
 *
 * GREEN (classic): fopen returns NULL; console shows "null[ok]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>

int main(void) {
    /* Use a name that cannot plausibly exist from a fresh run */
    FILE *f = fopen("NOEXIST.TXT", "r");
    if (f != NULL) {
        fclose(f);
        puts("null[NOTNIL]");
        return 1;
    }
    puts("null[ok]");
    return 0;
}
