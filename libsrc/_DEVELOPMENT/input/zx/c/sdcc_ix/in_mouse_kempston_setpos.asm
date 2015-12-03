
; void in_mouse_kempston_setpos(uint16_t x, uint16_t y)

SECTION code_clib
SECTION code_input

PUBLIC _in_mouse_kempston_setpos

EXTERN asm_in_mouse_kempston_setpos

_in_mouse_kempston_setpos:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_in_mouse_kempston_setpos
