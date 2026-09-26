/* runtime_fileio_seekwrite.c -- random-access write-back regression (ravn/z88dk#54).
 *
 * Writes four 128-byte records (tags 0x10/0x20/0x30/0x40), reopens the file in
 * update mode "r+b", fseek()s to record 2, and fwrite()s 128 bytes of 0x99 over
 * it.  Then reads all four records back and prints each record's first and last
 * byte.  The in-place write must persist to record 2 AND leave records 0,1,3
 * untouched (the original #54 bug wrote nothing and corrupted a neighbour).
 *
 * Worked example (correct behaviour):
 *   rec0[0]=10 rec0[127]=10   <- untouched
 *   rec1[0]=20 rec1[127]=20   <- untouched
 *   rec2[0]=99 rec2[127]=99   <- overwritten in place
 *   rec3[0]=40 rec3[127]=40   <- untouched (neighbour not corrupted)
 *
 * GREEN (classic): sccz80 and llvmz80 both produce the four lines above.
 * NEWLIB: fails to link (CP/M newlib ships no file-open driver -- ravn/z88dk#34).
 */
#include <stdio.h>

int main(void) {
    unsigned char b[128];
    int i, r;
    const unsigned char tag[4] = {0x10, 0x20, 0x30, 0x40};
    FILE *f;

    f = fopen("X.DAT", "wb");
    if (!f) { puts("FAIL open-wb"); return 1; }
    for (r = 0; r < 4; r++) {
        for (i = 0; i < 128; i++) b[i] = tag[r];
        fwrite(b, 1, 128, f);
    }
    fclose(f);

    f = fopen("X.DAT", "r+b");
    if (!f) { puts("FAIL open-r+b"); return 1; }
    fseek(f, 2L * 128, SEEK_SET);       /* seek to record 2 */
    for (i = 0; i < 128; i++) b[i] = 0x99;
    fwrite(b, 1, 128, f);               /* overwrite record 2 in place */
    fclose(f);

    f = fopen("X.DAT", "rb");
    if (!f) { puts("FAIL open-rb"); return 1; }
    for (r = 0; r < 4; r++) {
        fread(b, 1, 128, f);
        printf("rec%d[0]=%02x rec%d[127]=%02x\n", r, b[0], r, b[127]);
    }
    fclose(f);
    remove("X.DAT");
    return 0;
}
