/****************************************

 sp1 Sprite Demo 1

 A simple demo program to show how z88dk and sp1 can be used to make a game.

 q = increase number of sprites
 a = decrease number of sprites
 o = exit to basic
 p = change background
 space = toggle border timer

 (C) 2012 Timmy

http://www.worldofspectrum.org/forums/discussion/37467/a-z88dk-sp1-demo-with-source
http://www.worldofspectrum.org/forums/discussion/comment/864043/#Comment_864043

****************************************/

// zcc +zx -vn -O3 -startup=31 -clib=new demo.c graphics.asm -o demo -create-app
// zcc +zx -vn -SO3 -startup=31 -clib=sdcc_iy --max-allocs-per-node200000 demo.c graphics.asm -o demo -create-app

#include <arch/zx.h>
#include <arch/zx/sp1.h>
#include <input.h>
#include <z80.h>               // for z80_bpoke(), z80_wpoke(), im2 functions
#include <string.h>            // for memset()
#include <stdlib.h>            // for rand()
#include <intrinsic.h>         // for intrinsic_di()
#include <sound.h>             // for bit_beepfx()

#pragma output REGISTER_SP           = 0xd000    // place stack at $d000 at startup
#pragma output CLIB_MALLOC_HEAP_SIZE = 3000      // create a 3000-byte heap in BSS section

#pragma output CRT_ORG_CODE          = 32768     // org 32768
#pragma output CLIB_EXIT_STACK_SIZE  = 0         // no atexit() functions
#pragma output CLIB_STDIO_HEAP_SIZE  = 0         // no memory for files
#pragma output CLIB_FOPEN_MAX        = -1        // do not create open files list


// Clipping Rectangle for Sprites
// format is y,x,w,h!

struct sp1_Rect cliprect    = {2, 2, 28, 20};             // full screen minus border
struct sp1_Rect levelbrect  = {0, 0, 32, 24};             // full screen


// The maximum number of sprites is 10.

unsigned char maxsprites = 10;


// Table Holding Movement Data for Each Sprite

struct sprentry {
   struct sp1_ss  *s;          // sprite handle returned by sp1_CreateSpr()
   unsigned char   x;          // sprite x coordinate
   unsigned char   y;          // sprite x coordinate
   unsigned char  dx;          // signed horizontal speed in pixels
   unsigned char  dy;          // signed vertical speed in pixels
};


// Define Starting Positions of the Sprites

struct sprentry sprtbl[] = {
   {0,128,88,1,1}, {0,128,120,2,0}, {0,128,56,2,0}, {0,96,88,2,0}, {0,96,120,2,0},
   {0,96,56,1,1}, {0,160,88,2,0}, {0,160,120,2,0}, {0,160,56,2,0}, {0,0,0,2,0}
};


// Attach C Variable to data declared in external asm file "graphics.asm"

extern unsigned char sprite1[];
extern unsigned char backwalls[];


// Memory to define the background.

unsigned char levelb[32*24*3];


// Refresh the whole screen

void drawmap(void)
{
	sp1_PutTiles(&levelbrect, (struct sp1_tp *)(levelb));
	sp1_Invalidate(&levelbrect);
}

// Fill the background with some arbitrary patterns, and draw it.

void loadlevel(void)
{
   unsigned int p;
   unsigned int i;

   p = 0;
   i = 0;

   while (i<32*24)
   {
      levelb[p+1] = 108+(rand()&3);
      levelb[p]   = 68+(rand()&3);

      if ((i<64) || (i>703) || ((i&31)>29) || ((i&31)<2))
      {
         levelb[p+1] =107;
         levelb[p]   =86;
      }
      
      i++;
      p += 3;
   }

   p=p-15+1;
   
   levelb[p]=84;
   levelb[p+3]=73;
   levelb[p+6]=77;
   levelb[p+9]=77;
   levelb[p+12]=89;

   drawmap();
}


// Variables for Joysticks

unsigned char  joys;
udk_t          joykeys;        // holds keys selected for keyboard joystick

#ifdef __SDCC
uint16_t (*joyfunc)(udk_t *);  // pointer to joystick function
#endif

