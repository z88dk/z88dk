
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_25

INCLUDE "config_private.inc"

EXTERN asm_bit_beep_raw

_bitfx_25:

   ; audio tape rewind

   ld hl,1024

fx2_1:

   ld de,1
   
   push de
   push hl
   
   ld a,55
   xor l
   ld l,a
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   dec hl

   ld a,h
   or l
   jr nz, fx2_1
   
   scf
   ret
