/* runtime_fileio_update.c -- in-place random write-back to an existing file.
 *
 * Regression guard for ravn/z88dk#54.  Open an existing file in update mode
 * ("r+b", O_RDWR), fseek() back to a record and fwrite() over it in place, then
 * reopen and verify the bytes persisted AND that the neighbouring record is
 * intact.  Reads are done sequentially (NO fseek before them) on purpose --
 * that is exactly what triggers the bug.
 *
 * ROOT CAUSE (confirmed by bisection under ntvcm, not the issue's guess):
 *   The fseek+fwrite write-back was NEVER broken -- verifying with an fseek
 *   before each read returns the correct 0x99/0x22.  The real defect was that
 *   getfcb() did not initialise fcb->record_nr, so the FIRST read after fopen
 *   (before any fseek, when rnr_dirty==0) used a STALE record_nr left in the
 *   recycled _fcb slot (e.g. 2 after creating a 2-record file) and RRAN'd a
 *   non-existent record -> EOF fill 0x1A.  A single fseek sets rnr_dirty=1,
 *   which recomputes record_nr and hides the bug.  The issue's "write didn't
 *   persist" was actually this seekless verify read mis-reading.
 *   Fixed upstream in getfcb.c commit cc22967e21 ("fcb->record_nr = 0;").
 *   Released z88dk 2.4 (and older) still exhibit it; current master/dev-fork
 *   pass.  This is a shared classic-lib bug -> affects BOTH sccz80 and llvmz80.
 *
 * Self-checking: compares read-back bytes against hard-coded expected values
 * (0x99 rewritten record 0, 0x22 untouched record 1) and prints a stable ASCII
 * verdict, so a regression FAILS on either front-end (an oracle-vs-oracle diff
 * would wrongly agree since both share the classic lib).
 *
 * Bytes are filled programmatically (no string/array initialisers): z88dk
 * z80asm rejects .ascii directives emitted for local initialisers containing
 * high bytes / control characters.
 *
 * GREEN (fixed master/dev-fork): console shows "update[PASS]"
 * RED   (released 2.4, #54):     console shows "update[FAIL r0=22 r1=1a raw=1]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>

#define RECSZ 128

int main(void) {
    unsigned char b[RECSZ];
    FILE *f;
    int i;
    int r0, r1, raw_ok;

    /* --- create W.DAT: record 0 = 0x11 x128, record 1 = 0x22 x128 --- */
    f = fopen("W.DAT", "wb");
    if (!f) { puts("update[FAIL open-wb]"); return 1; }
    for (i = 0; i < RECSZ; i++) fputc(0x11, f);   /* record 0 */
    for (i = 0; i < RECSZ; i++) fputc(0x22, f);   /* record 1 */
    fclose(f);

    /* --- reopen update, seek to record 0, overwrite with 0x99 in place --- */
    f = fopen("W.DAT", "r+b");                     /* O_RDWR */
    if (!f) { puts("update[FAIL open-r+b]"); return 1; }
    if (fseek(f, 0L, SEEK_SET) != 0) { puts("update[FAIL fseek]"); fclose(f); return 1; }
    for (i = 0; i < RECSZ; i++) b[i] = 0x99;
    raw_ok = ((int)fwrite(b, 1, RECSZ, f) == RECSZ);
    fclose(f);

    /* --- verify persistence + no neighbour corruption --- */
    f = fopen("W.DAT", "rb");
    if (!f) { puts("update[FAIL open-rb]"); return 1; }
    for (i = 0; i < RECSZ; i++) b[i] = 0;
    fread(b, 1, RECSZ, f); r0 = b[0];              /* want 0x99 */
    for (i = 0; i < RECSZ; i++) b[i] = 0;
    fread(b, 1, RECSZ, f); r1 = b[0];              /* want 0x22 */
    fclose(f);
    remove("W.DAT");

    if (r0 == 0x99 && r1 == 0x22 && raw_ok)
        puts("update[PASS]");
    else
        printf("update[FAIL r0=%02x r1=%02x raw=%d]\n", r0, r1, raw_ok);
    return 0;
}
