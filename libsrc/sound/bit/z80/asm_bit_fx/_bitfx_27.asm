
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_27

INCLUDE "config_private.inc"

EXTERN asm_bit_beep_raw

_bitfx_27:

   ld hl,1124
   ld de,1

fx4_1:

   push de
   push hl
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   push de
   push hl
   
   ld bc,900
   sbc hl,bc
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   inc hl
   
   ld a,l
   or a
   jr nz, fx4_1
   
   scf
   ret
