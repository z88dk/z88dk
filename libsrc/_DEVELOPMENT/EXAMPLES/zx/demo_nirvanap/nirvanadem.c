/* ----------------------------------------------------------------
 * NIRVANA+ ENGINE DEMO - converted to z88dk C Compiler
 *
 * Before using Nirvana+, it should be configured.
 *
 * The default configuration is:
 *
 * - Spectrum 48/128 mode
 * - Disable wide draw and wide sprites
 * - Total rows = 23
 *
 * This program assumes the default configuration so nothing
 * needs to be done to configure the engine prior to compiling.
 *
 * However in other circumstances, the zx's nirvana+ target
 * configuration file should be edited to change the settings
 * ("z88dk/libsrc/_DEVELOPMENT/target/zx/config_nirvanap.m4")
 * and then the zx library should be rebuilt by running
 * "Winmake zx" (windows) or "make TARGET=zx" (other) from the
 * "z88dk/libsrc/_DEVELOPMENT" directory.  To run on a pentagon
 * machine, also edit "target/zx/config_target.m4".
 *
 * Note that if wide tiles or wide sprites are enabled, the ORG
 * address of the Nirvana+ engine will change from 56323.  You
 * can find the correct ORG address by compiling with the "-m"
 * flag to generate a map file and then look up "org_nirvanap"
 * in that file to find its value.  Because this program
 * uses the default configuration, the appmake invocation to
 * generate the nirvana+ tap assumes an ORG of 56323.
 *
 * This program can be compiled as follows:
 *
 * 1. SCCZ80 + New C Library
 *
 *    zcc +zx -vn -startup=1 -clib=new nirvanadem.c btile.asm -o nirvanadem
 *    appmake +zx -b nirvanadem_NIRVANAP.bin -o nirvanap.tap --noloader --org 56323 --blockname NIRVANAP
 *    appmake +zx -b nirvanadem_CODE.bin -o nirvanadem.tap --noloader --org 32768 --blockname nirvanadem
 *    copy /b loader.tap + nirvanap.tap + nirvanadem.tap demo.tap
 *
 * 2. ZSDCC + New C Library
 *
 *    zcc +zx -vn -SO3 -startup=1 -clib=sdcc_iy --max-allocs-per-node200000 nirvanadem.c btile.asm -o nirvanadem
 *    appmake +zx -b nirvanadem_NIRVANAP.bin -o nirvanap.tap --noloader --org 56323 --blockname NIRVANAP
 *    appmake +zx -b nirvanadem_CODE.bin -o nirvanadem.tap --noloader --org 32768 --blockname nirvanadem
 *    copy /b loader.tap + nirvanap.tap + nirvanadem.tap demo.tap
 *
 * After compiling, the binaries "nirvanadem_CODE.bin"
 *   (containing the program) and "nirvanadem_NIRVANAP.bin"
 *   (containing the nirvana engine) are produced.
 * Appmake is run to turn those into CODE-only tap files.
 * Windows "copy" is used to append those taps to the end of
 *   "loader.tap" to form the final tap file "demo.tap"
 *
 * "loader.tap" contains this basic loader:
 *
 * 10 CLEAR VAL "32767"
 * 20 LOAD "NIRVANAP"CODE
 * 30 LOAD ""CODE
 * 40 RANDOMIZE USR VAL "32768"
 *
 * Thanks to Timmy for the first conversion to C of this demo.
 *
 * ----------------------------------------------------------------
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <input.h>
#include <arch/zx.h>
#include <arch/zx/nirvana+.h>

#pragma output CLIB_OPT_PRINTF       = 0x00000400   // enable %c for printf only

#pragma output CLIB_MALLOC_HEAP_SIZE = 0            // do not create a heap
#pragma output REGISTER_SP           = -1           // do not change sp

#define printInk(k)          printf("\x10%c", (k))
#define printPaper(k)        printf("\x11%c", (k))
#define printAt(row, col)    printf("\x16%c%c", (col), (row))

extern unsigned char btiles[];

const unsigned char pos[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0,
                              0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0,
                              0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0,
                              0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0,
                              0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1,
                              0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0,
                              0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
char dlin[8], dcol[8];
unsigned char lin, col, tile, sprite, counter;
unsigned char *addr;

void main(void)
{
    // Initialize screen
    zx_border(0);
    zx_cls(9);

    printPaper(1);
    printInk(7);
    printAt(0, 0);
    printf("NIRVANA+ ENGINE (c) Einar Saukas");

    // Set btiles address
    NIRVANAP_tiles(_btiles);

    // Activate NIRVANA ENGINE
    NIRVANAP_start();

    for (;;) {

        // Draw or erase tiles on screen until key is pressed
        do {
            lin = (((rand()^rand())%12)<<4)+16;                      // random values 16,32,..,192
            col = ((rand()&15)<<1);                         // random values 0,2,4,..,30
            if (pos[(lin-16)+(col>>1)] > 0) {
                NIRVANAP_halt();
                NIRVANAP_drawT_raw(16, lin, col);
            } else if (rand()&1) {
                NIRVANAP_halt();
                NIRVANAP_drawT_raw((rand()^rand())&15, lin, col);
            } else {
                NIRVANAP_halt();
                NIRVANAP_fillT_raw(0, lin, col);
            }
        } while (!in_test_key());  // test if a key is pressed, smaller than in_inkey()

        // Wait until key is released
        in_wait_nokey();

        // Erase all tiles
        for (lin = 16; lin != 208; lin += 16) {
            for (col = 0; col != 32; col+=2) {
                if (col == 0 || col == 16) {
                    NIRVANAP_halt();
                }
                NIRVANAP_fillT_raw(0, lin, col);
            }
        }

        // Initialize sprites randomly
        for (sprite = 0; sprite != 8; sprite++) {
            lin = ((rand()%99)<<1)+2;                       // random values 2,4,..,198
            col = (rand()%29)+1;                            // random values 1,2,..,29
            dlin[sprite] = ((rand()%2)<<2)-2;               // random values -2,2
            dcol[sprite] = (rand()%3)-1;                    // random values -1,0,1
            NIRVANAP_halt();
            NIRVANAP_spriteT(sprite, sprite<<1, lin, col);
        }

        // Move sprites on screen until key is pressed
        do {
            counter++;
            for (sprite = 0; sprite < 8; sprite++) {
                lin = *SPRITELIN(sprite);
                col = *SPRITECOL(sprite);
                tile = *SPRITEVAL(sprite);
                if (sprite == 0 || sprite == 3 || sprite == 6)
                    NIRVANAP_halt();
                NIRVANAP_fillT_raw(0, lin, col);
                lin += dlin[sprite];
                col += dcol[sprite];
                if ((counter & 7) == sprite)
                    tile ^= 1;
                NIRVANAP_spriteT(sprite, tile, lin, col);
                if (lin == 0 || lin == 200)
                    dlin[sprite] = -dlin[sprite];
                if (col == 0 || col == 30)
                    dcol[sprite] = -dcol[sprite];
            }
        } while (!in_test_key());  // test if a key is pressed, smaller than in_inkey()

        // Wait until key is released
        in_wait_nokey();

        // Erase and hide sprites (moving each sprite to line zero)
        NIRVANAP_halt();
        for (sprite = 0; sprite < 8; sprite++) {
            lin = *SPRITELIN(sprite);
            col = *SPRITECOL(sprite);
            *SPRITELIN(sprite) = 0;
            NIRVANAP_fillT_raw(0, lin, col);
        }
    }
}
