
/////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #5d
// 04.2006 aralbrec
//
// Beginning from ex5c we take a moment to reinforce the idea
// that a character cell's "struct sp1_update" contains all
// the information about what the background graphic and
// background colour will be.
//
// Whereas the tic-tac-toe lines were previously printed
// with calls to sp1_PrintAt(), just as might be done in
// a basic program when printing to the screen, this time
// we make use of sp1_IterateUpdateRect() and the rectangles
// constructed to cover the tic-tac-toe lines to visit the
// individual "struct sp1_update"s making up the lines and
// poke the background graphic and background colour directly.
/////////////////////////////////////////////////////////////

// zcc +zx -vn ex5d.c -o ex5d.bin -create-app -lsp1 -lmalloc

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

// Helper Function to Place Tile in a Specific Character Cell

uint tile;
void Print(struct sp1_update *u)
{
   u->tile = tile;
   u->colour = INK_BLUE | PAPER_YELLOW;
}

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

   // Create Four Rectangles that Cover the Four Tic-Tac-Toe Lines
   
   sr1.row =  7; sr1.col =  0; sr1.width = 32; sr1.height =  1;    // top horizontal line
   sr2.row = 16; sr2.col =  0; sr2.width = 32; sr2.height =  1;    // bottom horizontal line
   sr3.row =  0; sr3.col = 10, sr3.width =  1; sr3.height = 24;    // leftmost vertical line
   sr4.row =  0; sr4.col = 21, sr4.width =  1; sr4.height = 24;    // rightmost vertical line

   // Print a Tic-Tac-Toe Pattern by Visiting the Character Cells Making up the Lines
   
   tile = 'H';
   sp1_IterateUpdateRect(&sr1, Print);                 // draw top horizontal line
   sp1_IterateUpdateRect(&sr2, Print);                 // draw bottom horizontal line
   
   tile = 'V';
   sp1_IterateUpdateRect(&sr3, Print);                 // draw top horizontal line
   sp1_IterateUpdateRect(&sr4, Print);                 // draw top horizontal line
   
   sp1_PrintAt( 7, 10, INK_RED | PAPER_GREEN, 'C');    // where the lines intersect
   sp1_PrintAt( 7, 21, INK_RED | PAPER_GREEN, 'C');    // print the intersection graphic
   sp1_PrintAt(16, 10, INK_RED | PAPER_GREEN, 'C');
   sp1_PrintAt(16, 21, INK_RED | PAPER_GREEN, 'C');

   sp1_Invalidate(&cr);        // invalidate entire screen so that it is all initially drawn
   sp1_UpdateNow();            // draw screen area managed by sp1 now

   // Now Remove the Tic-Tac-Toe Lines from the sp1 Engine
   
   sp1_IterateUpdateRect(&sr1, sp1_RemoveUpdateStruct);
   sp1_IterateUpdateRect(&sr2, sp1_RemoveUpdateStruct);
   sp1_IterateUpdateRect(&sr3, sp1_RemoveUpdateStruct);
   sp1_IterateUpdateRect(&sr4, sp1_RemoveUpdateStruct);

   // Create Ten Masked Software-Rotated Sprites
   
   for (i=0; i!=10; i++)
   {
      s = sprtbl[i].s = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 3, 0, i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2, 0, 48, i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2RB, 0, 0, i);
      sp1_MoveSprAbs(s, &cr, gr_window, 10, 14, 0, 4);

   };
   
   while (1) {                                   // main loop
   
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
