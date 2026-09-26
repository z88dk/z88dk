/* runtime_fileio_status.c -- coverage for the classic +cpm FILE* positioning
 * routines that had NO direct fixture:  fileno, rewind, fsetpos (the last two
 * are header macros over fseek, stdio.h:314/315 -- this pins those
 * definitions).  Complements runtime_fileio_seek (fseek/ftell) and
 * runtime_fileio_update/qsort (random write-back).
 *
 * NOTE: ferror / feof / clearerr are deliberately NOT checked here -- ferror
 * and feof return GARBAGE under llvmz80 on classic +cpm (their plain int
 * f*(FILE*) decls bypass the __z88dk_fastcall bridge when __STDC_ABI_ONLY is
 * in effect, so clang tail-calls the stack-arg _ferror/_feof asm with the arg
 * in a register).  That divergence is captured by xfail_ferror_feof.{c,sh};
 * keep this fixture green so it guards the routines that DO work.
 *
 * NOTE on z88dk's fsetpos: stdio.h defines
 *     #define fsetpos(fp,pos) fseek(fp,pos,SEEK_SET)
 * so it takes the position BY VALUE (an fpos_t), NOT the ISO C
 * `const fpos_t *`.  We call it the z88dk way on purpose -- the point is to
 * verify what this tree actually ships.
 *
 * Self-verifying (NOT an oracle diff): the routines live in the SHARED classic
 * path, so sccz80 and llvmz80 would agree even if buggy.  The program asserts
 * concrete expected values and prints "status[OK]" only when every check holds.
 *
 * File layout: 16 bytes, byte i == 0x10 + i.
 *
 * GREEN: console shows "status[OK]"
 * RED:   console shows "status[FAIL <which>]"
 * NEWLIB: fails to link (CP/M FILE* unsupported -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>

#define N 16

int main(void) {
    FILE *f;
    unsigned char buf[N];
    int i, fd, c;
    fpos_t pos;

    /* seed the file */
    f = fopen("ST.DAT", "wb");
    if (!f) { puts("status[FAIL make]"); return 1; }
    for (i = 0; i < N; i++) buf[i] = (unsigned char)(0x10 + i);
    if (fwrite(buf, 1, N, f) != N) { puts("status[FAIL write]"); fclose(f); return 1; }
    fclose(f);

    f = fopen("ST.DAT", "rb");
    if (!f) { puts("status[FAIL open]"); return 1; }

    /* fileno: a valid open stream must yield a non-negative descriptor */
    fd = fileno(f);
    if (fd < 0) { printf("status[FAIL fileno %d]\n", fd); fclose(f); goto done; }

    /* read 4 bytes, snapshot position with fgetpos (must be 4) */
    for (i = 0; i < 4; i++) { c = fgetc(f); if (c != 0x10 + i) { printf("status[FAIL read %d got %d]\n", i, c); fclose(f); goto done; } }
    if (fgetpos(f, &pos) != 0) { puts("status[FAIL fgetpos]"); fclose(f); goto done; }
    if (pos != 4) { printf("status[FAIL pos %ld]\n", (long)pos); fclose(f); goto done; }

    /* advance further, then fsetpos BACK to the snapshot (by value, z88dk-style) */
    (void)fgetc(f); (void)fgetc(f);           /* now at offset 6 */
    if (fsetpos(f, pos) != 0) { puts("status[FAIL fsetpos]"); fclose(f); goto done; }
    if (ftell(f) != 4) { printf("status[FAIL after-fsetpos ftell %ld]\n", (long)ftell(f)); fclose(f); goto done; }
    c = fgetc(f);
    if (c != 0x14) { printf("status[FAIL reread %d]\n", c); fclose(f); goto done; }

    /* rewind must reposition to 0 */
    rewind(f);
    if (ftell(f) != 0) { printf("status[FAIL rewind ftell %ld]\n", (long)ftell(f)); fclose(f); goto done; }
    c = fgetc(f);
    if (c != 0x10) { printf("status[FAIL rewind-read %d]\n", c); fclose(f); goto done; }

    fclose(f);
    puts("status[OK]");
done:
    remove("ST.DAT");
    return 0;
}
