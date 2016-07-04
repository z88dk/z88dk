
#include <stdio.h>
#include <stropts.h>
#include <sound/bit.h>
#include <compress/zx7.h>
#include <input.h>
#include <intrinsic.h>
#include <arch/zx.h>
#include <z80.h>

#pragma output CLIB_OPT_PRINTF       = 0x00000202   // enable %us for printf only
#pragma output CLIB_OPT_SCANF        = 0x00000022   // enable %un for scanf only

#pragma output CRT_ORG_CODE          = 40000
#pragma output REGISTER_SP           = 0
#pragma output CLIB_MALLOC_HEAP_SIZE = 128
#pragma output CLIB_STDIO_HEAP_SIZE  = 0

// Workspace Location for Decompressed Songs

#define WORKSPACE ((void *)(55000))

// External Assembly Labels

extern unsigned char zx7_darklight[];
extern unsigned char zx7_journey[];
extern unsigned char zx7_madashell[];
extern unsigned char zx7_super70s[];
extern unsigned char zx7_triceropop[];
extern unsigned char zx7_fotb[];

// Compressed Songs Structure

struct songs
{
   unsigned char *name;
   void          *start;
};

struct songs song_list[] = {
   {"Dark Light",              zx7_darklight  },
   {"Flight of the Bumblebee", zx7_fotb       },
   {"Journey",                 zx7_journey    },
   {"Mad As Hell",             zx7_madashell  },
   {"Super 70s",               zx7_super70s   },
   {"Triceropop",              zx7_triceropop }
};

void main(void)
{
   static void *s;
   static unsigned int i, j;
   static unsigned char *buffer;
   static unsigned int len, offset;

   intrinsic_di();
   
   zx_border(INK_MAGENTA);
   ioctl(1, IOCTL_OTERM_PAUSE, 0);
   ioctl(1, IOCTL_OTERM_CLS);

   while (1)
   {      
      // Title
      
      printf("\n\n\nTRITONE MUSIC DEMO\nmusic by Frank Triggs\n");
      printf("http://tinyurl.com/mefafxa\n\n");
      
      // Song List
      
      for (i = 0; i != sizeof(song_list) / sizeof(struct songs); ++i)
         printf("   %u. %s\n", i+1, song_list[i].name);

      // Gather Song Selection
      
      printf("\n\nPlaylist by number: ");
      
      fflush(stdin);
      getline(&buffer, &len, stdin);

      for (offset = 0; sscanf(buffer + offset, "%u%n", &i, &j) == 1; offset += j)
      {
         if ((i > 0) && (i < (sizeof(song_list) / sizeof(struct songs) + 1)))
         {            
            // Decompress into Workspace
            
            printf("\n   Decompressing \"%s\"\n", song_list[--i].name);
            dzx7_standard(song_list[i].start, WORKSPACE);
            
            // Play Song Until Keypress
            
            in_wait_nokey();
            
            printf("   Now playing \"%s\"\n", song_list[i].name);
            for (s = WORKSPACE; s && (in_test_key() == 0); s = bit_play_tritone(s))
            {
               // could do things here while song plays
            }
            
            in_wait_nokey();
         }
         else
         {
            printf("\n\t%u: INVALID", i);
         }
      }
   }
}
