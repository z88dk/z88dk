
; char *bit_play_di_fastcall(char *melody)

SECTION code_sound_bit

PUBLIC _bit_play_di_fastcall

_bit_play_di_fastcall:
   
   push ix
   
   call asm_bit_play_di
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_play_di.asm"
