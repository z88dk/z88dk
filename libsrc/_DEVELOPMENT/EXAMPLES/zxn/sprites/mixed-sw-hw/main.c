// zcc +zxn -v -startup=1 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 main.c graphics.asm.m4 interrupt.asm -o main -pragma-include:zpragma.inc -subtype=nex -Cz"--clean" -create-app

#include <arch/zxn.h>
#include <arch/zxn/color.h>
#include <arch/zxn/sp1.h>
#include <im2.h>
#include <input.h>
#include <intrinsic.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SW_SPRITES 64
#define MAX_HW_SPRITES 64
#define MAX_SPLATS     64

unsigned char num_sw_sprites = 0;
unsigned char num_hw_sprites = 0;
unsigned char num_splats     = 0;

// hardware sprites

extern unsigned char gfx_sword[];

struct hw_sprite
{
   unsigned int x;
   unsigned int y;
   signed   int dx;
   signed   int dy;
};

struct hw_sprite_attr
{
   uint8_t x;
   uint8_t y;
   uint8_t p1;  // 7:4 = palette offset, 3 = x mirror, 2 = y mirror, 1 = rotate, 0 = x msb
   uint8_t p2;  // 7 = visible, 5:0 = pattern index 0-63
};

struct hw_sprite      hw_sprites[MAX_HW_SPRITES];
struct hw_sprite_attr hw_attr;   // all zeroes

void initialize_hw_sprites(void)
{
   // it's important to initialize all sprites even if they are not used
   // because they initially contain random sprite attributes

   IO_SPRITE_SLOT = 0;
   
   // sprite pattern

   intrinsic_outi(gfx_sword, __IO_SPRITE_PATTERN, 256);  // unrolled outi from intrinsic.h

   // sprite attributes

   memset(&hw_attr, 0, sizeof(hw_attr));   // makes sprite invisible
   
   for (unsigned char i = 0; i != MAX_HW_SPRITES; ++i)
      intrinsic_outi(&hw_attr, __IO_SPRITE_ATTRIBUTE, 4);
}

// sp1 software sprites

extern unsigned char gfx_happy_face[];

struct sp1_Rect full_screen = {0, 0, 32, 24};  // row,col,width,height
struct sp1_Rect text_cutout = {20, 1, 19, 3};

struct sw_sprite
{
   struct sp1_ss *sprite;
   signed int     dx;
   signed int     dy;
};

struct sw_sprite sw_sprites[MAX_SW_SPRITES];

void toggle_clash(unsigned int count, struct sp1_cs *cs)
{
   cs->attr = (cs->attr & 0x07) + (((~cs->attr << 3) & 0x38) & cs->attr_mask);
   cs->attr_mask ^= 0x78;   // toggle whether sprite colour replaces background bright and paper
}

unsigned char colour;

void colour_sprite(unsigned int count, struct sp1_cs *cs)
{
   cs->attr_mask = 0xf8;   // sprite colour replaces background ink only
   cs->attr = colour;
}

void initialize_sw_sprites(void)
{
   for (unsigned char i = 0; i != MAX_SW_SPRITES; ++i)
   {
      // create a masked sprite (initially off screen)
      
      sw_sprites[i].sprite = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 2, (int)gfx_happy_face, i);
      sp1_AddColSpr(sw_sprites[i].sprite, SP1_DRAW_MASK2RB, SP1_TYPE_2BYTE, 0, i);
      
      // colour the sprite
      
      colour = i & 0x07;
      
      if ((colour == INK_MAGENTA) || (colour == INK_WHITE))
         colour = INK_BLACK;

      sp1_IterateSprChar(sw_sprites[i].sprite, colour_sprite);
   }
}

// splats

extern unsigned char gfx_splat[];

struct splat
{
   unsigned char x;
   unsigned char y;
};

struct splat splats[MAX_SPLATS];

void splat_it(unsigned char x, unsigned char y, unsigned char add)
{
   struct sp1_update *u;
   
   if ((x < 32) && (y < 24))
   {
      if ((y < text_cutout.row) || (y >= text_cutout.row + text_cutout.height) || (x < text_cutout.col) || (x >= text_cutout.col + text_cutout.width))
      {
         u = sp1_GetUpdateStruct(y, x);
         
         if (add)
         {
            sp1_RemoveUpdateStruct(u);
            
            for (unsigned char i = 0; i != 8; ++i)
               *(zx_cxy2saddr(x, y) + (i << 8)) = gfx_splat[i];
            
            *zx_cxy2aaddr(x, y) = INK_BLACK | PAPER_WHITE;
         }
         else
         {
            sp1_RestoreUpdateStruct(u);
            sp1_PrintAtInv(y, x, INK_MAGENTA | PAPER_MAGENTA | BRIGHT, ' ');
         }
      }
   }
}

