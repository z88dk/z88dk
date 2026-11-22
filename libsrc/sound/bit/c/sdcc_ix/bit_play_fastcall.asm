
; char *bit_play_fastcall(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_fastcall

EXTERN asm_bit_play

_bit_play_fastcall:
   
   push ix
   
   call asm_bit_play
   
   pop ix
   ret
