
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_10

INCLUDE "config_private.inc"

_bitfx_10:

   ; Dual note with LOT of fuzzy added
   
   ld b,100

ts_loop:

   dec h
   jr nz, ts_jump
   
   push hl
   push af
   
   ld a,__SOUND_BIT_TOGGLE
   ld h,0
   and (hl)
   ld l,a
   
   pop af
   
   xor l
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"
   
   pop hl
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

ts_FR_1:

   ld h,130

ts_jump:

   dec l
   jr nz, ts_loop
   
   push hl
   push af
   
   ld a,__SOUND_BIT_TOGGLE
   ld l,h
   ld h,0
   and (hl)
   ld l,a
   
   pop af
   
   xor l
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   pop hl
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

ts_FR_2:

   ld l,155
   djnz ts_loop
   
   ret
