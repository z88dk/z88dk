
; int in_key_pressed(uint16_t scancode)

SECTION code_input

PUBLIC in_key_pressed

in_key_pressed:

   INCLUDE "input/zx/z80/asm_in_key_pressed.asm"
