
; void in_mouse_amx_init_callee(uint8_t x_vector, uint8_t y_vector)

SECTION code_input

PUBLIC in_mouse_amx_init_callee

in_mouse_amx_init_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld b,l
   INCLUDE "input/zx/z80/asm_in_mouse_amx_init.asm"
