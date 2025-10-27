
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_8

INCLUDE "config_private.inc"

_bitfx_8:

   ; deep space
      
   ld b,100
   
ds_loop:

   dec h
   jr nz, ds_jump
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push bc
   ld b,250

loosetime1:

   djnz loosetime1
   
   pop bc
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

ds_FR_1:

   ld h,254

ds_jump:

   dec l
   jr nz, ds_loop
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push bc
   
   ld b,200

loosetime2:

   djnz loosetime2
   
   pop bc
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

ds_FR_2:

   ld l,255
   djnz ds_loop
   
   ret
