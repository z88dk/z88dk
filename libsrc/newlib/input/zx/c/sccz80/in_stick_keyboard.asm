
; uint16_t in_stick_keyboard(udk_t *u)

SECTION code_clib
SECTION code_input

PUBLIC in_stick_keyboard

EXTERN asm_in_stick_keyboard

defc in_stick_keyboard = asm_in_stick_keyboard
