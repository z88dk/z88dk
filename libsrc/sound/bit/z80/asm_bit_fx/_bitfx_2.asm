
SECTION code_clib
SECTION code_sound_bit

PUBLIC _bitfx_2

EXTERN asm_bit_beep_raw

_bitfx_2:

   ; Strange squeak hl=300,de=2
   ; Game up hl=300,de=10 inc de
   ; - like a PACMAN sound

   ld b,1

fx6_1:

   push bc
   
   ld de,10
   ld hl,300

fx6_2:

   push de
   push hl
   
   call asm_bit_beep_raw
   
   pop hl
   pop de

;  inc de

   ld bc,10
   
   or a
   sbc hl,bc
   
   jr nc, fx6_2
   
   pop bc
   djnz fx6_1
   
   scf
   ret
