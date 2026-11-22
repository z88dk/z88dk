
// zcc +zx -vn -startup=31 -O3 -clib=new fzx_modes.c -o fzx_modes -create-app
// zcc +zx -vn -startup=31 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 fzx_modes.c -o fzx_modes -create-app

#include <font/fzx.h>
#include <rect.h>
#include <arch/zx.h>
#include <input.h>
#include <stdlib.h>
#include <z80.h>

#pragma output CLIB_EXIT_STACK_SIZE  = 0   // no exit stack
#pragma output CLIB_MALLOC_HEAP_SIZE = 0   // no user heap
#pragma output REGISTER_SP           = -1  // do not change sp
#pragma output CLIB_STDIO_HEAP_SIZE  = 0   // no stdio heap for fd structures
#pragma output CLIB_FOPEN_MAX        = 0   // no allocated FILE structures
#pragma output CLIB_OPEN_MAX         = 0   // no fd table

// fzx state

struct fzx_state fs;

// rectangles defining areas on screen

struct r_Rect16 screen = { 0, 256, 0, 192 };

struct r_Rect8 tl = { 1, 14, 1, 10 };
struct r_Rect8 tr = { 17, 14, 1, 10 };
struct r_Rect8 bl = { 1, 14, 13, 10 };
struct r_Rect8 br = { 17, 14, 13, 10 };

// some text

char *txt_intro = "press any key to move to next section";
char *txt_hello = "Hello World!";
char *txt_xor   = "xor mode activated";
char *txt_reset = "reset mode activated";

// hash udg

unsigned char hash[] = { 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa };

void print_random_location(char *s)
{
   int len;
   
   len = fzx_string_extent(fs.font, s);
   
   if ((len < (fs.paper.width - fs.left_margin)) && (fs.font->height < fs.paper.height))
   {
      fs.x = rand() % (fs.paper.width - fs.left_margin - len);
      fs.y = rand() % (fs.paper.height - fs.font->height);
      
      fzx_puts(&fs, s);
   }
}

void main(void)
{
   unsigned int i;

   // introduction
   
   zx_border(INK_BLACK);
   zx_cls(INK_WHITE | PAPER_BLACK);
   
   fzx_state_init(&fs, &ff_ao_Dutch, &screen);   // sets xor mode by default
   
   fs.fgnd_attr = INK_WHITE | PAPER_BLACK;
   fs.fgnd_mask = 0;
   
   fs.y = (fs.paper.height - fs.font->height) / 2;
   fs.x = (fs.paper.width - fs.left_margin - fzx_string_extent(fs.font, txt_intro)) / 2;
   
   fzx_puts(&fs, txt_intro);
   
   in_wait_nokey();
   in_wait_key();
   in_wait_nokey();
   
   // or mode, fzx text printed ink-only

   fzx_state_init(&fs, &ff_ao_Cayeux, &screen);

   fs.fzx_draw = _fzx_draw_or;
   fs.fgnd_attr = INK_BLACK;
   fs.fgnd_mask = 0x38;        // do not change the paper!

   do
   {
      zx_cls(INK_BLACK | PAPER_BLACK);
      
      zx_cls_wc(&tl, INK_RED | PAPER_RED);
      zx_cls_wc(&tr, INK_GREEN | PAPER_GREEN);
      zx_cls_wc(&bl, INK_BLUE | PAPER_BLUE);
      zx_cls_wc(&br, INK_YELLOW | PAPER_YELLOW);
      
      for (i=0; i!=20; ++i)
      {
         if (in_test_key()) break;
         print_random_location(txt_hello);
         z80_delay_ms(250);        // so that the loop takes ~5s
      }
      
   } while (!in_test_key());
   
   in_wait_nokey();
   
   // xor mode
   
   zx_border(INK_MAGENTA);
   
   fzx_state_init(&fs, &ff_utz_Phraktur, &screen);
   
   fs.fzx_draw = _fzx_draw_xor;
   fs.fgnd_attr = INK_WHITE | PAPER_BLACK;
   fs.fgnd_mask = 0;

   do
   {
      zx_cls(INK_MAGENTA | PAPER_MAGENTA);

      for (i=0; i!=20; ++i)
      {
         if (in_test_key()) break;
         print_random_location(txt_xor);
         z80_delay_ms(250);        // so that the loop takes ~5s
      }
      
   } while (!in_test_key());
   
   in_wait_nokey();

   // reset mode
   
   zx_border(INK_BLACK);
   
   fzx_state_init(&fs, &ff_ao_Sinclair, &screen);
   
   fs.fzx_draw = _fzx_draw_reset;
   fs.fgnd_attr = INK_BLUE | PAPER_CYAN;
   fs.fgnd_mask = 0;

   do
   {
      zx_cls(INK_BLACK | PAPER_GREEN);
      
      for (i = 0x4000; i != 0x5800; ++i)
         *(char *)(i) = hash[zx_saddr2py((void *)(i)) & 0x07];

      for (i=0; i!=20; ++i)
      {
         if (in_test_key()) break;
         print_random_location(txt_reset);
         z80_delay_ms(250);        // so that the loop takes ~5s
      }
      
   } while (!in_test_key());
   
   in_wait_nokey();
}
