/* Regression for strerror() under llvmz80.
 *
 * strerror(errnum) requires __rodata_error_strings_head, which in the z88dk
 * newlib model is auto-generated as the rodata_error_strings section start.
 * The classic CP/M clib has no such section, so the symbol was undefined.
 *
 * Fix (ravn/z88dk 2026-07-21): __strerror_table.asm (in libsrc/l/llvmz80/)
 * defines __rodata_error_strings_head in SECTION code_l_clang with the full
 * classic errno.h string table.  Table lives outside rodata_error_strings to
 * avoid conflict with the linker's auto-generated section-head symbol.
 *
 * Green: EINVAL="EINVAL", ENOMEM="ENOMEM", strerror(0)!="" strerror(99)="ERR"
 * Red  : link error "undefined symbol: __rodata_error_strings_head"
 */
#include <string.h>
#include <errno.h>
#include <stdio.h>

int main(void) {
    int ok = 1;

    /* errnum 0 -> "EOK" (handled before table search) */
    const char *s0 = strerror(0);
    if (!s0 || s0[0] == '\0') { printf("FAIL strerror(0) empty\n"); ok = 0; }

    /* EINVAL = 6 */
    const char *s6 = strerror(EINVAL);
    if (!s6 || s6[0] == '\0') { printf("FAIL strerror(EINVAL)\n"); ok = 0; }

    /* ENOMEM = 10 */
    const char *s10 = strerror(ENOMEM);
    if (!s10 || s10[0] == '\0') { printf("FAIL strerror(ENOMEM)\n"); ok = 0; }

    /* unknown -> default "ERR" string */
    const char *sunk = strerror(99);
    if (!sunk || sunk[0] == '\0') { printf("FAIL strerror(99) empty\n"); ok = 0; }

    if (ok)
        printf("PASS strerror links and returns non-empty strings\n");
    return 0;
}
