
; char *bit_play_fastcall(char *melody)

SECTION code_sound_bit

PUBLIC _bit_play_fastcall

_bit_play_fastcall:
   
   push ix
   
   call asm_bit_play
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_play.asm"
