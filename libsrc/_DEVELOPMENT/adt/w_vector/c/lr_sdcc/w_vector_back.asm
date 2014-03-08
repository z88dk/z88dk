
; void *w_vector_back(b_vector_t *v)

XDEF w_vector_back

w_vector_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_w_vector_back.asm"
