
; int w_vector_resize(w_vector_t *v, size_t n)

XDEF w_vector_resize

w_vector_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_resize.asm"
