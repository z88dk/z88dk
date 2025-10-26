
; void in_mouse_kempston_setpos(uint16_t x, uint16_t y)

SECTION code_clib
SECTION code_input

PUBLIC in_mouse_kempston_setpos

EXTERN asm_in_mouse_kempston_setpos

in_mouse_kempston_setpos:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_in_mouse_kempston_setpos
