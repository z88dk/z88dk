
; void *bit_play_tritone_di(void *song)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_tritone_di

EXTERN _bit_play_tritone_di_fastcall

_bit_play_tritone_di:

   pop af
   pop hl
   
   push hl
   push af

   jp _bit_play_tritone_di_fastcall
