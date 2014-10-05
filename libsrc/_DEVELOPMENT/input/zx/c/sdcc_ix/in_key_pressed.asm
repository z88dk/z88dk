
; int in_key_pressed(uint16_t scancode)

SECTION seg_code_input

PUBLIC _in_key_pressed

_in_key_pressed:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "input/zx/z80/asm_in_key_pressed.asm"
