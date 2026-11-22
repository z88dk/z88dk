
; void *bit_play_tritone_di(void *song)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_play_tritone_di

EXTERN asm_bit_play_tritone_di

defc bit_play_tritone_di = asm_bit_play_tritone_di
