
; void bit_click(void)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_click

EXTERN asm_bit_click

defc bit_click = asm_bit_click
