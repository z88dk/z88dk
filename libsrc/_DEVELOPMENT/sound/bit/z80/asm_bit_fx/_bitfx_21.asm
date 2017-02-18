
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_21

INCLUDE "config_private.inc"

_bitfx_21:

   ; ascending buzzer

   ld hl,1023

hdesc1:

   push hl
   ld b,16

hdesc2:

   rl l
   rl h
   
   jr nc, hdesc3
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

hdesc3:

   djnz hdesc2
   
   pop hl
   dec hl
   
   ld c,a
   
   ld a,h
   or l
   
   ld a,c
   jr nz, hdesc1
   
   ret