void visit_splat(struct splat *s, unsigned char add)
{
   unsigned char x;
   unsigned char y;
   
   x = s->x;
   y = s->y;
   
   splat_it(x, y, add);
   
   --x;
   
   splat_it(x, y, add);
   
   ++x;
   --y;

   splat_it(x, y, add);
   
   y += 2;
   
   splat_it(x, y, add);
   
   ++x;
   
   splat_it(x, y, add);
}

// layer 2

extern unsigned char gfx_tile[];   // 16x16 tile

void initialize_layer_2(void)
{
   for (unsigned char i = 18; i < 24; ++i)
   {
      ZXN_WRITE_MMU0(i);
      
      // write tile to top 16 lines
      
      for (unsigned char j = 0; j != 16; ++j)
      {
         memcpy((void *)(j << 8), &gfx_tile[j << 4], 16);
         memcpy((void *)((j << 8) + 16), (void *)(j << 8), 256-16);
      }
      
      // copy tile to rest of lines in page
      
      for (unsigned char j = 16; j != 32; ++j)
         memcpy((void *)(j << 8), (void *)((j & 0xf) << 8), 256);
   }
   
   ZXN_WRITE_MMU0(0xff);
}

// interrupt routine

unsigned char dx, dy;

IM2_DEFINE_ISR_8080(isr)
{
   unsigned char save;
   
   // save nextreg register

   // not actually required because nextreg instructions are used below
   // which do not alter the selected register in port 0x243b.
   
   save = IO_NEXTREG_REG;
   
   // simple update of layer 2 scroll
   
   ZXN_NEXTREGA(REG_LAYER_2_OFFSET_X, ++dx);
   
   if (++dy > 191) dy = 0;
   ZXN_NEXTREGA(REG_LAYER_2_OFFSET_Y, dy);
   
   // restore nextreg register
   
   IO_NEXTREG_REG = save;
}

// MAIN

