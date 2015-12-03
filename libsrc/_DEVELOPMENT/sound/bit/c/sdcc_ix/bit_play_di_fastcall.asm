
; char *bit_play_di_fastcall(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_di_fastcall

EXTERN asm_bit_play_di

_bit_play_di_fastcall:
   
   push ix
   
   call asm_bit_play_di
   
   pop ix
   ret
