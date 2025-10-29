
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_0

INCLUDE "config_private.inc"

_bitfx_0:
      
   ld e,150

fx2_1:

   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"
   
   ld b,e

fx2_2:

   djnz fx2_2
   
   inc e
   jr nz, fx2_1
   
   ret
