
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_24

INCLUDE "config_private.inc"

EXTERN asm_bit_beep_raw

_bitfx_24:

   ; strange squeak

   ld b,1

fx1_1:

   push bc
   
   ld hl,600
   ld de,2

fx1_2:

   push de
   push hl
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   push de
   push hl
   
   ld bc,400
   sbc hl,bc
   
   ld l,c
   ld h,b                      ; someone must have screwed up here
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   ld bc,40

   or a
   sbc hl,bc
   
   jr nc, fx1_2
   
   pop bc
   djnz fx1_1
   
   scf
   ret
