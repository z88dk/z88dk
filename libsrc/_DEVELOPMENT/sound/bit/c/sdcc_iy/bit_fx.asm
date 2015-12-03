
; void bit_fx(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_fx

EXTERN asm_bit_fx

_bit_fx:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_bit_fx
