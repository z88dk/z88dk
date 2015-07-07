
; uint16_t in_stick_keyboard(udk_t *u)

SECTION code_input

PUBLIC _in_stick_keyboard

EXTERN asm_in_stick_keyboard

defc _in_stick_keyboard = asm_in_stick_keyboard
