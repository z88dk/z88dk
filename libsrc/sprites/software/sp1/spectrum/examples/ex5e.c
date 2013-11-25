
/////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #5e
// 04.2006 aralbrec
//
// This will likely be a challenging example to understand
// so be prepared for a little head-scratching.  Keep in
// mind that sp1's coordinate system is always rectangular
// even if you may be questioning this while trying to figure
// out this example program :).
//
// Whether background tiles are being printed (sp1_PrintAt,
// etc) or sprites are being moved (sp1_MoveSprRel, etc)
// the coordinates used are actually referring to the
// array of "struct sp1_update"s that sp1 manages and not
// to screen coordinates.  So, eg, coordinate (4,5) doesn't
// actually refer to the screen location row=4, column=5 but
// to the particular "struct sp1_update" in row 4, column 5
// of sp1's update array.
//
// If you recall, the screen address where each "struct
// sp1_update" is drawn is actually stored inside the
// "struct sp1_update" itself in the "screen" member.
// During initialization (the call to sp1_Initialize)
// the "screen" members of each "struct sp1_update"
// were initialized such that there was a perfect
// correspondence between screen coordinates and
// sp1 coordinates.  So, eg, the "struct sp1_update"
// at sp1 coordinate (4,5) had its "screen" member
// initialized with the screen address of the character
// in the 4th row and 5th column on the screen.
//
// What this has meant is there has been no difference
// between screen coordinates and sp1 coordinates.
//
// In this example program we break that correspondence by
// telling sp1 to draw certain "struct sp1_update"s at a
// different screen location.
//
// While the program runs, the keyboard is read to allow
// the user to select two tic-tac-toe rectangles.  These
// rectangles are highlighted in cyan paper.  Once the
// two rectangles are selected, the "struct sp1_update"s
// making them up have their screen addresses swapped,
// meaning the two tic-tac-toe rectangles are drawn in
// each other's position on screen.  Despite the fact
// that the two rectangles are drawn in different
// places on screen, sp1's coordinate system has not changed!
// Remember sp1's coordinates refer to an array of
// "struct sp1_update"s and we have not reordered that array;
// what we have done is change the location where some
// of those "struct sp1_update"s are drawn on screen. 
// The evidence of this is that the sprites continue to
// move in their linear manner but are drawn in new screen
// locations as they pass through the exchanged tic-tac-toe
// squares.
//
// What do you think would happen if multiple "struct sp1_
// update"s held the same screen address?
//
// In this example a few new library functions have been
// introduced.  in_Inkey() and in_WaitForNoKey() are used
// to read the keyboard; they are part of the input library
// and are documented on the z88dk wiki.  The only new sp1
// function used is sp1_ClearRectInv() which clears a rectangular
// area on screen.  A flag is passed as parameter to indicate
// whether the background tile, background colour, sprites or
// a combination of these should be cleared from the character
// squares in the rectangle.  sp1_ClearRect() is also in the
// library and functions similarly but does not invalidate
// the rectangular area.
/////////////////////////////////////////////////////////////

// zcc +zx -vn ex5e.c -o ex5e.bin -create-app -lsp1 -lmalloc

#include <sprites/sp1.h>
#include <input.h>
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

// Rectangles Covering Each Tic-Tac-Toe Square

struct sp1_Rect sq[] = {                         // row,col,width,height
   {0,0,10,7},                                   // square 0
   {0,11,10,7},                                  // square 1
   {0,22,10,7},                                  // square 2
   {8,0,10,7},                                   // square 3
   {8,11,10,7},                                  // square 4
   {8,22,10,7},                                  // square 5
   {17,0,10,7},                                  // square 6
   {17,11,10,7},                                 // square 7
   {17,22,10,7}                                  // square 8
};

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

// Swap the Location on Screen where Two Tic-Tac-Toe Rectangles Are Drawn

struct sp1_Rect *dr;                               // the second rectangle
uchar srow, scol;                                  // track row,col position in second rectangle as first rectangle is iterated

