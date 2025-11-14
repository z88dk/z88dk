
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_6

INCLUDE "config_private.inc"

_bitfx_6:

   ; beep thing

zap3_1:

   push bc
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push af
   
   xor a
   sub b
   ld b,a
   
   pop af

zap3_2:

   nop
   djnz zap3_2
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   pop bc
   push bc

zap3_3:

   nop
   djnz zap3_3
   
   pop bc
   djnz zap3_1
   
   ret
