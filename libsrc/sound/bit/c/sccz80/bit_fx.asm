
; void bit_fx(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_fx

EXTERN asm_bit_fx

defc bit_fx = asm_bit_fx
