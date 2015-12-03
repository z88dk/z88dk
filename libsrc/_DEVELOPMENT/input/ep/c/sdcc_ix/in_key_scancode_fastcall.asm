
; uint16_t in_key_scancode_fastcall(int c)

SECTION code_clib
SECTION code_input

PUBLIC _in_key_scancode_fastcall

EXTERN asm_in_key_scancode

defc _in_key_scancode_fastcall = asm_in_key_scancode
