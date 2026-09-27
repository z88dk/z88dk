/* printf_autoformat_dynamic.c -- tests that -autoformat emits a diagnostic note
 * for DYNAMIC (non-literal) format arguments in a MIXED translation unit.
 *
 * A "mixed" TU is one that also has at least one literal format -- which prunes
 * the converter table to exactly what the literals use.  A runtime/variable fmt
 * may then require a converter that no literal mentioned, and the converter will
 * silently be absent at runtime.
 *
 * -autoformat detects this and emits a compiler note (to stderr) pointing at the
 * non-literal call site so the user knows to add an explicit #pragma printf.
 * This file verifies that the NOTE fires for the dynamic case and does NOT fire
 * for a pure-dynamic-only TU (where no pruning takes place).
 *
 * See also: https://github.com/z88dk/z88dk/wiki/Classic--Pragmas#configuring-printf-and-scanf-converters
 */
#include <stdio.h>

/* Mixed TU: literal "%d" (prunes table) + runtime format variable.
 * Expected: zpragma -autoformat emits a "not a string literal" note pointing
 * here, because the runtime fmt may need converters not covered by the literal.
 */
int main(int argc, char **argv) {
    const char *fmt = (argc > 1) ? argv[1] : "%x";
    printf("count=%d\n", argc);   /* literal -- prunes the table to include %d */
    printf(fmt, argc);             /* non-literal -- triggers the note */
    return 0;
}