#ifdef __SCCZ80
void *joyfunc;                 // pointer to joystick function
#endif


// Function to Set Up Keyboard as a Joystick

void setupkeyboard(void) 
{
   joyfunc = in_stick_keyboard;

   joykeys.fire  = IN_KEY_SCANCODE_SPACE;
   joykeys.left  = IN_KEY_SCANCODE_o;
   joykeys.right = IN_KEY_SCANCODE_p;
   joykeys.up    = IN_KEY_SCANCODE_q;
   joykeys.down  = IN_KEY_SCANCODE_a;
}


// Main: Program Starts HERE

main()
{
   unsigned char i;
   struct sp1_ss *s;
   unsigned char c;
   unsigned char d;

   // Make the border black.

   zx_border(INK_BLACK);
   
   
   // The next part is very important. The game will not compile if it is removed.
   // Initialise the SP1 library
   
   sp1_Initialize( SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE,
                   BRIGHT | INK_WHITE | PAPER_BLACK, ' ');


   // Initialise Background Tiles

   for (i=0; i<5; i++)
   {
      sp1_TileEntry(107+i, backwalls+i*8);
   }


   // Call SP1 functions to let it know we are using 10 sprites.
    
   for (i=0; i<maxsprites; i++)
   {
      s = sprtbl[i].s = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 3, 0, i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2, 0, 48, i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2RB, 0, 0, i);
   };


   // Create some random directions for our sprites.

   for (i=0; i<10; i++)
   {
      sprtbl[i].dx = (i-5); sprtbl[i].dy = (i-5);
      if (i==5) { sprtbl[i].dx = 1; sprtbl[i].dy = 1; }
   }


   // Draw some random background

   loadlevel();


   // Set up Joystick/Keyboard

   joys = 0;
   setupkeyboard();


   // Setting up some variables

   maxsprites = 3;
   c=0; d=1;


   // MAIN LOOP

   while (d)
   {

      // Read Joystick/Keyboard and process the buttons pressed.

      joys = (joyfunc) (&joykeys);
      
      if ((IN_STICK_UP & joys) && (maxsprites<10))   { bit_beepfx_di(BEEPFX_PICK); maxsprites++; }
      if ((IN_STICK_DOWN & joys) && (maxsprites>1))  { bit_beepfx_di(BEEPFX_PICK); maxsprites--; }
      if ((IN_STICK_RIGHT & joys) && (maxsprites>1)) { bit_beepfx_di(BEEPFX_PICK); loadlevel(); }
      if ((IN_STICK_LEFT & joys) && (maxsprites>1))  { bit_beepfx_di(BEEPFX_PICK); d=0; }
      if (IN_STICK_FIRE & joys)                      { bit_beepfx_di(BEEPFX_PICK); c=!c; zx_border(INK_BLACK); }


      // Let SP1 know where the sprites are located.

      for (i=0; i<maxsprites; i++)
      {
         sp1_MoveSprPix(sprtbl[i].s, &cliprect, sprite1, sprtbl[i].x, sprtbl[i].y);
      }


      // Border Effect Part 1

      if (c)
      {
         zx_border(INK_BLACK);
      }


      // Update Sprites

      sp1_UpdateNow();


      // Border Effect Part 2

      if (c)
      {
         intrinsic_halt();     // halt without impeding optimizer
         zx_border(INK_BLUE);
      }


      // Calculate next location of sprites.
      // If sprite is outside the screen then change direction.

      for (i=0; i<maxsprites; i++)
      {
         sprtbl[i].x += sprtbl[i].dx;
         sprtbl[i].y += sprtbl[i].dy;
         
         if (sprtbl[i].x>240) sprtbl[i].dx=-sprtbl[i].dx;
         if (sprtbl[i].y>176) sprtbl[i].dy=-sprtbl[i].dy;
      }


   }


   // Return to BASIC (crt will set interrupt mode 1 for us)
   // BORDER 7
   
   zx_border(INK_WHITE);
   z80_bpoke(23624, 56);       // system variable bordclr

   return 0;
}
