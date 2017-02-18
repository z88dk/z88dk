
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_17

INCLUDE "config_private.inc"

_bitfx_17:

   ; blirp 2

   ld b,100

blrp:

   push af
   
   ld a,__SOUND_BIT_TOGGLE
   ld h,0
   ld l,b
   and (hl)
   ld l,a
   
   pop af
   
   xor l
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push bc
   push af
   
   ld a,255
   sub b
   ld b,a
   
   pop af

dlyb:

   nop
   djnz dlyb
   
   pop bc
   
   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push bc

dlya:

   nop
   djnz dlya
   
   pop bc
   djnz blrp
   
   ret
