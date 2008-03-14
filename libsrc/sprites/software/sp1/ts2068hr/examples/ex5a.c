
/////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #5a
// 04.2006 aralbrec
//
// There is still much more to cover with sprites but we take
// a short breather to discuss background tiles.  Every
// character in the display is described by a
// "struct sp1_update".  These test programs were compiled
// using the default configuration of the library which
// specifies that sp1 will manage the full 64x24 display.
// This means there are 64*24 = 1536 "struct sp1_update"s,
// one for each character in the display.
//
// These "struct sp1_update"s contain information on what
// graphic occupies the character square ("the tile") and
// the screen address where the tile should be
// drawn.  There is also other information in the struct, as
// you can see if you examine the sp1 header file.  These
// other members are used by the library to correctly draw
// sprites that are passing over the character square and
// should not be modified.
//
// This program begins with the ten masked sprites introduced
// in ex1.c and makes a tentative foray into background tiles
// by printing a tic-tac-toe pattern on the screen using the
// sp1_PrintAt() function.  There is a companion sp1_PrintAtInv()
// function in the library that does the same thing but also
// invalidates the character square to ensure that it gets
// drawn during the next sp1_UpdateNow() call.  Recall that
// the sp1 library only draws character cells that have been
// invalidated; the sp1_PrintAt() call will not invalidate
// any cells.  However a succeeding sp1_Invalidate() invalidates
// the entire screen so that everything gets drawn anyway.
/////////////////////////////////////////////////////////////

// zcc +ts2068 -vn ex5a.c -o ex5a.bin -create-app -lsp1 -lmalloc

#include <sprites/sp1.h>
#include <malloc.h>
#include <ts2068.h>
#include <string.h>

#pragma output STACKPTR=47104                    // place stack at $b800 at startup
long heap;                                       // malloc's heap pointer

// Memory Allocation Policy                      // the sp1 library will call these functions
                                                 //  to allocate and deallocate dynamic memory
void *u_malloc(uint size) {
   return malloc(size);
}

void u_free(void *addr) {
    free(addr);
}

// Clipping Rectangle for Sprites

struct sp1_Rect cr = {0, 0, 64, 24};             // rectangle covering the full screen

// Table Holding Movement Data for Each Sprite

struct sprentry {
   struct sp1_ss  *s;                            // sprite handle returned by sp1_CreateSpr()
   char           dx;                            // signed horizontal speed in pixels
   char           dy;                            // signed vertical speed in pixels
};

struct sprentry sprtbl[] = {                     // doubled the dx speed compared to spectrum
   {0,2,0}, {0,0,1}, {0,2,2}, {0,4,1}, {0,2,3},  // because we're traversing double the horizontal res
   {0,6,1}, {0,4,3}, {0,6,2}, {0,2,1}, {0,4,2}
};

// UDG Definitions for Background Characters

uchar hash   [] = {0x55,0xaa,0x55,0xaa,0x55,0xaa,0x55,0xaa};    // background hash
uchar horline[] = {0,0,0xff,0,0,0xff,0,0};                      // horizontal line
uchar verline[] = {0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24};    // vertical line
uchar intline[] = {0x24,0x24,0xe7,0,0,0xe7,0x24,0x24};          // intersection of horizontal and vertical lines

// Attach C Variable to Sprite Graphics Declared in ASM at End of File

extern uchar gr_window[];      // gr_window will hold the address of the asm label _gr_window

main()
{
   uchar i;
   struct sp1_ss *s;
   struct sprentry *se;
   void *temp;
   
   #asm
   di
   #endasm

   // Initialize MALLOC.LIB
   
   heap = 0L;                  // heap is empty
   sbrk(40000, 5000);          // add 40000-44999 to malloc

   // Set 512x192 Video Mode
   
   memset(16384, 0, 6144);     // clear both halves of the display file before switching video mode
   memset(24576, 0, 6144);
   ts_vmod(PAPER_BLACK | VMOD_HIRES);   // select 64-col mode with black background
   
   // Initialize SP1.LIB
   
   sp1_Initialize(SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE, ' ');

   sp1_TileEntry(' ', hash);     // redefine graphic associated with space character
   sp1_TileEntry('H', horline);  // 'H' will be the horizontal line graphic
   sp1_TileEntry('V', verline);  // 'V' will be the vertical line graphic
   sp1_TileEntry('C', intline);  // 'C' will be the intersection graphic

   // Print a Tic-Tac-Toe Pattern
   
   for (i=0; i!=64; ++i)       // draw the two horizontal lines in tic-tac-toe pattern
   {
      sp1_PrintAt( 7, i, 'H');
      sp1_PrintAt(16, i, 'H');
   }
   
   for (i=0; i!=24; ++i)       // draw the two vertical lines in tic-tac-toe pattern
   {
      sp1_PrintAt(i, 20, 'V');
      sp1_PrintAt(i, 42, 'V');
   }
   
   sp1_PrintAt( 7, 20, 'C');   // where the lines intersect
   sp1_PrintAt( 7, 42, 'C');   // print the intersection graphic
   sp1_PrintAt(16, 20, 'C');
   sp1_PrintAt(16, 42, 'C');

   sp1_Invalidate(&cr);        // invalidate entire screen so that it is all initially drawn
   sp1_UpdateNow();            // draw screen area managed by sp1 now

   // Create Ten Masked Software-Rotated Sprites
   
   for (i=0; i!=10; i++)
   {
      s = sprtbl[i].s = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 3, 0, i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2, 0, 48, i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2RB, 0, 0, i);
      sp1_MoveSprAbs(s, &cr, gr_window, 10, 14, 0, 4);

   };
   
   while (1) {                                  // main loop
   
      sp1_UpdateNow();                          // draw screen now
      
      for (i=0; i!=10; i++) {                    // move all sprites
 
         se = &sprtbl[i];
         
         sp1_MoveSprRel(se->s, &cr, 0, 0, 0, se->dy, se->dx);
         
         if (se->s->row > 21)                    // if sprite went off screen, reverse direction
            se->dy = - se->dy;
            
         if (se->s->col > 61)                    // notice if coord moves less than 0, it becomes
            se->dx = - se->dx;                   //   255 which is also caught by these cases

      }
      
   }  // end main loop

}

#asm

   defb @11111111, @00000000
   defb @11111111, @00000000
   defb @11111111, @00000000
   defb @11111111, @00000000
   defb @11111111, @00000000
   defb @11111111, @00000000
   defb @11111111, @00000000

; ASM source file created by SevenuP v1.20
; SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

;GRAPHIC DATA:
;Pixel Size:      ( 16,  24)
;Char Size:       (  2,   3)
;Sort Priorities: Mask, Char line, Y char, X char
;Data Outputted:  Gfx
;Interleave:      Sprite
;Mask:            Yes, before graphic

._gr_window

	DEFB	128,127,  0,192,  0,191, 30,161
	DEFB	 30,161, 30,161, 30,161,  0,191
	DEFB	  0,191, 30,161, 30,161, 30,161
	DEFB	 30,161,  0,191,  0,192,128,127
	DEFB	255,  0,255,  0,255,  0,255,  0
	DEFB	255,  0,255,  0,255,  0,255,  0
	
	DEFB	  1,254,  0,  3,  0,253,120,133
	DEFB	120,133,120,133,120,133,  0,253
	DEFB	  0,253,120,133,120,133,120,133
	DEFB	120,133,  0,253,  0,  3,  1,254
	DEFB	255,  0,255,  0,255,  0,255,  0
	DEFB	255,  0,255,  0,255,  0,255,  0
	
#endasm
