/* ----------------------------------------------------------------
 * BIFROST*L ENGINE DEMO - converted to z88dk C Compiler
 *
 * Before using Bifrost_l, it should be configured.
 *
 * The default configuration is:
 *
 *   Animation speed: 2 or 4 frames per second
 *   defc __BIFROSTL_ANIM_SPEED = 4
 *
 *   Animation size: 2 or 4 frames per animation group
 *   defc __BIFROSTL_ANIM_GROUP = 4
 *
 *   First non-animated frame
 *   defc __BIFROSTL_STATIC_MIN = 128
 *
 *   Value subtracted from non-animated frames
 *   defc __BIFROSTL_STATIC_OVERLAP = 128
 *
 *   Location of the tiles table (64 bytes per tile)
 *   defc __BIFROSTL_TILE_IMAGES = 48500
 *
 *   Location of the tile map (9x9=81 tiles)
 *   defc __BIFROSTL_TILE_MAP = 65281
 *
 *   Tile rendering order (1 for sequential, 7 for distributed)
 *   defc __BIFROSTL_TILE_ORDER = 7
 *
 * This program assumes the default configuration so nothing
 * needs to be done to configure the engine prior to compiling.
 *
 * However in other circumstances, the zx's bifrost_l target
 * configuration file should be edited to change the settings
 * ("z88dk/libsrc/_DEVELOPMENT/target/zx/config_bifrost_l.m4")
 * and then the zx library should be rebuilt by running
 * "Winmake zx" (windows) or "make TARGET=zx" (other) from the
 * "z88dk/libsrc/_DEVELOPMENT" directory.
 *
 * This program can be compiled as follows:
 *
 * 1. SCCZ80 + New C Library
 *
 *    zcc +zx -vn -startup=1 -clib=new bifrostldem.c ctile.asm -o bifrostldem
 *    appmake +zx -b bifrostldem_BIFROSTL.bin -o bifrostl.tap --noloader --org 58625 --blockname BIFROSTL
 *    appmake +zx -b bifrostldem_CODE.bin -o bifrostldem.tap --noloader --org 32768 --blockname bifrostldem
 *    copy /b loader.tap + bifrostl.tap + bifrostldem.tap demo.tap
 *
 * 2. SDCC + New C Library
 *
 *    zcc +zx -vn -SO3 -startup=1 -clib=sdcc_iy --max-allocs-per-node200000 bifrostldem.c ctile.asm -o bifrostldem
 *    appmake +zx -b bifrostldem_BIFROSTL.bin -o bifrostl.tap --noloader --org 58625 --blockname BIFROSTL
 *    appmake +zx -b bifrostldem_CODE.bin -o bifrostldem.tap --noloader --org 32768 --blockname bifrostldem
 *    copy /b loader.tap + bifrostl.tap + bifrostldem.tap demo.tap
 *
 * After compiling, the binaries "bifrostldem_CODE.bin"
 *   (containing the program) and "bifrostldem_BIFROSTL.bin"
 *   (containing the bifrost*l engine) are produced.
 * Appmake is run to turn those into CODE-only tap files.
 * Windows "copy" is used to append those taps to the end of
 *   "loader.tap" to form the final tap file "demo.tap"
 *
 * "loader.tap" contains this basic loader:
 *
 * 10 CLEAR VAL "32767"
 * 30 LOAD "BIFROSTL"CODE
 * 40 LOAD ""CODE
 * 50 RANDOMIZE USR VAL "32768"
 *
 * Original version and further information is available at
 * http://www.worldofspectrum.org/infoseekid.cgi?id=0027405
 * ----------------------------------------------------------------
 */
#include <stdio.h>
#include <stdlib.h>
#include <input.h>
#include <arch/zx.h>
#include <arch/zx/bifrost_l.h>

#pragma output CLIB_OPT_PRINTF       = 0x00000400   // enable %c for printf only

#pragma output CLIB_MALLOC_HEAP_SIZE = 0            // do not create a heap
#pragma output REGISTER_SP           = -1           // do not change sp

#define printInk(k)          printf("\x10%c", (k))
#define printPaper(k)        printf("\x11%c", (k))
#define printAt(row, col)    printf("\x16%c%c", (col), (row))

extern unsigned char ctiles[];

void pressAnyKey() {
    in_wait_nokey();

    printInk(7);
    printAt(22, 1);
    printf("PRESS ANY KEY");

    in_wait_key();

    printAt(22, 1);
    printf("             ");
}

void pressSpeedKey() {
    int f, key;

    for (f = 0; f < 51; ++f) {
        BIFROSTL_setTile(rand()%9, rand()%9, rand()%8);
    }
    in_wait_nokey();

    printInk(7);
    printAt(22, 1);
    printf("CHOOSE SPEED 2-4 OR 0 TO EXIT");

    while ((key = in_inkey()) != '0') {
        switch (key) {
            case '2':
                BIFROSTL_resetAnimSlow();
                printInk(5);
                printAt(20, 25);
                printf(" slow)");
                break;
            case '4':
                BIFROSTL_resetAnimFast();
                printInk(5);
                printAt(20, 25);
                printf(" fast)");
                break;
        }
    }

    printAt(22, 1);
    printf("                             ");
}

main()
{
    int f, g, a, b, c;

    zx_border(0);
    zx_cls(0);
    printPaper(0);
    printInk(6);
    printAt(4, 22);
    printf("BIFROST*");
    printAt(5, 23);
    printf("ENGINE");
    printAt(6, 24);
    printf("DEMO");
    printInk(4);
    printAt(10, 24);
    printf("with");
    printAt(11, 23);
    printf("z88dk!");

	 BIFROSTL_resetTileImages(_ctiles);
	 
    for (f = 0; f < 81; ++f) {
        BIFROSTL_tilemap[f] = BIFROSTL_STATIC + f;
    }

	 BIFROSTL_start();
	 
    while (1) {
        pressAnyKey();

        printInk(5);
        printAt(20, 1);
        printf("Demonstrating static tiles");

        for (f = 0; f < 81; ++f) {
            BIFROSTL_tilemap[f] = BIFROSTL_STATIC + (rand()%26)+8;
        }
        pressAnyKey();

        printInk(5);
        printAt(20, 1);
        printf("Animated tiles (4 frames) ");

        pressSpeedKey();

        printInk(5);
        printAt(20, 17);
        printf("2");

        BIFROSTL_resetAnim2Frames();
        pressSpeedKey();
        BIFROSTL_resetAnim4Frames();

        printInk(5);
        printAt(20, 1);
        printf("Directly modifying areas      ");

        M_BIFROSTL_SETTILE(4, 4, BIFROSTL_DISABLED);
        M_BIFROSTL_SETTILE(4, 5, BIFROSTL_DISABLED);

        printAt(9, 9);
        printf("BIFR");
        printAt(10, 9);
        printf("OST*");

        for (c = 0; c < 8; ++c) {
            a = rand()%8;
            for (b = 0; b < 2; ++b) {
                for (f = 8+72+0; f < 8+72+16; ++f) {
                    for (g = 9; g < 13; ++g) {
                        *BIFROSTL_findAttrH(f, g) = (b == 0 ? a*8 : a);
                        a = (a == 7 ? 3 : a+1);
                    }
                }
            }
        }
    }
}

