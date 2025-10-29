
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_5

INCLUDE "config_private.inc"

_bitfx_5:
   
   ; klaxon sound

   ld b,90

klaxon_loop:

   dec h
   jr nz, klaxon_jump
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

klaxon_FR_1:

   ld h,230

klaxon_jump:

   dec l
   jr nz, klaxon_loop
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

klaxon_FR_2:

   ld l,255
   djnz klaxon_loop
   
   ret
