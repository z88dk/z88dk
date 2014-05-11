
; uint16_t in_key_scancode(int c)

PUBLIC _in_key_scancode

_in_key_scancode:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "input/zx/z80/asm_in_key_scancode.asm"
