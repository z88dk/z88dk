
; void bit_fx_di(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_fx_di

EXTERN asm_bit_fx_di

defc bit_fx_di = asm_bit_fx_di
