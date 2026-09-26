/* runtime_printf_autoformat.c -- STOCK z88dk classic printf, NO #pragma printf.
 *
 * The point of this test is the ABSENCE of any `#pragma printf` and of the
 * __LLVMZ80_IEEE_PRINTF route: with -compiler=llvmz80 the driver's zpragma
 * -autoformat pass scans these printf() call sites, sees the %f/%e/%g/%d/%s
 * conversions, and auto-selects the matching classic converters + flags
 * handling (ravn/z88dk#42).  Without that pass, %f prints a literal 'f' and
 * the following varargs desync -- the exact footgun #42 documents.
 *
 * Built with --math32 (clang's double is 32-bit binary32, so the classic
 * float converter core is math32).  Green: prints "PASS autoformat".
 */
#include <stdio.h>
#include <string.h>

int main(void) {
    int  ok = 1;
    char buf[48];

    /* %f with width/precision -- needs both the 'f' converter (bit 0x4000000)
       and flags handling (bit 0x40000000), the two things the auto-scan must
       select for "%6.1f" to render instead of printing "6.1f" literally. */
    snprintf(buf, sizeof buf, "v=%6.1f|d=%d|s=%s", 3.5, 42, "ok");
    if (strcmp(buf, "v=   3.5|d=42|s=ok") != 0) { printf("FAIL fmt [%s]\n", buf); ok = 0; }

    /* plain %f (no width) -- the bare converter path */
    snprintf(buf, sizeof buf, "%f", 2.0);
    if (strcmp(buf, "2.000000") != 0) { printf("FAIL bare %%f [%s]\n", buf); ok = 0; }

    if (ok) printf("PASS autoformat\n");
    return 0;
}
