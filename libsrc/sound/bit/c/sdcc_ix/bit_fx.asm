
; void bit_fx(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_fx

EXTERN _bit_fx_fastcall

_bit_fx:

   pop af
   pop hl
   
   push hl
   push af

   jp _bit_fx_fastcall
