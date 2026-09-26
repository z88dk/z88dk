/* runtime_fileio_rename.c -- rename() then fopen under new name.
 *
 * Creates OLD.TXT, writes a known string, closes it, calls rename() to move
 * it to NEW.TXT, then reads NEW.TXT back and prints the content.  Exercises
 * CP/M BDOS-23 (Rename File) through the stdio layer.
 *
 * GREEN (classic): rename succeeds, content readable from NEW.TXT;
 *                  console shows "rename[renamed]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>
#include <string.h>

int main(void) {
    char buf[32];
    FILE *f;

    f = fopen("OLD.TXT", "w");
    if (!f) { puts("FAIL open-w"); return 1; }
    fputs("renamed\n", f);
    fclose(f);

    if (rename("OLD.TXT", "NEW.TXT") != 0) { puts("FAIL rename"); return 1; }

    f = fopen("NEW.TXT", "r");
    if (!f) { puts("FAIL open-new"); return 1; }
    buf[0] = 0;
    fgets(buf, sizeof buf, f);
    fclose(f);
    buf[strcspn(buf, "\r\n")] = 0;

    printf("rename[%s]\n", buf);
    return 0;
}
