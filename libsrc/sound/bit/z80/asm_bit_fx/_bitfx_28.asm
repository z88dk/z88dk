
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_28

INCLUDE "config_private.inc"

EXTERN asm_bit_beep_raw

_bitfx_28:

   ; descending squeak
   
   ld hl,200
   ld de,1

fx5_1:

   push de
   push hl
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   push de
   push hl
   
   ld bc,180
   sbc hl,bc
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   push de
   push hl
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   inc hl
   inc de
   
   ld a,l
   or a
   jr nz, fx5_1
   
   scf
   ret
