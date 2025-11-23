
; void *bit_play_tritone(void *song)

SECTION code_clib
SECTION smc_sound_bit

PUBLIC _bit_play_tritone

EXTERN asm_bit_play_tritone

_bit_play_tritone:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_bit_play_tritone
