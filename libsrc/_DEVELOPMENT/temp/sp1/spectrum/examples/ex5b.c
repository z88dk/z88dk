
/////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #5b
// 04.2006 aralbrec
//
// Background tiles lie in the background, meaning all sprites
// travel over top of them.  What if you want the sprites to
// travel behind them?  This program shows one way to do this
// by making the tic-tac-toe lines appear to be printed in the
// foreground.
//
// The method used here is to tell the sp1 engine not to draw
// the character squares occupied by the tic-tac-toe lines.
// When sprites pass over the affected character squares, they
// will not be drawn so it will appear that the sprite passes
// underneath the background graphic.  We tell the engine not
// to draw specific character squares by validating them.
// Recall the process of telling sp1 what character squares
// to draw is called invalidation; similarly we tell sp1 not
// to draw specific characters by validating them.
//
// Individual character squares can be invalidated and
// validated with calls to sp1_InvUpdateStruct() and
// sp1_ValUpdateStruct() but here we invalidate and validate
// entire rectangular areas using sp1_Invalidate() and
// sp1_Validate().
//
// The placement of the sp1_Validate() call in the main loop
// is important.  The sp1_MoveSprRel() calls to move the
// sprites will invalidate the character squares the sprites
// occupy so that the screen gets redrawn in those areas. We
// must validate the tic-tac-toe lines after this (in fact,
// it is done just before the sp1_UpdateNow() call) so that
// the last indication to sp1 is to not draw the affected
// squares.
//
// You cannot quite invalidate and validate character squares
// whenever you feel like it as the above paragraph may imply.
// This is because of a speed optimization the sp1 engine
// employs.  When a character is invalidated (ie marked for
// redraw) it is added to an internal list of chars that will
// be redrawn when sp1_UpdateNow() is called.  However when
// a character is validated, it is not removed from the list
// if it is already there; it is only marked as "validated".
// This means invalidating a character, followed by validating
// it, and then invalidating it again will cause problems.
// So unless you are careful with what you are doing, the rule
// is: do all your drawing and invalidation whenever you like
// but only validate just before an sp1_UpdateNow() call.
/////////////////////////////////////////////////////////////

// zcc +zx -vn ex5b.c -o ex5b.bin -create-app -lsp1 -lmalloc

#include <sprites/sp1.h>
#include <malloc.h>
#include <spectrum.h>

#pragma output STACKPTR=53248                    // place stack at $d000 at startup
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

struct sp1_Rect cr = {0, 0, 32, 24};             // rectangle covering the full screen
struct sp1_Rect sr1;                             // spare rectangle to use as needed
struct sp1_Rect sr2;                             // spare rectangle to use as needed
struct sp1_Rect sr3;                             // spare rectangle to use as needed
struct sp1_Rect sr4;                             // spare rectangle to use as needed

// Table Holding Movement Data for Each Sprite

struct sprentry {
   struct sp1_ss  *s;                            // sprite handle returned by sp1_CreateSpr()
   char           dx;                            // signed horizontal speed in pixels
   char           dy;                            // signed vertical speed in pixels
};

struct sprentry sprtbl[] = {
   {0,1,0}, {0,0,1}, {0,1,2}, {0,2,1}, {0,1,3},
   {0,3,1}, {0,2,3}, {0,3,2}, {0,1,1}, {0,2,2}
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
   sbrk(40000, 10000);         // add 40000-49999 to malloc

   // Initialize SP1.LIB
   
   zx_border(INK_BLACK);
   sp1_Initialize(SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE, INK_BLACK | PAPER_WHITE, ' ');

   sp1_TileEntry(' ', hash);     // redefine graphic associated with space character
   sp1_TileEntry('H', horline);  // 'H' will be the horizontal line graphic
   sp1_TileEntry('V', verline);  // 'V' will be the vertical line graphic
   sp1_TileEntry('C', intline);  // 'C' will be the intersection graphic

   // Print a Tic-Tac-Toe Pattern
   
   for (i=0; i!=32; ++i)       // draw the two horizontal lines in tic-tac-toe pattern
   {
      sp1_PrintAt( 7, i, INK_RED | PAPER_GREEN, 'H');
      sp1_PrintAt(16, i, INK_RED | PAPER_GREEN, 'H');
   }
   
   for (i=0; i!=24; ++i)       // draw the two vertical lines in tic-tac-toe pattern
   {
      sp1_PrintAt(i, 10, INK_RED | PAPER_GREEN, 'V');
      sp1_PrintAt(i, 21, INK_RED | PAPER_GREEN, 'V');
   }
   
   sp1_PrintAt( 7, 10, INK_RED | PAPER_GREEN, 'C');    // where the lines intersect
   sp1_PrintAt( 7, 21, INK_RED | PAPER_GREEN, 'C');    // print the intersection graphic
   sp1_PrintAt(16, 10, INK_RED | PAPER_GREEN, 'C');
   sp1_PrintAt(16, 21, INK_RED | PAPER_GREEN, 'C');

   // Create Four Rectangles that Cover the Four Tic-Tac-Toe Lines
   
   sr1.row =  7; sr1.col =  0; sr1.width = 32; sr1.height =  1;    // top horizontal line
   sr2.row = 16; sr2.col =  0; sr2.width = 32; sr2.height =  1;    // bottom horizontal line
   sr3.row =  0; sr3.col = 10, sr3.width =  1; sr3.height = 24;    // leftmost vertical line
   sr4.row =  0; sr4.col = 21, sr4.width =  1; sr4.height = 24;    // rightmost vertical line

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
   
   while (1) {                                   // main loop
   
      sp1_Validate(&sr1);                        // validate areas so that they are not drawn
      sp1_Validate(&sr2);
      sp1_Validate(&sr3);
      sp1_Validate(&sr4);

      sp1_UpdateNow();                           // draw screen now
      
      for (i=0; i!=10; i++) {                    // move all sprites
 
         se = &sprtbl[i];
         
         sp1_MoveSprRel(se->s, &cr, 0, 0, 0, se->dy, se->dx);
         
         if (se->s->row > 21)                    // if sprite went off screen, reverse direction
            se->dy = - se->dy;
            
         if (se->s->col > 29)                    // notice if coord moves less than 0, it becomes
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
