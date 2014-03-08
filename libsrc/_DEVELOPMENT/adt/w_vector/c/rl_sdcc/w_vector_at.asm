
; void *w_vector_at(w_vector_t *v, size_t idx)

XDEF w_vector_at

w_vector_at:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_w_vector_at.asm"
