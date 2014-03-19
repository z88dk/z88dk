
; int w_vector_resize(w_vector_t *v, size_t n)

XDEF w_vector_resize

w_vector_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_w_vector_resize.asm"
