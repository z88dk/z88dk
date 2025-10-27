
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_30

INCLUDE "config_private.inc"

EXTERN asm_bit_beep_raw

_bitfx_30:

   ; fx7 effect
   
   ld hl,1000
   ld de,1

fx7_1:

   push de
   push hl
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   push de
   push hl
   
   ld bc,200
   sbc hl,bc
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   dec hl
   
   ld a,l
   and 50
   jr nz, fx7_1
   
   scf
   ret

