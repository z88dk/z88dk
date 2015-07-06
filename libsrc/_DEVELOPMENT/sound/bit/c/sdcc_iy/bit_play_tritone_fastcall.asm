
; void *bit_play_tritone_fastcall(void *song)

SECTION smc_sound_bit

PUBLIC _bit_play_tritone_fastcall

EXTERN asm_bit_play_tritone

defc _bit_play_tritone_fastcall = asm_bit_play_tritone
