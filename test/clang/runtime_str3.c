/* Runtime regression test for the llvmz80 string bridges fixed in
 * "Group C klasse 1": stricmp, strrstr, strlcpy
 * (libsrc/string/c/sccz80/{stricmp,strrstr,strlcpy}.asm).
 *
 * stricmp: had a copy-paste typo, `___stricmp` called the stack-based
 *   smallc entry `strcasecmp` instead of the register-based worker
 *   `asm_strcasecmp`, corrupting HL/DE and returning garbage.
 * strrstr/strlcpy: still had the old broken `defc ___X = X` stack-ABI
 *   alias that a prior commit (2842d1c8f7) fixed for 14 sibling
 *   functions but never migrated for these two.
 *
 * RED:  pre-fix, stricmp("equal","equal") != 0 (garbage), strrstr
 *       returns wrong pointers / hangs, strlcpy corrupts dest / returns
 *       the wrong length.
 * GREEN: all assertions print matching values on a single output line.
 */
#include <string.h>
#include <stdio.h>

int main(void) {
    /* stricmp: case-insensitive equal -> 0 */
    int si = stricmp("Equal", "eQUAL");            /* expect 0 */

    /* strrstr: last occurrence of "Test" in "TestTest" -> offset 4 */
    const char *s2 = "TestTest";
    char *rs = strrstr(s2, "Test");
    int rs_off = rs ? (int)(rs - s2) : -1;         /* expect 4 */

    /* strrstr: not found -> NULL */
    char *rs_nf = strrstr("string", "not");        /* expect NULL (0) */

    /* strlcpy: fits in dest -> full copy, returns strlen(src) */
    char dst[16];
    size_t r1 = strlcpy(dst, "hello", sizeof(dst)); /* expect dst="hello" r1=5 */

    /* strlcpy: truncates when dest too small, still returns strlen(src) */
    char dst2[3];
    size_t r2 = strlcpy(dst2, "hello", sizeof(dst2)); /* expect dst2="he" r2=5 */

    printf("str3 si=%d rs=%d rsnf=%d [%s] r1=%d [%s] r2=%d\n",
           si, rs_off, rs_nf == NULL ? -1 : 1, dst, (int)r1, dst2, (int)r2);
    return 0;
}
