
; char *bit_play_di(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_play_di

EXTERN asm_bit_play_di

defc bit_play_di = asm_bit_play_di
