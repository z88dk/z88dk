
; uint16_t in_stick_keyboard(udk_t *u)

SECTION seg_code_input

PUBLIC in_stick_keyboard

in_stick_keyboard:

   INCLUDE "input/zx/z80/asm_in_stick_keyboard.asm"
