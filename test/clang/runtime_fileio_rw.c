/* runtime_fileio_rw.c -- fwrite / fread binary round-trip through a CP/M file.
 *
 * Writes 8 known bytes with fwrite in binary mode, reads them back with fread,
 * and verifies each byte.  Tests the binary FILE* path independent of text-mode
 * line-ending translation.
 *
 * GREEN (classic): fwrite and fread agree; console shows "rw[ok]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>

int main(void) {
    /* Initialise programmatically: z88dk z80asm fails to assemble .ascii
     * directives emitted for local array initialisers (both high bytes and
     * control characters cause syntax errors in the z80asm stage). */
    unsigned char DATA[8];
    DATA[0]='A'; DATA[1]='B'; DATA[2]='C'; DATA[3]='D';
    DATA[4]='a'; DATA[5]='b'; DATA[6]='c'; DATA[7]='d';
    unsigned char buf[8];
    unsigned int i, n;
    FILE *f;

    f = fopen("RW.TXT", "wb");
    if (!f) { puts("FAIL open-wb"); return 1; }
    n = (unsigned int)fwrite((void *)DATA, 1, sizeof DATA, f);
    fclose(f);
    if (n != sizeof DATA) { printf("FAIL fwrite n=%u\n", n); return 1; }

    f = fopen("RW.TXT", "rb");
    if (!f) { puts("FAIL open-rb"); return 1; }
    for (i = 0; i < sizeof buf; i++) buf[i] = 0;
    n = (unsigned int)fread((void *)buf, 1, sizeof buf, f);
    fclose(f);
    if (n != sizeof DATA) { printf("FAIL fread n=%u\n", n); return 1; }

    for (i = 0; i < sizeof DATA; i++) {
        if (buf[i] != DATA[i]) {
            printf("rw[MISMATCH i=%u got=%02x want=%02x]\n",
                   i, (unsigned)buf[i], (unsigned)DATA[i]);
            return 1;
        }
    }
    puts("rw[ok]");
    return 0;
}
