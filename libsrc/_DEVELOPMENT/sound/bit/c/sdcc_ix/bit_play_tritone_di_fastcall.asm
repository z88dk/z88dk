
; void *bit_play_tritone_di_fastcall(void *song)

SECTION code_sound_bit

PUBLIC _bit_play_tritone_di_fastcall

_bit_play_tritone_di_fastcall:
   
   push ix
   
   call asm_bit_play_tritone_di
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_play_tritone_di.asm"