void swap_helper(struct sp1_update *u)
{
   void *temp;
   struct sp1_update *t;
   
   // current position in second rectangle tracked by srow, scol
   // second rectangle is iterated by increasing scol by one after each visit
   
   if (scol >= (dr->col + dr->width))              // if run off the right edge of second rectangle
   {
      scol = dr->col;                              // move back to left edge
      ++srow;                                      // in the next row
   }
   
   if (srow < (dr->row + dr->height))              // as long as the row hasn't fallen off the bottom of second rectangle
   {
      temp = u->screen;                                             // store the screen address for character cell in first rectangle
      u->screen = (t = sp1_GetUpdateStruct(srow, scol))->screen;    // write screen address of second rectangle's cell (found from char coord srow, scol)
      t->screen = temp;                                             // write screen address of first rectangle char cell into second rectangle
   }
   
   ++scol;                                         // will be visiting next char cell in second rectangle on next call
}

void swap_dfile(struct sp1_Rect *a, struct sp1_Rect *b)
{
   dr = b; srow = b->row; scol = b->col;           // second rectangle will be manually iterated over (above for explanation of vars)
   sp1_IterateUpdateRect(a, swap_helper);          // iterate over the first rectangle's character squares
}

main()
{
   struct sp1_ss *s;
   struct sprentry *se;
   void *temp;
   uchar i, sel1, sel2;

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

   // Number Each Square in the Tic-Tac-Toe Board
   
   sp1_PrintAt( 3,  5, INK_BLACK | PAPER_WHITE, '0');
   sp1_PrintAt( 3, 16, INK_BLACK | PAPER_WHITE, '1');
   sp1_PrintAt( 3, 27, INK_BLACK | PAPER_WHITE, '2');
   sp1_PrintAt(11,  5, INK_BLACK | PAPER_WHITE, '3');
   sp1_PrintAt(11, 16, INK_BLACK | PAPER_WHITE, '4');
   sp1_PrintAt(11, 27, INK_BLACK | PAPER_WHITE, '5');
   sp1_PrintAt(20,  5, INK_BLACK | PAPER_WHITE, '6');
   sp1_PrintAt(20, 16, INK_BLACK | PAPER_WHITE, '7');
   sp1_PrintAt(20, 27, INK_BLACK | PAPER_WHITE, '8');

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
   
   sel1 = sel2 = 9;                              // no rectangles selected
   
   while (1)
   {
      sp1_UpdateNow();                           // draw screen now
      
      // Move the Sprites
      
      for (i=0; i!=10; i++)
      {
         se = &sprtbl[i];
         sp1_MoveSprRel(se->s, &cr, 0, 0, 0, se->dy, se->dx);
         
         if (se->s->row > 21)                    // if sprite went off screen, reverse direction
            se->dy = - se->dy;
            
         if (se->s->col > 29)                    // notice if coord moves less than 0, it becomes
            se->dx = - se->dx;                   //   255 which is also caught by these cases
      }
      
      // Manage Selection of Tic-Tac-Toe Rectangles

      if ((i = in_Inkey()) && (i >= '0') && (i <= '8'))
      {
         i -= '0';                               // convert key '0'..'8' to number 0..8
         in_WaitForNoKey();                      // wait for key to be released
         
         if (sel1 > 8)                           // if no rectangles are selected
         {
            sel1 = i;                            // select this one as first rectangle
            sp1_ClearRectInv(&sq[sel1], INK_BLACK | PAPER_CYAN, 0, SP1_RFLAG_COLOUR);
         }
         else if (sel2 > 8)                      // if second rectangle not selected
         {
            sel2 = i;                            // select this one as second rectangle
            sp1_ClearRectInv(&sq[sel2], INK_BLACK | PAPER_CYAN, 0, SP1_RFLAG_COLOUR);
            sp1_Invalidate(&sq[sel1]);           // make sure the first rectangle is redrawn too
            swap_dfile(&sq[sel1], &sq[sel2]);    // swap the location where the two rectangles are drawn on screen
         }
         else                                    // both rectangles have already been selected
         {
            sp1_ClearRectInv(&sq[sel1], INK_BLACK | PAPER_WHITE, 0, SP1_RFLAG_COLOUR);
            sp1_ClearRectInv(&sq[sel2], INK_BLACK | PAPER_WHITE, 0, SP1_RFLAG_COLOUR);
            swap_dfile(&sq[sel1], &sq[sel2]);    // restore location where the two rectangles are drawn on screen
            
            sel1 = i; sel2 = 9;                  // select this rectangle as first one and unselect the second one
            sp1_ClearRectInv(&sq[sel1], INK_BLACK | PAPER_CYAN, 0, SP1_RFLAG_COLOUR);
         }
      }
      
   }  // end while loop
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
