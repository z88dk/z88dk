/* ----------------------------------------------------------------
 * BIFROST*2 ENGINE DEMO - converted to z88dk C Compiler
 *
 * Before using Bifrost*2, it should be configured.
 *
 * The default configuration is:
 *
 *   Animation size: 2 or 4 frames per animation group
 *   defc __BIFROST2_ANIM_GROUP = 4
 *
 *   First non-animated frame
 *   defc __BIFROST2_STATIC_MIN = 128
 * 
 *   Value subtracted from non-animated frames
 *   defc __BIFROST2_STATIC_OVERLAP = 128
 *
 *   Default location of multicolor tiles table (16x16 pixels, 64 bytes per tile)
 *   defc __BIFROST2_TILE_IMAGES = 49000
 *
 *   Tile rendering order (1 for sequential, 7 or 9 for distributed)
 *   defc __BIFROST2_TILE_ORDER = 7
 *
 *   Location of the tile map (11x10=110 tiles)
 *   defc __BIFROST2_TILE_MAP = 65281
 *
 *   Number of char rows rendered in multicolor (3-22)
 *   define(`__BIFROST2_TOTAL_ROWS', 22)
 *
 * This program assumes the default configuration so nothing
 * needs to be done to configure the engine prior to compiling.
 *
 * However in other circumstances, the zx's bifrost*2 target
 * configuration file should be edited to change the settings
 * ("z88dk/libsrc/_DEVELOPMENT/target/zx/config_bifrost_2.m4")
 * and then the zx library should be rebuilt by running
 * "Winmake zx" (windows) or "make TARGET=zx" (other) from the
 * "z88dk/libsrc/_DEVELOPMENT" directory.
 *
 * This program can be compiled as follows:
 *
 * 1. SCCZ80 + New C Library
 *
 *    zcc +zx -vn -startup=1 -clib=new bifrost2dem.c ctile.asm -o bifrost2dem
 *    appmake +zx -b bifrost2dem_BIFROST2.bin -o bifrost2.tap --noloader --org 51625 --blockname BIFROST2
 *    appmake +zx -b bifrost2dem_CODE.bin -o bifrost2dem.tap --noloader --org 32768 --blockname bifrost2dm
 *    copy /b loader.tap + bifrost2.tap + bifrost2dem.tap demo.tap
 *
 * 2. SDCC + New C Library
 *
 *    zcc +zx -vn -SO3 -startup=1 -clib=sdcc_iy --max-allocs-per-node200000 bifrost2dem.c ctile.asm -o bifrost2dem
 *    appmake +zx -b bifrost2dem_BIFROST2.bin -o bifrost2.tap --noloader --org 51625 --blockname BIFROST2
 *    appmake +zx -b bifrost2dem_CODE.bin -o bifrost2dem.tap --noloader --org 32768 --blockname bifrost2dm
 *    copy /b loader.tap + bifrost2.tap + bifrost2dem.tap demo.tap
 *
 * After compiling, the binaries "bifrost2dem_CODE.bin"
 *   (containing the program) and "bifrost2dem_BIFROST2.bin"
 *   (containing the bifrost*2 engine) are produced.
 * Appmake is run to turn those into CODE-only tap files.
 * Windows "copy" is used to append those taps to the end of
 *   "loader.tap" to form the final tap file "demo.tap"
 *
 * "loader.tap" contains this basic loader:
 *
 * 10 CLEAR VAL "32767"
 * 20 LOAD "BIFROST2"CODE
 * 30 LOAD ""CODE
 * 40 RANDOMIZE USR VAL "32768"
 *
 * ----------------------------------------------------------------
 */

#include <stdio.h>
#include <stdlib.h>
#include <input.h>
#include <arch/zx.h>
#include <arch/zx/bifrost2.h>

#pragma output CLIB_OPT_PRINTF       = 0x00000400   // enable %c for printf only

#pragma output CLIB_MALLOC_HEAP_SIZE = 0            // do not create a heap
#pragma output REGISTER_SP           = -1           // do not change sp

#define printInk(k)          printf("\x10%c", '0'+k)
#define printPaper(k)        printf("\x11%c", '0'+k)
#define printAt(row, col)    printf("\x16%c%c", (col), (row))

extern unsigned char ctiles[];

void pressAnyKey() {
    in_wait_nokey();

    printInk(7);
    printAt(23, 4);
    printf("PRESS ANY KEY!");

    in_wait_key();

    printAt(23, 4);
    printf("              ");
}

main()
{
    int px, py, tile, attr, f, key;

    zx_border(0);
    zx_cls(0);
    printPaper(0);
    printInk(4);
    printAt(5, 22);
    printf("BIFROST*2");
    printAt(7, 23);
    printf("ENGINE");
    printAt(9, 22);
    printf("BY EINAR");

    // Install BIFROST*2 ENGINE (first time only!)
    BIFROST2_install();

    // Configure tile images address
    BIFROST2_resetTileImages(_ctiles);

    // Clear tilemap area
    for (f = 0; f < 110; ++f) {
        BIFROST2_tilemap[f] = BIFROST2_DISABLED;
    }

    // Start BIFROST*2 ENGINE
    BIFROST2_start();

    while (1) {

        printInk(5);
        printAt(16, 23);
        printf("STATIC  ");
        printAt(18, 23);
        printf("TILES");

        // Fill tilemap with random static tiles
        for (f = 0; f < 110; ++f) {
            tile = rand() & 63;
            if (tile < 32)
                BIFROST2_tilemap[f] = BIFROST2_STATIC + tile;
        }

        pressAnyKey();

        printInk(5);
        printAt(16, 23);
        printf("ANIMATED");
        printAt(20, 22);
        printf("(4 FRAMES)");

        // Animate tiles
        for (f = 0; f < 110; ++f) {
            if (BIFROST2_tilemap[f] != BIFROST2_DISABLED)
                BIFROST2_tilemap[f] -= BIFROST2_STATIC;
        }

        printInk(7);
        printAt(23, 1);
        printf("CHOOSE FRAMES 2-4 OR 0 TO EXIT");

        BIFROST2_resetAnim4Frames();

        in_wait_nokey();

        // Modify number of animation frames
        printInk(5);
        while ((key = in_inkey()) != '0') {
            switch (key) {
                case '2':
                    BIFROST2_resetAnim2Frames();
                    printAt(20, 23);
                    printf("2");
                    break;
                case '4':
                    BIFROST2_resetAnim4Frames();
                    printAt(20, 23);
                    printf("4");
                    break;
            }
        }

        printAt(23, 1);
        printf("                              ");

        printInk(5);
        printAt(16, 23);
        printf("PAINTING");
        printAt(20, 22);
        printf("          ");

        // Disable, paint and erase tiles
        px = 0;
        py = 0;
        do {
            attr = rand() & 127;
            BIFROST2_setTile(px, py, BIFROST2_DISABLED);
            BIFROST2_halt();
            BIFROST2_fillTileAttrH(PX2LIN(px), PY2COL(py), attr);
            BIFROST2_halt();
            BIFROST2_fillTileAttrH(PX2LIN(px), PY2COL(py), 0);
            py += 7;
            if (py > 9) {
                py -= 10;
                px = (px+1) % 11;
            }
        } while (px || py);

        pressAnyKey();
    }
}
