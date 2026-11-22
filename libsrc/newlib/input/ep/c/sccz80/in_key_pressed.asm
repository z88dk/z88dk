
; int in_key_pressed(uint16_t scancode)

SECTION code_clib
SECTION code_input

PUBLIC in_key_pressed

EXTERN asm_in_key_pressed

defc in_key_pressed = asm_in_key_pressed
