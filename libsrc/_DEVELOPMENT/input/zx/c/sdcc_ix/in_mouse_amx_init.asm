
; void in_mouse_amx_init(uint8_t x_vector, uint8_t y_vector)

SECTION code_input

PUBLIC _in_mouse_amx_init

_in_mouse_amx_init:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   ld b,e
   INCLUDE "input/zx/z80/asm_in_mouse_amx_init.asm"
