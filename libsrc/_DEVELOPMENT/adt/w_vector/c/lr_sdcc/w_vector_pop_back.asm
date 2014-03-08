
; void *w_vector_pop_back(w_vector_t *v)

XDEF w_vector_pop_back

w_vector_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_w_vector_pop_back.asm"
