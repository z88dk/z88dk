
; void im2_prepend_generic_callback_callee(uint8_t vector, void *callback)

SECTION code_z80

PUBLIC _im2_prepend_generic_callback_callee

_im2_prepend_generic_callback_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "z80/z80/asm_im2_prepend_generic_callback.asm"
