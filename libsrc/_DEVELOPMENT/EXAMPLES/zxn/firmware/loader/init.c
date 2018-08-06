#include <arch/zxn.h>
#include "init.h"

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
   
   for (unsigned char i = 0; i !=16; ++i)
   {
      IO_NEXTREG_DAT = 0b00000000;
      IO_NEXTREG_DAT = 0b00000010;
      IO_NEXTREG_DAT = 0b10100000;
      IO_NEXTREG_DAT = 0b10100010;
      IO_NEXTREG_DAT = 0b00010100;
      IO_NEXTREG_DAT = 0b00010110;
      IO_NEXTREG_DAT = 0b10110100;
      IO_NEXTREG_DAT = 0b10110110;
             
      IO_NEXTREG_DAT = 0b00000000;
      IO_NEXTREG_DAT = 0b00000011;
      IO_NEXTREG_DAT = 0b11100000;
      IO_NEXTREG_DAT = 0b11100111;
      IO_NEXTREG_DAT = 0b00011100;
      IO_NEXTREG_DAT = 0b00011111;
      IO_NEXTREG_DAT = 0b11111100;
      IO_NEXTREG_DAT = 0b11111111;
   }
   
   // set default ula paper colours
   
   ZXN_NEXTREG(REG_PALETTE_INDEX, 128);
   
   IO_NEXTREG_REG = REG_PALETTE_VALUE_8;
   
   for (unsigned char i = 0; i !=16; ++i)
   {
      IO_NEXTREG_DAT = 0b00000000;
      IO_NEXTREG_DAT = 0b00000010;
      IO_NEXTREG_DAT = 0b10100000;
      IO_NEXTREG_DAT = 0b10100010;
      IO_NEXTREG_DAT = 0b00010100;
      IO_NEXTREG_DAT = 0b00010110;
      IO_NEXTREG_DAT = 0b10110100;
      IO_NEXTREG_DAT = 0b10110110;
             
      IO_NEXTREG_DAT = 0b00000000;
      IO_NEXTREG_DAT = 0b00000011;
      IO_NEXTREG_DAT = 0b11100000;
      IO_NEXTREG_DAT = 0b11100111;
      IO_NEXTREG_DAT = 0b00011100;
      IO_NEXTREG_DAT = 0b00011111;
      IO_NEXTREG_DAT = 0b11111100;
      IO_NEXTREG_DAT = 0b11111111;
   }
   
   // layer 2 palette
   
   ZXN_NEXTREG(REG_PALETTE_CONTROL, RPC_SELECT_LAYER_2_PALETTE_0);
   set_ordered_palette();
   
   // sprite palette
   
   ZXN_NEXTREG(REG_PALETTE_CONTROL, RPC_SELECT_SPRITES_PALETTE_0);
   set_ordered_palette();
}
