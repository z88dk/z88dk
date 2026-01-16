#include <stdio.h>    // putchar()
#include <unistd.h>   // write()
#include <stropts.h>  // ioctl()
#include <arch/sms.h>
#include <rect.h>
#include <input.h>    // in_wait_nokey(), in_pause()
#include <stdlib.h>   // malloc(), free()
#include <string.h>
#include <ctype.h>

#include "quotes.h"

// SMS INFORMATION

const unsigned char author[] = "z88dk";
const unsigned char name[] = "Speech Bubbles";
const unsigned char description[] = "Demonstrates runtime output terminal configuration.";

// PALETTE

const unsigned char palette[] = {0x00,0x01,0x05,0x15,0x24,0x25,0x29,0x39,0x16,0x1a,0x1b,0x2a,0x3a,0x3e,0x2b,0x3f};

// FONTS

#include "font_8x8_bubble.h"

extern unsigned char font_8x8_bbc_system[];
extern unsigned char font_8x8_zx_system[];
extern unsigned char font_8x8_clairsys[];

enum
{
   FONT_ZX = 0,
   FONT_BBC,
   FONT_CLAIRSYS,
   FONT_BUBBLE
};

const unsigned int font_offset[] = {0, 96, 192, 288};  //fonts define 96 characters

// RECTANGLES

const struct r_Rect8 full_screen = {0, 32, 0, 24};
const struct r_Rect8 base_bubble = {0, 8, 0, 8};

struct r_Rect8 expanded_bubble;

// VARIABLES

unsigned int *tile_storage;
unsigned char *buffer, *buffer_max, *buffer_walk, *buffer_space;
unsigned int i;

void main(void)
{
   // initialize palette
   
   sms_memcpy_mem_to_cram(0, palette, 16);
   sms_memcpy_mem_to_cram(16, palette, 16);
   
   // copy fonts to vram load in same order as indicated by enum
   
   sms_vdp_set_write_address(0x0000);
   sms_copy_font_8x8_to_vram(font_8x8_zx_system, 96, 0, 2);
   sms_copy_font_8x8_to_vram(font_8x8_bbc_system, 96, 10, 1);
   sms_copy_font_8x8_to_vram(font_8x8_clairsys, 96, 0, 4);
   sms_copy_font_8x8_to_vram(font_8x8_bubble, 8, 0, 10);

   sms_border(1);
   sms_display_on();

   // fill the screen with random letters
   // use the zx font to do this
   
   ioctl(1, IOCTL_OTERM_SET_WINDOW_RECT, &full_screen);
   ioctl(1, IOCTL_OTERM_CLS);
   
   ioctl(1, IOCTL_OTERM_CHARACTER_PATTERN_OFFSET, font_offset[FONT_ZX] - ' ');

   for (i = 0; i != 768; ++i)
      putchar(rand() % 96 + ' ');

   do
   {
      // inflate the speech bubble to a random size
   
      memcpy(&expanded_bubble, &base_bubble, sizeof(base_bubble));
   
      expanded_bubble.width += rand() % (31 - expanded_bubble.width);
      expanded_bubble.height += rand() % (23 - expanded_bubble.height);
   
      expanded_bubble.x += rand() % (32 - expanded_bubble.width);
      expanded_bubble.y += rand() % (24 - expanded_bubble.height);

      // store tiles underneath speech bubble
   
      tile_storage = malloc(expanded_bubble.width * expanded_bubble.height * sizeof(*tile_storage));
      sms_tiles_get_area(&expanded_bubble, tile_storage);
   
      // place output terminal at speech bubble
   
      ioctl(1, IOCTL_OTERM_SET_WINDOW_RECT, &expanded_bubble);
      ioctl(1, IOCTL_OTERM_CLS);
   
      // change terminal font to FONT_BUBBLE
   
      ioctl(1, IOCTL_OTERM_CHARACTER_PATTERN_OFFSET, font_offset[FONT_BUBBLE] - 'A');
   
      // print the speech bubble outline
   
      buffer = malloc(expanded_bubble.width * sizeof(*buffer));
   
      memset(buffer, 'G', expanded_bubble.width);
      buffer[0] = 'B';
      buffer[expanded_bubble.width - 1] = 'E';
   
      write(1, buffer, expanded_bubble.width);
   
      memset(buffer, 'A', expanded_bubble.width);
      buffer[0] = 'C';
      buffer[expanded_bubble.width - 1] = 'C';
   
      for (i = 0; i != expanded_bubble.height - 2; ++i)
         write(1, buffer, expanded_bubble.width);
   
      memset(buffer, 'H', expanded_bubble.width);
      buffer[0] = 'D';
      buffer[expanded_bubble.width - 1] = 'F';
   
      write(1, buffer, expanded_bubble.width);
   
      free(buffer);
   
      // shrink the output terminal by one char on all sides
      // so that it lies inside the speech bubble
   
      expanded_bubble.x += 1;
      expanded_bubble.width -= 2;
   
      expanded_bubble.y += 1;
      expanded_bubble.height -= 2;
   
      ioctl(1, IOCTL_OTERM_SET_WINDOW_RECT, &expanded_bubble);
      ioctl(1, IOCTL_OTERM_CLS);
   
      // set a random font and force pause if terminal screen fills up
   
      ioctl(1, IOCTL_OTERM_CHARACTER_PATTERN_OFFSET, font_offset[rand() % FONT_BUBBLE] - ' ');
      ioctl(1, IOCTL_OTERM_PAUSE, 1);
   
      // select a random passage and print it with minimal word splitting
   
      buffer = quotes[rand() % num_quotes()];
      while (*(buffer = strstrip(buffer)))
      {
         buffer_max = buffer + strnlen(buffer, expanded_bubble.width);
      
         buffer_space = buffer_max;
         for (buffer_walk = buffer; buffer_walk != buffer_max; ++buffer_walk)
         {
            if (isspace(*buffer_walk))
            {
               buffer_space = buffer_walk + 1;
            
               if (*buffer_walk == '\n')
               {
                  buffer_space--;
                  break;
               }
            }
         }

         write(1, buffer, buffer_space - buffer);
         putchar('\n');
         
         buffer = buffer_space;
      }
   
      // pause for fifteen seconds (press a button to skip)
      
      in_wait_nokey();
      in_pause(15000);
      
      // erase speech bubble
      
      expanded_bubble.x -= 1;
      expanded_bubble.width += 2;
   
      expanded_bubble.y -= 1;
      expanded_bubble.height += 2;

      sms_tiles_put_area(&expanded_bubble, tile_storage);
      free(tile_storage);

   } while (1);
}
