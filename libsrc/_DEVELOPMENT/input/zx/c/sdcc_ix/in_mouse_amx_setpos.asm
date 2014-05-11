
; void in_mouse_amx_setpos(uint16_t x, uint16_t y)

PUBLIC _in_mouse_amx_setpos

_in_mouse_amx_setpos:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "input/zx/z80/asm_in_mouse_amx_setpos.asm"
