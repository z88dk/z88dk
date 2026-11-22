
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_26

INCLUDE "config_private.inc"

EXTERN asm_bit_beep_raw

_bitfx_26:

   ; fx3 effect
   
   ld hl,30
   ld de,1

fx3_1:

   push de
   push hl
   
   call asm_bit_beep_raw
   
   ld hl,600
   ld de,1
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   dec hl
   inc de
   
   ld a,h
   or l
   jr nz, fx3_1
   
   scf
   ret
