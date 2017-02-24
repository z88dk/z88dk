// By szeliga @ worldofspectrum.org forums
// while running press any key to reset screen

// zcc +zx -vn -clib=new -startup=31 @sp1demo.lst -o demo -create-app
// zcc +zx -vn -SO3 -clib=sdcc_iy -startup=31 --max-allocs-per-node200000 @sp1demo.lst -o demo -create-app
 
#include <input.h>
#include <sound.h>
#include <stdlib.h>
#include <arch/zx.h>
#include <arch/zx/sp1.h>
#include <intrinsic.h>

#pragma output REGISTER_SP           = 0xd000    // place stack at $d000 at startup
#pragma output CRT_ENABLE_RESTART    = 1         // not returning to basic
#pragma output CRT_ENABLE_CLOSE      = 0         // do not close files on exit
#pragma output CLIB_EXIT_STACK_SIZE  = 0         // no exit stack
#pragma output CLIB_MALLOC_HEAP_SIZE = 5000      // malloc heap size (not sure what is needed exactly)
#pragma output CLIB_STDIO_HEAP_SIZE  = 0         // no memory needed to create file descriptors
#pragma output CLIB_FOPEN_MAX        = -1        // no allocated FILE structures, -1 for no file lists too
#pragma output CLIB_OPEN_MAX         = 0         // no fd table
 
 
#define MAX_SPRITES  10
#define DEAD_SPRITE  100

extern int sp1_TestCollision(struct sp1_ss *s1, struct sp1_ss *s2, unsigned int tolerance) __z88dk_callee;
 
// Clipping Rectangle for Sprites
 
struct sp1_Rect cr = {0, 0, 32, 24};            // rectangle covering the full screen
 
// Table Holding Movement Data for Each Sprite
 
struct sprentry
{
   struct sp1_ss  	*s;                     // sprite handle returned by sp1_CreateSpr()
   char           	dx;                     // signed horizontal speed in pixels
   char           	dy;                     // signed vertical speed in pixels
   unsigned char        state;                  // frame state (MSS)
};
 
struct sprentry sprtbl[] = {
   {0,1,0,0}, {0,0,1,0}, {0,1,2,0}, {0,2,1,0}, {0,1,3,0},
   {0,3,1,0}, {0,2,3,0}, {0,3,2,0}, {0,1,1,0}, {0,2,2,0}
};
 
// A Hashed UDG for Background
 
unsigned char hash[] = {127,255,255,255,223,255,251,255};
 
// Attach C Variable to Sprite Graphics Declared in external ASM File
 
extern unsigned char sprite01[];      // gr_window will hold the address of the asm label _gr_window
extern unsigned char sprite02[];      // gr_window will hold the address of the asm label _gr_window
extern unsigned char sprite03[];      // gr_window will hold the address of the asm label _gr_window
extern unsigned char sprite04[];      // gr_window will hold the address of the asm label _gr_window
 
// Callback Function to Colour Sprites Using sp1_IterateSprChar()
 
unsigned char colour;
unsigned char cmask;
 
void colourSpr(unsigned int count, struct sp1_cs *c)
{
   c->attr_mask = cmask;
   c->attr = colour;
}
 
main()
{
   static unsigned char i, j, deleteSpriteFlag, numLiveSprites;
   static struct sp1_ss *s;
   static struct sprentry *se;
 
   // Initialize SP1.LIB
 
   zx_border(INK_BLACK);
 
   sp1_Initialize(SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE, INK_BLACK | PAPER_WHITE, ' ');
   sp1_TileEntry(' ', hash);   // redefine graphic associated with space character
 
   sp1_Invalidate(&cr);        // invalidate entire screen so that it is all initially drawn
   sp1_UpdateNow();            // draw screen area managed by sp1 now
 
   // Create and Colour Sprites
 
   for (i=0; i!=MAX_SPRITES; ++i)
   {
      s = sprtbl[i].s = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE,  3,  0,  i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2, 0, 48, i);
      sp1_AddColSpr(s, SP1_DRAW_MASK2RB, 0, 0, i);
 
      colour = (i & 0x01) ? (INK_BLACK | PAPER_CYAN) : (INK_BLACK | PAPER_YELLOW);
      cmask = SP1_AMASK_INK & SP1_AMASK_PAPER;
 
      sp1_IterateSprChar(s, colourSpr);
   }
 
   // Main Loop
 
   while (1)
   {
      // Move Sprites to Initial Location
 
      for (i=0; i!=MAX_SPRITES; ++i)
      {
         sp1_MoveSprAbs(sprtbl[i].s, &cr, sprite01, (rand() & 0x0f) + 4, (rand() & 0x0f) + 8, 0, 4);
         sprtbl[i].state = 0;
      }
 
      do
      {
         sp1_UpdateNow();
 
         numLiveSprites = 0;
 
         for (i=0; i!=MAX_SPRITES; ++i)
         {
            // move all sprites
 
            se = &sprtbl[i];
 
            if ((j = se->state) != DEAD_SPRITE)
            {
               s = se->s;
 
               sp1_MoveSprRel(s, &cr, (j < 10) ? sprite01 : ((j < 20) ? sprite02 : ((j < 30) ? sprite03 : sprite04)), 0, 0, se->dy, se->dx);
               se->state = (j > 39) ? 0 : (j + 1);
 
               if (s->row > 21) se->dy = - se->dy;           // if sprite went off screen reverse direction
               if (s->col > 29) se->dx = - se->dx;
 
               // check for collision with other sprites
 
               deleteSpriteFlag = 0;
 
               for (j=i+1; j!=MAX_SPRITES; ++j)
               {
                  if ((sprtbl[j].state != DEAD_SPRITE) && (sp1_TestCollision(s, sprtbl[j].s, 2)))    // 2 pixel tolerance
                  {
                     // move current 'j' sprite off screen and mark as removed
 
                     sp1_MoveSprAbs(sprtbl[j].s, &cr, 0, 32, 0, 0, 0);
                     sprtbl[j].state = DEAD_SPRITE;
 
                     deleteSpriteFlag = 1;
                  }
               }
 
               if (deleteSpriteFlag)
               {
                  bit_beepfx(BEEPFX_ITEM_1);
                  in_pause(500);                  // pause 500 ms
 
                  sp1_MoveSprAbs(s, &cr, 0, 32, 0, 0, 0);
                  se->state = DEAD_SPRITE;
               }
               else
               {
                  ++numLiveSprites;
               }
            }
         }
      } while ((numLiveSprites) && (!in_test_key()));
 
      // all sprites dead or key pressed
 
      zx_border(INK_RED);
 
      bit_beepfx(BEEPFX_ALARM_2);
      in_pause(500);
 
      zx_border(INK_BLACK);
   }
}
