
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_1

EXTERN asm_bit_beep_raw

_bitfx_1:

   ; Laser repeat sound

   ld b,1

fx5_1:

   push bc
   
   ld de,6
   ld hl,1200

fx5_2:

   push de
   push hl
   
   call asm_bit_beep_raw
   
   pop hl
   pop de
   
   ld bc,100
   
   or a
   sbc hl,bc
   
   jr nc, fx5_2

   pop bc
   djnz fx5_1
   
   scf
   ret
