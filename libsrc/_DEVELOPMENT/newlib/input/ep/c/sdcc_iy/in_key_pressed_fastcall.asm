
; int in_key_pressed_fastcall(uint16_t scancode)

SECTION code_clib
SECTION code_input

PUBLIC _in_key_pressed_fastcall

EXTERN asm_in_key_pressed

defc _in_key_pressed_fastcall = asm_in_key_pressed
