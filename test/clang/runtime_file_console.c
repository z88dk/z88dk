/* runtime_file_console.c -- console output must survive an intervening fopen.
 *
 * Minimal, deterministic repro of a newlib +cpm defect uncovered while wiring
 * the upstream CP/M FCB file driver (cpm_01_file.asm, z88dk #3025):
 *
 *   1. puts("BEFORE")  -> console (BDOS 2)                 [works]
 *   2. fopen(...,"w")  -> make file (BDOS 22)
 *   3. puts("AFTER")   -> MUST still go to the console
 *
 * EXPECTED (and observed on the classic clib): both lines reach the console,
 *   so the program prints
 *       BEFORE
 *       AFTER
 *
 * ACTUAL on newlib (-clib=newlib_iy / newlib_ix, and identically under SDCC
 *   -clib=sdcc_iy): after the fopen the console stream is rebound to the file
 *   driver -- step 3 is misrouted into the file (BDOS make/read/write), so the
 *   console only ever shows
 *       BEFORE
 *   The write path itself is fine (the file is created with correct content);
 *   the defect is that opening a file corrupts the stdout console stream.
 *   (With an explicit fflush(stdout) after the fopen the llvmz80 build hangs in
 *    asm_p_forward_list_push_front on a circular stdio stream list; this test
 *    avoids fflush so the failure is a clean missing-line mismatch, not a hang.)
 *
 * The bug is compiler-independent (SDCC hits the same core misroute), so it is
 * a newlib CP/M stdio/fcntl driver issue, not a clang calling-convention one.
 */
#include <stdio.h>

int main(void) {
    puts("BEFORE");
    FILE *f = fopen("FCON.TXT", "w");
    if (f) fclose(f);
    puts("AFTER");
    return 0;
}
