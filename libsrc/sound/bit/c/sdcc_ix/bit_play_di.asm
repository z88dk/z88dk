
; char *bit_play_di(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_di

EXTERN _bit_play_di_fastcall

_bit_play_di:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _bit_play_di_fastcall
