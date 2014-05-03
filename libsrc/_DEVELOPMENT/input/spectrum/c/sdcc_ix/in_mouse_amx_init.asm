
; void in_mouse_amx_init(uint8_t x_vector, uint8_t y_vector)

XDEF _in_mouse_amx_init

_in_mouse_amx_init:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   ld b,e
   INCLUDE "input/spectrum/z80/asm_in_mouse_amx_init.asm"
