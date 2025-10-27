
; char *bit_play(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play

EXTERN asm_bit_play

_bit_play:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_bit_play
