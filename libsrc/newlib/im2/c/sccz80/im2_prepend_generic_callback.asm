
; void im2_prepend_generic_callback(uint8_t vector, void *callback)

SECTION code_clib
SECTION code_z80

PUBLIC im2_prepend_generic_callback

EXTERN asm_im2_prepend_generic_callback

im2_prepend_generic_callback:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_im2_prepend_generic_callback
