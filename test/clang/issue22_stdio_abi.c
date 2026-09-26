/* issue22_stdio_abi.c -- regression guard for ravn/z88dk#22.
 *
 * #22 (register-vs-stack ABI class): under -compiler=llvmz80 several classic
 * stdio functions were declared via the generic __ZPROTO{2,3} clang branch,
 * which calls the classic worker with args in registers (sdcccall1) -- but the
 * workers are __smallc stack functions (they pop their args off the stack). The
 * mismatch made fputs/fgets warm-boot-loop and ungetc/fgetpos return garbage.
 *
 * Fixed in include/stdio.h by binding each affected function straight to its
 * classic worker via a reversed-param __smallc prototype under __LLVMZ80 -- the
 * same pattern already used for fopen/freopen/fclose/fflush/ftell/fseek/fread/
 * fwrite. This fixture exercises the four verified-affected functions:
 *   fputs, fgets, ungetc, fgetpos.
 * (rename was checked and is NOT affected; the fd-layer functions fdopen/
 * fdgetpos/_freopen1/fmemopen/fgets_cons are unverified on CP/M classic.)
 *
 * GREEN: prints "OK" for each, then DONE.
 * RED (pre-fix): warm-boot restart loop (reprints early lines forever) and/or
 * wrong values.
 */
#include <stdio.h>

int main(void)
{
    /* fputs: write "hello\n" */
    FILE *f = fopen("A.DAT", "wb");
    int r = fputs("hello\n", f);
    printf("fputs=%d %s\n", r, r > 0 ? "OK" : "BAD"); fflush(stdout);
    fclose(f);

    /* fgets: read the line back */
    f = fopen("A.DAT", "rb");
    char buf[16];
    char *g = fgets(buf, sizeof buf, f);
    int fgets_ok = (g != 0) && (buf[0] == 'h') && (buf[4] == 'o');
    printf("fgets=%s %s\n", fgets_ok ? "hello" : "BAD", fgets_ok ? "OK" : "BAD"); fflush(stdout);
    fclose(f);

    /* ungetc: push back the first char, re-read it */
    f = fopen("A.DAT", "rb");
    int a = fgetc(f);
    int u = ungetc(a, f);
    int b = fgetc(f);
    int ungetc_ok = (u == a) && (b == a);
    printf("ungetc=%d,%c,%c %s\n", u, a, b, ungetc_ok ? "OK" : "BAD"); fflush(stdout);
    fclose(f);

    /* fgetpos: after reading 2 bytes, position must be 2 and return 0 */
    f = fopen("A.DAT", "rb");
    fgetc(f); fgetc(f);
    fpos_t pos;
    int pr = fgetpos(f, &pos);
    int fgetpos_ok = (pr == 0) && ((long)pos == 2);
    printf("fgetpos=%d,%ld %s\n", pr, (long)pos, fgetpos_ok ? "OK" : "BAD"); fflush(stdout);
    fclose(f);

    printf("DONE\n");
    return 0;
}
