
; void *w_vector_at(w_vector_t *v, size_t idx)

XDEF w_vector_at

w_vector_at:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_w_vector_at.asm"
