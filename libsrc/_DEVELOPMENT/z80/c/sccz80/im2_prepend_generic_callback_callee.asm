
; void im2_prepend_generic_callback_callee(uint8_t vector, void *callback)

PUBLIC im2_prepend_generic_callback_callee

im2_prepend_generic_callback_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "z80/z80/asm_im2_prepend_generic_callback.asm"
