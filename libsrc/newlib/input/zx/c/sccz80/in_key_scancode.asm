
; uint16_t in_key_scancode(int c)

SECTION code_clib
SECTION code_input

PUBLIC in_key_scancode

EXTERN asm_in_key_scancode

defc in_key_scancode = asm_in_key_scancode
