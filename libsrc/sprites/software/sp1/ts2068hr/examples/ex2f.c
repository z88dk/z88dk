
/////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #2F
// 04.2006 aralbrec
//
// As in ex2e.c with the occluding load sprites but this time
// we see what happens when the SP1_TYPE_BGNDCLR flag is not
// specified.  Last time SP1_TYPE_OCCLUDE was specified in
// combination with SP1_TYPE_BGNDCLR; the occlude flag 
// indicates to the engine not to bother drawing any graphics
// that appear underneath the sprite but the background clear
// flag makes an exception to draw the background tile only.
//
// We remove the SP1_TYPE_BGNDCLR flag so that not even the
// background tile is drawn.  Since the pixel buffer drawn
// into isn't initialized with the background tile graphics,
// a mix of complete graphics from a previous character
// square and the occluding sprite is drawn on screen.  This
// will be used later to do things like reflections but for
// here it only confuses the eye.  See if you can make sense
// of it all.
/////////////////////////////////////////////////////////////

// zcc +ts2068 -vn ex2f.c -o ex2f.bin -create-app -lsp1 -lmalloc

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

// A Hashed UDG for Background

uchar hash[] = {0x55,0xaa,0x55,0xaa,0x55,0xaa,0x55,0xaa};

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
   sp1_TileEntry(' ', hash);   // redefine graphic associated with space character

   sp1_Invalidate(&cr);        // invalidate entire screen so that it is all initially drawn
   sp1_UpdateNow();            // draw screen area managed by sp1 now
   
   // Create Ten Masked Software-Rotated Sprites
   
   for (i=0; i!=10; i++) {

      s = sprtbl[i].s = sp1_CreateSpr(SP1_DRAW_LOAD2LBIM, SP1_TYPE_2BYTE | SP1_TYPE_OCCLUDE, 3, 0, i);
      sp1_AddColSpr(s, SP1_DRAW_LOAD2, SP1_TYPE_OCCLUDE, 48, i);
      sp1_AddColSpr(s, SP1_DRAW_LOAD2RBIM, SP1_TYPE_OCCLUDE, 0, i);
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
