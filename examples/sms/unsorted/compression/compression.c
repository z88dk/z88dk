#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <compress/aplib.h>
#include <compress/zx7.h>
#include <arch/sms.h>
#include <stropts.h>
#include <intrinsic.h>

// Header Information

const unsigned char author[] = "z88dk";
const unsigned char name[] = "Compression Test";
const unsigned char description[] = "Boring program that verifies that aplib and zx7 decompression works.";

// Palette

const unsigned char palette[] = {0x00,0x0f};

// Font

extern unsigned char font_8x8_clairsys_bold[];

// RAM Buffer

#include "binaries.h"

#define TRUE  1
#define FALSE 0

#define OVERHANG 10

unsigned char buffer[RAWBIN_SIZE + OVERHANG];

unsigned char verify(void)
{
   unsigned char i;
   
   if (memcmp(rawbin, buffer, RAWBIN_SIZE))
      return FALSE;

   for (i = 0; i != OVERHANG; ++i)
      if (buffer[RAWBIN_SIZE + i] != 0xff)
         return FALSE;
   
   return TRUE;
}

int main(void)
{
   // set up the text display
   
   sms_memcpy_mem_to_cram(0, palette, 2);
   
   sms_vdp_set_write_address(0x0000);
   sms_copy_font_8x8_to_vram(font_8x8_clairsys_bold, 128 - 32, 0, 1);
   
   sms_display_on();
   sms_border(0);
   
   ioctl(1, IOCTL_OTERM_CLS);
   
   printf("DECOMPRESSION TEST\n\n");
   
   // ensure the header agrees with the facts
   
   assert(RAWBIN_SIZE == rawbin_end - rawbin);

   // verify aplib decompression

   printf("Verifying aplib...\n");

   memset(buffer, 0xff, sizeof(buffer));
   aplib_depack(buffer, rawbin_ap);
   if (verify() == FALSE)
   {
      perror("aplib_depack");
      exit(1);
   }

   sms_memset_vram(0x3000, 0xff, RAWBIN_SIZE);

intrinsic_label(APLIB_TIMER_START);

	sms_aplib_depack_vram(0x3000, rawbin_ap);

intrinsic_label(APLIB_TIMER_STOP);

   memset(buffer, 0xff, sizeof(buffer));
   sms_memcpy_vram_to_mem(buffer, 0x3000, RAWBIN_SIZE);
   if (verify() == FALSE)
   {
      perror("aplib_depack_vram");
      exit(1);
   }

   // verify zx7 decompression
   
   printf("Verifying zx7...\n");

   memset(buffer, 0xff, sizeof(buffer));
   dzx7_standard(rawbin_zx7, buffer);
   if (verify() == FALSE)
   {
      perror("dzx7_standard");
      exit(1);
   }

   sms_memset_vram(0x3000, 0xff, RAWBIN_SIZE);

intrinsic_label(ZX7_TIMER_START);

   sms_dzx7_standard_vram(rawbin_zx7, 0x3000);

intrinsic_label(ZX7_TIMER_STOP);

   memset(buffer, 0xff, sizeof(buffer));
   sms_memcpy_vram_to_mem(buffer, 0x3000, RAWBIN_SIZE);
   if (verify() == FALSE)
   {
      perror("dzx7_standard_vram");
      exit(1);
   }
   
   // hurray it's a pass
   
   printf("\nPass... Nothing to see here.\n");
	return 0;
}
