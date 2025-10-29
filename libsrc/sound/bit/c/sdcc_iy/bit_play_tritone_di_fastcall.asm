
; void *bit_play_tritone_di_fastcall(void *song)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_tritone_di_fastcall

EXTERN asm_bit_play_tritone_di

defc _bit_play_tritone_di_fastcall = asm_bit_play_tritone_di
