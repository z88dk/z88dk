
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_19

INCLUDE "config_private.inc"

_bitfx_19:

  ; blurp

   ld b,255

blurp2:

   push af
   
   ld a,__SOUND_BIT_TOGGLE
   ld h,0
   ld l,b
   and (hl)
   ld l,a
   
   pop af
   
   xor l
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

   push af
   
   ld a,(hl)

dblurp:

   dec a
   jr nz, dblurp
   
   pop af
   djnz blurp2
   
   ret
