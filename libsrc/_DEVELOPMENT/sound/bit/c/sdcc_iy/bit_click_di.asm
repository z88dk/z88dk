
; void bit_click_di(void)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_click_di

EXTERN asm_bit_click_di

defc _bit_click_di = asm_bit_click_di
