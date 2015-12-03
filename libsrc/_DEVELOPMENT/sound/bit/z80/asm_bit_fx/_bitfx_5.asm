
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_5

INCLUDE "clib_target_cfg.asm"

_bitfx_5:
   
   ; klaxon sound

   ld b,90

klaxon_loop:

   dec h
   jr nz, klaxon_jump
   
   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

klaxon_FR_1:

   ld h,230

klaxon_jump:

   dec l
   jr nz, klaxon_loop
   
   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

klaxon_FR_2:

   ld l,255
   djnz klaxon_loop
   
   ret
