
; char *bit_play(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play

EXTERN _bit_play_fastcall

_bit_play:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _bit_play_fastcall
