#include <arch/zxn.h>
#include "init.h"

// INK 0-7, BRIGHT INK 0-7

const unsigned char ula_ink[] = {
   0b00000000, 0b00000010, 0b10100000, 0b10100010,
   0b00010100, 0b00010110, 0b10110100, 0b10110110,
             
   0b00000000, 0b00000011, 0b11100000, 0b11100111,
   0b00011100, 0b00011111, 0b11111100, 0b11111111,
};

// PAPER 0-7, BRIGHT PAPER 0-7

const unsigned char ula_paper[] = {
   0b00000000, 0b00000010, 0b10100000, 0b10100010,
   0b00010100, 0b00010110, 0b10110100, 0b10110110,
             
   0b00000000, 0b00000011, 0b11100000, 0b11100111,
   0b00011100, 0b00011111, 0b11111100, 0b11111111,
};

void set_ordered_palette(void)
{
   ZXN_NEXTREG(REG_PALETTE_INDEX, 0);
   
   IO_NEXTREG_REG = REG_PALETTE_VALUE_8;

   for (unsigned int i = 0; i != 256; ++i)
      IO_NEXTREG_DAT = i;
}

void init(void)
{
   // set default ula ink colours
   
   ZXN_NEXTREG(REG_PALETTE_INDEX, 0);
   
   IO_NEXTREG_REG = REG_PALETTE_VALUE_8;
   
   for (unsigned char i = 0; i != sizeof(ula_ink); ++i)
      IO_NEXTREG_DAT = ula_ink[i];
   
   // set default ula paper colours
   
   ZXN_NEXTREG(REG_PALETTE_INDEX, 128);
   
   IO_NEXTREG_REG = REG_PALETTE_VALUE_8;
   
   for (unsigned char i = 0; i != sizeof(ula_paper); ++i)
      IO_NEXTREG_DAT = ula_paper[i];

   // layer 2 palette
   
   ZXN_NEXTREG(REG_PALETTE_CONTROL, RPC_SELECT_LAYER_2_PALETTE_0);
   set_ordered_palette();
   
   // sprite palette
   
   ZXN_NEXTREG(REG_PALETTE_CONTROL, RPC_SELECT_SPRITES_PALETTE_0);
   set_ordered_palette();
}
