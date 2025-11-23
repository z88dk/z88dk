
; void *bit_play_tritone_di(void *song)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_tritone_di

EXTERN asm_bit_play_tritone_di

_bit_play_tritone_di:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_bit_play_tritone_di
