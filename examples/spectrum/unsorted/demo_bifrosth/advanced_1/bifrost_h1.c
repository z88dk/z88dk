/* ----------------------------------------------------------------
 * BIFROST* ENGINE HI-DEMO #1
 *
 * This program can be compiled as follows with zsdcc:

   zcc +zx -vn -m -startup=1 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 bifrost_h1.c ctile.asm -o bifrost_h1
   appmake +glue -b bifrost_h1 --filler 0 --clean
   appmake +zx -b bifrost_h1__.bin --org 32768 --blockname bf_h1 -o bifrost_h1.tap

 * Or with sccz80:

   zcc +zx -v -m -startup=1 -clib=new bifrost_h1.c ctile.asm -o bifrost_h1
   appmake +glue -b bifrost_h1 --filler 0 --clean
   appmake +zx -b bifrost_h1__.bin --org 32768 --blockname bf_h1 -o bifrost_h1.tap

 * The compile will produce two binares.  The first is the compiled code destined for address
 * 32768 and the second is the bifrost engine itself destined for a different address.
 *
 * appmake +glue generates a single monolithic binary out of the output binaries, putting things
 * together according to org address and filling any holes.
 *
 * appmake +zx generates a tap file from +glue's output.
 *
 * Original version and further information is available at
 * https://www.worldofspectrum.org/forums/discussion/40246/redirect/p1
 * ----------------------------------------------------------------
 */

#pragma output CLIB_MALLOC_HEAP_SIZE =  0           // do not create a heap
#pragma output REGISTER_SP           = -1           // do not change sp (below CLEAR in loader)

#pragma printf = "%c %u"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <input.h>
#include <intrinsic.h>
#include <arch/zx.h>
#include <arch/zx/bifrost_h.h>

#define PRINT_CLS      "\x0c"
#define PRINT_INK_I    "\x10%c"
#define PRINT_PAPER_P  "\x11%c"
#define PRINT_AT_CR    "\x16%c%c"

#define INSIDE_COLOR      INK_BLACK
#define OUTSIDE_COLOR     INK_WHITE
#define NUM_TILES         5

extern unsigned char ctiles[];

struct tiles_s 
{
   unsigned char lin;                   // hi-res vertical tile position
   signed   char dlin;                  // hi-res vertical tile movement
   unsigned char col;                   // hi-res horizontal tile position
   signed   char dcol;                  // hi-res horizontal tile movement
   unsigned char tile;                  // tile number
} tiles[NUM_TILES];

unsigned char px, py;                   // "abstract" coordinates

unsigned char f;                        // generic counter
unsigned char frames = 1;

void main(void)
{
   struct tiles_s *tptr;
   
   // initialize variables
   
   for (tptr = tiles; tptr != tiles + NUM_TILES; ++tptr)
   {
      tptr->lin = (unsigned int)rand() % 161;
      tptr->dlin = ((unsigned int)rand() % 2)*2 - 1;
      tptr->col = (unsigned int)rand() % 19;
      tptr->dcol = ((unsigned int)rand() % 3) - 1;
      tptr->tile = 8 + (unsigned int)rand() % 18;
   }

   // clear bitmap screen

   zx_border(OUTSIDE_COLOR);
   printf(PRINT_PAPER_P PRINT_INK_I PRINT_CLS, OUTSIDE_COLOR, OUTSIDE_COLOR);

   // show messages
    
   printf(PRINT_INK_I PRINT_AT_CR "Delay: %u frame(s)" PRINT_AT_CR "Use O/P to change", 7-OUTSIDE_COLOR, 1+1, 20+1, frames, 1+1, 21+1);

   // disable entire tile map
    
   memset(BIFROSTH_tilemap, BIFROSTH_DISABLED, 81);

   // clear multicolor attributes (no glitches since BIFROST* is still disabled)

   for (px = 0; px < 9; ++px)
      for (py = 0; py < 9; ++py)
         BIFROSTH_fillTileAttrH((px+1)<<4, (py<<1)+1, INSIDE_COLOR*9);

   // start
   
	BIFROSTH_resetTileImages(_ctiles);
   BIFROSTH_start();

   while (1)
   {
      // process input keys
        
      if (f = in_inkey())
      {
         if (f == 'o' && frames > 1)
            --frames;

         if (f == 'p' && frames < 9)
            ++frames;

         printf(PRINT_AT_CR "%u", 8+1, 20+1, frames);
         in_wait_nokey();
      }

      // bounce tiles
        
      for (tptr = tiles; tptr != tiles + NUM_TILES; ++tptr)
      {
         // bounce above/below, checks both <0 (close to 255) and >160 cases

         if ((unsigned char)(tptr->lin + tptr->dlin) > 160)
            tptr->dlin = -tptr->dlin;
         
         // bounce on the sides, checks both <0 (close to 255) and >18 cases

         if ((unsigned char)(tptr->col + tptr->dcol) > 18)
            tptr->dcol = -tptr->dcol;
      }

      // delay
      
      for (f = 0; f < frames; ++f)
         intrinsic_halt();
      
      // erase tiles

      for (tptr = tiles; tptr != tiles + NUM_TILES; ++tptr)
         BIFROSTH_fillTileAttrH(tptr->lin, tptr->col, INSIDE_COLOR*9);

      // move and draw tiles

      for (tptr = tiles; tptr != tiles + NUM_TILES; ++tptr)
      {
         tptr->lin += tptr->dlin;
         tptr->col += tptr->dcol;
         BIFROSTH_drawTileH(tptr->lin, tptr->col, tptr->tile);
      }
   }
}
