
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_4

INCLUDE "config_private.inc"

_bitfx_4:

   ; Our old squelch...
   
   ld b,0

zap1_1:

   push bc
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

zap1_2:

   nop
   nop
   
   djnz zap1_2   

   pop bc
   djnz zap1_1
   
   ret
