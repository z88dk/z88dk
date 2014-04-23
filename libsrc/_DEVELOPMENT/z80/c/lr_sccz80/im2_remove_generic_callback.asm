
; int im2_remove_generic_callback(uint8_t vector, void *callback)

XLIB im2_remove_generic_callback

LIB asm_im2_remove_generic_callback

im2_remove_generic_callback:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_im2_remove_generic_callback
