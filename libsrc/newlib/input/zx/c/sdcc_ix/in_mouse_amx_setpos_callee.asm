
; void in_mouse_amx_setpos_callee(uint16_t x, uint16_t y)

SECTION code_clib
SECTION code_input

PUBLIC _in_mouse_amx_setpos_callee

EXTERN asm_in_mouse_amx_setpos

_in_mouse_amx_setpos_callee:

   pop af
   pop de
   pop bc
   push af
   
   jp asm_in_mouse_amx_setpos