void main(void)
{
   static unsigned char c;

   // fast cpu
   
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   
   // global transparency
   
   ZXN_NEXTREG(REG_FALLBACK_COLOR, ZXN_RGB332_FACEBOOK_1);    // ignored by cspect
   ZXN_NEXTREG(REG_GLOBAL_TRANSPARENCY_COLOR, ZXN_RGB332_NEXTOS_BRIGHT_MAGENTA);
   
   // apply pattern to layer 2

   initialize_layer_2();

   // initialize sp1 which will manage ula screen

   zx_border(INK_BLUE);

   sp1_Initialize(SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE, INK_MAGENTA | PAPER_MAGENTA | BRIGHT, ' ' );
   sp1_Invalidate(&full_screen);
  
   sp1_UpdateNow();
   sp1_IterateUpdateRect(&text_cutout, sp1_RemoveUpdateStruct);  // remove text area from the engine
   
   // sprites
   
   initialize_sw_sprites();
   initialize_hw_sprites();
   
   // layer priority and enable sprites
   
   ZXN_NEXTREGA(REG_SPRITE_LAYER_SYSTEM, RSLS_LAYER_PRIORITY_SUL | RSLS_SPRITES_OVER_BORDER | RSLS_SPRITES_VISIBLE);
   
   ZXN_NEXTREG(REG_LAYER_2_RAM_BANK, 9);
   IO_LAYER_2_CONFIG = IL2C_SHOW_LAYER_2;

   // enable interrupts
   
   intrinsic_ei();
   
   // main loop
   
   while (1)
   {
      // update software sprites
      
      for (unsigned char i = 0; i != num_sw_sprites; ++i)
      {
         sp1_MoveSprRel(sw_sprites[i].sprite, &full_screen, 0, 0, 0, sw_sprites[i].dy, sw_sprites[i].dx);
         
         if (sw_sprites[i].sprite->col > 31)
            sw_sprites[i].dx = -sw_sprites[i].dx;
         
         if (sw_sprites[i].sprite->row > 23)
            sw_sprites[i].dy = -sw_sprites[i].dy;
      }
      
      sp1_UpdateNow();
      
      // update hardware sprites
      
      IO_SPRITE_SLOT = 0;
      
      for (unsigned char i = 0; i != num_hw_sprites; ++i)
      {
         if ((hw_sprites[i].x += hw_sprites[i].dx) > 319-16)
            hw_sprites[i].dx = -hw_sprites[i].dx;
         
         if ((hw_sprites[i].y += hw_sprites[i].dy) > 255-16)
            hw_sprites[i].dy = -hw_sprites[i].dy;
         
         hw_attr.x  = hw_sprites[i].x;
         hw_attr.y  = hw_sprites[i].y;
         hw_attr.p1 = (hw_sprites[i].x >> 8) != 0;
         hw_attr.p2 = 0x80;
         
         intrinsic_outi(&hw_attr, __IO_SPRITE_ATTRIBUTE, 4);
      }

      c = in_inkey();
      
      // change number of software sprites

      if ((c == 'S') && (num_sw_sprites != MAX_SW_SPRITES))
      {
         // more
         
         sw_sprites[num_sw_sprites].dx = ((unsigned int)rand() % 8) - 4;
         sw_sprites[num_sw_sprites].dy = ((unsigned int)rand() % 8) - 4;
         
         sp1_MoveSprPix(sw_sprites[num_sw_sprites].sprite, &full_screen, 0, (unsigned int)rand() % 256, (unsigned int)rand() % 168);

         printf("\x16\x02\x16" "\x15\x32" "NUM SW SPRITES = %02u", ++num_sw_sprites);
      }
      
      if ((c == 's') && num_sw_sprites)
      {
         // less
         
         --num_sw_sprites;
         sp1_MoveSprAbs(sw_sprites[num_sw_sprites].sprite, &full_screen, 0, 0, 32, 0, 0);   // move off screen
         
         printf("\x16\x02\x16" "\x15\x32" "NUM SW SPRITES = %02u", num_sw_sprites);
      }

      // change number of hardware sprites
      
      if ((c == 'H') && (num_hw_sprites != MAX_HW_SPRITES))
      {
         // more
         
         hw_sprites[num_hw_sprites].x = (unsigned int)rand() % (320-16);
         hw_sprites[num_hw_sprites].y = (unsigned int)rand() % (256-16);
         
         hw_sprites[num_hw_sprites].dx = ((unsigned int)rand() % 8) - 4;
         hw_sprites[num_hw_sprites].dy = ((unsigned int)rand() % 8) - 4;
         
         printf("\x16\x02\x17" "\x15\x32" "NUM HW SPRITES = %02u", ++num_hw_sprites);
      }
      
      if ((c == 'h') && num_hw_sprites)
      {
         // less
         
         IO_SPRITE_SLOT = --num_hw_sprites;
         
         hw_attr.p2 = 0;   // make invisible
         intrinsic_outi(&hw_attr, __IO_SPRITE_ATTRIBUTE, 4);
         
         printf("\x16\x02\x17" "\x15\x32" "NUM HW SPRITES = %02u", num_hw_sprites);
      }

      // toggle clash on software sprites
      
      if (c == 'c')
      {
         for (unsigned char i = 0; i != MAX_SW_SPRITES; ++i)
            sp1_IterateSprChar(sw_sprites[i].sprite, toggle_clash);
      }

      // toggle sprite and ula priority
      
      if (c == 'p')
         ZXN_NEXTREGA(REG_SPRITE_LAYER_SYSTEM, ZXN_READ_REG(REG_SPRITE_LAYER_SYSTEM) ^ 0x18);
      
      // splat!
      
      if ((c == 'Z') && (num_splats != MAX_SPLATS))
      {
         // more
         
         splats[num_splats].x = (unsigned int)rand() % 32;
         splats[num_splats].y = (unsigned int)rand() % 24;
         
         visit_splat(&splats[num_splats], 1);
         
         printf("\x16\x02\x15" "\x15\x32" "NUM SPLATS     = %02u", ++num_splats);
      }
      
      if ((c == 'z') && num_splats)
      {
         // less
         
         visit_splat(&splats[--num_splats], 0);
         
         printf("\x16\x02\x15" "\x15\x32" "NUM SPLATS     = %02u", num_splats);
      }
      
      // wait for key release
      
      while (in_inkey()) ;
   }
}
