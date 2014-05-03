
; void in_mouse_kempston_setpos(uint16_t x, uint16_t y)

XLIB in_mouse_kempston_setpos

LIB asm_in_mouse_kempston_setpos

in_mouse_kempston_setpos:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_in_mouse_kempston_setpos
