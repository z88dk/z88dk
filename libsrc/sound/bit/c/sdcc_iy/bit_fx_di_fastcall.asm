
; void bit_fx_di_fastcall(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_fx_di_fastcall

EXTERN asm_bit_fx_di

defc _bit_fx_di_fastcall = asm_bit_fx_di
