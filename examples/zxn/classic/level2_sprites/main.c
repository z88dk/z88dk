#include <arch/zxn.h>
#include <arch/zxn/color.h>
#include <arch/zxn/sprites.h>
#include <interrupt.h>
#include <im2.h>
#include <input.h>
#include <intrinsic.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>

#define MAX_HW_SPRITES 64

unsigned char num_hw_sprites = 0;

// hardware sprites

extern unsigned char gfx_sword[];

struct hw_sprite
{
   unsigned int x;
   unsigned int y;
   signed   int dx;
   signed   int dy;
};


struct hw_sprite      hw_sprites[MAX_HW_SPRITES];
struct sprite         hw_attr;   // all zeroes


void initialize_hw_sprites(void)
{
   // it's important to initialize all sprites even if they are not used
   // because they initially contain random sprite attributes
   IO_SPRITE_SLOT = 0;
   
   // sprite pattern
   intrinsic_outi(gfx_sword, __IO_SPRITE_PATTERN, 256);  // unrolled outi from intrinsic.h

   // sprite attributes
   sprite_init(&hw_attr);
   for (unsigned char i = 0; i != MAX_HW_SPRITES; ++i) {
        sprite_update(i, &hw_attr);
   }
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


static void isr(void)
{
   M_PRESERVE_MAIN;
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
   M_RESTORE_MAIN;
}

// MAIN

void main(void)
{
   static unsigned char c;

    intrinsic_di();
   // fast cpu
   
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   
   // global transparency
   
   ZXN_NEXTREG(REG_FALLBACK_COLOR, ZXN_RGB332_FACEBOOK_1);    // ignored by cspect
   ZXN_NEXTREG(REG_GLOBAL_TRANSPARENCY_COLOR, ZXN_RGB332_NEXTOS_BRIGHT_MAGENTA);
   
   // apply pattern to layer 2

   initialize_layer_2();


   // sprites
   
   initialize_hw_sprites();
   
   // layer priority and enable sprites
   
   ZXN_NEXTREGA(REG_SPRITE_LAYER_SYSTEM, RSLS_LAYER_PRIORITY_SUL | RSLS_SPRITES_OVER_BORDER | RSLS_SPRITES_VISIBLE);
   
   ZXN_NEXTREG(REG_LAYER_2_RAM_BANK, 9);
   IO_LAYER_2_CONFIG = IL2C_SHOW_LAYER_2;


   // Setup the ULA layer. Mark most of the ULA layer as transparent
   zx_border(INK_BLUE);
   zx_cls_attr(0x5b);	// bright magenta ink + paper
   zx_setink(INK_BLACK);
   zx_setpaper(PAPER_WHITE);
   
   zx_im2_init((void *)0xd000, 0xd1);
   add_raster_int(isr);
   
   // enable interrupts
   intrinsic_ei();


   // main loop
   
   while (1)
   {
      // A small pause
      __asm__("halt");
      
      // update hardware sprites
      
      IO_SPRITE_SLOT = 0;
      
      for (unsigned char i = 0; i != num_hw_sprites; ++i)
      {
         if ((hw_sprites[i].x += hw_sprites[i].dx) > 319-16)
            hw_sprites[i].dx = -hw_sprites[i].dx;
         
         if ((hw_sprites[i].y += hw_sprites[i].dy) > 255-16)
            hw_sprites[i].dy = -hw_sprites[i].dy;
         
         sprite_set_x(&hw_attr, hw_sprites[i].x);
         sprite_set_y(&hw_attr, hw_sprites[i].y);
         sprite_set_visible(&hw_attr);
         sprite_set_rotate(&hw_attr);
         sprite_set_xmirror(&hw_attr);
         sprite_set_pattern_number(&hw_attr, 0);

         sprite_update(i, &hw_attr);
      }

      c = getk();
      
      // change number of hardware sprites
      
      if ((c == 'H') && (num_hw_sprites != MAX_HW_SPRITES))
      {
         // more
         
         hw_sprites[num_hw_sprites].x = (unsigned int)rand() % (320-16);
         hw_sprites[num_hw_sprites].y = (unsigned int)rand() % (256-16);
         
         hw_sprites[num_hw_sprites].dx = ((unsigned int)rand() % 8) - 4;
         hw_sprites[num_hw_sprites].dy = ((unsigned int)rand() % 8) - 4;
         
         gotoxy(2,23);
         printf("NUM HW SPRITES = %02u", ++num_hw_sprites);
      }
      
      if ((c == 'h') && num_hw_sprites)
      {
         // less
         
         IO_SPRITE_SLOT = --num_hw_sprites;
         
         sprite_unset_visible(&hw_attr);
         sprite_update(num_hw_sprites, &hw_attr);
       
         gotoxy(2,23);
         printf("NUM HW SPRITES = %02u", num_hw_sprites);
      }
      
      // wait for key release
      
      while (getk()) ;
   }
}
