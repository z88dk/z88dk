
; void *bit_play_tritone_fastcall(void *song)

SECTION code_clib
SECTION smc_sound_bit

PUBLIC _bit_play_tritone_fastcall

EXTERN asm_bit_play_tritone

_bit_play_tritone_fastcall:
   
   push ix
   
   call asm_bit_play_tritone
   
   pop ix
   ret
