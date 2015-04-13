
; int in_key_pressed_fastcall(uint16_t scancode)

SECTION code_input

PUBLIC _in_key_pressed_fastcall

_in_key_pressed_fastcall:

   INCLUDE "input/zx/z80/asm_in_key_pressed.asm"
