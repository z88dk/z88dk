/* runtime_strlit.c -- regression for the fixlabels.pl string-literal dot bug.
 *
 * bridge_postproc.sh runs fixlabels.pl to flatten clang's dotted LABELS
 * (.LBB0_4, L_.str.1, _counter.3) into z80asm-legal names.  The generic
 * "identifier with an internal dot -> dots become _" rule used to run over the
 * WHOLE line, including the body of `DEFM "..."` string literals emitted for
 * `.asciz`.  So any literal whose text looks like a dotted identifier was
 * silently corrupted: "a.b.c" was stored as "a_b_c", "3.14" as "3_14", etc.
 * (Found via strchr('.') returning NULL: the '.' had become '_' in the data.)
 *
 * This exercises several real-world dotted literals end to end and checks the
 * stored bytes.  On the pre-fix toolchain every '.' between identifier chars
 * prints as '_', so the expected line does not appear -> the .sh harness fails.
 */
#include <stdio.h>
#include <string.h>

int main(void)
{
    /* dot between identifier chars: the exact corruption pattern */
    static const char fn[] = "file.txt";
    /* version string: multiple internal dots */
    static const char ver[] = "1.2.3";
    /* pi as text: digit.digit */
    static const char pi[] = "3.14159";
    /* a runtime buffer (not a literal) so strchr must run for real */
    char buf[16];
    strcpy(buf, "a.b.c");

    int ok = 1;
    ok &= (fn[4]  == '.');          /* file[.]txt */
    ok &= (ver[1] == '.' && ver[3] == '.');
    ok &= (pi[1]  == '.');
    ok &= (strchr(buf, '.') == buf + 1);        /* first '.' at index 1 */
    ok &= (strrchr(buf, '.') == buf + 3);       /* last  '.' at index 3 */
    ok &= (strcmp(fn, "file.txt") == 0);        /* literal round-trips */

    /* Print the dotted literals so a human (and grep) can see them intact. */
    printf("strlit %s %s %s %s %d\n", fn, ver, pi, buf, ok);
    return 0;
}
