
; void in_mouse_amx_init_callee(uint8_t x_vector, uint8_t y_vector)

SECTION code_clib
SECTION code_input

PUBLIC in_mouse_amx_init_callee

EXTERN asm_in_mouse_amx_init

in_mouse_amx_init_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld b,l
   jp asm_in_mouse_amx_init
