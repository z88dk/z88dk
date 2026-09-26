/* xfail_tmpfile.c -- KNOWN GAP: `tmpfile()` is not available under
 * zcc +cpm -compiler=llvmz80 (nor for sccz80/sdcc on the classic +cpm clib).
 *
 * WHY IT DOES NOT WORK
 *   `FILE *tmpfile(void)` returns a stream backed by an automatically-created,
 *   auto-deleted temporary file.  CP/M 2.2 has no temp-file primitive: no
 *   O_TMPFILE, no unlink-on-close, no /tmp, no atomic unique-name service.
 *   Implementing it would mean inventing a unique-name scheme + registering an
 *   at-exit unlink, none of which the classic +cpm FILE* layer provides.  So
 *   z88dk deliberately omits `tmpfile` from classic `+cpm` stdio.h across all
 *   compilers.
 *
 * This is a CLASSIC-DESIGN / platform gap, not an llvmz80 bug: CP/M simply has
 * no temp-file concept.  Workaround: fopen a caller-named scratch file and
 * `remove()` it yourself.
 *
 * The .sh harness expects this TU to FAIL TO COMPILE
 * ("call to undeclared function 'tmpfile'") and reports XFAIL.
 */
#include <stdio.h>

int main(void) {
    FILE *f = tmpfile();       /* undeclared on classic +cpm -> compile error */
    if (!f) return 1;
    fputs("scratch\n", f);
    fclose(f);
    return 0;
}
