
; void im2_append_generic_callback(uint8_t vector, void *callback)

XDEF _im2_append_generic_callback

_im2_append_generic_callback:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "z80/z80/asm_im2_append_generic_callback.asm"
