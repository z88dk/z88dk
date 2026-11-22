
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_20

INCLUDE "config_private.inc"

_bitfx_20:

   ; descending buzzer

   ld hl,1000

desc1:

   push hl
   ld b,16

desc2:

   rl l
   rl h
   
   jr nc, desc3
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

desc3:

   ld e,5

desc4:

   dec e
   jr nz, desc4
   
   djnz desc2
   
   pop hl
   dec hl
   
   ld c,a
   
   ld a,h
   or l
   
   ld a,c
   jr nz, desc1
   
   ret
