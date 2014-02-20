
; int b_vector_pop_back(b_vector_t *v)

XDEF b_vector_pop_back

b_vector_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_b_vector_pop_back.asm"
