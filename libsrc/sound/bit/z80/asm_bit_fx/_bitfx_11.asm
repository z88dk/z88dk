
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_11

INCLUDE "config_private.inc"

_bitfx_11:

   ; klaxon 2
   
   ld b,200

cs_loop:

   dec h
   jr nz, cs_jump
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push bc
   ld b,250

cswait1:

   djnz cswait1
   
   pop bc
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

cs_FR_1:

   ld h,230

cs_jump:

   inc l
   jr nz, cs_loop
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push bc
   ld b,200

cswait2:

   djnz cswait2
   
   pop bc
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

cs_FR_2:

   ld l,0
   djnz cs_loop
   
   ret
