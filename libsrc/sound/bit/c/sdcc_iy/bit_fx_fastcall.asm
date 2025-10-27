
; void bit_fx_fastcall(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_fx_fastcall

EXTERN asm_bit_fx

defc _bit_fx_fastcall = asm_bit_fx
