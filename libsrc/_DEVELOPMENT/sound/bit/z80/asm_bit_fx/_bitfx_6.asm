
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_6

INCLUDE "clib_target_cfg.asm"

_bitfx_6:

   ; beep thing

zap3_1:

   push bc
   
   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push af
   
   xor a
   sub b
   ld b,a
   
   pop af

zap3_2:

   nop
   djnz zap3_2
   
   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   pop bc
   push bc

zap3_3:

   nop
   djnz zap3_3
   
   pop bc
   djnz zap3_1
   
   ret
