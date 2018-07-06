#include <stdio.h>
#include <stdlib.h>
#include <libgen.h>
#include <arch/zxn/esxdos.h>

#include "globals.h"
#include "load.h"

void load_tap(void)
{
   // currently mounted tap will be closed by open
   
   if (esx_m_tapein_open(basename(program_name)))
      return;

   printf("\nto start - LOAD \"t:\": LOAD \"\"n");
   exit(0);
}

void load_exe(void)
{
   return;
}


/*

struct header
{
   unsigned char desc[2];           // two character descriptor
   uint16_t      version;           // block version
   uint16_t      size;              // number of bytes following header
};

struct header block;

typedef unsigned char (*df)(void);

struct dispatch
{
   struct header h;
   df     func;
};

struct dispatch known_blocks[] = {
   { {'N','X'}, 0, 0, block_NX },
   { {'-','-'}, 0, 0, block_mm },
   { {'P','L'}, 0, 0, block_PL },
   { {'D','L'}, 0, 0, block_DL },
   { {'P','B'}, 0, 0, block_PB },
   { {'C','L'}, 0, 0, block_CL },
   { {'W','D'}, 0, 0, block_WD },
   { {'A','T'}, 0, 0, block_AT },
   { {'S','T'}, 0, 0, block_ST },
   { {'S','R'}, 0, 0, block_SR },
};

int match_block(struct header *h1, struct header *h2)
{
   return memcmp(h1, h2, 4);
}


unsigned char fin = 0xff;

unsigned char signature_seen = 0;
unsigned char return_is_safe = 1;

typedef unsigned char 

void load_program(void)
{
   // sort block types to speed up search
   
   qsort(known_blocks, sizeof(known_blocks)/sizeof(*known_blocks), sizeof(*known_blocks), match_block);

   // dispatch all blocks until done
   
   num = 0;
   
   while (1)
   {
      struct dispatch *dis;
      
      esx_f_read(fin, &block, sizeof(header));
      
      if ((dis = bsearch(&block, known_blocks, sizeof(known_blocks)/sizeof(*known_blocks), sizeof(*known_blocks), match_block)) == NULL)
         error("block not found");
      
      if ((dis->func)())
         error(errno);
      
      num++;
   }
}

*/
