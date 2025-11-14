
; void *bit_play_tritone(void *song)

SECTION code_clib
SECTION smc_sound_bit

PUBLIC bit_play_tritone

EXTERN asm_bit_play_tritone

defc bit_play_tritone = asm_bit_play_tritone
