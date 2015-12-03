
; char *bit_play_fastcall(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_fastcall

EXTERN asm_bit_play

defc _bit_play_fastcall = asm_bit_play
