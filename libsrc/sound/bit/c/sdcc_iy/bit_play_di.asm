
; char *bit_play_di(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_di

EXTERN asm_bit_play_di

_bit_play_di:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_bit_play_di
