/*
 * console_after_fopen.c -- console output must survive an intervening fopen().
 *
 * Bug demonstrator for z88dk/z88dk#3022 (newlib +cpm CP/M FCB file driver).
 *
 * The program prints a marker to the console, opens (and closes) a file, then
 * prints a second marker:
 *
 *     puts("CONSOLE-BEFORE-FOPEN");
 *     fopen("caf.dat","w"); fclose(...);
 *     puts("CONSOLE-AFTER-FOPEN");
 *
 * EXPECTED (and observed on the classic clib, -clib=default): both markers
 * reach the console.
 *
 * ACTUAL on newlib (-clib=new): only the first marker appears.  Opening a file
 * rebinds the stdout console stream onto the CP/M file driver, so the second
 * puts() is misrouted into the file instead of the console.  The file write
 * path itself is fine -- it is the console stream that gets corrupted.
 *
 * The run recipe in the Makefile greps the emulator's console output for the
 * second marker, so the classic target passes and the newlib target fails.
 */
#include <stdio.h>

int main(void)
{
    puts("CONSOLE-BEFORE-FOPEN");

    FILE *fp = fopen("caf.dat", "w");
    if (fp)
        fclose(fp);

    puts("CONSOLE-AFTER-FOPEN");
    return 0;
}
