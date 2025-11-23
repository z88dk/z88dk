
; void *bit_play_tritone_di_fastcall(void *song)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_tritone_di_fastcall

EXTERN asm_bit_play_tritone_di

_bit_play_tritone_di_fastcall:
   
   push ix
   
   call asm_bit_play_tritone_di
   
   pop ix
   ret
