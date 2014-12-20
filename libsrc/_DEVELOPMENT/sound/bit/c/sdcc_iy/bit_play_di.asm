
; char *bit_play_di(char *melody)

SECTION code_sound_bit

PUBLIC _bit_play_di

_bit_play_di:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "sound/bit/z80/asm_bit_play_di.asm"
