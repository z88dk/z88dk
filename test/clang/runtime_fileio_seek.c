/* runtime_fileio_seek.c -- fseek / ftell through a CP/M file.
 *
 * Writes three fixed-length records, then uses fseek to jump to the second
 * record, reads it back, and prints it.  Exercises fseek(SEEK_SET) and ftell.
 *
 * Records are 16 bytes each (padded with spaces) so the seek offset is exact
 * regardless of CR/LF translation.  We open in binary mode to avoid any
 * line-ending surprises.
 *
 * GREEN (classic): fseek to rec 1 reads "record-1"; console shows "seek[record-1]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>
#include <string.h>

#define RECSZ 16

static void write_rec(FILE *f, const char *s) {
    char buf[RECSZ];
    unsigned int i;
    for (i = 0; i < RECSZ; i++) buf[i] = ' ';
    for (i = 0; i < RECSZ && s[i]; i++) buf[i] = s[i];
    fwrite(buf, 1, RECSZ, f);
}

int main(void) {
    char buf[RECSZ + 1];
    long pos;
    FILE *f;

    f = fopen("SEEK.TXT", "wb");
    if (!f) { puts("FAIL open-wb"); return 1; }
    write_rec(f, "record-0");
    write_rec(f, "record-1");
    write_rec(f, "record-2");
    pos = ftell(f);   /* should be 3*RECSZ = 48 */
    fclose(f);
    (void)pos;

    f = fopen("SEEK.TXT", "rb");
    if (!f) { puts("FAIL open-rb"); return 1; }
    if (fseek(f, (long)RECSZ, SEEK_SET) != 0) { puts("FAIL fseek"); return 1; }
    fread(buf, 1, RECSZ, f);
    buf[RECSZ] = 0;
    /* trim trailing spaces */
    {
        int j = RECSZ - 1;
        while (j >= 0 && buf[j] == ' ') { buf[j] = 0; j--; }
    }
    fclose(f);

    printf("seek[%s]\n", buf);
    return 0;
}
