
; void *w_vector_front(w_vector_t *v)

XDEF w_vector_front

w_vector_front:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_w_vector_front.asm"
