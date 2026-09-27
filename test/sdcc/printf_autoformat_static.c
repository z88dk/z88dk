/* printf_autoformat_static.c -- tests that -autoformat auto-selects %f/%d/%s
 * from a STATIC (string-literal) format argument, requiring NO #pragma printf.
 *
 * Repro from ravn/z88dk#74: without -autoformat, printf("v=%f|d=%d\n", 3.5, 42)
 * silently prints "v=f|d=0" under -compiler=sdcc --math32 because the classic
 * printf converter table omits %f by default and never consumes the float arg.
 *
 * With -autoformat, zpragma scans the literal format strings below, determines
 * CRT_printf_format needs the %f converter (0x04000000) and flags handling
 * (0x40000000), and emits the bitmask into zcc_opt.def so the linker pulls the
 * correct converters in.
 *
 * See also: https://github.com/z88dk/z88dk/wiki/Classic--Pragmas#configuring-printf-and-scanf-converters
 */
#include <stdio.h>
#include <string.h>

int main(void) {
    int  ok = 1;
    char buf[48];

    /* %f with width/precision -- also requires the flags-handling converter */
    snprintf(buf, sizeof buf, "v=%6.1f|d=%d|s=%s", 3.5, 42, "ok");
    if (strcmp(buf, "v=   3.5|d=42|s=ok") != 0) {
        printf("FAIL fmt [%s]\n", buf);
        ok = 0;
    }

    /* bare %f */
    snprintf(buf, sizeof buf, "%f", 2.0);
    if (strcmp(buf, "2.000000") != 0) {
        printf("FAIL bare %%f [%s]\n", buf);
        ok = 0;
    }

    if (ok) printf("PASS autoformat-static\n");
    return 0;
}
