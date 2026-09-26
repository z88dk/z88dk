/* runtime_fileio_fmt.c -- fprintf / fscanf round-trip through a CP/M file.
 *
 * Writes a formatted line with fprintf, then reads it back with fscanf and
 * prints the decoded values to the console.  Exercises the text-mode FILE*
 * path for formatted I/O, not just raw fputs/fgets.
 *
 * GREEN (classic): both fprintf and fscanf work; console shows "fmt[42][hello]"
 * NEWLIB: fails to link (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)
 */
#include <stdio.h>
#include <string.h>

int main(void) {
    int n;
    char buf[16];
    FILE *f;

    f = fopen("FMT.TXT", "w");
    if (!f) { puts("FAIL open-w"); return 1; }
    fprintf(f, "%d %s\n", 42, "hello");
    fclose(f);

    f = fopen("FMT.TXT", "r");
    if (!f) { puts("FAIL open-r"); return 1; }
    n = 0;
    buf[0] = 0;
    fscanf(f, "%d %15s", &n, buf);
    fclose(f);

    printf("fmt[%d][%s]\n", n, buf);
    return 0;
}
