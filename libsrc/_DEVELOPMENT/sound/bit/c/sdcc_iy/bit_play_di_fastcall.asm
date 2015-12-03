
; char *bit_play_di_fastcall(char *melody)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_play_di_fastcall

EXTERN asm_bit_play_di

defc _bit_play_di_fastcall = asm_bit_play_di
