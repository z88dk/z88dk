/* runtime_fileio_rbplus.c -- fopen mode-string "rb+" must allow writing (ravn/z88dk#53).
 *
 * C treats "rb+" and "r+b" as equivalent update modes.  Classic stdio used to
 * parse the mode positionally and only accept '+' in the slot right after the
 * primary letter, so "rb+" (b before +) silently opened read-only and every
 * write failed.  This test opens an existing file with each spelling and writes
 * 128 bytes; both must report 128 written.
 *
 * IMPORTANT -- this is an ABSOLUTE-assertion test, not an sccz80/llvmz80 oracle
 * comparison: both toolchains share the same classic stdio, so before the fix
 * BOTH returned 0 and an oracle comparison would have (wrongly) passed.  The
 * program prints "rbplus=<n> rplusb=<n>" and the harness asserts n==128.
 *
 * GREEN: "rbplus=128 rplusb=128" on both sccz80 and llvmz80.
 * Pre-fix (buggy): "rbplus=0 rplusb=128".
 */
#include <stdio.h>

static int write_mode(const char *mode) {
    unsigned char b[128];
    int i, n;
    FILE *f;
    for (i = 0; i < 128; i++) b[i] = 0x99;
    f = fopen("M.DAT", mode);
    if (!f) return -1;
    n = (int)fwrite(b, 1, 128, f);
    fclose(f);
    return n;
}

int main(void) {
    unsigned char b[128];
    int i, rbplus, rplusb;
    FILE *f;

    /* create a 256-byte file so there is something to overwrite in place */
    f = fopen("M.DAT", "wb");
    if (!f) { puts("FAIL open-wb"); return 1; }
    for (i = 0; i < 256; i++) fputc(0x11, f);
    fclose(f);
    rbplus = write_mode("rb+");

    f = fopen("M.DAT", "wb");
    for (i = 0; i < 256; i++) fputc(0x11, f);
    fclose(f);
    rplusb = write_mode("r+b");

    remove("M.DAT");
    printf("rbplus=%d rplusb=%d\n", rbplus, rplusb);
    return 0;
}
