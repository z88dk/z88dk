/* runtime_libgen.c -- basename()/basename_ext()/dirname()/pathnice() on classic
 * +cpm must return the SAME strings under sccz80 and llvmz80.
 *
 * These are the same ferror/feof ABI-mismatch class (ravn/z88dk#55 audit):
 * their plain `char *basename(char *path)` decl carried NO ABI attribute and the
 * `__z88dk_fastcall` variant + redirect macro were hidden behind
 * `#ifndef __STDC_ABI_ONLY`.  Under llvmz80 (__STDC_ABI_ONLY defined) the plain
 * decl was used, so clang read the returned pointer from DE (its sdcccall(1)
 * default) while the hand-asm worker returns it in HL -> garbage pointer.
 * (Verified before the fix: sccz80 bn=[zcc] dn=[/usr/local/bin], llvmz80 printed
 * a garbage/binary pointer.)  The single `char*` argument coincidentally worked
 * because a single 16-bit arg lands in HL either way; only the RETURN register
 * diverged.
 *
 * Fix (libgen.h): drop the `#ifndef __STDC_ABI_ONLY` guard so the fastcall decl +
 * redirect macro apply unconditionally, exactly like the ferror/feof fix and
 * mirroring how fileno is declared __smallc __z88dk_fastcall.  llvmz80 now reads
 * the return from HL and agrees with sccz80.
 *
 * Oracle: sccz80 defines the correct strings, llvmz80 must match.
 */
#include <libgen.h>
#include <stdio.h>

int main(void) {
    char p1[] = "/usr/local/bin/zcc";
    char p2[] = "/usr/local/bin/zcc";
    char p3[] = "/aa/bb/report.txt";
    char p4[] = "C:/DIR/FILE.COM";

    char *bn = basename(p1);
    char *dn = dirname(p2);
    char *be = basename_ext(p3);
    char *pn = pathnice(p4);

    printf("lg bn=[%s] dn=[%s] be=[%s] pn=[%s]\n",
           bn ? bn : "(nil)", dn ? dn : "(nil)",
           be ? be : "(nil)", pn ? pn : "(nil)");
    return 0;
}
