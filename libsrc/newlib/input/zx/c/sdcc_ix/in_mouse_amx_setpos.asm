
; void in_mouse_amx_setpos(uint16_t x, uint16_t y)

SECTION code_clib
SECTION code_input

PUBLIC _in_mouse_amx_setpos

EXTERN asm_in_mouse_amx_setpos

_in_mouse_amx_setpos:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_in_mouse_amx_setpos
