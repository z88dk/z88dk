
; char *bit_play(char *melody)

SECTION code_sound_bit

PUBLIC _bit_play

_bit_play:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "sound/bit/z80/asm_bit_play.asm"
