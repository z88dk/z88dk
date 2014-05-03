
; void in_mouse_amx_init(uint8_t x_vector, uint8_t y_vector)

XLIB in_mouse_amx_init

LIB asm_in_mouse_amx_init

in_mouse_amx_init:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   ld b,e
   jp asm_in_mouse_amx_init
