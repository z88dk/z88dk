
; int w_vector_resize(w_vector_t *v, size_t n)

XDEF w_vector_resize

w_vector_resize:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_w_vector_resize.asm"
