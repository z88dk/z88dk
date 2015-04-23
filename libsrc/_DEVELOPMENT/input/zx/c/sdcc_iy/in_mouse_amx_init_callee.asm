
; void in_mouse_amx_init_callee(uint8_t x_vector, uint8_t y_vector)

SECTION code_input

PUBLIC _in_mouse_amx_init_callee, l0_in_mouse_amx_init_callee

_in_mouse_amx_init_callee:

   pop af
   pop de
   pop bc
   push af

l0_in_mouse_amx_init_callee:

   ld b,e
   INCLUDE "input/zx/z80/asm_in_mouse_amx_init.asm"
