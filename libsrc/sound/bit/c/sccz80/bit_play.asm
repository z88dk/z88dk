
; char *bit_play(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_play

EXTERN asm_bit_play

defc bit_play = asm_bit_play
