
; uint16_t in_stick_keyboard_fastcall(udk_t *u)

SECTION code_clib
SECTION code_input

PUBLIC _in_stick_keyboard_fastcall

EXTERN asm_in_stick_keyboard

defc _in_stick_keyboard_fastcall = asm_in_stick_keyboard
