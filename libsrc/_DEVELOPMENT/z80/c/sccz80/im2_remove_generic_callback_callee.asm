
; int im2_remove_generic_callback_callee(uint8_t vector, void *callback)

SECTION code_z80

PUBLIC im2_remove_generic_callback_callee

im2_remove_generic_callback_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "z80/z80/asm_im2_remove_generic_callback.asm"
