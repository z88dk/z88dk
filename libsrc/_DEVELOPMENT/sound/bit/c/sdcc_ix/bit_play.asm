
; char *bit_play(char *melody)

PUBLIC _bit_play

_bit_play:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_bit_play
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_play.asm"
