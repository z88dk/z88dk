
/////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #4A
// 04.2006 aralbrec
//
// We begin with the ten masked sprites once again and for
// the first time add some colour.  By default sprites are
// created transparent in colour, meaning they do not
// alter the background colour.  We make the first five
// sprites (which appear closer to the viewer) RED ink with
// INK-only attribute mask meaning they will not affect the
// background PAPER/FLASH/BRIGHT.  The attribute mask byte
// has 1s where the background attribute should be preserved
// before the sprite colour is ORed in to determine the
// final colour of the square.
//
// The last five sprites we make BLUE ink and GREEN paper.
// When a RED sprite overlaps a BLUE one you will see the
// colour becomes RED on GREEN.  This is because the BLUE one
// appears underneath the RED one, setting the paper to GREEN.
// The RED one is then drawn on top but it is INK-only so
// only alters the INK colour to RED.  The result is RED
// on GREEN.
//
// As sprites are created in sp1_CreateSpr() and sp1_AddColSpr()
// calls, sp1 internally creates a "struct sp1_cs" for each
// character square of the sprite, the details of which you
// can examine in the sp1 header file.  Among the properties
// of each sprite character stored here is the sprite char's
// attribute (ie colour) and attribute mask (ie colour mask).
// By using the function "sp1_IterateSprChar()" we can
// visit all nine "struct sp1_cs" of each 3x3 sprite, calling
// a supplied function once for each of these nine structs.
// We supply a function that change's the struct's stored
// colour.
/////////////////////////////////////////////////////////////

// zcc +zx -vn ex4a.c -o ex4a.bin -create-app -lsp1 -lmalloc

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

// A Hashed UDG for Background

uchar hash[] = {0x55,0xaa,0x55,0xaa,0x55,0xaa,0x55,0xaa};

// Attach C Variable to Sprite Graphics Declared in ASM at End of File

extern uchar gr_window[];      // gr_window will hold the address of the asm label _gr_window

// Used to colour the sprites

uchar attr;
uchar amask;

void colourSpr(struct sp1_cs *c)
{
   c->attr_mask = amask;       // set the sprite character's attribute mask
   c->attr = attr;             // set the sprite character's attribute
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
   sp1_TileEntry(' ', hash);   // redefine graphic associated with space character

   sp1_Invalidate(&cr);        // invalidate entire screen so that it is all initially drawn
   sp1_UpdateNow();            // draw screen area managed by sp1 now
   
   // Create Ten Masked Software-Rotated Sprites
   
   for (i=0; i!=10; i++) {

      s = sprtbl[i].s = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 3, 0, i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2, 0, 48, i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2RB, 0, 0, i);
      sp1_MoveSprAbs(s, &cr, gr_window, 10, 14, 0, 4);
      
      if (i < 5)                           // for the first five sprites
      {      
         attr  = INK_RED;                  // store colour in global variable
         amask = 0xf8;                     // store INK-only mask (set bits indicate what parts of background attr are kept)
      }
      else                                 // for the last five sprites
      {
         attr  = INK_BLUE | PAPER_GREEN;
         amask = 0xc0;                     // mask will keep background flash and bright  
      }
      
      sp1_IterateSprChar(s, colourSpr);    // colour the sprite

   };
   
   while (1) {                                  // main loop
   
      sp1_UpdateNow();                          // draw screen now
      
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
