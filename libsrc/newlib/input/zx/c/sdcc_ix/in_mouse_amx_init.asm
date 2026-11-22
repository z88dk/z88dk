
; void in_mouse_amx_init(uint8_t x_vector, uint8_t y_vector)

SECTION code_clib
SECTION code_input

PUBLIC _in_mouse_amx_init

EXTERN l0_in_mouse_amx_init_callee

_in_mouse_amx_init:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af

   jp l0_in_mouse_amx_init_callee
