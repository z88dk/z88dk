
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_29

INCLUDE "config_private.inc"

EXTERN asm_bit_beep_raw

_bitfx_29:

   ld hl,300
   ld de,1

fx6_1:

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
   
   inc hl
   inc de
   
   ld a,l
   and 50
   jr nz, fx6_1
   
   scf
   ret
