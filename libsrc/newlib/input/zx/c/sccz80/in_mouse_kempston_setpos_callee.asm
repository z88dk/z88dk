
; void in_mouse_kempston_setpos_callee(uint16_t x, uint16_t y)

SECTION code_clib
SECTION code_input

PUBLIC in_mouse_kempston_setpos_callee

EXTERN asm_in_mouse_kempston_setpos

in_mouse_kempston_setpos_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_in_mouse_kempston_setpos
