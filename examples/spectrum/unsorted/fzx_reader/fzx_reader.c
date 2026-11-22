// for targets supporting fzx

// zcc +zx -vn -startup=31 -O3 -clib=new fzx_reader.c The_Jungle.c -o fzxr -create-app
// zcc +zx -vn -startup=31 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 fzx_reader.c The_Jungle.c -o fzxr -create-app

#include <font/fzx.h>
#include <rect.h>
#include <arch/zx.h>
#include <string.h>
#include <input.h>

#pragma output REGISTER_SP           = 0   // set to 0 (top of memory)
#pragma output CRT_ENABLE_RESTART    = 1   // not returning to basic
#pragma output CRT_ENABLE_CLOSE      = 0   // do not close files on exit
#pragma output CLIB_EXIT_STACK_SIZE  = 0   // no exit stack
#pragma output CLIB_MALLOC_HEAP_SIZE = 0   // no user heap
#pragma output CLIB_STDIO_HEAP_SIZE  = 0   // no stdio heap for fd structures
#pragma output CLIB_FOPEN_MAX        = 0   // no allocated FILE structures
#pragma output CLIB_OPEN_MAX         = 0   // no fd table

#define FONT_CHOICE ff_ao_Orion

// fzx state

struct fzx_state fs;

// rectangles defining columns on screen

int active_window;
struct r_Rect16 window[] = { { 0, 120, 0, 192 }, { 136, 120, 0, 192 } };

// book pointers

extern char *book;
char *p_start, *p_end, *p_part;

void newline(void)
{
   fs.x  = fs.left_margin;
   fs.y += fs.font->height * 3/2;   // 1.5 line spacing
}

main()
{
   int res;

   zx_border(INK_MAGENTA);
   
   // portion of fzx_state that is target-dependent
   // not initialized by fzx_state_init()
   
   fs.fgnd_attr = INK_BLACK | PAPER_RED;
   fs.fgnd_mask = 0;

   while(1)
   {
      // start of book
         
      p_start = strstrip(book);

      // clear screen
      
      active_window = 0;
      fzx_state_init(&fs, &FONT_CHOICE, &window[0]);
      
      zx_cls(INK_WHITE | PAPER_MAGENTA);

      // print book into columns

      while (*p_start)
      {            
         // delimit paragraph
            
         p_end = strchrnul(p_start, '\n');
            
         // print paragraph
            
         while (p_start < p_end)
         {
            // find line that will fit into window
               
            p_part = fzx_buffer_partition_ww(fs.font, p_start, p_end - p_start, fs.paper.width - fs.left_margin);
            
            if (p_part == p_start)
            {
               // solid text without spaces exceeds allowed width
               // this text will not be justified -- should the justify function insert spaces between characters??
               
               p_part = fzx_buffer_partition(fs.font, p_start, p_end - p_start, fs.paper.width - fs.left_margin);
            }
            
            // print line

            if (p_part == p_end)
            {
               // last line of paragraph
               
               res = fzx_write(&fs, p_start, p_part - p_start);
            }
            else
            {
               res = fzx_write_justified(&fs, p_start, p_part - p_start, fs.paper.width - fs.left_margin);
            }

            if (res < 0)
            {
               // bottom of window reached
                  
               if (++active_window >= (sizeof(window) / sizeof(struct r_Rect16)))
               {
                  // page full
                     
                  active_window = 0;
                     
                  in_wait_nokey();
                  in_wait_key();
                     
                  zx_cls(INK_WHITE | PAPER_MAGENTA);
               }
                  
               // move to top left of next window
                                     
               fzx_state_init(&fs, &FONT_CHOICE, &window[active_window]);
            }
            else
            {
               // move pointer to beginning of next line
                 
               p_start = strstrip(p_part);
               newline();
            }
         }
            
         // end of paragraph, process newlines
            
         if (*p_end)
         {
            while (*(++p_end) == '\n')
            {
               newline();
               if (fs.y >= fs.paper.height) break;
            }
         }
            
         // move past paragraph
            
         p_start = strstrip(p_end);
      }

      // end of book
      
      in_wait_nokey();
      in_wait_key();
   }
}
